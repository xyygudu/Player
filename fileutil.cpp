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

QString FileUtil::convertByteTo(qint64 size)
{
    int integer = 0;  //整数位
        int decimal = 0;  //小数位，保留2位
        char unit ='B';
        qint64 standardSize = size;
        qint64 curSize = size;

        if(standardSize > 1024) {
            curSize = standardSize * 1000;
            curSize /= 1024;
            integer = curSize / 1000;
            decimal = curSize % 1000;
            standardSize /= 1024;
            unit = 'K';
            if(standardSize > 1024) {
                curSize = standardSize * 1000;
                curSize /= 1024;
                integer = curSize / 1000;
                decimal = curSize % 1000;
                standardSize /= 1024;
                unit = 'M';
                if(standardSize > 1024) {
                    curSize = standardSize * 1000;
                    curSize /= 1024;
                    integer = curSize / 1000;
                    decimal = curSize % 1000;
                    unit = 'G';
                }
            }
        }

        QString dec = "0";
        if (0 <= decimal && decimal <= 9) {
            dec = dec + QString::number(decimal);
        }

        if (10 <= decimal && decimal <= 99) {
            dec = QString::number(decimal);
        }

        if (100 <= decimal && decimal <= 999) {
            dec = QString::number(decimal/10);
        }

        return QString::number(integer) + "." + dec + unit;
}
