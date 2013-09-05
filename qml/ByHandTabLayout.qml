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
            Layout.fillHeight: true
            Layout.fillWidth: true
            verticalAlignment: TextInput.AlignTop
            wrapMode: TextEdit.WordWrap
        }

        Button {
            text: qsTr("Parse")
            Layout.preferredHeight: mainWidget.height / 16
            Layout.fillWidth: true

            onClicked: {
                ItemHandler.parseString(handInput.text)
                mainWidget.currentIndex = 0
            }
        }
    }
}
