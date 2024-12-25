#ifndef TASKWRAPPER_CPP
#define TASKWRAPPER_CPP

#include <QDebug>
#include <QThreadPool>
#include <QTimer>

class RunnableFuncWrapper : public QRunnable {
public:
    RunnableFuncWrapper(std::function<void()> task);

    void run() override;

private:
    std::function<void()> m_funTask = nullptr;
};

class TaskWrapper : public QObject {
    Q_OBJECT
public:
    explicit TaskWrapper(QRunnable* task, QObject* parent = nullptr);
    explicit TaskWrapper(std::function<void()> task, QObject* parent = nullptr);
    ~TaskWrapper();
    void run();
signals:
    void finish(QObject* object);

private:
    QRunnable* m_task = nullptr;
    std::function<void()> m_funTask = nullptr;
};

#endif
