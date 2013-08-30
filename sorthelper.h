#ifndef SORTHELPER_H
#define SORTHELPER_H

#include <QAbstractListModel>
#include <QSettings>
#include <QEvent>

class BuyItem
{
public:
    BuyItem(QString newItemName);
    BuyItem();
    QString name() const;
    bool done() const;
    quint32 amount() const;
    void setName(QString newName);
    void setDone(bool done);
    void setAmount(quint32 newAmount);
private:
    QString mName;
    bool mDone;
    quint32 mAmount;
};

class SortHelper : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(BuyItemRoles)
public:
    enum BuyItemRoles
    {
        NameRole = Qt::UserRole + 1,
        DoneRole,
        AmountRole
    };

    explicit SortHelper(QObject *parent = 0);
    Q_INVOKABLE void addBuyItem(QString itemName, quint32 itemCount = 1);
    Q_INVOKABLE void removeItem(int position);
    Q_INVOKABLE void moveToEnd(int position);
    Q_INVOKABLE void moveToStart(int position);
    Q_INVOKABLE void setData(int position, QVariant value, int role = NameRole);
    Q_INVOKABLE void saveData();
    Q_INVOKABLE void restoreData();


    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
protected:
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
private:
    QList<BuyItem> mItems;
    QSettings mSettings;
signals:
    
public slots:
    void parseString(QString deliveredText);
};

#endif // SORTHELPER_H
