#include <QtGui/QGuiApplication>
#include <QTranslator>
#include <QLibraryInfo>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    /*
    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator myappTranslator;
    myappTranslator.load("goandbuy_" + QLocale::system().name());
    app.installTranslator(&myappTranslator);*/

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/GoAndBuy/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
