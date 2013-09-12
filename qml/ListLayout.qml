import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GroupBox {
    anchors.fill: parent
    anchors.margins: mainWidget.height / 100

    ColumnLayout {
        anchors.fill: parent

        ListView {
            focus: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ItemHandler
            delegate: lil
            spacing: 5
            clip: true
            add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: mainWidget.height; duration: 1000 } }
            move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
            remove: Transition { NumberAnimation { property: "x"; to: Math.abs(x) / x * mainWidget.width; duration: 500 } }
            removeDisplaced: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
            moveDisplaced:  Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
        }

        RowLayout
        {
            TextField {
                id: newBuyItemText
                placeholderText: qsTr("New item name")
                Layout.fillWidth: true
                Layout.preferredHeight: mainWidget.height / 16
                onAccepted: addBuyItemButton.clicked()
            }

            SpinBox {
                id: buyItemCount
                minimumValue: 1
                Layout.preferredHeight: mainWidget.height / 16
            }

            PriorityButton {
                id: priorityList
                Layout.preferredHeight: mainWidget.height / 16
            }
        }

        Button {
            id: addBuyItemButton
            text: qsTr("Add")
            Layout.fillWidth: true
            Layout.preferredHeight: mainWidget.height / 16
            onClicked: {
                if(newBuyItemText.text !== "") {
                    ItemHandler.addBuyItem(newBuyItemText.text, buyItemCount.value, priorityList.currentPriority)
                    newBuyItemText.text = ""
                }
            }
        }
    }
}
