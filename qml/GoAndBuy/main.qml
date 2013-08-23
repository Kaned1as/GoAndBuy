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
                        model: sampleLM
                        delegate: lil
                        spacing: 5
                        clip: true
                        add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: mainWindow.height; duration: 1000 } }
                        move: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
                        moveDisplaced:  Transition { NumberAnimation { property: "y"; easing.type: Easing.OutElastic; duration: 2000 } }
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
                    }

                    Button {
                        id: addBuyItemButton
                        text: qsTr("Add")
                        Layout.fillWidth: true
                        height: mainWindow.height / 12
                        onClicked: {
                            if(newBuyItemText.text !== "") {
                                sampleLM.append({"title" : newBuyItemText.text});
                                newBuyItemText.text = "";
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

    ListModel {
        id: sampleLM
        ListElement {
            title: "first"
        }
        ListElement {
            title: "second"
        }
        ListElement {
            title: "third"
        }
    }
}
