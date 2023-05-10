#include "musicplayer.h"
#include "fileutil.h"
#include "lyrics.h"
#include <QDebug>
#include <QFileDialog>
#include <QJsonArray>

MusicPlayer::MusicPlayer(QObject *parent)
    : QObject{parent}
{
    m_musicTableModel = new MusicTableModel{};
    m_lyricModel = new LyricModel{};
    m_currentPath = "F:/网易云音乐";
    fileInfoToModel(m_currentPath);
    m_httpUtil = new HttpUtil{};
    connect(m_httpUtil, &HttpUtil::parseJson, this, &MusicPlayer::parseMusicsFromJson);
}

MusicPlayer::~MusicPlayer()
{
    delete m_musicTableModel;
    delete m_lyricModel;
    delete m_httpUtil;
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
    if (row < 0)
        return "请选择音乐";
    else
        return m_musicTableModel->getMusicNamebyRow(row);
}

QString MusicPlayer::getSingerNameByRow(int row)
{
    if (row < 0)
        return "未知歌手";
    else
        return m_musicTableModel->getSingerNamebyRow(row);
}

int MusicPlayer::getMusicIdByRow(int row)
{
    if (row < 0)
        return -1;
    else
        return m_musicTableModel->getMusicIdByRow(row);
}

void MusicPlayer::upDateLyricModelBy(int row)
{
    m_lyricModel->clear();  // 清空之前的歌词
    m_lyric2IdxMap.clear();
    if (m_musicTableModel->mode() == MusicTableModel::LOCAL)

    {
        // 从当前音乐目录的lrc子目录中找对应歌词文件，也就是说歌词文件必须放在m_currentPath的lrc子目录下才能读取到
        QString musicName = getMusicNameByRow(row);
        QString lyricPath = m_currentPath + "/lrc/" + musicName + ".lrc";
        Lyrics::parseLyricsFromFile(lyricPath, m_lyric2IdxMap, m_lyricModel);
    }
    else
    {
        int musicId = getMusicIdByRow(row);
        Lyrics::parseLyricsFromMusicId(musicId, m_lyric2IdxMap, m_lyricModel);
    }
}

int MusicPlayer::getLyricIdxByPosition(qint64 pos)
{
    QMap<qint64, int>::iterator iter = m_lyric2IdxMap.begin();
//    qDebug() << m_lyric2IdxMap << m_lyric2IdxMap.size();
    while (iter != m_lyric2IdxMap.end())
    {
         if (iter == m_lyric2IdxMap.begin() && (iter+1).key() > pos)
         {
             return iter.value();  // 从pos=0开始到第2条歌词前，都显示第一条歌词
         }
         if ((iter.key()<=pos)  && (iter+1).key() > pos)
         {
             return iter.value();
         }
         iter++;
    }
    return -1;
}

// 点击搜索框的搜索按钮就会执行此函数
void MusicPlayer::searchMusicOnline(QString content)
{
    // 把之前的模型清空
    m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
    m_httpUtil->searchMusic(content);
}

void MusicPlayer::setMode(int mode)
{
    if (mode == 0)    // 本地模式
    {
        m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
        m_musicTableModel->setMode(MusicTableModel::LOCAL);
        m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
        fileInfoToModel(m_currentPath);
    }
    else
    {
        m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
        m_musicTableModel->setMode(MusicTableModel::ONLINE);
        m_musicTableModel->removeRows(0, m_musicTableModel->rowCount());
    }
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

// 在线搜索后，解析音乐后的槽函数
void MusicPlayer::parseMusicsFromJson(QJsonObject totalObject)
{
    // 列出json里所有的key
    QStringList keys = totalObject.keys();
    if(keys.contains("result"))
    {
        //在 json 文本中 {}花括号里面是QJsonObject对象, []方括号里面是QJsonArray
        QJsonObject resultObject = totalObject["result"].toObject();     //就将带 result 的内容提取后转换为对象
        QStringList resultKeys = resultObject.keys();      //保存所有key
        if(resultKeys.contains("songs"))                   //如果 key 为songs ,代表找到了歌曲
        {
            QJsonArray array = resultObject["songs"].toArray();
            for(auto i : array)                   //开始获取歌曲中的信息
            {
                OnlineMusicInfo info;       // 存储在线音乐信息
                QJsonObject object = i.toObject();
                info.onlineId = object["id"].toInt();                   // 音乐id
                info.duration = object["duration"].toInt();             // 音乐时长
                info.musicName = object["name"].toString();             // 音乐名
                QStringList artistsKeys = object.keys();
                if(artistsKeys.contains("artists"))                //如果result中包含了 artists
                {
                    QJsonArray artistsArray = object["artists"].toArray();   //将 artist 的内容提取后保存
                    // 有多个歌手默认只显示第一个
                    info.artist = artistsArray.at(0).toObject()["name"].toString();
                }
                if(artistsKeys.contains("album"))                //包含了专辑
                {
                    QJsonObject albumObjct = object["album"].toObject();
                    info.album = albumObjct["name"].toString();            // 专辑名
                }
                m_musicTableModel->append(info);
//                qDebug() << info.musicName << info.album <<info.artist << info.duration << info.onlineId;
            }
        }
    }
}
