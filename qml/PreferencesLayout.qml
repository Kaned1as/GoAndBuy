import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GroupBox {
    anchors.fill: parent
    anchors.margins: mainWidget.height / 100

    Column {
        id: prefContainer
        anchors.fill: parent
        spacing: 5

        add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: mainWidget.height; duration: 400 } }
        move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
        Text {
            text: qsTr("Phone number to track")
            horizontalAlignment: Qt.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
        }

        TextField {
            id: phonesPreference
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWidget.height / 16
            text: AndroidPrefs.phones
            validator: RegExpValidator { regExp: /[\d;]+/ }
            placeholderText: qsTr("Phone number to track")
            onActiveFocusChanged: if(!activeFocus) {
                AndroidPrefs.writeParams();
            }

            Binding {
               target: AndroidPrefs
               property: "phones"
               value: phonesPreference.text
            }
        }

        Text {
            text: qsTr("Buy string to search for")
            horizontalAlignment: Qt.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
        }

        TextField {
            id: buyStringPreference
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWidget.height / 16
            text: AndroidPrefs.buyString
            placeholderText: qsTr("Buy string")
            onActiveFocusChanged: if(!activeFocus) {
                AndroidPrefs.writeParams();
            }

            Binding {
               target: AndroidPrefs
               property: "buyString"
               value: buyStringPreference.text
            }
        }

        Text {
            text: qsTr("Items priority for SMS")
            horizontalAlignment: Qt.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
        }

        PriorityButton {
            id: priorityPreference
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWidget.height / 16
            currentPriority: AndroidPrefs.smsPriority

            onActiveFocusChanged: if(!activeFocus) {
                AndroidPrefs.writeParams();
            }

            Binding {
               target: AndroidPrefs
               property: "smsPriority"
               value: priorityPreference.currentPriority
            }
        }

        Button {
            id: syncStarter
            text: qsTr("Send sync to other app")
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWidget.height / 16
            onClicked: ItemHandler.startSync()
        }

        Button {
            id: syncReceiver
            text: qsTr("Receive sync from other app")
            anchors.left: parent.left
            anchors.right: parent.right
            height: mainWidget.height / 16
            onClicked: {
                ItemHandler.receiveSync()
                waiter.visible = true
            }
        }
    }

    Rectangle {
        id: waiter
        anchors.fill: parent
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
                text: qsTr("Please wait...")
                anchors.centerIn: parent
            }

            Button {
                text: qsTr("Cancel")
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: mainWidget.width / 50
                onClicked: {
                    ItemHandler.stopSync()
                    waiter.visible = false
                }
            }
        }
    }
}
