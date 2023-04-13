#ifndef VIDEOTABLEMODEL_H
#define VIDEOTABLEMODEL_H

#include <QAbstractTableModel>
#include <QFileInfoList>

class VideoTableModel : public QAbstractTableModel
{
    Q_OBJECT
public:

    explicit VideoTableModel(QObject *parent = nullptr);

    // 返回表头内容（比如每一列/行的标题）
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

    QString getVideoPathByRow(int row);
    QString getVideoNamebyRow(int row);

signals:

private:
    QStringList m_headerDatas;
    QFileInfoList m_datas;            // 用于保存表格中要显示的数据


};

#endif // VIDEOTABLEMODEL_H
