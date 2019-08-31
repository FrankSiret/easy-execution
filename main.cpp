#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QSettings>
#include <QDebug>
#include <QApplication>

#include "easyexecution.h"

void setContextMenu(QGuiApplication &app) {
    const QString key = "HKEY_CURRENT_USER\\Software\\Classes";
    QString filePath = QDir::toNativeSeparators(app.applicationFilePath());
    QSettings settings(key, QSettings::NativeFormat);
    settings.beginGroup("Folder");
    settings.beginGroup("shell");
    settings.beginGroup("EasyExecution");
    settings.setValue("Default", "Add folder to Easy Execution");
    settings.setValue("icon", filePath + ",0");
    settings.beginGroup("command");
    settings.setValue("Default", filePath + " -folder \"%1\"");
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();

    /*settings.beginGroup("Directory");
    settings.beginGroup("background");
    settings.beginGroup("shell");
    settings.beginGroup("Add to Easy Execution");
    settings.setValue("icon", filePath + ",0");
    settings.beginGroup("command");
    settings.setValue("Default", filePath + " \"%V\"");
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();*/

    settings.beginGroup("*");
    settings.beginGroup("shell");
    settings.beginGroup("EasyExecution");
    settings.setValue("Default", "Add file to Easy Execution");
    settings.setValue("icon", filePath + ",0");
    settings.beginGroup("command");
    settings.setValue("Default", filePath + " -file \"%1\"");
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
    settings.endGroup();
}

enum Option {
    OPEN = 1,
    HELP = 2,
    README = 3,
    ABOUT = 4,
    ADD_FILE = 5,
    ADD_FOLDER = 6
};

void append(QQmlApplicationEngine &engine, Option e = ADD_FILE, QString p = "") {
    qmlRegisterType<EasyExecution>("easy_execution_model", 1, 1, "EasyExecution");
    engine.rootContext()->setContextProperty("openOption", e);
    engine.rootContext()->setContextProperty("programToAppend", p);
    engine.load(QUrl(QStringLiteral("qrc:/open.qml")));
}

void open(QQmlApplicationEngine &engine, Option e = OPEN) {
    qmlRegisterType<EasyExecution>("easy_execution_model", 1, 1, "EasyExecution");
    engine.rootContext()->setContextProperty("openOption", e);
    engine.load(QUrl(QStringLiteral("qrc:/config.qml")));
}

void execute(QQmlApplicationEngine &engine, QString e) {
    engine.rootContext()->setContextProperty("programToEject", e);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
}

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);

    QApplication app(argc, argv);

    app.setApplicationName("EasyExecution");
    app.setApplicationDisplayName("EasyExecution");
    app.setOrganizationName("Mirage's Company");
    app.setApplicationVersion("1.2");
    app.setOrganizationDomain("easyexecution.franksiret.project.qt.com.cu");

    setContextMenu(app);

    QStringList larg = app.arguments();
    QSettings sett(app.applicationDirPath() + "\\listOfProgram.ini", QSettings::IniFormat);

    QQmlApplicationEngine engine;

    if ( larg.size() > 2 ) {
        if ( larg[1] == "-file" ) {
            QString file = larg[2];
            file.replace("\\","/");
            append(engine, ADD_FILE, file);
        }
        else if( larg[1] == "-folder" ) {
            QString folder = larg[2];
            folder.replace("\\","/");
            folder.replace("\"","");
            append(engine, ADD_FOLDER, folder);
        }
        else {
            open(engine, HELP);
        }

        if (engine.rootObjects().isEmpty())
            return -1;

        return app.exec();
    }


    if ( larg.size() < 2 ) {
        open(engine);

        if (engine.rootObjects().isEmpty())
            return -1;

        return app.exec();
    }

    QString arg1 = larg[1];
    QString prog = sett.value(arg1, "").toString();
    prog.replace("\\","/");
    prog.replace("\"","");

    if ( arg1 == "-h" || arg1 == "--help" ) {
        open(engine, HELP);
    }
    else if ( arg1 == "-a" || arg1 == "--about" ) {
        open(engine, ABOUT);
    }
    else if ( arg1 == "-r" || arg1 == "--readme" ) {
        open(engine, README);
    }
    else if ( arg1 == "-l" || arg1 == "--list" ) {
        //open(engine, LIST);
        prog = app.applicationDirPath() + "\\listOfProgram.ini";
        prog.replace("\\","/");
        execute(engine, prog);
        return 0;
    }
    else if(!prog.isEmpty()) {
        execute(engine, prog);
        return 0;
    }
    else return 0;

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
