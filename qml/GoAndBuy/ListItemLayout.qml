import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import com.adonai.Enums 1.0

Component {
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40 * mainWindow.height * 0.0025
        opacity: (mainWindow.width - Math.abs(x)) / mainWindow.width

        MouseArea {
            onPressed: {
                parent.anchors.left = undefined
                parent.anchors.right = undefined
            }
            onReleased: {
                if(parent.opacity < 0.7)
                    ItemHandler.removeItem(index)
                else {
                    parent.anchors.left = parent.parent.left
                    parent.anchors.right = parent.parent.right
                }
            }
            onClicked: buyItemCheckBox.checked = !buyItemCheckBox.checked

            anchors.fill: parent
            drag.target: parent
            //drag.axis: Drag.XAxis
        }

        Rectangle {
            id: mainRect
            anchors.fill: parent
            color: "gray"
            radius: mainWindow.width / 50
            border.width: 3
            border.color: Qt.darker("gray")

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8

                CheckBox {
                    id: buyItemCheckBox
                    checked: done
                    Layout.alignment: Qt.AlignVCenter
                    style: CheckBoxStyle {
                        indicator: Rectangle {
                            implicitWidth: mainWindow.height / 30
                            implicitHeight: mainWindow.height / 30
                            radius: mainWindow.height / 200
                            border.color: control.activeFocus ? "darkblue" : "gray"
                            border.width: 1
                            Rectangle {
                                visible: control.checked
                                color: "#555"
                                border.color: "#333"
                                radius: mainWindow.height / 400
                                anchors.margins: 4
                                anchors.fill: parent
                            }
                        }
                    }

                    onCheckedChanged: {
                        ItemHandler.setData(index, checked, BuyItem.DoneRole)
                        if(checked)
                            ItemHandler.moveToEnd(index)
                        else
                            ItemHandler.moveToStart(index)
                    }
                }

                Text {
                    id: buyItemName
                    anchors.left: buyItemCheckBox.right
                    anchors.right: splitter.left
                    horizontalAlignment: Qt.AlignHCenter
                    text: name
                    color: "white"
                    font.bold: true
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    id: splitter
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: mainWindow.width / 8
                    width: 1
                    color: "black"
                }

                Text {
                    anchors.left: splitter.right
                    anchors.right: parent.right
                    id: buyItemAmount
                    text: amount
                    font.pointSize: 10
                    horizontalAlignment: Qt.AlignHCenter
                }
            }
        }
    }
}
