import QtQuick 2.0

Rectangle {
    id: firstLaunch
    anchors.fill: parent
    opacity: 0.8
    color: "black"
    z: 1
    visible: AndroidPrefs.getValue("firstLaunch") !== "0"
    Behavior on visible { NumberAnimation { property: "scale"; duration: 200; easing.type: Easing.InOutQuad; to: 3 } }

    Component.onCompleted:  AndroidPrefs.setValue("firstLaunch", "0")

    Text {
        id: leftText
        anchors.right: parent.right
        anchors.rightMargin: mainWidget.width / 6 * 5
        width: mainWidget.width
        transformOrigin: Item.Right
        rotation: -95
        color: "white"
        font.pointSize: 12
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("Add items manually with count that you choose")
        wrapMode: Text.Wrap

        SequentialAnimation {
            running: firstLaunch.visible
            loops: Animation.Infinite
            NumberAnimation { target: leftText; property: "rotation"; from: -100; to: -80; easing.type: Easing.InOutQuad; duration: 1000 }
            NumberAnimation { target: leftText; property: "rotation"; from: -80; to: -100; easing.type: Easing.InOutQuad; duration: 1000 }
        }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: mainWidget.width / 2
        width: mainWidget.width
        transformOrigin: Item.Right
        rotation: -90
        color: "white"
        font.pointSize: 12
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("Copy text anywhere and navigate to second tab - it will be pasted here automagically, so you have only to click \"Parse\"")
        wrapMode: Text.Wrap
    }

    Text {
        id: rightText
        anchors.right: parent.right
        anchors.rightMargin: mainWidget.width / 6
        width: mainWidget.width
        transformOrigin: Item.Right
        rotation: -85
        color: "white"
        font.pointSize: 12
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("Choose desired phone number and string to search for in incoming SMS and wait for the first!")
        wrapMode: Text.Wrap

        SequentialAnimation {
            running: firstLaunch.visible
            loops: Animation.Infinite
            NumberAnimation { target: rightText; property: "rotation"; from: -80; to: -100; easing.type: Easing.InOutQuad; duration: 1000 }
            NumberAnimation { target: rightText; property: "rotation"; from: -100; to: -80; easing.type: Easing.InOutQuad; duration: 1000 }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: mainWidget.height / 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        color: "white"
        font.pointSize: 12
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("This program is designed for people who get their purchases list from wife's SMS ;) ")
        wrapMode: Text.Wrap
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "white"
        font.pointSize: 12
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("Use it well!")
        wrapMode: Text.Wrap
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.visible = false
            AndroidPrefs.writeParams()
        }
    }
}
