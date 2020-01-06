import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import easy_execution_model 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 600
    height: 500

    minimumWidth: 560
    minimumHeight: 500

    color: "transparent"

    background: Rectangle {
        radius: 4
        color: "#303030"
        border.color: Qt.darker("#303030")
        border.width: 2
    }

    property var _model: []

    EasyExecution {
        id: easyExecution
        onAppendProgram: {
            //listModel.append({"programName": _programName, "aliasName": _aliasName})
            _model.push([_programName, _aliasName])
        }
        onEndList: {
            //_model = listModel
            restore()
        }
        onQuitProgram: {
            Qt.quit()
        }
    }

    property string whatIs: ""
    property var listAlias: []
    property bool isRegister: false

    Component.onCompleted: {
        var OPEN = 1,
            HELP = 2,
            README = 3,
            ABOUT = 4,
            ADD_FILE = 5,
            ADD_FOLDER = 6;

        if ( openOption === OPEN ) {
            whatIs = "new program"
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
            whatIs = "program"
        }
        else {
            whatIs = "new program"
        }

        isRegister = easyExecution.isRegister("ex")
        listAlias = easyExecution.getListOfPrograms()
        easyExecution.getCompleteList();
    }

    MouseArea { /// check max-min window can move and maximization window when is factible
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
            cursorShape: Qt.SizeFDiagCursor
            onPressed: {
                lastMousePos = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                var delta = Qt.point(mouse.x - lastMousePos.x,
                                     mouse.y - lastMousePos.y)

                window.width = Math.max(window.width + delta.x, minimumWidth)
                window.height = Math.max(window.height + delta.y, minimumHeight)
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
            text: "easy execution"
            font.bold: true
            font.pointSize: 14
            Layout.rightMargin: 10
        }

        Rectangle {
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
            ToolTip {
                text: "Add"
                delay: 500
                timeout: 2000
                visible: parent.hover
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
                    dialogConfig.open()
                }
            }
            ToolTip {
                text: "Config"
                delay: 500
                timeout: 2000
                visible: parent.hover
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

            /*MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.hover = true; parent.rectColor = parent.press ? "#aaa" : "#fff" }
                onExited: { parent.hover = false; parent.rectColor = "#606060" }
                onPressed: { parent.press = true; parent.rectColor = "#aaa" }
                onReleased: { parent.press = false; parent.rectColor = parent.hover ? "#fff" : "#606060" }
                onClicked: {

                }
            }*/
            ToolTip {
                text: "Help"
                delay: 500
                timeout: 2000
                visible: parent.hover
            }
        }

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

    function restore() {
        listModel.clear()
        for(var i=0; i<_model.length; i++){
            listModel.append({
                "programName":_model[i][0],
                "aliasName":_model[i][1]
            })
        }
    }

    function filter(text) {
        try {
            var c=0
            for(var i=0;i<_model.length;i++) {
                var pn = _model[i][0]
                var an = _model[i][1]
                var arr = text.split(" ");

                var b = true
                //console.log(arr)
                for(var j=0; j<arr.length;j++){
                    var it=arr[j]
                    if(it.length > 0 && an.match(it) === null && pn.match(it) === null) {
                        b = false;
                    }
                }
                if(!b) {
                    listModel.remove(i-c++);
                }
            }
            text0.text = ""
        }
        catch (err) {
            //console.log(err)
            text0.text = "Invalid regular expression"
        }
    }

    Timer {
        id: timeout
        interval: 100
        onTriggered: {
            restore()
            filter(search.text)
        }
    }

    TextField {
        id: search
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: layoutTitle.bottom
        anchors.margins: 20
        placeholderText: "Filter"
        selectByMouse: true
        onTextChanged: timeout.restart()
        onAccepted: {
            if(listModel.count === 1)
                Qt.openUrlExternally("file:///" + listModel.get(0).programName)
            else listProgram.forceActiveFocus()
        }
        focus: true
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: search.clear()
        }

        Label {
            id: text0
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

        KeyNavigation.tab: listProgram
        KeyNavigation.down: listProgram
        KeyNavigation.up: listProgram
    }

    property int maxAdvance: 0

    Rectangle {
        anchors.fill: listProgram
        color: "#2d2d2d"
        Image {
            source: "qrc:/img/back.jpg"
            anchors.centerIn: parent
            scale: 2
            opacity: listModel.count === 0 ? .5 : 0
            anchors.horizontalCenterOffset: -20
        }
    }

    Component {
        id: delegateRect
        Rectangle {
            color: ListView.isCurrentItem ? "#50ce93d8" : Qt.lighter("#303030")
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            radius: 2
            //anchors.margins: 2
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            Rectangle {
                id: rectTop
                color: "transparent"
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: rectTop.color = Qt.rgba(1,1,1,.1)
                    onExited: rectTop.color = Qt.rgba(1,1,1,0)
                    onPressed: rectTop.color = Qt.rgba(1,1,1,.2)
                    onReleased: rectTop.color = Qt.rgba(1,1,1,.1)
                    onCanceled: rectTop.color = Qt.rgba(1,1,1,.1)
                    onClicked: listProgram.currentIndex = index
                    onDoubleClicked: {
                        listProgram.currentIndex = index
                        Qt.openUrlExternally("file:///" + listModel.get(index).programName)
                    }
                }
            }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 10
                Label {
                    text: aliasName
                    font.bold: true
                    font.pointSize: 12
                    Layout.minimumWidth: maxAdvance
                    font.capitalization: Font.AllUppercase
                    horizontalAlignment: Text.AlignRight
                    Component.onCompleted: maxAdvance = Math.max(maxAdvance, advance.width)
                }
                MenuSeparator {
                    contentItem: Rectangle {
                        implicitWidth: 1
                        implicitHeight: 25
                        color: "#2affffff"
                    }
                }
                Label {
                    text: programName
                    property int maxWidth: 0
                    //wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    //horizontalAlignment: (advance.width > width) ? Text.AlignRight : Text.AlignLeft
                    font.pointSize: 12
                    //clip: true
                    Layout.fillWidth: true
                    elide: Text.ElideLeft
                    //Layout.maximumWidth: window.width - 120
                    //Layout.minimumWidth: window.width - 120
                }
                MenuSeparator {
                    contentItem: Rectangle {
                        implicitWidth: 1
                        implicitHeight: 25
                        color: "#2affffff"
                    }
                }
                /*Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: "#882a2a2a"
                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -2
                        anchors.verticalCenterOffset: 2
                        source: "qrc:/img/edit.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 25
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: 15
                        color: "transparent"
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.color = Qt.rgba(0,0,0,.1)
                                rectTop.color = Qt.rgba(1,1,1,.1)
                            }
                            onExited: {
                                parent.color = Qt.rgba(0,0,0,0)
                                rectTop.color = Qt.rgba(1,1,1,0)
                            }
                            onPressed: {
                                parent.color = Qt.rgba(0,0,0,.2)
                            }
                            onReleased: {
                                parent.color = Qt.rgba(0,0,0,.1)
                            }
                            onCanceled: {
                                parent.color = Qt.rgba(0,0,0,.1)
                            }
                            onClicked: {
                                dialogEasyExecution.typeDialog = "edit"
                                dialogEasyExecution.aliasName1 = listModel.get(index).aliasName
                                dialogEasyExecution.programName = listModel.get(index).programName
                                dialogEasyExecution.index = index
                                dialogEasyExecution.opened()
                                dialogEasyExecution.open()
                            }
                        }
                    }
                }*/
                Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: "#882a2a2a"
                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -2
                        anchors.verticalCenterOffset: 1
                        source: "qrc:/img/garbage-2.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 25
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: 15
                        color: "transparent"
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.color = Qt.rgba(0,0,0,.1)
                                rectTop.color = Qt.rgba(1,1,1,.1)
                            }
                            onExited: {
                                parent.color = Qt.rgba(0,0,0,0)
                                rectTop.color = Qt.rgba(1,1,1,0)
                            }
                            onPressed: {
                                parent.color = Qt.rgba(0,0,0,.2)
                            }
                            onReleased: {
                                parent.color = Qt.rgba(0,0,0,.1)
                            }
                            onCanceled: {
                                parent.color = Qt.rgba(0,0,0,.1)
                            }
                            onClicked: {
                                confirmDialog.entity = listModel.get(index).aliasName
                                confirmDialog.index = index
                                confirmDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            color: "#00ce93d8"
            border.color: "#ce93d8"
            border.width: 2
            radius: 2
            anchors.left: listModel.count > 0 ? parent.left : undefined
            anchors.right: listModel.count > 0 ? parent.right : undefined
            height: 40
            z: 2
            y: listProgram.currentItem.y
            Behavior on y {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }

    ListView {
        id: listProgram
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: search.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        clip: true
        spacing: 10
        model: ListModel { id: listModel }
        delegate: delegateRect

        highlight: highlight
        highlightFollowsCurrentItem: false

        ScrollBar.vertical: ScrollBar { }

        KeyNavigation.tab: search
        Keys.onPressed: {
            if(event.key >= Qt.Key_A && event.key <= Qt.Key_Z) {
                search.text = String.fromCharCode(event.key + 32)
                search.forceActiveFocus()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Escape)
            {
                search.clear()
                search.forceActiveFocus()
                event.accepted = true
            }
            else if(event.key === Qt.Key_Return) {
                Qt.openUrlExternally("file:///" + listModel.get(currentIndex).programName)
            }
        }
    }

    Dialog {
        id: confirmDialog
        modal: true
        property string entity: ""
        property int index: -1
        title: "Delete item {" + entity.toUpperCase() + "}"
//        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 200 + maxAdvance
        bottomPadding: -1
        rightPadding: 5
        contentItem: RowLayout {
            focus: true
            Item {
                width: 1
                Layout.fillWidth: true
            }
            Button {
                text: "Accept"
                font.pixelSize: 14
                onClicked: confirmDialog.accept()
                Layout.minimumWidth: 90
                highlighted: true
                flat: true
            }
            Button {
                text: "Cancel"
                font.pixelSize: 14
                onClicked: confirmDialog.reject()
                Layout.minimumWidth: 90
                highlighted: true
                flat: true
            }
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    confirmDialog.reject()
                    event.accepted = true
                }
                else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    confirmDialog.accept()
                    event.accepted = true
                }
            }
        }

        onAccepted: {
            var len = _model.length
            var temp = []
            for(var i=0; i<len; i++) {
                if(_model[i][1] !== entity)
                    temp.push(_model[i])
            }
            _model = temp
            console.log(_model.length, _model)
            //easyExecution.deleteKey(entity)
            //listAlias = easyExecution.getListOfPrograms()
            timeout.restart()
        }

        x: Math.max(0, window.width / 2 - width / 2)
        y: Math.max(0, window.height / 2 - height / 2 - 20)
    }

    Dialog {
        id: dialogEasyExecution
        modal: true
        property alias programName: pathName.text
        property alias aliasName1: aliasName.text
        property int index: -1
        property string typeDialog: "edit"
        property bool aliasInUse: false
        title: typeDialog === "edit" ? "Edit item {" + aliasName1.toUpperCase() + "}" : "Add new item to Easy Execution"
        width: 400
//        bottomPadding: -1
//        rightPadding: 5

        signal opened()

        onOpened: {
            text1.text = ""
            text2.text = ""
            text1.height = 0
            text2.height = 0
            //console.log("opened")
        }

        contentItem: GridLayout {
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.top: labelTitle.bottom
//            anchors.bottom: parent.bottom
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
                text: "Path"
                Layout.fillWidth: true
            }

            TextField {
                id: aliasName
                selectByMouse: true
                onTextChanged: {
                    //console.log ( text )
                    dialogEasyExecution.aliasInUse = listAlias.indexOf(text.toLowerCase()) != -1
                }
                color: dialogEasyExecution.aliasInUse ? Material.color(Material.Red) : "white"
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
                //text: dialogEasyExecution.aliasName1
            }
            TextField {
                id: pathName
                selectByMouse: true
                //readOnly: true
                Layout.fillWidth: true
                onTextChanged: {
                    text = text.replace('\\','/')
                }

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
//                text: dialogEasyExecution.programName
//                Layout.rightMargin: 40
//                ToolButton {
//                    text: "..."
//                    onClicked: {
//                        var r = easyExecution.getPath();
//                    }
//                }
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

                        var valid = easyExecution.isValid(pathName.text)

                        if ( !dialogEasyExecution.aliasInUse && aliasName.text.length !== 0 && pathName.text.length !== 0 ) {

                            if ( !valid ) {
                                text1.height = 20
                                text1.text = "The Path doesn't exist"
                            }
                            else {
                                easyExecution.append(pathName.text, aliasName.text)
                                listAlias = easyExecution.getListOfPrograms()
                                _model.push([pathName.text, aliasName.text])
                                timeout.restart()
                                dialogEasyExecution.accept()
                            }
                        }
                        else {
                            if( dialogEasyExecution.aliasInUse ) {
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
                        dialogEasyExecution.reject()
                    }
                    Layout.minimumWidth: 150
                    //Layout.fillWidth: true
                    //Layout.fillHeight: true
                }
            }
        }

        onAccepted: {
            listAlias = easyExecution.getListOfPrograms()
        }

        x: Math.max(0, window.width / 2 - width / 2)
        y: Math.max(0, window.height / 2 - height / 2 - 20)
    }

    Dialog {
        id: dialogConfig
        modal: true

        title: "Config"
        width: 400

        signal opened()

        onOpened: {
            check1.checked = isRegister
        }

        contentItem: GridLayout {
            anchors.margins: 20
            anchors.bottomMargin: 14
            columns: 2

            columnSpacing: 10
            rowSpacing: 5

            CheckBox {
                id: check1
                text: "Add to Window's path"
                Layout.fillWidth: true
                checked: isRegister
                onClicked: {
                    if(checked) {
                        isRegister = true
                        easyExecution.regedit("ex")
                    }
                    else {
                        isRegister = false
                        easyExecution.deleteRegister("ex")
                    }
                }
                Layout.columnSpan: 2
            }

            Label {
                id: label1
                text: "Alias for easy execution"
            }
            TextField {
                id: textAlias
                selectByMouse: true
                onTextChanged: {
                    console.log ( text )
                    //dialogEasyExecution.aliasInUse = listAlias.indexOf(text.toLowerCase()) != -1
                }
                //color: dialogEasyExecution.aliasInUse ? Material.color(Material.Red) : "white"
                onAccepted: {

                }
                readOnly: true
                text: "ex"
                placeholderText: "Default: ex"
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
                    text: "Ok"
                    onClicked: {
                        dialogConfig.reject()
                    }
                    Layout.minimumWidth: 150
                }
            }
        }

        onAccepted: {
            listAlias = easyExecution.getListOfPrograms()
        }

        x: Math.max(0, window.width / 2 - width / 2)
        y: Math.max(0, window.height / 2 - height / 2 - 20)
    }

    flags: Qt.MSWindowsFixedSizeDialogHint | Qt.FramelessWindowHint
}
