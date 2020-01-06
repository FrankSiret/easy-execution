import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import easy_execution_model 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 500
    height: 210

    minimumWidth: 500
    minimumHeight: 210
    maximumHeight: 210

    color: "transparent"

    title: qsTr("easy-execution")

    background: Rectangle {
        radius: 4
        color: "#303030"
        border.color: Qt.darker("#303030")
        border.width: 2
    }

    EasyExecution {
        id: easyExecution
        onQuitProgram: {
            Qt.quit()
        }
    }

    property string whatIs: ""
    property var listAlias: []

    Component.onCompleted: {
        var OPEN = 1,
                HELP = 2,
                README = 3,
                ABOUT = 4,
                ADD_FILE = 5,
                ADD_FOLDER = 6;

        if ( openOption === OPEN ) {
            whatIs = "new object"
        }
        else if ( openOption === HELP ) { }
        else if ( openOption === README ) { }
        else if ( openOption === ABOUT ) { }
        else if ( openOption === ADD_FILE ) {
            pathName.text = programToAppend
            pathName.readOnly = true
            whatIs = "file"
        }
        else if ( openOption === ADD_FOLDER ) {
            pathName.text = programToAppend
            pathName.readOnly = true
            whatIs = "folder"
        }
        else {
            whatIs = "new object"
        }

        listAlias = easyExecution.getListOfPrograms()
    }

    MouseArea {
        anchors.fill: parent
        property point lastMousePos: Qt.point(0, 0)
        property bool mousePressed: false
        onPressed: {
            lastMousePos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            var delta = Qt.point(mouse.x - lastMousePos.x,
                                 mouse.y - lastMousePos.y)
            window.x += delta.x
            window.y += delta.y
        }
    }

    Rectangle {
        width: 12
        height: 12
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2
        color: Qt.rgba(0,0,0,0)
        Image {
            anchors.centerIn: parent
            width: 11
            fillMode: Image.PreserveAspectFit
            source: "qrc:/img/resize.svg"
            opacity: .3
        }
        MouseArea {
            anchors.fill: parent
            property point lastMousePos: Qt.point(0, 0)
            property bool mousePressed: false
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                lastMousePos = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                var delta = Qt.point(mouse.x - lastMousePos.x,
                                     mouse.y - lastMousePos.y)

                window.width = Math.max(window.width + delta.x, minimumWidth)
                window.height = Math.max(Math.min(window.height + delta.y, maximumHeight), minimumHeight)
            }
        }
    }

    RowLayout {
        id: layoutTitle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20

        Label {
            id: labelTitle
            text: "Add " + whatIs + " to Easy Execution"
            font.bold: true
            font.pointSize: 14
            Layout.rightMargin: 10
        }

        /*Rectangle {
            id: buttonAdd
            width: 30
            height: 30
            color: "transparent"

            property color rectColor: "#606060"
            Rectangle {
                width: 17
                height: 3
                color: parent.rectColor
                anchors.centerIn: parent
            }
            Rectangle {
                width: 17
                height: 3
                color: parent.rectColor
                rotation: 90
                anchors.centerIn: parent
            }

            property bool hover: false
            property bool press: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.hover = true; parent.rectColor = parent.press ? "#aaa" : "#fff" }
                onExited: { parent.hover = false; parent.rectColor = "#606060" }
                onPressed: { parent.press = true; parent.rectColor = "#aaa" }
                onReleased: { parent.press = false; parent.rectColor = parent.hover ? "#fff" : "#606060" }
                onClicked: {
                    dialogEasyExecution.typeDialog = "add"
                    dialogEasyExecution.aliasName1 = ""
                    dialogEasyExecution.programName = ""
                    dialogEasyExecution.index = -1
                    dialogEasyExecution.opened()
                    dialogEasyExecution.open()
                }
            }
        }

        Rectangle {
            id: buttonHelp
            width: 30
            height: 30
            color: "transparent"

            property color rectColor: "#606060"
            Label {
                text: "?"
                font.bold: true
                font.pointSize: 16
                color: parent.rectColor
                anchors.centerIn: parent
            }

            property bool hover: false
            property bool press: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.hover = true; parent.rectColor = parent.press ? "#aaa" : "#fff" }
                onExited: { parent.hover = false; parent.rectColor = "#606060" }
                onPressed: { parent.press = true; parent.rectColor = "#aaa" }
                onReleased: { parent.press = false; parent.rectColor = parent.hover ? "#fff" : "#606060" }
                onClicked: {

                }
            }
        }

        Rectangle {
            id: buttonSetting
            width: 30
            height: 30
            color: "transparent"

            property var sources: ["qrc:/img/settings1.svg", "qrc:/img/settings2.svg", "qrc:/img/settings3.svg"]
            property string rectSource: sources[0]

            Image {
                id: img1
                source: parent.rectSource
                anchors.centerIn: parent
                sourceSize.width: 17
                fillMode: Image.PreserveAspectFit
            }

            property bool hover: false
            property bool press: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.hover = true; parent.rectSource = parent.press ? parent.sources[2] : parent.sources[1] }
                onExited: { parent.hover = false; parent.rectSource = parent.sources[0] }
                onPressed: { parent.press = true; parent.rectSource = parent.sources[2] }
                onReleased: { parent.press = false; parent.rectSource = parent.hover ? parent.sources[1] : parent.sources[0] }
                onClicked: {

                }
            }
        }*/

        Item {
            width: 1
            Layout.fillWidth: true
        }

        Label {
            text: "frank.siret@gmail.com"
            font.pointSize: 9
            color: "#ce93d8"
            property bool hover: false
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Qt.openUrlExternally("mailto:frank.siret@gmail.com")
                }
                onHoveredChanged: {
                    parent.font.underline = parent.hover = !parent.hover
                }
            }
            ToolTip {
                text: "Frank Rodríguez Siret"
                delay: 500
                timeout: 2000
                visible: parent.hover
            }
        }

        Rectangle {
            id: buttonClose
            width: 30
            height: 30
            color: "transparent"

            property color rectColor: "#606060"
            Rectangle {
                width: 20
                height: 3
                color: parent.rectColor
                rotation: 45
                anchors.centerIn: parent
            }
            Rectangle {
                width: 20
                height: 3
                color: parent.rectColor
                rotation: -45
                anchors.centerIn: parent
            }

            property bool hover: false
            property bool press: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.hover = true; parent.rectColor = parent.press ? "#aaa" : "#fff" }
                onExited: { parent.hover = false; parent.rectColor = "#606060" }
                onPressed: { parent.press = true; parent.rectColor = "#aaa" }
                onReleased: { parent.press = false; parent.rectColor = parent.hover ? "#fff" : "#606060" }
                onClicked: Qt.quit()
            }
        }
    }

    property bool aliasInUse: false

    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: layoutTitle.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        anchors.bottomMargin: 14
        columns: 2

        columnSpacing: 10
        rowSpacing: 5

        Label {
            text: "Alias"
            Layout.minimumWidth: 40
        }
        Label {
            text: whatIs
            font.capitalization: Font.Capitalize
            Layout.fillWidth: true
        }

        TextField {
            id: aliasName
            selectByMouse: true
            onTextChanged: {
                //console.log ( text )
                aliasInUse = listAlias.indexOf(text.toLowerCase()) != -1
            }
            color: aliasInUse ? Material.color(Material.Red) : "white"
            onAccepted: {
                accept.clicked()
            }
            focus: true

            Label {
                id: text2
                anchors.top: parent.bottom
                anchors.topMargin: -5
                anchors.left: parent.left
                text: ""
                font.pointSize: 9
                color: Material.color(Material.Red)
                height: 0

                Behavior on height {
                    NumberAnimation { duration: 1500 }
                }
            }
        }
        TextField {
            id: pathName
            selectByMouse: true
            readOnly: true
            Layout.fillWidth: true
            Label {
                id: text1
                anchors.top: parent.bottom
                anchors.topMargin: -5
                anchors.left: parent.left
                text: ""
                font.pointSize: 9
                color: Material.color(Material.Red)
                height: 0

                Behavior on height {
                    NumberAnimation { duration: 1500 }
                }
            }
        }

        Item {
            height: 1
            Layout.fillHeight: true
            Layout.columnSpan: 2
        }

        RowLayout {
            Layout.columnSpan: 2
            spacing: 10
            Item {
                width: 1
                Layout.fillWidth: true
            }
            Button {
                id: accept
                text: "Accept"
                onClicked: {
                    text1.text = ""
                    text2.text = ""
                    text1.height = 0
                    text2.height = 0
                    if ( !aliasInUse && aliasName.text.length !== 0 && pathName.text.length !== 0 ) {
                        easyExecution.append(pathName.text, aliasName.text)
                        Qt.quit()
                    }
                    else {
                        if( aliasInUse ) {
                            text2.text = "Alias {" + aliasName.text + "} exists"
                            text2.height = 20
                        }
                        if( aliasName.text.length === 0 ) {
                            text2.text = "Blank field"
                            text2.height = 20
                        }
                        if( pathName.text.length === 0 ) {
                            text1.text = "Blank field"
                            text1.height = 20
                        }
                    }
                }
                Layout.minimumWidth: 150
                //Layout.fillWidth: true
                //Layout.fillHeight: true
                highlighted: true
            }
            Button {
                text: "Cancel"
                onClicked: {
                    Qt.quit()
                }
                Layout.minimumWidth: 150
                //Layout.fillWidth: true
                //Layout.fillHeight: true
            }
        }
    }

    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.FramelessWindowHint
}
