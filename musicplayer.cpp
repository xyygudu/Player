#include "musicplayer.h"
#include "fileutil.h"
#include "lyrics.h"
#include <QDebug>
#include <QFileDialog>

MusicPlayer::MusicPlayer(QObject *parent)
    : QObject{parent}
{
    m_musicTableModel = new MusicTableModel{};
    m_lyricModel = new LyricModel{};
    m_currentPath = "F:/网易云音乐";
    fileInfoToModel(m_currentPath);
}

MusicPlayer::~MusicPlayer()
{
    delete m_musicTableModel;
    delete m_lyricModel;
}

void MusicPlayer::fileInfoToModel(const QString &path)
{
    QFileInfoList fileInfos = FileUtil::instance()->getFiles(path, {"*.mp3", "*.wmv", "*.wav"});

    // 把所有文件信息都添加到model中
    for (const auto &fileInfo : qAsConst(fileInfos))
    {
        m_musicTableModel->append(fileInfo);
    }
}

void MusicPlayer::updateMusicModel(const QString &path)
{
    // 打开文件夹窗口
    QString dirPath = QFileDialog::getExistingDirectory(nullptr, "选择音乐目录", path,
                                     QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    if (!dirPath.isEmpty())
    {
        setCurrentPath(dirPath);
        m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
        fileInfoToModel(dirPath);
    }
}

QString MusicPlayer::getMusicPathByRow(int row)
{
    return m_musicTableModel->getMusicPathByRow(row);
}

QString MusicPlayer::getMusicNameByRow(int row)
{
    return m_musicTableModel->getMusicNamebyRow(row);
}

void MusicPlayer::upDateLyricModelBy(int row)
{
    m_lyricModel->clear();  // 清空之前的歌词
    m_lyric2IdxMap.clear();
    QString musicName = getMusicNameByRow(row);
    // 从当前音乐目录的lrc子目录中找对应歌词文件，也就是说歌词文件必须放在m_currentPath的lrc子目录下才能读取到
    QString lyricPath = m_currentPath + "/lrc/" + musicName + ".lrc";
    Lyrics::parseLyrics(lyricPath, m_lyric2IdxMap, m_lyricModel);
}

int MusicPlayer::getLyricIdxByPosition(qint64 pos)
{
     QMap<qint64, int>::iterator iter = m_lyric2IdxMap.begin();
     while (iter != m_lyric2IdxMap.end())
     {
         if ((iter.key()-500<=pos)  && (iter+1).key()-500 > pos)
         {
             return iter.value();
         }
         iter++;
     }
     return -1;
}

MusicTableModel *MusicPlayer::musicTableModel() const
{
    return m_musicTableModel;
}

const QString &MusicPlayer::currentPath() const
{
    return m_currentPath;
}

void MusicPlayer::setCurrentPath(const QString &newCurrentPath)
{
    if (m_currentPath == newCurrentPath)
        return;
    m_currentPath = newCurrentPath;
    emit currentPathChanged();
}

LyricModel *MusicPlayer::lyricModel() const
{
    return m_lyricModel;
}

const QMap<qint64, int> &MusicPlayer::lyric2IdxMap() const
{
    return m_lyric2IdxMap;
}
