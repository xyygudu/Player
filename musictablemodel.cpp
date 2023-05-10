#include "musictablemodel.h"
#include "fileutil.h"
#include <QDateTime>

MusicTableModel::MusicTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_mode = LOCAL;
    m_musicBaseUrl = "https://music.163.com/song/media/outer/url?id=";
    // 设置表头名称
    if (m_mode == LOCAL)
        m_headerDatas << "ID" << "名称" << "大小" << "创建日期"; //新增了成员后，这里也要相应增加列名
    else
        m_headerDatas << "ID" << "名称" << "歌手" << "专辑";
}

QVariant MusicTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole)
    {
        if (orientation == Qt::Horizontal)
        {
            // 返回第section列的表头数据，如果section超出范围，则返回QString::number(section)
            return m_headerDatas.value(section, QString::number(section));
        }
    }
    return QVariant();
}

int MusicTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    if (m_mode == LOCAL)
        return m_datas.count();
    else
        return m_onlineMusics.size();
}

int MusicTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_headerDatas.count();
}

QVariant MusicTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole || role == Qt::EditRole)
    {
        const int row = index.row();
        if (m_mode ==LOCAL)
        {
            // 新增列后，这里也要相应修改
            switch(index.column())
            {
            // 索引号
            case 0: return row + 1;
            // 音乐文件名称
            case 1: return m_datas.at(row).baseName();
            // 文件大小
            case 2: return FileUtil::instance()->convertByteTo(m_datas.at(row).size());
            // 创建日期
            case 3: return m_datas.at(row).birthTime().toString("yyyy-MM-dd hh:mm:ss");
            }
        }
        else
        {
            // 新增列后，这里也要相应修改
            switch(index.column())
            {
            // 索引号
            case 0: return row + 1;
            // 歌曲名
            case 1: return m_onlineMusics.at(row).musicName;
            // 歌手
            case 2: return m_onlineMusics.at(row).artist;
            // 专辑
            case 3: return m_onlineMusics.at(row).album;
            }
        }
    }
    return QVariant();
}

bool MusicTableModel::insertRows(int row, int count, const QModelIndex &parent)
{
    //row为0就是开始，为rowcount就在尾巴
    if(row < 0 || count < 1 || row > rowCount())
        return false;
    //需要将操作放到beginInsertRows和endInsertRows两个函数调用之间
    beginInsertRows(parent, row, row + count - 1);
    for(int i = row; i < row + count; i++)
    {
        //在接口对应行插入空数据
        if (m_mode == LOCAL)
            m_datas.insert(i, QFileInfo());
        else
            m_onlineMusics.push_back(OnlineMusicInfo{});
    }
    endInsertRows();
    return true;
}

bool MusicTableModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || count < 1 || row+count > rowCount())
        return false;
    //需要将操作放到beginRemoveRows和endRemoveRows两个函数调用之间
    beginRemoveRows(parent, row, row + count - 1);
    for(int i = row + count - 1; i >= row; i--)
    {
        if (m_mode == LOCAL)
            m_datas.removeAt(i);
        else
            m_onlineMusics.removeAt(i);
    }
    endRemoveRows();
    return true;
}

bool MusicTableModel::insertRow(int row, const QFileInfo &info)
{
    if (row >=0 && row <= m_datas.size())
    {
        //进行增删改查都需要begin/end，用来发送信号通知关联Model上的view进行更新
        beginInsertRows(QModelIndex(), row, row); //QModelIndex()得到这个Model中的虚拟rootItem
        m_datas.insert(row, info);
        endInsertRows();
        return true;
    }
    return false;
}

bool MusicTableModel::removeRow(int row)
{
    if (row < 0 || row > rowCount())
         return false;
    //需要将操作放到beginRemoveRows和endRemoveRows两个函数调用之间
    beginRemoveRows(QModelIndex(), row, row);
    if (m_mode == LOCAL)
        m_datas.removeAt(row);
    else
        m_onlineMusics.removeAt(row);
    endRemoveRows();
    return true;
}

void MusicTableModel::append(const QFileInfo &info)
{
    beginInsertRows(QModelIndex(), m_datas.count(), m_datas.count()); //QModelIndex()得到这个Model中的虚拟rootItem
    m_datas.append(info);
    endInsertRows();
}

bool MusicTableModel::insertRow(int row, const OnlineMusicInfo &info)
{
    if (row >=0 && row <= m_onlineMusics.size())
    {
        //进行增删改查都需要begin/end，用来发送信号通知关联Model上的view进行更新
        beginInsertRows(QModelIndex(), row, row); //QModelIndex()得到这个Model中的虚拟rootItem
        m_onlineMusics.insert(row, info);
        endInsertRows();
        return true;
    }
    return false;
}

void MusicTableModel::append(const OnlineMusicInfo &info)
{
    beginInsertRows(QModelIndex(), m_onlineMusics.count(), m_onlineMusics.count());
    m_onlineMusics.append(info);
    endInsertRows();
}

// 通过行号找到音乐所在路径（如果是在线音乐，就返回音乐的url）
QString MusicTableModel::getMusicPathByRow(int row)
{
    if (row < 0 || row >= rowCount())
         return "";
    if (m_mode == LOCAL)
        return m_datas.at(row).absoluteFilePath();
    else
        return m_musicBaseUrl + QString::number(m_onlineMusics.at(row).onlineId);
}

QString MusicTableModel::getMusicNamebyRow(int row)
{
    if (row < 0 || row >= rowCount())
         return "";
    if (m_mode == LOCAL)
        return m_datas.at(row).baseName();
    else
        return m_onlineMusics.at(row).musicName;
}

QString MusicTableModel::getSingerNamebyRow(int row)
{
    if (row < 0 || row >= rowCount())
         return "";
    if (m_mode == LOCAL)
        return "未知歌手";
    else
        return m_onlineMusics.at(row).artist;
}

int MusicTableModel::getMusicIdByRow(int row)
{
    if (row < 0 || row >= rowCount())
         return -1;
    if (m_mode == LOCAL)
        return row + 1;  // 返回music在列表中的行
    else
        return m_onlineMusics.at(row).onlineId;
}

void MusicTableModel::setMode(Mode m)
{
    m_mode = m;
    if (m_mode == LOCAL)
    {
        m_headerDatas.clear();
        m_headerDatas << "ID" << "名称" << "大小" << "创建日期";
        emit headerDatasChanged();
    }
    else
    {
        m_headerDatas.clear();
        m_headerDatas << "ID" << "名称" << "歌手" << "专辑";
        emit headerDatasChanged();
    }

}

void MusicTableModel::setHeaderDatas(const QStringList &newHeaderDatas)
{
    if (m_headerDatas == newHeaderDatas)
        return;
    m_headerDatas = newHeaderDatas;
    emit headerDatasChanged();
}


