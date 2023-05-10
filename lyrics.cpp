#include "lyrics.h"
#include "httputil.h"
#include <QFile>
#include <QDebug>
#include <QRegularExpression>
#include <QTextCodec>
#include <QByteArray>
#include <QDataStream>
#include <QJsonArray>

Lyrics::Lyrics(QObject *parent)
    : QObject{parent}
{

}

// // 解析歌词，把歌词变成QMap<qint64, int>形式，qint64表示当前歌曲播放的位置(单位是毫秒)，int表示对应歌词的索引，示例 27000 : 3
void Lyrics::parseLyricsFromFile(QString path, QMap<qint64, int> &lyric2IdxMap, LyricModel *lyricModel)
{
    QFile file(path);
    if (!file.exists())
    {
        // 歌词文件不存在就给出默认的歌词信息
        lyric2IdxMap.insert(0, 0);
        lyricModel->append("未找到任何歌词信息");
        return;
    }
    if(!file.open(QIODevice::ReadOnly))
        return;
    QByteArray allLyricByte = file.readAll();
    file.close();
    QTextCodec *codec = QTextCodec::codecForName("GBK");
    QString allLyricStr = codec->toUnicode(allLyricByte);
    parseLyrics(allLyricStr, lyric2IdxMap, lyricModel);
}

void Lyrics::parseLyricsFromMusicId(int musicId, QMap<qint64, int> &lyric2IdxMap, LyricModel *lyricModel)
{
    HttpUtil *httpUtil = new HttpUtil{};
    connect(httpUtil, &HttpUtil::parseJson, [=, &lyric2IdxMap](const QJsonObject &totalObject) mutable {
        // 列出json里所有的key
        QStringList keys = totalObject.keys();
        if(keys.contains("lyric"))
        {
            QString allLyricStr = totalObject["lyric"].toString();
            if (allLyricStr.isEmpty())
            {
                lyric2IdxMap.insert(0, 0);
                lyricModel->append("未找到任何歌词信息");
            }
            else
            {
                Lyrics::parseLyrics(allLyricStr, lyric2IdxMap, lyricModel);
            }
        }
        else
        {
            lyric2IdxMap.insert(0, 0);
            lyricModel->append("未找到任何歌词信息");
        }

    });
    httpUtil->getLyrics(musicId);
}


void Lyrics::parseLyrics(QString allLyricStr, QMap<qint64, int> &lyric2IdxMap, LyricModel *lyricModel)
{
    QStringList lyricList = allLyricStr.split("\n");
    // 通过正则表达式匹配歌词，下面表达式没有匹配[ar:xx音乐家][al:xx专辑]等信息
    // \\[(\\d+)?:(\\d+)?\\.(\\d+)?\\.?(\\d+)?\\](.*)?
    QRegularExpression regularExpression("\\[(\\d+)?:(\\d+)?\\.(\\d+)?\\.?(\\d+)?\\](.*)?");
    QRegularExpressionMatch match;
    int lyricIndex = 0;
    for (auto &lyric : lyricList)
    {
        match = regularExpression.match(lyric, 0);
        if (match.hasMatch()) {
            int totalTime;
            totalTime = match.captured(1).toInt() * 60000 + match.captured(2).toInt() * 1000;   /*  计算该时间点毫秒数            */
            QString currentText =QString::fromStdString(match.captured(5).toStdString());
            lyricModel->append(currentText);
            lyric2IdxMap.insert(totalTime, lyricIndex);
            lyricIndex++;
        }
    }
}
