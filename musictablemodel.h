#ifndef MUSICTABLEMODEL_H
#define MUSICTABLEMODEL_H

#include <QAbstractTableModel>
#include <QFileInfoList>

class MusicTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
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

    QString getMusicPathByRow(int row);
    QString getMusicNamebyRow(int row);

private:
    QStringList m_headerDatas;
    QFileInfoList m_datas;            // 用于保存表格中要显示的数据
};

#endif // MUSICTABLEMODEL_H
