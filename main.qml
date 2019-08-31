import QtQuick 2.9

Item {
    Component.onCompleted: Qt.openUrlExternally("file:///" + programToEject)
}
