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
                    }

                    TextField {
                        id: newBuyItemText
                        placeholderText: qsTr("New item name")
                        Layout.fillWidth: true
                        Layout.minimumHeight: mainWindow.height / 16
                        onAccepted: addBuyItemButton.clicked()
                    }
                    RowLayout
                    {
                        Button {
                            id: addBuyItemButton
                            text: qsTr("Add")
                            Layout.fillWidth: true
                            Layout.minimumHeight: mainWindow.height / 16
                            onClicked: {
                                if(newBuyItemText.text !== "") {
                                    ItemHandler.addBuyItem(newBuyItemText.text, buyItemCount.value)
                                    newBuyItemText.text = ""
                                }
                            }
                        }

                        SpinBox {
                            id: buyItemCount
                            minimumValue: 1
                            Layout.minimumHeight: mainWindow.height / 16
                        }
                    }
                }
            }
        }

        Tab {
            title: "Parameters"

            GroupBox {
                anchors.fill: parent
                anchors.margins: 5

                Column {
                    id: prefContainer
                    anchors.fill: parent
                    spacing: 5

                    add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: mainWindow.height; duration: 400 } }
                    move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }


                    TextField {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: mainWindow.height / 16
                        placeholderText: qsTr("Phone number to track")
                        onActiveFocusChanged: if(!activeFocus) {
                            ItemHandler.writeParams(text);
                        }
                        onTextChanged: ItemHandler.saveParams(text);
                    }

                }

                Button {
                    id: addPhoneButton
                    activeFocusOnPress: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: mainWindow.height / 16
                    text: qsTr("Add another phone")
                    onClicked: {
                        if(prefContainer.children.length >= 5)
                            return;

                        Qt.createQmlObject('import QtQuick.Layouts 1.0;
                                                   import QtQuick.Controls 1.0;
                                                   TextField {
                                                        anchors.left: parent.left
                                                        anchors.right: parent.right
                                                        height: mainWindow.height / 16
                                                   }', prefContainer);
                        }
                }

            }
        }
    }

    Component.onCompleted: ItemHandler.restoreData();
}
