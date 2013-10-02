import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GroupBox {
    anchors.fill: parent
    anchors.margins: mainWidget.height / 100

    ColumnLayout {
        anchors.fill: parent

        Text {
            text: qsTr("Provide input by hand")
            Layout.alignment: Qt.AlignHCenter
        }

        TextArea {
            id: handInput
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: mainWidget.height / 2
            Layout.fillWidth: true
            verticalAlignment: TextInput.AlignTop
            wrapMode: TextEdit.WordWrap

            onActiveFocusChanged: if(text.length == 0) text = ClipboardAdapter.getText()

            MouseArea {
                anchors.fill: parent
                onClicked: pasteDialog.visible = true;
            }
        }

        Button {
            focus: true
            text: qsTr("Parse")
            anchors.top: handInput.bottom
            anchors.topMargin: 10
            Layout.preferredHeight: mainWidget.height / 16
            Layout.fillWidth: true
            onClicked: {
                ItemHandler.parseString(handInput.text)
                handInput.text = ""
            }
        }
    }

    ButtonDialog {
        id: pasteDialog;
        dialogText: qsTr("Paste from clipboard?")
        buttonText: qsTr("Paste")
        onClicked: { pasteDialog.visible = false; handInput.append(ClipboardAdapter.getText()) }
    }
}
