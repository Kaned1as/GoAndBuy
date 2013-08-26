import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0

Rectangle {
    id: mainWindow
    width: 300
    height: 600

    ListItemLayout {
        id: lil
    }

    TabView {
        id: tabView
        anchors.fill: parent
        style: TabViewStyle {
            frameOverlap: 1
            tabsMovable: true
        }

        Tab {
            id: buyItemsTab
            title: "First"

            GroupBox {
                anchors.fill: parent
                anchors.margins: 5

                ColumnLayout {
                    anchors.fill: parent

                    ListView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        model: ItemHandler
                        delegate: lil
                        spacing: 5
                        clip: true
                        add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: mainWindow.height; duration: 1000 } }
                        move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
                        remove: Transition { NumberAnimation { property: "x"; to: Math.abs(x) / x * mainWindow.width; duration: 500 } }
                        removeDisplaced: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
                        moveDisplaced:  Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }

                        onCountChanged: saveItemsButton.visible = true;
                    }

                    TextField {
                        id: newBuyItemText
                        placeholderText: qsTr("New item name")
                        Layout.fillWidth: true
                        style: TextFieldStyle {
                            textColor: "black"
                            background: Rectangle {
                                radius: mainWindow.width / 100
                                implicitHeight: mainWindow.height / 16
                                border.color: "#333"
                                border.width: 1
                            }
                        }

                        onAccepted: addBuyItemButton.clicked()
                    }
                    RowLayout
                    {
                        Button {
                            id: addBuyItemButton
                            text: qsTr("Add")
                            Layout.fillWidth: true
                            height: mainWindow.height / 10
                            onClicked: {
                                if(newBuyItemText.text !== "") {
                                    ItemHandler.addBuyItem(newBuyItemText.text)
                                    newBuyItemText.text = ""
                                }
                            }
                        }

                        Button {
                            id: saveItemsButton
                            visible: false
                            text: qsTr("Save Items")
                            Layout.fillWidth: true
                            height: mainWindow.height / 10
                            onClicked: {
                                visible = false;
                                ItemHandler.saveData();
                            }
                        }
                    }
                }
            }
        }

        Tab {
            title: "Second"

            GroupBox {
                anchors.fill: parent
                anchors.margins: 5
            }
        }
    }

    Component.onCompleted: ItemHandler.restoreData();
}
