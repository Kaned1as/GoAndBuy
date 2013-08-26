#include <QtGui/QGuiApplication>
#include <QTranslator>
#include <QtQml>
#include <QLibraryInfo>
#include "qtquick2applicationviewer.h"
#include "sorthelper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Heaven Inc.");
    QCoreApplication::setOrganizationDomain("antic1tizen.com");
    QCoreApplication::setApplicationName("Go And Buy");
    /*
    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator myappTranslator;
    myappTranslator.load("goandbuy_" + QLocale::system().name());
    app.installTranslator(&myappTranslator);*/
    qmlRegisterUncreatableType<SortHelper>("com.adonai.Enums", 1, 0, "BuyItem", "Export enum to QML");
    SortHelper sorter;
    sorter.addBuyItem("axax");

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("ItemHandler", &sorter);
    viewer.setMainQmlFile(QStringLiteral("qml/GoAndBuy/main.qml"));
    viewer.showExpanded();


    return app.exec();
}
