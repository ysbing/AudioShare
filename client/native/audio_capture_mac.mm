// macOS system audio capture via ScreenCaptureKit (macOS 13+).
// Exports the same C interface as audio_capture.dll on Windows so the
// Dart layer can use identical FFI bindings on both platforms.
//
// Flow mirrors the Windows WASAPI implementation:
//   Initialize → Listen (TCP server) → Start (begin audio stream) → Stop/Cleanup

#import <Foundation/Foundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#include <AudioToolbox/AudioToolbox.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>

// ---- Callback type (matches Windows declaration) ----
typedef void (*ConnectCallback)(const char* connectCode);

// ---- Global state ----
static volatile int g_bListening   = 0;
static volatile int g_bRunning     = 0;
static volatile int g_bConnected   = 0;
static char         g_connectCodeBuf[256] = {0};
static ConnectCallback g_connectCallback  = NULL;

static volatile int g_listenFd  = -1;
static volatile int g_clientFd  = -1;

static pthread_t     g_listenThread;
static pthread_cond_t  g_listenReadyCond  = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t g_listenReadyMutex = PTHREAD_MUTEX_INITIALIZER;
static int g_listenReady = 0;  // 0=pending, 1=ok, -1=error

// Objective-C objects — retained via __strong in a wrapper to avoid ARC issues
// in a mixed C/ObjC++ translation unit.
static __strong id g_stream   = nil;
static __strong id g_delegate = nil;

// ---- Helpers ----
static void SendAll(int fd, const void* data, size_t len) {
    const uint8_t* ptr = (const uint8_t*)data;
    while (len > 0) {
        ssize_t sent = send(fd, ptr, len, 0);
        if (sent <= 0) break;
        ptr += sent;
        len -= (size_t)sent;
    }
}

// ---- TCP listen thread ----
// Accepts one Android client, reads the connectCode, fires callback.
// Mirrors Windows ListenThread().
static void* ListenThread(void* arg) {
    int port = (int)(intptr_t)arg;

    int fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (fd < 0) goto fail;
    g_listenFd = fd;

    {
        int opt = 1;
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

        struct sockaddr_in addr = {};
        addr.sin_family      = AF_INET;
        addr.sin_port        = htons((uint16_t)port);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);

        if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) goto fail;
        if (listen(fd, 1) < 0) goto fail;
    }

    g_bListening = 1;
    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = 1;
    pthread_cond_signal(&g_listenReadyCond);
    pthread_mutex_unlock(&g_listenReadyMutex);

    {
        struct sockaddr_in clientAddr = {};
        socklen_t addrLen = sizeof(clientAddr);
        int cfd = accept(fd, (struct sockaddr*)&clientAddr, &addrLen);
        if (cfd < 0) return NULL;
        g_clientFd = cfd;

        int sndbuf = 256 * 1024;
        setsockopt(cfd, SOL_SOCKET, SO_SNDBUF, &sndbuf, sizeof(sndbuf));

        char buf[256] = {};
        ssize_t n = recv(cfd, buf, sizeof(buf) - 1, 0);
        if (n > 0) {
            buf[n] = '\0';
            memcpy(g_connectCodeBuf, buf, (size_t)n + 1);
            g_bConnected = 1;
            if (g_connectCallback) g_connectCallback(g_connectCodeBuf);
        }
    }
    return NULL;

fail:
    if (g_listenFd >= 0) { close(g_listenFd); g_listenFd = -1; }
    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = -1;
    pthread_cond_signal(&g_listenReadyCond);
    pthread_mutex_unlock(&g_listenReadyMutex);
    return NULL;
}

// ---- ScreenCaptureKit audio delegate ----
// Receives Float32 planar audio from the OS, converts to stereo PCM16,
// sends over the TCP socket — equivalent to Windows CaptureThread().
API_AVAILABLE(macos(13.0))
@interface AudioCaptureDelegate : NSObject <SCStreamDelegate, SCStreamOutput>
@end

@implementation AudioCaptureDelegate

- (void)stream:(SCStream*)stream
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   ofType:(SCStreamOutputType)type {
    if (type != SCStreamOutputTypeAudio) return;
    if (!g_bRunning) return;
    int cfd = g_clientFd;
    if (cfd < 0) return;

    CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
    const AudioStreamBasicDescription* asbd =
        CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    if (!asbd) return;

    int numFrames = (int)CMSampleBufferGetNumSamples(sampleBuffer);
    if (numFrames <= 0) return;

    // Get the AudioBufferList.
    size_t bufListSize = 0;
    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
        sampleBuffer, &bufListSize, NULL, 0, NULL, NULL, 0, NULL);
    if (bufListSize == 0) return;

    AudioBufferList* abl = (AudioBufferList*)malloc(bufListSize);
    if (!abl) return;

    CMBlockBufferRef blockBuf = NULL;
    OSStatus st = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
        sampleBuffer, NULL, abl, bufListSize, NULL, NULL,
        kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuf);

    if (st != noErr) {
        free(abl);
        if (blockBuf) CFRelease(blockBuf);
        return;
    }

    short* pcm = (short*)malloc(numFrames * 2 * sizeof(short));
    if (!pcm) {
        free(abl);
        if (blockBuf) CFRelease(blockBuf);
        return;
    }

    BOOL nonInterleaved = (asbd->mFormatFlags & kAudioFormatFlagIsNonInterleaved) != 0;

    if (nonInterleaved && abl->mNumberBuffers >= 2) {
        // Standard ScreenCaptureKit format: Float32 planar, one buffer per channel.
        const float* L = (const float*)abl->mBuffers[0].mData;
        const float* R = (const float*)abl->mBuffers[1].mData;
        for (int i = 0; i < numFrames; i++) {
            float l = L[i], r = R[i];
            if (l >  1.0f) l =  1.0f; else if (l < -1.0f) l = -1.0f;
            if (r >  1.0f) r =  1.0f; else if (r < -1.0f) r = -1.0f;
            pcm[i*2+0] = (short)(l * 32767.0f);
            pcm[i*2+1] = (short)(r * 32767.0f);
        }
    } else if (nonInterleaved && abl->mNumberBuffers == 1) {
        // Mono planar — duplicate to stereo.
        const float* M = (const float*)abl->mBuffers[0].mData;
        for (int i = 0; i < numFrames; i++) {
            float s = M[i];
            if (s >  1.0f) s =  1.0f; else if (s < -1.0f) s = -1.0f;
            short v = (short)(s * 32767.0f);
            pcm[i*2+0] = v;
            pcm[i*2+1] = v;
        }
    } else {
        // Interleaved fallback.
        const float* src = (const float*)abl->mBuffers[0].mData;
        UInt32 bytesPerFrame = asbd->mBytesPerFrame;
        int srcCh = (bytesPerFrame > 0)
            ? (int)(bytesPerFrame / sizeof(float)) : 2;
        for (int i = 0; i < numFrames; i++) {
            float l = src[i * srcCh + 0];
            float r = (srcCh > 1) ? src[i * srcCh + 1] : l;
            if (l >  1.0f) l =  1.0f; else if (l < -1.0f) l = -1.0f;
            if (r >  1.0f) r =  1.0f; else if (r < -1.0f) r = -1.0f;
            pcm[i*2+0] = (short)(l * 32767.0f);
            pcm[i*2+1] = (short)(r * 32767.0f);
        }
    }

    SendAll(cfd, pcm, numFrames * 2 * sizeof(short));
    free(pcm);
    free(abl);
    if (blockBuf) CFRelease(blockBuf);
}

- (void)stream:(SCStream*)stream didStopWithError:(NSError*)error {
    g_bRunning = 0;
}

@end

// ============================================================
// Exported C API — identical symbols to audio_capture.dll
// ============================================================

extern "C" __attribute__((visibility("default")))
int AudioCapture_Initialize() {
    // ScreenCaptureKit requires macOS 13.0.
    if (@available(macOS 13.0, *)) {
        return 1;
    }
    return 0;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_Listen(int port, ConnectCallback callback) {
    g_connectCallback = callback;
    g_bListening = 0;

    // Close any previous sockets so accept() unblocks immediately (matches
    // Windows behaviour — close first, wait for thread second).
    int lfd = g_listenFd;
    if (lfd >= 0) { close(lfd); g_listenFd = -1; }
    int cfd = g_clientFd;
    if (cfd >= 0) { close(cfd); g_clientFd = -1; }

    // Reap previous listen thread.
    pthread_join(g_listenThread, NULL);

    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = 0;
    pthread_mutex_unlock(&g_listenReadyMutex);

    pthread_create(&g_listenThread, NULL, ListenThread, (void*)(intptr_t)port);

    // Wait up to 5 s for ListenThread to bind and listen.
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    ts.tv_sec += 5;

    pthread_mutex_lock(&g_listenReadyMutex);
    while (g_listenReady == 0) {
        if (pthread_cond_timedwait(&g_listenReadyCond, &g_listenReadyMutex, &ts) != 0) break;
    }
    int ready = g_listenReady;
    pthread_mutex_unlock(&g_listenReadyMutex);

    return (ready == 1) ? 1 : 0;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_Start() {
    if (@available(macOS 13.0, *)) {
        __block int success = 0;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        [SCShareableContent
            getShareableContentExcludingDesktopWindows:NO
            onScreenWindowsOnly:NO
            completionHandler:^(SCShareableContent* content, NSError* error) {
                if (error || !content || content.displays.count == 0) {
                    dispatch_semaphore_signal(sema);
                    return;
                }

                // Content filter: entire primary display → captures all system audio.
                SCContentFilter* filter =
                    [[SCContentFilter alloc] initWithDisplay:content.displays[0]
                                          excludingWindows:@[]];

                SCStreamConfiguration* config = [[SCStreamConfiguration alloc] init];
                config.capturesAudio              = YES;
                config.excludesCurrentProcessAudio = NO;
                config.sampleRate                 = 48000;
                config.channelCount               = 2;
                // Minimise video overhead — we only care about audio samples.
                config.width                  = 2;
                config.height                 = 2;
                config.minimumFrameInterval   = CMTimeMake(1, 1);  // 1 fps

                AudioCaptureDelegate* del = [[AudioCaptureDelegate alloc] init];
                g_delegate = del;

                SCStream* stream = [[SCStream alloc] initWithFilter:filter
                                                      configuration:config
                                                           delegate:del];
                NSError* addErr = nil;
                dispatch_queue_t q =
                    dispatch_queue_create("com.ysbing.audioshare.audio", DISPATCH_QUEUE_SERIAL);
                [stream addStreamOutput:del
                                   type:SCStreamOutputTypeAudio
                     sampleHandlerQueue:q
                                  error:&addErr];
                if (addErr) {
                    dispatch_semaphore_signal(sema);
                    return;
                }

                // Send 8-byte format header so Android creates the correct AudioTrack.
                // [uint32 sampleRate LE][uint16 channels LE][uint16 bitsPerSample LE]
                int cfd = g_clientFd;
                if (cfd >= 0) {
                    uint8_t hdr[8];
                    uint32_t sr   = 48000;
                    uint16_t ch   = 2;
                    uint16_t bits = 16;
                    memcpy(hdr + 0, &sr,   4);
                    memcpy(hdr + 4, &ch,   2);
                    memcpy(hdr + 6, &bits, 2);
                    SendAll(cfd, hdr, 8);
                }

                g_bRunning = 1;
                g_stream   = stream;

                [stream startCaptureWithCompletionHandler:^(NSError* startErr) {
                    if (startErr) {
                        g_bRunning = 0;
                        g_stream   = nil;
                    } else {
                        success = 1;
                    }
                    dispatch_semaphore_signal(sema);
                }];
            }];

        dispatch_semaphore_wait(sema,
            dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        return success;
    }
    return 0;
}

extern "C" __attribute__((visibility("default")))
void AudioCapture_Stop() {
    g_bRunning = 0;

    int cfd = g_clientFd;
    if (cfd >= 0) { close(cfd); g_clientFd = -1; }
    int lfd = g_listenFd;
    if (lfd >= 0) { close(lfd); g_listenFd = -1; }

    if (@available(macOS 13.0, *)) {
        __strong SCStream* stream = (SCStream*)g_stream;
        if (stream) {
            [stream stopCaptureWithCompletionHandler:^(NSError*) {}];
            g_stream   = nil;
            g_delegate = nil;
        }
    }
}

extern "C" __attribute__((visibility("default")))
void AudioCapture_Cleanup() {
    AudioCapture_Stop();
    pthread_join(g_listenThread, NULL);
    g_connectCallback  = NULL;
    g_bConnected       = 0;
    g_connectCodeBuf[0] = '\0';
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_IsConnected(char* outBuf, int bufSize) {
    if (!g_bConnected) return 0;
    if (outBuf && bufSize > 0) {
        int len = (int)strlen(g_connectCodeBuf);
        if (len >= bufSize) len = bufSize - 1;
        memcpy(outBuf, g_connectCodeBuf, len);
        outBuf[len] = '\0';
    }
    return 1;
}
