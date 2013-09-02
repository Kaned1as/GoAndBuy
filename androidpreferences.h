#ifndef ANDROIDPREFERENCES_H
#define ANDROIDPREFERENCES_H

#include <QStringList>
#include <QObject>

class AndroidPreferences : public QObject
{
    Q_OBJECT
public:
    AndroidPreferences(QObject *parent = 0);

    Q_PROPERTY(QString phones READ phones WRITE setPhones NOTIFY phonesChanged)

    void setPhones(QString phones);

    // this function is never called in desktop versions!
    Q_INVOKABLE void writeParams(QString phoneNumbers);
    Q_INVOKABLE void saveParams(QString phoneNumbers);
    Q_INVOKABLE void restoreParams();
    QString phones();
private:
    QStringList phoneNumbers;
signals:
    void phonesChanged(QString);
};

#endif // ANDROIDPREFERENCES_H
