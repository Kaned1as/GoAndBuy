#include <QtGui/QGuiApplication>
#include <QTranslator>
#include <QtQml>
#include <QLibraryInfo>
#include "qtquick2applicationviewer.h"

#include "sorthelper.h"
#include "androidpreferences.h"

static QString localeString = "";
static SortHelper* exportedSorter;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Heaven Inc.");
    QCoreApplication::setOrganizationDomain("antic1tizen.com");
    QCoreApplication::setApplicationName("Go And Buy");
    qmlRegisterUncreatableType<SortHelper>("com.adonai.Enums", 1, 0, "BuyItem", "Export enum to QML");


    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

#ifndef ANDROID
    localeString = QLocale::system().name();
#endif


    QTranslator myappTranslator;
    myappTranslator.load("assets:/i18n/" + localeString);
    app.installTranslator(&myappTranslator);


    AndroidPreferences sharedPrefs;
    sharedPrefs.restoreParams();

    SortHelper sorter(&sharedPrefs);
    sorter.restoreData();
    exportedSorter = &sorter;

    QtQuick2ApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("ItemHandler", &sorter);
    viewer.rootContext()->setContextProperty("AndroidPrefs", &sharedPrefs);
    viewer.setMainQmlFile(QStringLiteral("qml/GoAndBuy/main.qml"));
    viewer.showExpanded();

    return app.exec();
}

#ifdef ANDROID
#include <jni.h>
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

    // search for our class
    jclass clazz=env->FindClass("org/qtproject/qt5/android/bindings/QtActivity");
    if (!clazz)
    {
        qCritical() << "Can't find QtActivity class";
        return -1;
    }

    // Java class, that can get Local information
    const char* localeClassName = "java/util/Locale";
    jclass locale = env->FindClass(localeClassName);
    jmethodID constr = env->GetStaticMethodID(locale, "getDefault", "()Ljava/util/Locale;");
    // calling static method - getDefault() - getting java.util.Locale object
    jobject obj1 = env->CallStaticObjectMethod(locale, constr);
    jclass appClass1 = env->GetObjectClass(obj1);
    constr = env->GetMethodID(appClass1, "toString", "()Ljava/lang/String;");
    // calling method of java.util.Locale object - getLanguage()
    jstring result = (jstring)env->CallObjectMethod(obj1, constr);
    // converting jstring to QString
    const char *strResult = env->GetStringUTFChars(result, 0);
    localeString = strResult;
    env->ReleaseStringUTFChars(result, strResult);

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
