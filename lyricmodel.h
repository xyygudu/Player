#ifndef LYRICMODEL_H
#define LYRICMODEL_H

#include <QAbstractListModel>

class LyricModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit LyricModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void insert(int index, const QString &data);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void append(const QString &data);
    Q_INVOKABLE void clear();

private:
    QStringList m_lyricList;

};

#endif // LYRICMODEL_H
