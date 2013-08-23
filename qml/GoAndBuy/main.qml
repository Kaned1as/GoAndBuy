import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    width: 300
    height: 600

    ListItemLayout {
        id: lil
    }

    TabView {
        anchors.fill: parent

        Tab {
            title: "First"

            GroupBox {
                anchors.fill: parent
                anchors.margins: 5

                ColumnLayout {
                    anchors.fill: parent

                    ListView {
                        id: buyItemsList
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        model: sampleLM
                        delegate: lil
                        spacing: 5
                        clip: true
                        add: Transition { NumberAnimation { property: "y"; easing.type: Easing.OutBounce; from: 1000; duration: 1000 } }
                    }

                    TextField {
                        id: newBuyItemText
                        placeholderText: qsTr("New item name")
                        height: 150
                        Layout.fillWidth: true
                    }

                    Button {
                        id: addBuyItemButton
                        text: qsTr("Add")
                        Layout.fillWidth: true
                        height: 50
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
