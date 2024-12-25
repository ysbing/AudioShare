
#ifndef SOCKET_H
#define SOCKET_H

#include <QtNetwork>

class WorkSocket : public QObject {
    Q_OBJECT
public:
    explicit WorkSocket();
    ~WorkSocket();
    void write(const char* data, int len);
    int findAvailablePort();
    void disconnect();

signals:
    void listen(int port);
    void connected(const QString& connectCode);
    void clientDisconnect();

private:
    void newClientHandler();
    QTcpServer* server = nullptr;
    QTcpSocket* clientSocket = nullptr;
    int connectPort = 0;
};

#endif // SOCKET_H
