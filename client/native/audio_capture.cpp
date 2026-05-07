#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <mmreg.h>
#include <mmsystem.h>

#pragma comment(lib, "ws2_32.lib")

static IMMDeviceEnumerator* g_pEnumerator = NULL;
static IAudioClient* g_pAudioClient = NULL;
static IAudioCaptureClient* g_pCaptureClient = NULL;
static HANDLE g_hCaptureThread = NULL;
static HANDLE g_hListenThread = NULL;
static volatile BOOL g_bRunning = FALSE;
static volatile BOOL g_bListening = FALSE;
static int g_nChannels = 2;
static BOOL g_bPcmOutput = FALSE;
static UINT32 g_nSampleRate = 48000;

static SOCKET g_listenSocket = INVALID_SOCKET;
static SOCKET g_clientSocket = INVALID_SOCKET;
static WSADATA g_wsaData;
static HANDLE g_hListenReady = NULL;
static BOOL g_bWsaInitialized = FALSE;
static BOOL g_bConnected = FALSE;
static char g_connectCodeBuf[256] = {0};

// Callback to notify Dart that a client connected (passes connectCode)
typedef void (*ConnectCallback)(const char* connectCode);
static ConnectCallback g_connectCallback = NULL;

const CLSID CLSID_MMDeviceEnumerator_Local = __uuidof(MMDeviceEnumerator);
const IID IID_IMMDeviceEnumerator_Local = __uuidof(IMMDeviceEnumerator);
const IID IID_IAudioClient_Local = __uuidof(IAudioClient);
const IID IID_IAudioCaptureClient_Local = __uuidof(IAudioCaptureClient);

static void SendAll(SOCKET sock, const char* data, int len) {
    while (len > 0 && sock != INVALID_SOCKET) {
        int sent = send(sock, data, len, 0);
        if (sent <= 0) break;
        data += sent;
        len -= sent;
    }
}

// ---- Listen thread: accepts incoming connection from Android via ADB tunnel ----
static DWORD WINAPI ListenThread(LPVOID lpParam) {
    int port = (int)(intptr_t)lpParam;

    g_listenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (g_listenSocket == INVALID_SOCKET) return 1;

    int opt = 1;
    setsockopt(g_listenSocket, SOL_SOCKET, SO_REUSEADDR, (const char*)&opt, sizeof(opt));

    sockaddr_in addr = {};
    addr.sin_family = AF_INET;
    addr.sin_port = htons((u_short)port);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(g_listenSocket, (sockaddr*)&addr, sizeof(addr)) == SOCKET_ERROR) {
        closesocket(g_listenSocket);
        g_listenSocket = INVALID_SOCKET;
        if (g_hListenReady) SetEvent(g_hListenReady);
        return 1;
    }

    if (listen(g_listenSocket, 1) == SOCKET_ERROR) {
        closesocket(g_listenSocket);
        g_listenSocket = INVALID_SOCKET;
        if (g_hListenReady) SetEvent(g_hListenReady);
        return 1;
    }

    g_bListening = TRUE;
    if (g_hListenReady) SetEvent(g_hListenReady);

    while (g_bListening) {
        sockaddr_in clientAddr = {};
        int addrLen = sizeof(clientAddr);
        g_clientSocket = accept(g_listenSocket, (sockaddr*)&clientAddr, &addrLen);
        if (g_clientSocket == INVALID_SOCKET) break;

        // 256KB send buffer absorbs jitter without blocking the capture thread.
        int sndbuf = 256 * 1024;
        setsockopt(g_clientSocket, SOL_SOCKET, SO_SNDBUF, (const char*)&sndbuf, sizeof(sndbuf));

        // Read connectCode from Android server (blocking)
        char buf[256] = {};
        int n = recv(g_clientSocket, buf, sizeof(buf) - 1, 0);
        if (n > 0) {
            buf[n] = '\0';
            memcpy(g_connectCodeBuf, buf, n + 1);
            g_bConnected = TRUE;
            if (g_connectCallback) {
                g_connectCallback(g_connectCodeBuf);
            }
        }
        break; // Only handle one connection
    }

    return 0;
}

// ---- Capture thread: reads WASAPI audio, converts to stereo PCM16, sends via socket -----
static DWORD WINAPI CaptureThread(LPVOID lpParam) {
    HRESULT hr;
    UINT32 packetLength = 0;
    BYTE* pData;
    UINT32 numFramesAvailable;
    DWORD flags;

    // Set 1ms timer resolution: Sleep(1) will sleep ~1ms instead of ~15.6ms (default).
    // Without this, audio is sent in large 15ms bursts that underrun the Android AudioTrack.
    timeBeginPeriod(1);

    // Pre-allocate output buffer: stereo PCM16, max 1 second
    const int kMaxFrames = 48000;
    short* outBuf = new short[kMaxFrames * 2];

    // Send 8-byte format header: [uint32 sampleRate LE][uint16 channels LE][uint16 bitsPerSample LE]
    // Android reads this before creating AudioTrack so it uses the exact format we send.
    if (g_clientSocket != INVALID_SOCKET) {
        BYTE header[8];
        UINT32 sr = g_nSampleRate;
        UINT16 ch = 2;
        UINT16 bits = 16;
        memcpy(header + 0, &sr, 4);
        memcpy(header + 4, &ch, 2);
        memcpy(header + 6, &bits, 2);
        SendAll(g_clientSocket, (const char*)header, 8);
    }

    while (g_bRunning) {
        Sleep(1);
        if (!g_pCaptureClient || !g_bRunning) break;

        hr = g_pCaptureClient->GetNextPacketSize(&packetLength);
        if (FAILED(hr)) break;

        while (packetLength != 0 && g_bRunning) {
            hr = g_pCaptureClient->GetBuffer(&pData, &numFramesAvailable, &flags, NULL, NULL);
            if (FAILED(hr)) break;

            int nFrames = (int)numFramesAvailable;
            if (nFrames > kMaxFrames) nFrames = kMaxFrames;

            bool isSilent = (flags & AUDCLNT_BUFFERFLAGS_SILENT) != 0 || pData == NULL;

            if (isSilent) {
                memset(outBuf, 0, nFrames * 2 * sizeof(short));
            } else if (g_bPcmOutput) {
                // WASAPI delivered PCM16 — extract first 2 channels if surround
                const short* src = (const short*)pData;
                if (g_nChannels == 2) {
                    memcpy(outBuf, src, nFrames * 2 * sizeof(short));
                } else {
                    for (int i = 0; i < nFrames; i++) {
                        outBuf[i * 2 + 0] = src[i * g_nChannels + 0]; // L
                        outBuf[i * 2 + 1] = src[i * g_nChannels + 1]; // R
                    }
                }
            } else {
                // WASAPI delivered float32 — convert to PCM16, downmix if surround
                const float* src = (const float*)pData;
                if (g_nChannels == 2) {
                    for (int i = 0; i < nFrames * 2; i++) {
                        float s = src[i];
                        if (s > 1.0f) s = 1.0f;
                        else if (s < -1.0f) s = -1.0f;
                        outBuf[i] = (short)(s * 32767.0f);
                    }
                } else {
                    for (int i = 0; i < nFrames; i++) {
                        float l = src[i * g_nChannels + 0];
                        float r = src[i * g_nChannels + 1];
                        if (l > 1.0f) l = 1.0f; else if (l < -1.0f) l = -1.0f;
                        if (r > 1.0f) r = 1.0f; else if (r < -1.0f) r = -1.0f;
                        outBuf[i * 2 + 0] = (short)(l * 32767.0f);
                        outBuf[i * 2 + 1] = (short)(r * 32767.0f);
                    }
                }
            }

            // Release WASAPI buffer immediately so the engine can continue capturing
            // while we do the network send (avoids DATA_DISCONTINUITY under load).
            g_pCaptureClient->ReleaseBuffer(numFramesAvailable);

            if (g_clientSocket != INVALID_SOCKET) {
                SendAll(g_clientSocket, (const char*)outBuf, nFrames * 2 * (int)sizeof(short));
            }

            hr = g_pCaptureClient->GetNextPacketSize(&packetLength);
            if (FAILED(hr)) break;
        }
    }

    timeEndPeriod(1);
    delete[] outBuf;
    return 0;
}

extern "C" __declspec(dllexport) int AudioCapture_Initialize() {
    g_nChannels = 2;
    g_bPcmOutput = FALSE;

    HRESULT hr = CoInitializeEx(NULL, COINIT_MULTITHREADED);
    if (FAILED(hr) && hr != RPC_E_CHANGED_MODE) return 0;

    hr = CoCreateInstance(CLSID_MMDeviceEnumerator_Local, NULL, CLSCTX_ALL,
        IID_IMMDeviceEnumerator_Local, (void**)&g_pEnumerator);
    if (FAILED(hr)) return 0;

    IMMDevice* pDevice = NULL;
    hr = g_pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);
    if (FAILED(hr)) { g_pEnumerator->Release(); g_pEnumerator = NULL; return 0; }

    hr = pDevice->Activate(IID_IAudioClient_Local, CLSCTX_ALL, NULL, (void**)&g_pAudioClient);
    if (FAILED(hr)) { pDevice->Release(); return 0; }

    WAVEFORMATEX* pwfx = NULL;
    hr = g_pAudioClient->GetMixFormat(&pwfx);
    if (FAILED(hr)) { g_pAudioClient->Release(); g_pAudioClient = NULL; pDevice->Release(); return 0; }

    // First attempt: request exactly what Android needs — stereo PCM16 at 48kHz.
    // WASAPI shared mode will resample/downmix from the device's native format.
    // This avoids sample-rate drift (e.g. 44.1kHz source -> 48kHz playback) that
    // causes periodic buffer underruns every ~2 seconds.
    WAVEFORMATEXTENSIBLE targetFmt = {};
    targetFmt.Format.wFormatTag = WAVE_FORMAT_EXTENSIBLE;
    targetFmt.Format.nChannels = 2;
    targetFmt.Format.nSamplesPerSec = 48000;
    targetFmt.Format.wBitsPerSample = 16;
    targetFmt.Format.nBlockAlign = 2 * 2;
    targetFmt.Format.nAvgBytesPerSec = 48000 * 2 * 2;
    targetFmt.Format.cbSize = sizeof(WAVEFORMATEXTENSIBLE) - sizeof(WAVEFORMATEX);
    targetFmt.SubFormat = KSDATAFORMAT_SUBTYPE_PCM;
    targetFmt.Samples.wValidBitsPerSample = 16;
    targetFmt.dwChannelMask = SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT;

    hr = g_pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_LOOPBACK,
        0, 0, (WAVEFORMATEX*)&targetFmt, NULL);
    if (SUCCEEDED(hr)) {
        g_nChannels = 2;
        g_nSampleRate = 48000;
        g_bPcmOutput = TRUE;
    } else {
        // Fallback: use the device's native mix format and do software conversion.
        g_nChannels = pwfx->nChannels;
        g_nSampleRate = pwfx->nSamplesPerSec;
        hr = g_pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_LOOPBACK,
            0, 0, pwfx, NULL);
        g_bPcmOutput = FALSE;  // CaptureThread will convert float32->PCM16
    }

    CoTaskMemFree(pwfx);
    pDevice->Release();

    if (FAILED(hr)) {
        g_pAudioClient->Release();
        g_pAudioClient = NULL;
        return 0;
    }

    UINT32 bufferFrameCount;
    hr = g_pAudioClient->GetBufferSize(&bufferFrameCount);
    if (FAILED(hr)) return 0;

    hr = g_pAudioClient->GetService(IID_IAudioCaptureClient_Local, (void**)&g_pCaptureClient);
    if (FAILED(hr)) return 0;

    return 1;
}

// Start listening for Android connection on given port
extern "C" __declspec(dllexport) int AudioCapture_Listen(int port, ConnectCallback callback) {
    g_connectCallback = callback;
    g_bListening = FALSE;

    // Close sockets FIRST so accept() in ListenThread unblocks immediately,
    // then wait for the thread. Closing after the wait caused a 2s timeout
    // every reconnect (accept() never returns while socket is still open).
    if (g_clientSocket != INVALID_SOCKET) {
        closesocket(g_clientSocket);
        g_clientSocket = INVALID_SOCKET;
    }
    if (g_listenSocket != INVALID_SOCKET) {
        closesocket(g_listenSocket);
        g_listenSocket = INVALID_SOCKET;
    }
    // Reap the old capture thread handle if AudioCapture_Stop was called
    // (it doesn't wait, so the handle may still be open). By the time
    // Listen is called the thread has had time to exit naturally.
    if (g_hCaptureThread) {
        WaitForSingleObject(g_hCaptureThread, 500);
        CloseHandle(g_hCaptureThread);
        g_hCaptureThread = NULL;
    }
    if (g_hListenThread) {
        WaitForSingleObject(g_hListenThread, 2000);
        CloseHandle(g_hListenThread);
        g_hListenThread = NULL;
    }

    WSAStartup(MAKEWORD(2, 2), &g_wsaData);
    g_bWsaInitialized = TRUE;

    if (g_hListenReady) {
        CloseHandle(g_hListenReady);
    }
    g_hListenReady = CreateEvent(NULL, TRUE, FALSE, NULL);
    if (!g_hListenReady) return 0;

    g_hListenThread = CreateThread(NULL, 0, ListenThread, (LPVOID)(intptr_t)port, 0, NULL);
    if (!g_hListenThread) {
        CloseHandle(g_hListenReady);
        g_hListenReady = NULL;
        return 0;
    }

    // Wait for listen thread to bind and start listening
    DWORD waitResult = WaitForSingleObject(g_hListenReady, 5000);
    CloseHandle(g_hListenReady);
    g_hListenReady = NULL;

    if (waitResult != WAIT_OBJECT_0 || !g_bListening) {
        return 0;
    }

    return 1;
}

// Start audio capture (call after Listen accepted connection)
extern "C" __declspec(dllexport) int AudioCapture_Start() {
    if (!g_pAudioClient) return 0;

    HRESULT hr = g_pAudioClient->Start();
    if (FAILED(hr)) return 0;

    g_bRunning = TRUE;
    g_hCaptureThread = CreateThread(NULL, 0, CaptureThread, NULL, 0, NULL);
    if (!g_hCaptureThread) {
        g_bRunning = FALSE;
        g_pAudioClient->Stop();
        return 0;
    }

    return 1;
}

extern "C" __declspec(dllexport) void AudioCapture_Stop() {
    // Signal threads to exit — do NOT wait here. This is called from the Dart
    // UI thread via FFI; blocking it (WaitForSingleObject) freezes Flutter
    // rendering. Threads exit on their own: CaptureThread checks g_bRunning
    // every 1ms, ListenThread unblocks when sockets are closed below.
    g_bRunning = FALSE;
    g_bListening = FALSE;

    // Close sockets so blocked accept()/send() return immediately.
    if (g_clientSocket != INVALID_SOCKET) {
        closesocket(g_clientSocket);
        g_clientSocket = INVALID_SOCKET;
    }
    if (g_listenSocket != INVALID_SOCKET) {
        closesocket(g_listenSocket);
        g_listenSocket = INVALID_SOCKET;
    }

    // Stop WASAPI so CaptureThread stops receiving data.
    if (g_pAudioClient) {
        g_pAudioClient->Stop();
    }

    // Thread handles (g_hCaptureThread, g_hListenThread) are closed in the
    // next AudioCapture_Listen or AudioCapture_Cleanup call, by which time
    // the threads have had ample time to exit naturally.
}

extern "C" __declspec(dllexport) void AudioCapture_Cleanup() {
    AudioCapture_Stop();

    // On cleanup (app exit) we CAN wait — threads should exit within ms.
    if (g_hCaptureThread) {
        WaitForSingleObject(g_hCaptureThread, 1000);
        CloseHandle(g_hCaptureThread);
        g_hCaptureThread = NULL;
    }
    if (g_hListenThread) {
        WaitForSingleObject(g_hListenThread, 1000);
        CloseHandle(g_hListenThread);
        g_hListenThread = NULL;
    }
    if (g_bWsaInitialized) {
        WSACleanup();
        g_bWsaInitialized = FALSE;
    }

    if (g_pCaptureClient) {
        g_pCaptureClient->Release();
        g_pCaptureClient = NULL;
    }
    if (g_pAudioClient) {
        g_pAudioClient->Release();
        g_pAudioClient = NULL;
    }
    if (g_pEnumerator) {
        g_pEnumerator->Release();
        g_pEnumerator = NULL;
    }

    g_connectCallback = NULL;
    g_bConnected = FALSE;
    g_connectCodeBuf[0] = '\0';
}

// Poll: returns 1 if a client has connected and provides the connect code
extern "C" __declspec(dllexport) int AudioCapture_IsConnected(char* outBuf, int bufSize) {
    if (!g_bConnected) return 0;
    if (outBuf && bufSize > 0) {
        int len = (int)strlen(g_connectCodeBuf);
        if (len >= bufSize) len = bufSize - 1;
        memcpy(outBuf, g_connectCodeBuf, len);
        outBuf[len] = '\0';
    }
    return 1;
}
