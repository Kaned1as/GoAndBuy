#include "androidpreferences.h"

AndroidPreferences::AndroidPreferences()
{
}

void AndroidPreferences::setPhoneNumbers(QString phones)
{
    phoneNumbers = phones.split(";");
}
