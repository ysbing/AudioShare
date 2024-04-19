
#ifndef DATASOURCE_H
#define DATASOURCE_H

#include <QObject>
#include <QAbstractListModel>
#include <QTimer>
#include "adb.h"
#include "socket.h"
#include "processer.h"

class DataSource:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int deviceState READ deviceState NOTIFY deviceStateChanged)
public:
    enum DevicesModelRole {
        DeviceIdRole = Qt::UserRole + 1,
        UsbTypeRole = Qt::UserRole + 2,
        ModelRole = Qt::UserRole + 3,
        ManufacturerRole = Qt::UserRole + 4,
        AndroidVersionRole = Qt::UserRole + 5,
        ApiLevelRole = Qt::UserRole + 6,
        IpRole = Qt::UserRole + 7,
        PortRole = Qt::UserRole + 8,
        ConnectStateRole = Qt::UserRole + 9,
        ConnectEnableRole = Qt::UserRole + 10,
    };

    explicit DataSource();
    ~DataSource();
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    void updateConnectState(const QString& deviceId, int state);
    void resetConnectState();

public slots:
    void connectDevice(const QString& deviceId);
    void onConnected(const QString& connectCode);
    void disconnectDevice(const QString& deviceId);
    void disconnectAllDevice();
    int deviceState();
    void onClientDisconnect();

signals:
    void deviceStateChanged();

private:
    WorkSocket* socket = new WorkSocket;
    AudioProcesser* processer = new AudioProcesser(socket);
    Adb adb;
    QTimer timer;
    QList<DeviceModel*> datas;
    QMap<QString, int> connectStateMap;
    int deviceState_ = 0;
};

#endif // DATASOURCE_H
