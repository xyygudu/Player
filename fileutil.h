#ifndef FILEUTIL_H
#define FILEUTIL_H

#include <QObject>
#include <QFileInfoList>

class FileUtil : public QObject
{
    Q_OBJECT
public:
    static FileUtil* instance()
    {
        static FileUtil fileUtil;
        return &fileUtil;
    }

    QFileInfoList getFiles(const QString& dirPath, const QStringList& fliters);
    QString convertByteTo(qint64 size);

signals:

private:
    explicit FileUtil(QObject *parent = nullptr) { Q_UNUSED(parent)}
    FileUtil(const FileUtil &) = delete;
    const FileUtil& operator=(const FileUtil&)=delete;
    ~FileUtil() {}
};

#endif // FILEUTIL_H
