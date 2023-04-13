#include "videotablemodel.h"
#include <QDateTime>

VideoTableModel::VideoTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    //新增了成员后，这里也要相应增加列名
    m_headerDatas << "ID" << "名称" << "大小" << "创建日期";
}


QVariant VideoTableModel::headerData(int section, Qt::Orientation orientation, int role) const
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

int VideoTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_datas.count();
}

int VideoTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_headerDatas.count();
}

QVariant VideoTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole || role == Qt::EditRole)
    {
        const int row = index.row();
        // 新增列后，这里也要相应修改
        switch(index.column())
        {
        // 索引号
        case 0: return row + 1;
        // 视频文件名称
        case 1: return m_datas.at(row).baseName();
        // 文件大小
        case 2: return QString::number(m_datas.at(row).size() / 1024 / 1024,'f',2) + "MB";
        // 创建日期
        case 3: return m_datas.at(row).birthTime().toString("yyyy-MM-dd hh:mm:ss");
        }
    }
    return QVariant();
}

bool VideoTableModel::insertRows(int row, int count, const QModelIndex &parent)
{
    //row为0就是开始，为rowcount就在尾巴
    if(row < 0 || count < 1 || row > rowCount())
        return false;
    //需要将操作放到beginInsertRows和endInsertRows两个函数调用之间
    beginInsertRows(parent, row, row + count - 1);
    for(int i = row; i < row + count; i++)
    {
        //在接口对应行插入空数据
        m_datas.insert(i, QFileInfo());
    }
    endInsertRows();
    return true;

}

bool VideoTableModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (row < 0 || count < 1 || row+count > rowCount())
        return false;
    //需要将操作放到beginRemoveRows和endRemoveRows两个函数调用之间
    beginRemoveRows(parent, row, row + count - 1);
    for(int i = row + count - 1; i >= row; i--)
    {
        m_datas.removeAt(i);
    }
    endRemoveRows();
    return true;
}


bool VideoTableModel::insertRow(int row, const QFileInfo &info)
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

bool VideoTableModel::removeRow(int row)
{
    if (row < 0 || row > rowCount())
         return false;
    //需要将操作放到beginRemoveRows和endRemoveRows两个函数调用之间
    beginRemoveRows(QModelIndex(), row, row);
    m_datas.removeAt(row);
    endRemoveRows();
    return true;
}

void VideoTableModel::append(const QFileInfo &info)
{
    beginInsertRows(QModelIndex(), m_datas.count(), m_datas.count()); //QModelIndex()得到这个Model中的虚拟rootItem
    m_datas.append(info);
    endInsertRows();
}

QString VideoTableModel::getVideoPathByRow(int row)
{
    if (row < 0 || row >= rowCount())
         return "";
    return m_datas.at(row).absoluteFilePath();
}

QString VideoTableModel::getVideoNamebyRow(int row)
{
    if (row < 0 || row >= rowCount())
         return "";
    return m_datas.at(row).baseName();
}





