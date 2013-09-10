#include "sorthelper.h"
#include <QDebug>
#include <QStringList>

SortHelper::SortHelper(AndroidPreferences* prefs, QObject *parent) :
    QAbstractListModel(parent), mPrefs(prefs)
{
}

void SortHelper::addBuyItem(QString itemName, quint32 itemCount, quint32 priority)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    BuyItem item(itemName);
    item.setAmount(itemCount > 0 ? itemCount : 1);
    item.setPriority(priority);
    mItems << item;
    endInsertRows();

    saveData();
}

void SortHelper::removeItem(int position)
{
    beginRemoveRows(QModelIndex(), position, position);
    mItems.removeAt(position);
    endRemoveRows();

    saveData();
}

void SortHelper::moveToEnd(int position)
{
    if(position == rowCount() - 1)
        return;

    beginMoveRows(QModelIndex(), position, position, QModelIndex(), rowCount());
    mItems.move(position, mItems.count() - 1);
    endMoveRows();

    saveData();
}

void SortHelper::moveToStart(int position)
{
    if(position == 0)
        return;

    beginMoveRows(QModelIndex(), position, position, QModelIndex(), 0);
    mItems.move(position, 0);
    endMoveRows();

    saveData();
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


void SortHelper::setData(int position, QVariant value, int role)
{
    setData(index(position), value, role);
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
        case PriorityRole:
            item.setPriority(value.toUInt());
            break;
        default:
            return false;
    }

    return true;
}

Qt::ItemFlags SortHelper::flags(const QModelIndex &index)
{
    return Qt::ItemIsSelectable | Qt::ItemIsEditable | Qt::ItemNeverHasChildren;
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
        case PriorityRole:
            return item.priority();
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
    roles[PriorityRole] = "priority";
    return roles;
}

void SortHelper::parseString(QString deliveredText)
{
    QString buyString = mPrefs ? mPrefs->buyString() : tr("buy");

    int buyStart = deliveredText.indexOf(buyString, 0, Qt::CaseInsensitive);
    if(buyStart == -1)
        return;
    buyStart += buyString.length(); // real start point

    int buyEnd = deliveredText.indexOf(QRegExp("[.!\?]"), buyStart);
    if(buyEnd == - 1)
        buyEnd = deliveredText.length(); // real end point

    // we must parse all buy items, let's assume they are divided by commas and contain amounts
    QStringList buyItemsList = deliveredText.mid(buyStart, buyEnd - buyStart).split(",", QString::SkipEmptyParts);
    if(buyItemsList.count() > 0)
        for(QString item : buyItemsList)
        {
            QStringList itemParsed = item.split(' ', QString::SkipEmptyParts);
            quint32 assumedCount = 0;
            // search for amount, store and delete it from item text
            QMutableStringListIterator it(itemParsed);
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

quint32 BuyItem::priority() const
{
    return mPriority;
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

void BuyItem::setPriority(quint32 newpriority)
{
    mPriority = newpriority;
}
