#ifndef VIDEOPLAYER_H
#define VIDEOPLAYER_H

#include <QObject>
#include "videotablemodel.h"


class VideoPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(VideoTableModel* videoTableModel READ getVideoTableModel CONSTANT);
    Q_PROPERTY(QString currentPath READ currentPath WRITE setCurrentPath NOTIFY currentPathChanged)
public:
    explicit VideoPlayer(QObject *parent = nullptr);
    ~VideoPlayer();

    void fileInfoToModel(const QString &path);
    Q_INVOKABLE void updateVideoModel(const QString& path);
    Q_INVOKABLE QString getVideoPathByRow(int row);
    Q_INVOKABLE QString getVideoNameByRow(int row);
    VideoTableModel* getVideoTableModel();

    const QString &currentPath() const;
    void setCurrentPath(const QString &newCurrentPath);

signals:

    void currentPathChanged();

private:
    VideoTableModel *m_videoTableModel;
    QString m_currentPath;      // 记录当前播放视频的路径

};

#endif // VIDEOPLAYER_H
