
#ifndef PROCESSER_H
#define PROCESSER_H

#include <Mmdeviceapi.h>
#include <Windows.h>

#include <QThread>

#include "socket.h"

class AudioProcesser : public QThread {
public:
    explicit AudioProcesser(WorkSocket* socket);
    ~AudioProcesser();

    // QThread interface
protected:
    void run();

private:
    IMMDevice* getDevice(const TCHAR* pId);
    IMMDeviceCollection* getAudioDevices();
    HRESULT recordAudioStream(IMMDevice* pDevice);
    WorkSocket* workSocket = nullptr;
};
#endif // PROCESSER_H
