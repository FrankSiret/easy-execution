#include "easyexecution.h"
#include <QFileDialog>

EasyExecution::EasyExecution(QObject *parent) : QObject(parent)
{
    setting = new QSettings(QGuiApplication::applicationDirPath() + "/listOfProgram.ini", QSettings::IniFormat);
}

QList<QString> EasyExecution::getListOfPrograms() {
    set = setting->allKeys().toSet();
    return set.toList();
}

void EasyExecution::getCompleteList() {
    set = setting->allKeys().toSet();
    foreach (QString key, set) {
        QString _programName = setting->value(key, "").toString();
        QString _aliasName = key;
        if(!_programName.isEmpty())
            emit appendProgram(_programName, _aliasName);
    }
}

void EasyExecution::regedit(QString alias) {
    QSettings set("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths", QSettings::NativeFormat);
    set.beginGroup(alias + ".exe");
    set.setValue("Default", qApp->arguments()[0]);
    set.setValue("Path", qApp->applicationFilePath());
    set.endGroup();
}

QString EasyExecution::getPath() {
   QUrl openFileUrl = QFileDialog::getOpenFileUrl();
   qDebug() << openFileUrl;
   return "ads";
}

bool EasyExecution::isValid(QString path) {
    QDir a(path);
    bool res = a.exists();
    QFile b(path);
    res |= b.exists();
    return res;
}

void EasyExecution::append(QString pathName, QString alias)
{
    pathName.replace('\\','/');
    alias = alias.toLower();
    setting->setValue(alias, pathName);
    setting->sync();
}

void EasyExecution::deleteKey(QString alias)
{
    setting->remove(alias);
    setting->sync();
}

