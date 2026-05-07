#include <stdio.h>
#include <windows.h>
#include <winsock2.h>

typedef int (*AudioCapture_Initialize_Fn)();
typedef int (*AudioCapture_Listen_Fn)(int port, void (*callback)(const char*));
typedef void (*AudioCapture_Start_Fn)();
typedef void (*AudioCapture_Stop_Fn)();
typedef void (*AudioCapture_Cleanup_Fn)();

void onConnect(const char* code) {
    printf("CALLBACK: Connected with code: %s\n", code);
}

int main() {
    HMODULE hDll = LoadLibraryA("audio_capture.dll");
    if (!hDll) {
        printf("Failed to load DLL\n");
        return 1;
    }

    auto init = (AudioCapture_Initialize_Fn)GetProcAddress(hDll, "AudioCapture_Initialize");
    auto listen = (AudioCapture_Listen_Fn)GetProcAddress(hDll, "AudioCapture_Listen");
    auto start = (AudioCapture_Start_Fn)GetProcAddress(hDll, "AudioCapture_Start");
    auto stop = (AudioCapture_Stop_Fn)GetProcAddress(hDll, "AudioCapture_Stop");
    auto cleanup = (AudioCapture_Cleanup_Fn)GetProcAddress(hDll, "AudioCapture_Cleanup");

    if (!init || !listen || !start || !stop || !cleanup) {
        printf("Failed to get function pointers\n");
        return 1;
    }

    printf("Initializing...\n");
    int ret = init();
    printf("Initialize result: %d\n", ret);
    if (!ret) return 1;

    printf("Listening on port 11794...\n");
    ret = listen(11794, onConnect);
    printf("Listen result: %d\n", ret);
    if (!ret) { cleanup(); return 1; }

    printf("Waiting for connection... (press Enter to stop)\n");
    getchar();

    stop();
    cleanup();
    FreeLibrary(hDll);
    return 0;
}
