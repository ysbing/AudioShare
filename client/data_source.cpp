#include "data_source.h"
#include "threadpools.h"

DataSource::DataSource()
{
    processer->start();
    connect(socket, &WorkSocket::connected, this, &DataSource::onConnected);
    connect(socket, &WorkSocket::clientDisconnect, this, &DataSource::onClientDisconnect);
    // 每个3秒轮训一次连接的设备
    QObject::connect(&timer, &QTimer::timeout, this, [this](){
        adb.devices();
    });
    adb.devices();
    timer.start(3000);
    QObject::connect(&adb, &Adb::devicesChanged, this, [this](const QList<DeviceModel*>& devices){
        beginResetModel();
        datas.clear();
        datas.append(devices);
        endResetModel();
        if(datas.isEmpty())
        {
            deviceState_ = 1;
            resetConnectState();
        }
        else
        {
            deviceState_ = 2;
            QList<QString> connectKeys = connectStateMap.keys();
            for(int i = 0; i < connectKeys.count(); i++)
            {
                QString connectKey = connectKeys.at(i);
                bool has = false;
                for(int j = 0; j < devices.count(); j++)
                {
                    DeviceModel* device = devices.at(j);
                    if(device->deviceId == connectKey)
                    {
                        has = true;
                        break;
                    }
                }
                if(!has)
                {
                    connectStateMap[connectKey] = 0;
                }
            }
        }
        emit deviceStateChanged();
    });
}

DataSource::~DataSource()
{
    qDeleteAll(datas);
    disconnect(socket, &WorkSocket::connected, this, &DataSource::onConnected);
    disconnectAllDevice();
    socket->deleteLater();
    processer->deleteLater();
}

int DataSource::rowCount(const QModelIndex &parent) const
{
    return datas.size();
}

QVariant DataSource::data(const QModelIndex &index, int role) const
{
    DeviceModel* data = datas[index.row()];
    if (role == DeviceIdRole){
        return data->deviceId;
        }
   else if (role == UsbTypeRole){
        return data->usb;
    }
    else if (role == ModelRole) {
        return data->model;
    } else if (role == ManufacturerRole){
        return data->manufacturer;
        }
    else if (role == AndroidVersionRole){
        return data->androidVersion;
        }
    else if (role == ApiLevelRole) {
        return data->apiLevel;
    }
    else if (role == IpRole) {
        return data->ipPort.first;
    }
    else if (role == PortRole) {
        return data->ipPort.second;
    }
    else if (role == ConnectStateRole) {
        return connectStateMap[data->deviceId];
    }
    else if (role == ConnectEnableRole) {
        for (QString key : connectStateMap.keys()) {
            if(connectStateMap[key]==1){
                return false;
            }
        }
        int connectState = connectStateMap[data->deviceId];
        return connectState == 0 || connectState == 2;
    }
    return QVariant();
}

QHash<int, QByteArray> DataSource::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DeviceIdRole] = "deviceId";
    roles[UsbTypeRole] = "usbType";
    roles[ModelRole] = "deviceModel";
    roles[ManufacturerRole] = "manufacturer";
    roles[AndroidVersionRole] = "androidVersion";
    roles[ApiLevelRole] = "apiLevel";
    roles[IpRole] = "ip";
    roles[PortRole] = "port";
    roles[ConnectStateRole] = "connectState";
    roles[ConnectEnableRole] = "connectEnable";
    return roles;
}

void DataSource::updateConnectState(const QString& deviceId, int state)
{
    beginResetModel();
    connectStateMap[deviceId] = state;
    endResetModel();
}

void DataSource::resetConnectState()
{
    connectStateMap.clear();
}

void DataSource::connectDevice(const QString &deviceId)
{
    disconnectAllDevice();
    updateConnectState(deviceId, 1);
    ThreadPools::instance()->exec([=]{
        // 查询可用端口
        int port = socket->findAvailablePort();
        // 端口映射
        QString socketName = "audioshare_" + QString::number(port);
        adb.reverse(deviceId, socketName, QString::number(port));
        // 将程序推送到设备上
        adb.pushServer(deviceId);
        // 启动本地Socket
        emit socket->listen(port);
        // 启动服务
        adb.launchServer(deviceId, socketName);
        qDebug()<< "connect:"<<deviceId << port;
    });
}

void DataSource::disconnectDevice(const QString &deviceId)
{
    adb.stopServer();
    socket->disconnect();
    updateConnectState(deviceId, 0);
}

void DataSource::disconnectAllDevice()
{
    adb.stopServer();
    socket->disconnect();
    resetConnectState();
}

int DataSource::deviceState()
{
    return deviceState_;
}

void DataSource::onConnected(const QString &connectCode)
{
    updateConnectState(connectCode, 2);
}

void DataSource::onClientDisconnect()
{
    adb.devices();
}
