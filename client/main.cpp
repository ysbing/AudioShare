#include "data_source.h"
#include "single_application.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>

int main(int argc, char* argv[])
{
    if (!JQFoundation::singleApplication("AudioShareApplication")) {
        HWND hWnd = FindWindow(NULL, L"AudioShare");
        if (hWnd) {
            SetForegroundWindow(hWnd);
        }
        qDebug() << "Application already running" << hWnd;

        return -1;
    }
    QGuiApplication app(argc, argv);

    qmlRegisterType<DataSource>("DataSource", 1, 0, "DataSource");
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
