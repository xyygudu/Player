#include "fileutil.h"

#include <QDir>
#include <QDebug>

QFileInfoList FileUtil::getFiles(const QString &dirPath, const QStringList &fliters)
{
    QDir dir(dirPath);
    if (!dir.exists())
    {
        qDebug() << "目录不存在";
        return QFileInfoList{};
    }
    dir.setFilter(QDir::Files | QDir::NoSymLinks);  // 列出目录下所有文件
    dir.setNameFilters(fliters);
    return dir.entryInfoList();
}
