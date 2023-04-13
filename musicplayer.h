#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include <QObject>
#include "musictablemodel.h"
#include "lyricmodel.h"

class MusicPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(MusicTableModel *musicTableModel READ musicTableModel CONSTANT)
    Q_PROPERTY(LyricModel *lyricModel READ lyricModel CONSTANT)
    Q_PROPERTY(QMap<qint64, int> lyric2IdxMap READ lyric2IdxMap CONSTANT)
    Q_PROPERTY(QString currentPath READ currentPath WRITE setCurrentPath NOTIFY currentPathChanged)
public:
    explicit MusicPlayer(QObject *parent = nullptr);
    ~MusicPlayer();

    void fileInfoToModel(const QString &path);
    Q_INVOKABLE void updateMusicModel(const QString& path);
    Q_INVOKABLE QString getMusicPathByRow(int row);
    Q_INVOKABLE QString getMusicNameByRow(int row);
    Q_INVOKABLE void upDateLyricModelBy(int row);
    // 通过音乐播放的position和当前歌词的时间相比较，得到最终要显示歌词的index
    Q_INVOKABLE int getLyricIdxByPosition(qint64 pos);

    MusicTableModel *musicTableModel() const;

    const QString &currentPath() const;
    void setCurrentPath(const QString &newCurrentPath);

    LyricModel *lyricModel() const;

    const QMap<qint64, int> &lyric2IdxMap() const;

signals:

    void currentPathChanged();

private:
    MusicTableModel *m_musicTableModel;
    LyricModel *m_lyricModel;
    QString m_currentPath;      // 记录当前播放音乐的路径
    QMap<qint64, int> m_lyric2IdxMap; // 把音乐播放到的时间点和歌词的索引联系起来

};

#endif // MUSICPLAYER_H
