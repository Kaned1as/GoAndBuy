import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Component {
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40 * mainWindow.height * 0.0025
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
                            implicitWidth: mainWindow.width / 15
                            implicitHeight: mainWindow.width / 15
                            radius: mainWindow.width / 100
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

                    onCheckedChanged: {
                        if(checked)
                            sampleLM.move(index, sampleLM.count - 1, 1)
                        else
                            sampleLM.move(index, 0, 1)
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
