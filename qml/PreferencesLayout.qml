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

        add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; from: mainWidget.height; duration: 2000 } }
        move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }

        GroupBox {
            title: qsTr("Main preferences")
            anchors.left: parent.left
            anchors.right: parent.right

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: mainWidget.height / 30

                Text {
                    text: qsTr("Phone number to track")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }

                TextField {
                    id: phonesPreference
                    Layout.fillWidth: true
                    Layout.preferredHeight: mainWidget.height / 16
                    text: AndroidPrefs.phones
                    validator: RegExpValidator { regExp: /[\d;]+/ }
                    placeholderText: qsTr("Phone number to track")
                    onTextChanged: AndroidPrefs.writeParams()

                    Binding {
                       target: AndroidPrefs
                       property: "phones"
                       value: phonesPreference.text
                    }
                }

                Text {
                    text: qsTr("Buy string to search for")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }

                TextField {
                    id: buyStringPreference
                    Layout.fillWidth: true
                    Layout.preferredHeight: mainWidget.height / 16
                    text: AndroidPrefs.buyString
                    placeholderText: qsTr("Buy string")
                    onTextChanged: AndroidPrefs.writeParams()

                    Binding {
                       target: AndroidPrefs
                       property: "buyString"
                       value: buyStringPreference.text
                    }
                }

                Text {
                    text: qsTr("Items priority for SMS")
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }

                PriorityButton {
                    id: priorityPreference
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Layout.preferredHeight: mainWidget.height / 16
                    currentPriority: AndroidPrefs.smsPriority

                    onCurrentPriorityChanged: AndroidPrefs.writeParams()

                    Binding {
                       target: AndroidPrefs
                       property: "smsPriority"
                       value: priorityPreference.currentPriority
                    }
                }
            }
        }

        GroupBox {
            title: qsTr("Items sync preferences")
            anchors.left: parent.left
            anchors.right: parent.right

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: mainWidget.height / 30

                Button {
                    id: syncReceiver
                    text: qsTr("Receive sync from other app")
                    Layout.fillWidth: true
                    Layout.preferredHeight: mainWidget.height / 16
                    onClicked: ItemHandler.waitSync()
                }

                Button {
                    enabled: syncModePreference.current != undefined
                    id: syncStarter
                    text: qsTr("Send sync to other app")
                    Layout.fillWidth: true
                    Layout.preferredHeight: mainWidget.height / 16
                    onClicked: ItemHandler.sendSync()
                }

                ExclusiveGroup {
                    id: syncModePreference
                    onCurrentChanged: AndroidPrefs.writeParams()
                }

                SyncOptionRadioButton {
                    id: rb1
                    text: qsTr("Replace items")
                    pointColor: "#F00"
                    Layout.fillWidth: true
                    syncValue: "1"
                    exclusiveGroup: syncModePreference
                }

                SyncOptionRadioButton {
                    pointColor: "#0F0"
                    text: qsTr("Append items")
                    Layout.fillWidth: true
                    syncValue: "2"
                    exclusiveGroup: syncModePreference

                }

                SyncOptionRadioButton {
                    pointColor: "#00F"
                    text: qsTr("Append not existing items")
                    Layout.fillWidth: true
                    syncValue: "3"
                    exclusiveGroup: syncModePreference
                }
            }
        }
    }

    ButtonDialog {
        id: waiter
        onClicked: ItemHandler.stopSync()
    }

    Connections {
        target: ItemHandler
        onSyncCompleted: {
            prefContainer.enabled = true
            waiter.visible = false
        }
        onSyncStarted: {
            prefContainer.enabled = false
            waiter.visible = true
        }
    }
}
