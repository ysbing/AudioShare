#include "single_application.h"
#include <QSharedMemory>

#if !(defined Q_OS_IOS) && !(defined Q_OS_ANDROID) && !(defined Q_OS_WINPHONE)
bool JQFoundation::singleApplication(const QString& flag)
{
    static QSharedMemory* shareMem = nullptr;

    if (shareMem) {
        return true;
    }

    shareMem = new QSharedMemory("JQFoundationSingleApplication_" + flag);

    for (auto count = 0; count < 2; ++count) {
        if (shareMem->attach(QSharedMemory::ReadOnly)) {
            shareMem->detach();
        }
    }

    if (shareMem->create(1)) {
        return true;
    }

    return false;
}
#else
bool JQFoundation::singleApplication(const QString&)
{
    return true;
}
#endif

#if !(defined Q_OS_IOS) && !(defined Q_OS_ANDROID) && !(defined Q_OS_WINPHONE)
bool JQFoundation::singleApplicationExist(const QString& flag)
{
    QSharedMemory shareMem("JQFoundationSingleApplication_" + flag);

    for (auto count = 0; count < 2; ++count) {
        if (shareMem.attach(QSharedMemory::ReadOnly)) {
            shareMem.detach();
        }
    }

    if (shareMem.create(1)) {
        return false;
    }

    return true;
}
#else
bool JQFoundation::singleApplicationExist(const QString&)
{
    return false;
}
#endif
