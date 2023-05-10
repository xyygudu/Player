#ifndef MUSICTABLEMODEL_H
#define MUSICTABLEMODEL_H

#include <QAbstractTableModel>
#include <QFileInfoList>

struct OnlineMusicInfo
{
    int id = 0;                 // 音乐的序号
    int onlineId = 0;           // 搜索在线音乐得到的id
    QString musicName;
    QString artist = "未知歌手";
    QString album = "未知专辑";
    int duration;        // 音乐时长
    QString singerImgSrc = "qrc:/source/images/defaultsinger.png";
};

class MusicTableModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList headerDatas READ headerDatas WRITE setHeaderDatas NOTIFY headerDatasChanged)
public:
    enum Mode
    {
        LOCAL = 0,       // 本地模式
        ONLINE           // 线上模式
    };
    explicit MusicTableModel(QObject *parent = nullptr);

    // Header:
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

    bool insertRow(int row, const QFileInfo &info);
    bool removeRow(int row);
    void append(const QFileInfo &info);

    bool insertRow(int row, const OnlineMusicInfo &info);
    void append(const OnlineMusicInfo &info);

    QString getMusicPathByRow(int row);
    QString getMusicNamebyRow(int row);
    QString getSingerNamebyRow(int row);
    int getMusicIdByRow(int row);

    void setMode(Mode m);
    Mode mode() const { return m_mode; }

    const QStringList &headerDatas() const { return m_headerDatas; };

    void setHeaderDatas(const QStringList &newHeaderDatas);

signals:
    void headerDatasChanged();

private:
    QStringList m_headerDatas;
    QFileInfoList m_datas;            // 用于保存表格中要显示的数据
    QVector<OnlineMusicInfo> m_onlineMusics;   // 用于保存线上音乐信息
    Mode m_mode;                      // 音乐播放模式（本地/线上）
    QString m_musicBaseUrl;

};

#endif // MUSICTABLEMODEL_H
