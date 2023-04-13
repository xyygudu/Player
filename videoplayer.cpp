#include "videoplayer.h"
#include "fileutil.h"

#include <QDebug>
#include <QFileDialog>


VideoPlayer::VideoPlayer(QObject *parent)
    : QObject{parent}
{
    m_videoTableModel = new VideoTableModel{};
    m_currentPath = "F:/工作相关/万兴作业";
    fileInfoToModel(m_currentPath);
}

VideoPlayer::~VideoPlayer()
{
    delete m_videoTableModel;
}

void VideoPlayer::fileInfoToModel(const QString &path)
{ 
    QFileInfoList fileInfos = FileUtil::instance()->getFiles(path, {"*.mp4", "*.wmv", "*.avi"});

    // 把所有文件信息都添加到model中
    for (const auto &fileInfo : qAsConst(fileInfos))
    {
        m_videoTableModel->append(fileInfo);
    }
}

void VideoPlayer::updateVideoModel(const QString &path)
{
    // 打开文件夹窗口
    QString dirPath = QFileDialog::getExistingDirectory(nullptr, "选择视频目录", path,
                                     QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    if (!dirPath.isEmpty())
    {
        setCurrentPath(dirPath);
        m_videoTableModel->removeRows(0, m_videoTableModel->rowCount());
        fileInfoToModel(dirPath);
    }
}

QString VideoPlayer::getVideoPathByRow(int row)
{
    return m_videoTableModel->getVideoPathByRow(row);
}

QString VideoPlayer::getVideoNameByRow(int row)
{
    return m_videoTableModel->getVideoNamebyRow(row);
}


VideoTableModel* VideoPlayer::getVideoTableModel()
{
    return m_videoTableModel;
}

const QString &VideoPlayer::currentPath() const
{
    return m_currentPath;
}

void VideoPlayer::setCurrentPath(const QString &newCurrentPath)
{
    if (m_currentPath == newCurrentPath)
        return;
    m_currentPath = newCurrentPath;
    emit currentPathChanged();
}
