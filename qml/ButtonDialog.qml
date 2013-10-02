import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: buttonDialog

    property string buttonText: qsTr("Cancel")
    property string dialogText: qsTr("Please wait...")
    signal clicked;

    anchors.fill: parent
    anchors.margins: -50 // fill all space available
    color: "#AA000000"
    visible: false

    Rectangle {
        anchors.centerIn: parent
        anchors.left: parent.left
        anchors.right: parent.right
        color: "white"
        radius: mainWidget.width / 25
        height: mainWidget.height / 4
        width: mainWidget.width / 1.5

        Text {
            text: dialogText
            anchors.fill: parent
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            wrapMode: Text.WordWrap
        }

        Button {
            text: buttonText
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: mainWidget.width / 20
            onClicked:  buttonDialog.clicked();
        }
    }

    onVisibleChanged: {
        if(visible) smoothAppear.start()
    }

    NumberAnimation { id: smoothAppear; target: buttonDialog; property: "opacity"; from: 0; to: 1; duration: 1000; easing.type: Easing.OutQuad }
}
