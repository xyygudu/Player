#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "videoplayer.h"
#include "musicplayer.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    qmlRegisterSingletonType(QUrl("qrc:/Common/Skin.qml"), "Skin", 1, 0, "Skin");
    qmlRegisterSingletonType(QUrl("qrc:/Common/Config.qml"), "Config", 1, 0, "Config");

    VideoPlayer videoPlayer{};
    MusicPlayer musicPlayer{};
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("myVideoPlayer", &videoPlayer);
    engine.rootContext()->setContextProperty("myMusicPlayer", &musicPlayer);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
