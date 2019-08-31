#ifndef EASYEXECUTION_H
#define EASYEXECUTION_H

#include <QObject>
#include <QApplication>
#include <QSettings>
#include <QDebug>

class EasyExecution : public QObject
{
    Q_OBJECT
public:
    explicit EasyExecution(QObject *parent = nullptr);
    Q_INVOKABLE void append(QString pathName, QString alias);
    Q_INVOKABLE QList<QString> getListOfPrograms();
    Q_INVOKABLE void getCompleteList();
    Q_INVOKABLE void deleteKey(QString alias);
    Q_INVOKABLE QString getPath();
    Q_INVOKABLE bool isValid(QString path);
    Q_INVOKABLE void regedit(QString alias);

    enum Option {
        OPEN = 1,
        HELP = 2,
        README = 3,
        ABOUT = 4,
        ADD_FILE = 5,
        ADD_FOLDER = 6
    };
    Q_ENUM(Option)

signals:
    void appendProgram(QString _programName, QString _aliasName);
    void quitProgram();

public slots:

private:
    QSettings *setting;
    QSet<QString> set;
};

#endif // EASYEXECUTION_H
