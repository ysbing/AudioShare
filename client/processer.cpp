#include "processer.h"

#include <Audioclient.h>
#include <QAudioDevice>
#include <QMediaDevices>

#define EXIT_ON_ERROR(hres) \
    if (FAILED(hres)) {     \
        goto Exit;          \
    }
#define SAFE_RELEASE(punk) \
    if ((punk) != NULL) {  \
        (punk)->Release(); \
        (punk) = NULL;     \
    }

const CLSID CLSID_MMDeviceEnumerator = __uuidof(MMDeviceEnumerator);
const IID IID_IMMDeviceEnumerator = __uuidof(IMMDeviceEnumerator);
const IID IID_IAudioClient = __uuidof(IAudioClient);
const IID IID_IAudioCaptureClient = __uuidof(IAudioCaptureClient);

AudioProcesser::AudioProcesser(WorkSocket* socket)
    : workSocket(socket)
{
}

AudioProcesser::~AudioProcesser()
{
}

void AudioProcesser::run()
{
    QAudioDevice* device = new QAudioDevice(QMediaDevices::defaultAudioOutput());
    QString id(device->id());
    const TCHAR* tchar = reinterpret_cast<const TCHAR*>(id.utf16());
    IMMDevice* pDevice = getDevice(tchar);
    recordAudioStream(pDevice);
}

IMMDevice* AudioProcesser::getDevice(const TCHAR* pId)
{
    IMMDeviceCollection* pDevices = getAudioDevices();
    IMMDevice* pDevice;
    WCHAR* pName;
    IPropertyStore* pProps = NULL;
    UINT count;
    HRESULT hr = NULL;
    if (pDevices == NULL)
        return 0;
    pDevices->GetCount(&count);
    for (UINT i = 0; i < count; i++) {
        hr = pDevices->Item(i, &pDevice);
        EXIT_ON_ERROR(hr);
        hr = pDevice->GetId(&pName);
        EXIT_ON_ERROR(hr);
        if (lstrcmp(pName, pId) == 0) {
            goto Exit;
        }
        CoTaskMemFree(pName);
        SAFE_RELEASE(pDevice);
    }
Exit:
    SAFE_RELEASE(pDevices);
    return pDevice;
}

IMMDeviceCollection* AudioProcesser::getAudioDevices()
{
    HRESULT hr;
    IMMDeviceEnumerator* pEnumerator = NULL;
    IMMDeviceCollection* pDevices;
    hr = CoCreateInstance(CLSID_MMDeviceEnumerator, NULL, CLSCTX_ALL, IID_IMMDeviceEnumerator, (void**)&pEnumerator);
    EXIT_ON_ERROR(hr);
    hr = pEnumerator->EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, &pDevices);
    EXIT_ON_ERROR(hr);
    return pDevices;
Exit:
    SAFE_RELEASE(pEnumerator);
    SAFE_RELEASE(pDevices);
    return 0;
}

HRESULT AudioProcesser::recordAudioStream(IMMDevice* pDevice)
{
    HRESULT hr;
    UINT32 bufferFrameCount;
    UINT32 numFramesAvailable;
    IAudioClient* pAudioClient = NULL;
    IAudioCaptureClient* pCaptureClient = NULL;
    WAVEFORMATEX* pwfx = NULL;
    UINT32 packetLength = 0;
    BOOL bDone = FALSE;
    BYTE* pData;
    DWORD flags;

    // hr = pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);
    // EXIT_ON_ERROR(hr)

    hr = pDevice->Activate(IID_IAudioClient, CLSCTX_ALL, NULL, (void**)&pAudioClient);
    EXIT_ON_ERROR(hr)

    hr = pAudioClient->GetMixFormat(&pwfx);
    EXIT_ON_ERROR(hr)

    if (bDone == FALSE) {
        PWAVEFORMATEXTENSIBLE pEx = reinterpret_cast<PWAVEFORMATEXTENSIBLE>(pwfx);
        if (IsEqualGUID(KSDATAFORMAT_SUBTYPE_IEEE_FLOAT, pEx->SubFormat)) {
            pEx->SubFormat = KSDATAFORMAT_SUBTYPE_PCM;
            pEx->Samples.wValidBitsPerSample = 16;
            pwfx->wBitsPerSample = 16;
            pwfx->nBlockAlign = pwfx->nChannels * pwfx->wBitsPerSample / 8;
            pwfx->nAvgBytesPerSec = pwfx->nBlockAlign * pwfx->nSamplesPerSec;
        }
    }

    hr = pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_LOOPBACK, 0, 0, pwfx, NULL);
    EXIT_ON_ERROR(hr)

    // Get the size of the allocated buffer.
    hr = pAudioClient->GetBufferSize(&bufferFrameCount);
    EXIT_ON_ERROR(hr)

    hr = pAudioClient->GetService(IID_IAudioCaptureClient, (void**)&pCaptureClient);
    EXIT_ON_ERROR(hr)

    hr = pAudioClient->Start(); // Start recording.
    EXIT_ON_ERROR(hr)

    // Each loop fills about half of the shared buffer.
    while (bDone == FALSE) {
        Sleep(1);
        hr = pCaptureClient->GetNextPacketSize(&packetLength);
        EXIT_ON_ERROR(hr)

        while (packetLength != 0) {
            // Get the available data in the shared buffer.
            hr = pCaptureClient->GetBuffer(
                &pData,
                &numFramesAvailable,
                &flags, NULL, NULL);
            EXIT_ON_ERROR(hr)

            if (flags & AUDCLNT_BUFFERFLAGS_SILENT) {
                pData = NULL; // Tell CopyData to write silence.
            }

            workSocket->write(reinterpret_cast<const char*>(pData), numFramesAvailable * pwfx->nChannels * pwfx->wBitsPerSample / 8);

            EXIT_ON_ERROR(hr)

            hr = pCaptureClient->ReleaseBuffer(numFramesAvailable);
            EXIT_ON_ERROR(hr)

            hr = pCaptureClient->GetNextPacketSize(&packetLength);
            EXIT_ON_ERROR(hr)
        }
    }

    hr = pAudioClient->Stop(); // Stop recording.
    EXIT_ON_ERROR(hr)

Exit:
    CoTaskMemFree(pwfx);
    SAFE_RELEASE(pAudioClient)
    SAFE_RELEASE(pCaptureClient)

    return hr;
}
