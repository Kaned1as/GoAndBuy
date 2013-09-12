#ifndef SORTHELPER_H
#define SORTHELPER_H

#include <QAbstractListModel>
#include <QSettings>
#include <QEvent>

#include "androidpreferences.h"

class BuyItem
{
public:
    BuyItem(QString newItemName);
    BuyItem();
    QString name() const;
    bool done() const;
    quint32 amount() const;
    quint32 priority() const;
    void setName(QString newName);
    void setDone(bool done);
    void setAmount(quint32 newAmount);
    void setPriority(quint32 newpriority);

    bool operator < (BuyItem& second) const;
private:
    QString mName;
    bool mDone;
    quint32 mAmount;
    quint32 mPriority;
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
        AmountRole,
        PriorityRole
    };

    explicit SortHelper(AndroidPreferences* prefs = NULL, QObject *parent = 0);
    Q_INVOKABLE void addBuyItem(QString itemName, quint32 itemCount = 1, quint32 priority = 1);
    Q_INVOKABLE void removeItem(int position);
    Q_INVOKABLE void setData(int position, QVariant value, int role = NameRole);
    Q_INVOKABLE void saveData();
    void restoreData();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
    Q_INVOKABLE void sort();
protected:
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
private:
    QList<BuyItem> mItems;
    QSettings mSettings;
    AndroidPreferences* mPrefs;
signals:
    
public slots:
    // this function is never called in desktop versions!
    void parseString(QString deliveredText);
};

#endif // SORTHELPER_H
