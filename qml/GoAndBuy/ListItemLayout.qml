import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Component {
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        Rectangle {
            anchors.fill: parent
            color: "gray"
            radius: 3
            border.width: 3
            border.color: Qt.darker("gray")

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8

                CheckBox {
                    id: buyItemCheckBox
                    Layout.alignment: Qt.AlignVCenter

                    style: CheckBoxStyle {
                        indicator: Rectangle {
                            implicitWidth: 20
                            implicitHeight: 20
                            radius: 3
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1
                            Rectangle {
                                visible: control.checked
                                color: "#555"
                                border.color: "#333"
                                radius: 1
                                anchors.margins: 4
                                anchors.fill: parent
                            }
                        }
                    }
                }

                Text {
                    id: buyItemName
                    text: title
                }
            }
        }
    }
}
