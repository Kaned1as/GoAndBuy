#include <QtGui/QGuiApplication>
#include <QTranslator>
#include <QtQml>
#include <QLibraryInfo>
#include "qtquick2applicationviewer.h"

#include "sorthelper.h"
#include "androidpreferences.h"

#ifdef ANDROID
#include <jni.h>
#endif

static SortHelper* exportedSorter;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Heaven Inc.");
    QCoreApplication::setOrganizationDomain("antic1tizen.com");
    QCoreApplication::setApplicationName("Go And Buy");
    qmlRegisterUncreatableType<SortHelper>("com.adonai.Enums", 1, 0, "BuyItem", "Export enum to QML");

    /*
    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator myappTranslator;
    myappTranslator.load("goandbuy_" + QLocale::system().name());
    app.installTranslator(&myappTranslator);
    */

    SortHelper sorter;
    exportedSorter = &sorter;

    AndroidPreferences sharedPrefs;

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("ItemHandler", &sorter);
    viewer.rootContext()->setContextProperty("AndroidPrefs", &sharedPrefs);
    viewer.setMainQmlFile(QStringLiteral("qml/GoAndBuy/main.qml"));
    viewer.showExpanded();

    return app.exec();
}

#ifdef ANDROID
// our native method, it is called by the java code above
static void sendTextToQt(JNIEnv * env, jobject /*clazz*/, jstring text)
{
    const char* utfText = env->GetStringUTFChars(text, NULL);
    QString unparsed(utfText);

    // we call it so because sorter lives in another thread
    if(exportedSorter)
        QMetaObject::invokeMethod(exportedSorter, "parseString", Qt::QueuedConnection, Q_ARG(QString, unparsed));

    env->ReleaseStringUTFChars(text, utfText);
}

static JavaVM* s_javaVM = 0;
static JNINativeMethod methods[] = { {"sendTextToQt", "(Ljava/lang/String;)V", (void *)sendTextToQt} };

// this method is called immediately after the module is load
JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
{
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
    {
        qCritical() << "Can't get the environment";
        return -1;
    }

    s_javaVM = vm;
    // search for our class
    jclass clazz=env->FindClass("org/qtproject/qt5/android/bindings/QtActivity");
    if (!clazz)
    {
        qCritical() << "Can't find QtActivity class";
        return -1;
    }


    // register our native methods
    jclass activity = (jclass)env->NewGlobalRef(clazz);
    if (env->RegisterNatives(activity, methods, sizeof(methods) / sizeof(methods[0])) < 0)
    {
        qCritical() << "RegisterNatives failed";
        return -1;
    }

    qDebug() << "Yahooo!";
    return JNI_VERSION_1_6;
}
#endif
