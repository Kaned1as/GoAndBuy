import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

GroupBox {
    anchors.fill: parent
    anchors.margins: mainWidget.height / 100

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: mainWidget.height / 60

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
                onPressAndHold: pasteDialog.visible = true;
            }
        }

        Button {
            focus: true
            text: qsTr("Parse")
            Layout.preferredHeight: mainWidget.height / 16
            Layout.fillWidth: true
            onClicked: {
                ItemHandler.parseString(handInput.text, findWord.checked)
                handInput.text = ""
            }
        }

        CheckBox {
            id: findWord
            text: qsTr("Search for buy string?")
            style: CheckBoxStyle {
                indicator: Rectangle {
                    implicitWidth: mainWidget.height / 30
                    implicitHeight: mainWidget.height / 30
                    radius: mainWidget.height / 200
                    border.color: control.activeFocus ? "darkblue" : "gray"
                    border.width: 1
                    Rectangle {
                        visible: control.checked
                        color: "#555"
                        border.color: "#333"
                        radius: mainWidget.height / 400
                        anchors.margins: 4
                        anchors.fill: parent
                    }
                }
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
