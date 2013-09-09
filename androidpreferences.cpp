#include "androidpreferences.h"
#include <QFile>

AndroidPreferences::AndroidPreferences(QObject *parent) : QObject(parent)
{
    // write xml header usual for android shared prefs
    QDomProcessingInstruction header = prefXML.createProcessingInstruction( "xml", "version='1.0' encoding='utf-8' standalone='yes' ");
    prefXML.appendChild(header);
    // write main prefs map
    prefMap = prefXML.createElement("map");
    prefXML.appendChild(prefMap);
}



void AndroidPreferences::writeParams() const
{
    // filename that we previously set in SMSReceiveService
    QFile settings("../shared_prefs/devicePrefs.xml"); // initially home dir for android apps is /data/data/appname/files folder

    // if the file doesn't exist, create it
    if(!settings.exists())
    {
        QDir settingsPath;
        settingsPath.mkpath("../shared_prefs/");
        settings.open(QFile::WriteOnly);

        // write xml prefs to file
        settings.write(prefXML.toByteArray());
        settings.close();
        return;
    }

    // if the file already exists, alter it
    if(settings.open(QFile::Truncate | QFile::WriteOnly))
    {
        settings.write(prefXML.toByteArray());
        settings.close();
    }
}

void AndroidPreferences::restoreParams()
{
    QFile settings("../shared_prefs/devicePrefs.xml"); // initially home dir for android apps is /data/data/appname/files folder
    if(settings.exists() && settings.open(QFile::ReadOnly))
    {
        prefXML.setContent(&settings);
        prefMap = prefXML.lastChild().toElement();
        settings.close();
    }
}


void AndroidPreferences::setValue(const QString name, const QString value)
{
    // search if we have one already
    for(int i = 0; i < prefMap.childNodes().count(); ++i)
    {
        QDomNode current = prefMap.childNodes().item(i);
        if(current.toElement().attribute("name") == name)
        {
            if(!current.hasChildNodes())
            {
                QDomText newPhones = prefXML.createTextNode(value);
                current.appendChild(newPhones);
            }
            else
                current.firstChild().toText().setData(value);

            return;
        }
    }

    // create new
    QDomElement idString = prefXML.createElement("string");
    QDomText valueString = prefXML.createTextNode(value);
    prefMap.appendChild(idString);
    idString.setAttribute("name", name);
    idString.appendChild(valueString);
}

const QString AndroidPreferences::getValue(const QString name) const
{
    for(int i = 0; i < prefMap.childNodes().count(); ++i)
    {
        QDomNode current = prefMap.childNodes().item(i);
        if(current.toElement().attribute("name") == name)
            return current.toElement().text();
    }
    return QString();
}

QString AndroidPreferences::phones() const
{
    return getValue("IDs");
}

QString AndroidPreferences::buyString() const
{
    return getValue("buyString");
}

void AndroidPreferences::setPhones(const QString newPhones)
{
    setValue("IDs", newPhones);
    emit phonesChanged(newPhones);
}

void AndroidPreferences::setBuyString(const QString newBuyString)
{
    setValue("buyString", newBuyString);
    emit buyStringChanged(newBuyString);
}
