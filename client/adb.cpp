#include "adb.h"
#include "threadpools.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QRegularExpression>
#include <QStandardPaths>
#include <QThreadPool>

Adb::Adb()
{
}

Adb::~Adb()
{
    isDestory = true;
}

void Adb::devices()
{
    ThreadPools::instance()->exec([=] {
        QString output = exec(QStringList() << "devices");
        QStringList lines = output.split("\r\n");
        lines.removeFirst();
        QList<DeviceModel*> devices;
        for (const QString& line : lines) {
            static QRegularExpression regex("(.*?)\\s+device");
            QRegularExpressionMatch match = regex.match(line);
            if (match.hasMatch()) {
                QString deviceId = match.captured(1);
                if (!deviceId.isEmpty()) {
                    QPair<QString, QString> ipPort = getIpPort(deviceId);
                    bool usb = ipPort.first.isEmpty() || ipPort.second.isEmpty();
                    QString serialNumber = getSerialNumber(deviceId);
                    QString model = getModel(deviceId);
                    QString manufacturer = getManufacturer(deviceId);
                    QString androidVersion = getAndroidVersion(deviceId);
                    QString apiLevel = getApiLevel(deviceId);
                    devices.append(new DeviceModel(deviceId, usb, serialNumber, model, manufacturer, androidVersion, apiLevel, ipPort));
                }
            }
        }
        if (!isDestory) {
            emit devicesChanged(devices);
        }
    });
}

void Adb::reverse(const QString& deviceId, const QString& socketname, const QString& port)
{
    exec(QStringList() << "-s" << deviceId << "reverse" << "localabstract:" + socketname << "tcp:" + port);
}

void Adb::pushServer(const QString& deviceId)
{
    QString serverPath = QCoreApplication::applicationDirPath().append("/server");
    exec(QStringList() << "-s" << deviceId << "push" << serverPath << "/data/local/tmp/audioshare");
}

void Adb::launchServer(const QString& deviceId, const QString& socketname)
{
    stopServer();
    launchProcess = new QProcess;
    launchProcess->setProgram(adbExecPath());
    launchProcess->setArguments(QStringList() << "-s" << deviceId << "shell" << "app_process" << "-Djava.class.path=/data/local/tmp/audioshare" << "/data/local/tmp" << "com.ysbing.audioshare.Main" << "socketName=" + socketname << "connectCode=" + deviceId);
    launchProcess->start();
    //    launchProcess->waitForStarted();
    //    launchProcess->setReadChannel(QProcess::StandardError);
    //    while (launchProcess->state() != QProcess::NotRunning) {
    //        launchProcess->waitForReadyRead();
    //        QString output = QString::fromLocal8Bit(launchProcess->readAllStandardError());
    //        qDebug() << "launchServer:" << output;
    //    }
}

void Adb::stopServer()
{
    if (launchProcess) {
        launchProcess->kill();
        launchProcess->deleteLater();
        launchProcess = nullptr;
    }
}

QString Adb::exec(const QStringList& arguments)
{
    QProcess* process = new QProcess;
    process->setProgram(adbExecPath());
    process->setArguments(arguments);
    process->start();
    process->waitForStarted();
    process->waitForReadyRead();
    process->waitForFinished();
    QString output = QString::fromLocal8Bit(process->readAll());
    process = nullptr;
    return output;
}

QString Adb::adbExecPath()
{
    QFile file = QFile("./adb.exe");
    if (file.exists()) {
        return file.fileName();
    }
    QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    return tempDir.append("./adb.exe");
}

QPair<QString, QString> Adb::getIpPort(const QString& deviceId)
{
    static QRegularExpression regex("(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}):(\\d{1,5})");
    QRegularExpressionMatch match = regex.match(deviceId);
    if (match.hasMatch()) {
        QString ip = match.captured(1);
        QString port = match.captured(2);
        return QPair<QString, QString>(ip, port);
    }
    return QPair<QString, QString>();
}

QString Adb::getSerialNumber(const QString& deviceId)
{
    QString output = exec(QStringList() << "-s" << deviceId << "shell" << "getprop" << "ro.serialno");
    QStringList lines = output.split("\r\n");
    return lines.first();
}

QString Adb::getModel(const QString& deviceId)
{
    QString output = exec(QStringList() << "-s" << deviceId << "shell" << "getprop" << "ro.product.model");
    QStringList lines = output.split("\r\n");
    return lines.first();
}

QString Adb::getManufacturer(const QString& deviceId)
{
    QString output = exec(QStringList() << "-s" << deviceId << "shell" << "getprop" << "ro.product.manufacturer");
    QStringList lines = output.split("\r\n");
    return lines.first();
}

QString Adb::getAndroidVersion(const QString& deviceId)
{
    QString output = exec(QStringList() << "-s" << deviceId << "shell" << "getprop" << "ro.build.version.release");
    QStringList lines = output.split("\r\n");
    return lines.first();
}

QString Adb::getApiLevel(const QString& deviceId)
{
    QString output = exec(QStringList() << "-s" << deviceId << "shell" << "getprop" << "ro.build.version.sdk");
    QStringList lines = output.split("\r\n");
    return lines.first();
}

DeviceModel::DeviceModel(const QString& deviceId, bool usb, const QString& serialNumber, const QString& model, const QString& manufacturer, const QString& androidVersion, const QString& apiLevel, const QPair<QString, QString>& ipPort)
    : deviceId(deviceId)
    , usb(usb)
    , serialNumber(serialNumber)
    , model(model)
    , manufacturer(manufacturer)
    , androidVersion(androidVersion)
    , apiLevel(apiLevel)
    , ipPort(ipPort)
{
}
