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

    // this functions are never called in desktop versions!
    Q_INVOKABLE void writeParams() const;
    Q_INVOKABLE void saveValue(QString name, QString value);
    Q_INVOKABLE const QString getValue(QString name) const;
    Q_INVOKABLE void restoreParams();

    QString phones();
    void setPhones(QString newPhones);
private:
    QDomDocument prefXML;
    QDomElement prefMap;
signals:
    void phonesChanged(QString);
};

#endif // ANDROIDPREFERENCES_H
