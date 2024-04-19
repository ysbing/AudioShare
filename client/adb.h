
#ifndef ADB_H
#define ADB_H

#include <QObject>
#include <QProcess>

class DeviceModel {
public:
    explicit DeviceModel(const QString& deviceId, bool usb, const QString& serialNumber, const QString& model, const QString& manufacturer, const QString& androidVersion, const QString& apiLevel, const QPair<QString, QString>& ipPort);

    QString deviceId;
    bool usb;
    QString serialNumber;
    QString model;
    QString manufacturer;
    QString androidVersion;
    QString apiLevel;
    QPair<QString, QString> ipPort;
};

class Adb:public QObject
{
    Q_OBJECT
public:
    explicit Adb();
    ~Adb();

    void devices();
    void reverse(const QString& deviceId, const QString& socketname, const QString& port);
    void pushServer(const QString& deviceId);
    void launchServer(const QString& deviceId, const QString& socketname);
    void stopServer();

signals:
    void devicesChanged(const QList<DeviceModel*>& devices);

private:
    QString exec(const QStringList & arguments);
    QString adbExecPath();
    QPair<QString, QString> getIpPort(const QString& deviceId);
    QString getSerialNumber(const QString& deviceId);
    QString getModel(const QString& deviceId);
    QString getManufacturer(const QString& deviceId);
    QString getAndroidVersion(const QString& deviceId);
    QString getApiLevel(const QString& deviceId);

    QProcess* launchProcess = nullptr;
    bool isDestory = false;
};

#endif // ADB_H
