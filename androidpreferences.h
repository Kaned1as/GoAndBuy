#ifndef ANDROIDPREFERENCES_H
#define ANDROIDPREFERENCES_H

#include <QStringList>
#include <QObject>
#include <QtXml>

class AndroidPreferences : public QObject
{
    Q_OBJECT
public:
    AndroidPreferences(QObject *parent = 0);

    Q_PROPERTY(QString phones READ phones WRITE setPhones NOTIFY phonesChanged STORED false)
    Q_PROPERTY(QString buyString READ buyString WRITE setBuyString NOTIFY buyStringChanged STORED false)
    Q_PROPERTY(QString smsPriority READ smsPriority WRITE setSmsPriority NOTIFY smsPriorityChanged STORED false)

    // this functions are never called in desktop versions!
    Q_INVOKABLE void writeParams() const;
    Q_INVOKABLE void setValue(const QString name, const QString value);
    Q_INVOKABLE const QString getValue(const QString name) const;
    void restoreParams();

    QString phones() const;
    QString buyString() const;
    QString smsPriority() const;
    void setPhones(const QString newPhones);
    void setBuyString(const QString newBuyString);
    void setSmsPriority(const QString newSmsPriority);
private:
    QDomDocument prefXML;
    QDomElement prefMap;
signals:
    void phonesChanged(QString);
    void buyStringChanged(QString);
    void smsPriorityChanged(QString);
};

#endif // ANDROIDPREFERENCES_H
