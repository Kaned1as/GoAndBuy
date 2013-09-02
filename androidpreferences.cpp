#include "androidpreferences.h"
#include <QtXml>
#include <QFile>

AndroidPreferences::AndroidPreferences(QObject *parent) : QObject(parent)
{
}

void AndroidPreferences::writeParams(QString phoneNumbers)
{
    QDomDocument readyXml;
    // filename that we previously set in SMSReceiveService
    QFile settings("../shared_prefs/devicePrefs.xml"); // initially home dir for android apps is /data/data/appname/files folder

    // if the file doesn't exist, create it
    if(!settings.exists())
    {
        QDir settingsPath;
        settingsPath.mkpath("../shared_prefs/");
        settings.open(QFile::WriteOnly);

        // write xml header usual for android shared prefs
        QDomProcessingInstruction header = readyXml.createProcessingInstruction( "xml", "version='1.0' encoding='utf-8' standalone='yes' ");
        readyXml.appendChild(header);
        // write main prefs map
        QDomElement mainSettingsMap = readyXml.createElement("map");
        readyXml.appendChild(mainSettingsMap);
        // ID string - list of phones separated by ;
        QDomElement idString = readyXml.createElement("string");
        QDomText valueString = readyXml.createTextNode(phoneNumbers);
        mainSettingsMap.appendChild(idString);
        idString.setAttribute("name", "IDs");
        idString.appendChild(valueString);
        // write xml prefs to file
        settings.write(readyXml.toByteArray());
        settings.close();
        return;
    }

    // if the file already exists, alter it
    if(settings.open(QFile::ReadOnly))
    {
        readyXml.setContent(&settings);
        QDomNodeList strings = readyXml.elementsByTagName("string");
        for(int i = 0; i < strings.count(); ++i)
            if(strings.at(i).attributes().namedItem("name").toAttr().value() == "IDs")
                strings.at(i).firstChild().toText().setData(phoneNumbers);
        settings.close();

        settings.open(QFile::Truncate | QFile::WriteOnly);
        settings.write(readyXml.toByteArray());
        settings.close();
    }
}

void AndroidPreferences::saveParams(QString phoneNumbers)
{
    setPhones(phoneNumbers);
}

void AndroidPreferences::restoreParams()
{
    QDomDocument readyXml;

    QFile settings("../shared_prefs/devicePrefs.xml"); // initially home dir for android apps is /data/data/appname/files folder
    if(settings.exists() && settings.open(QFile::ReadOnly))
    {
        readyXml.setContent(&settings);
        QDomNodeList strings = readyXml.elementsByTagName("string");
        for(int i = 0; i < strings.count(); ++i)
        {
            if(strings.at(i).attributes().namedItem("name").toAttr().value() == "IDs")
                setPhones(strings.at(i).toElement().text());
        }
        settings.close();

        settings.open(QFile::Truncate | QFile::WriteOnly);
        settings.write(readyXml.toByteArray());
        settings.close();
    }
}


void AndroidPreferences::setPhones(QString phones)
{
    phoneNumbers = phones.split(";");
    emit phonesChanged(phones);
}

QString AndroidPreferences::phones()
{
    return phoneNumbers.join(";");
}
