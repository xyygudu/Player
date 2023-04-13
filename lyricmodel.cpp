#include "lyricmodel.h"

LyricModel::LyricModel(QObject *parent)
    : QAbstractListModel(parent)
{
}


int LyricModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_lyricList.count();
}

QVariant LyricModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if(index.row() >= m_lyricList.size())
        return QVariant();

    if (role == Qt::DisplayRole)
    {
        return m_lyricList.at(index.row());
    }

    return QVariant();
}

void LyricModel::insert(int index, const QString &data)
{
    if(index < 0 || index > m_lyricList.count())
    {
        return;
    }
    //进行增删改查都需要begin/end，用来发送信号通知关联Model上的view进行更新
    beginInsertRows(QModelIndex(), index, index); //QModelIndex()得到这个Model中的虚拟rootItem
    m_lyricList.insert(index, data);
    endInsertRows();
}

void LyricModel::remove(int index)
{
    if(index < 0 || index > m_lyricList.count())
    {
        return;
    }
    beginRemoveRows(QModelIndex(), index, index);
    m_lyricList.removeAt(index);
    endRemoveRows();
}

void LyricModel::append(const QString &data)
{
    int i = m_lyricList.size();
    beginInsertRows(QModelIndex(), i, i);
    m_lyricList.append(data);
    endInsertRows();
}

void LyricModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, m_lyricList.size() - 1);
    m_lyricList.clear();
    endRemoveRows();
}
