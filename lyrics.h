#ifndef LYRICS_H
#define LYRICS_H

#include <QObject>
#include "lyricmodel.h"

class Lyrics : public QObject
{
    Q_OBJECT
public:

    explicit Lyrics(QObject *parent = nullptr);
    // 解析歌词，把歌词变成QMap<qint64, int>形式，qint64表示当前歌曲播放的位置，int表示对应歌词的索引
    static void parseLyrics(QString path, QMap<qint64, int> &lyric2IdxMap, LyricModel *lyricModel);

signals:
private:
    QString m_path;
};

#endif // LYRICS_H
