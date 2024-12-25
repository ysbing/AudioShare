#include "socket.h"
#include "threadpools.h"

WorkSocket::WorkSocket()
{
    ThreadPools::instance()->initMainThread();
    connect(this, &WorkSocket::listen, this, [=](int port) {
        if (server && server->isListening() && connectPort == port) {
            return;
        }
        if (server) {
            server->close();
        }
        if (clientSocket) {
            clientSocket->close();
            clientSocket = nullptr;
        }
        server = new QTcpServer;
        if (server->listen(QHostAddress::Any, port)) {
            connectPort = port;
            connect(server, &QTcpServer::newConnection, this, &WorkSocket::newClientHandler);
        } else {
            connectPort = 0;
            server->close();
            server = nullptr;
        }
    });
}

WorkSocket::~WorkSocket()
{
    disconnect();
    if (server) {
        server->close();
        server = nullptr;
    }
}

void WorkSocket::write(const char* data, int len)
{
    if (data && clientSocket && clientSocket->isValid() && clientSocket->isWritable()) {
        clientSocket->write(data, len);
        clientSocket->flush();
    }
}

int WorkSocket::findAvailablePort()
{
    if (connectPort > 0) {
        return connectPort;
    }
    int port = 11794;
    for (int i = port; i < port + 10000; i++) {
        QTcpSocket socket;
        socket.connectToHost(QHostAddress::LocalHost, i);
        bool result = socket.waitForConnected(500);
        qDebug() << "findAvailablePort" << i << result;
        if (!result) {
            return i;
        }
    }
    return 0;
}

void WorkSocket::disconnect()
{
    if (clientSocket) {
        clientSocket->close();
        clientSocket = nullptr;
    }
    emit clientDisconnect();
}

void WorkSocket::newClientHandler()
{
    clientSocket = server->nextPendingConnection();
    connect(clientSocket, &QTcpSocket::readyRead, this, [=]() {
        QString connectCode = QString::fromUtf8(clientSocket->readAll());
        emit connected(connectCode);
    });
    connect(clientSocket, &QTcpSocket::disconnected, this, [=]() {
        disconnect();
    });
}
