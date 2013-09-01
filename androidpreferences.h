#ifndef ANDROIDPREFERENCES_H
#define ANDROIDPREFERENCES_H

#include <QStringList>

class AndroidPreferences
{
public:
    AndroidPreferences();
    void setPhoneNumbers(QString phones);
private:
    QStringList phoneNumbers;
};

#endif // ANDROIDPREFERENCES_H
