#include "sorthelper.h"
#include <QDebug>
#include <QStringList>

SortHelper::SortHelper(QObject *parent) :
    QAbstractListModel(parent)
{
}

void SortHelper::addBuyItem(QString itemName, quint32 itemCount)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    BuyItem item(itemName);
    item.setAmount(itemCount > 0 ? itemCount : 1);
    mItems << item;
    endInsertRows();
}

void SortHelper::removeItem(int position)
{
    beginRemoveRows(QModelIndex(), position, position);
    mItems.removeAt(position);
    endRemoveRows();
}

void SortHelper::moveToEnd(int position)
{
    qDebug() << mItems.at(position).done();
    if(position == rowCount() - 1)
        return;

    beginMoveRows(QModelIndex(), position, position, QModelIndex(), rowCount());
    mItems.move(position, mItems.count() - 1);
    endMoveRows();
}

void SortHelper::moveToStart(int position)
{
    qDebug() << mItems.at(position).done();
    if(position == 0)
        return;

    beginMoveRows(QModelIndex(), position, position, QModelIndex(), 0);
    mItems.move(position, 0);
    endMoveRows();
}

void SortHelper::setData(int position, QVariant value, int role)
{
    setData(index(position), value, role);
}

void SortHelper::saveData()
{
    mSettings.beginGroup("Stored");
    mSettings.remove("");
    mSettings.beginWriteArray("items");
    for(int i = 0; i < rowCount(); ++i)
    {
        mSettings.setArrayIndex(i);
        for(int iter : roleNames().keys())
            mSettings.setValue(roleNames()[iter], data(index(i), iter));
    }
    mSettings.endArray();
    mSettings.endGroup();
    mSettings.sync();
}

void SortHelper::restoreData()
{
    beginResetModel();
    mItems.clear();
    endResetModel();

    mSettings.beginGroup("Stored");
    int count = mSettings.beginReadArray("items");
    beginInsertRows(QModelIndex(), rowCount(), rowCount() + count);
    for(int i = 0; i < count; ++i)
    {
        mSettings.setArrayIndex(i);
        mItems.append(BuyItem());
        for(int iter : roleNames().keys())
            setData(index(i), mSettings.value(roleNames()[iter]), iter);
    }
    mSettings.endArray();
    mSettings.endGroup();
    endInsertRows();
}

int SortHelper::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mItems.count();
}

bool SortHelper::setData(const QModelIndex &index, const QVariant &value, int role)
{
    BuyItem& item = mItems[index.row()];
    switch(role)
    {
        case NameRole:
            item.setName(value.toString());
            break;
        case DoneRole:
            item.setDone(value.toBool());
            break;
        case AmountRole:
            item.setAmount(value.toUInt());
            break;
        default:
            return false;
    }

    return true;
}

QVariant SortHelper::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mItems.count())
        return QVariant();

    const BuyItem &item = mItems[index.row()];
    switch(role)
    {
        case NameRole:
            return item.name();
        case DoneRole:
            return item.done();
        case AmountRole:
            return item.amount();
        default:
            return QVariant();
    }
}

QHash<int, QByteArray> SortHelper::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DoneRole] = "done";
    roles[AmountRole] = "amount";
    return roles;
}

void SortHelper::parseString(QString deliveredText)
{
    int buyStart = deliveredText.indexOf(tr("buy"), 0, Qt::CaseInsensitive);
    if(buyStart == -1)
        return;

    // we must parse all buy items, let's assume they are divided by commas and contain amounts
    int buyEnd = deliveredText.indexOf('.', buyStart);
    QStringList buyItemsList = deliveredText.mid(buyStart + tr("buy").length(), buyEnd).split(",", QString::SkipEmptyParts);
    if(buyItemsList.count() > 0)
        for(QString item : buyItemsList)
        {
            QStringList itemParsed = item.split(' ', QString::SkipEmptyParts);
            quint32 assumedCount = 0;
            // search for amount, store and delete it from item text
            QMutableListIterator<QString> it(itemParsed);
            while(it.hasNext())
            {
                assumedCount = it.next().toUInt();
                if(assumedCount)
                {
                    it.remove();
                    break;
                }
            }

            addBuyItem(itemParsed.join(' '), assumedCount);
        }
}


BuyItem::BuyItem(QString newItemName) : mDone(false), mAmount(1)
{
    mName = newItemName;
}

BuyItem::BuyItem()
{
}

QString BuyItem::name() const
{
    return mName;
}

bool BuyItem::done() const
{
    return mDone;
}

quint32 BuyItem::amount() const
{
    return mAmount;
}

void BuyItem::setName(QString newName)
{
    mName = newName;
}

void BuyItem::setDone(bool done)
{
    mDone = done;
}

void BuyItem::setAmount(quint32 newAmount)
{
    mAmount = newAmount;
}
