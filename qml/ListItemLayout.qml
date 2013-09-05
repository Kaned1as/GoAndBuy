import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import com.adonai.Enums 1.0

Component {
    Rectangle {
        id: mainRect

        anchors.left: parent.left
        anchors.right: parent.right
        height: 40 * mainWidget.height * 0.0025
        opacity: (mainWidget.width - Math.abs(x)) / mainWidget.width

        color: "gray"
        radius: mainWidget.width / 50
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
                        implicitWidth: mainWidget.height / 30
                        implicitHeight: mainWidget.height / 30
                        radius: mainWidget.height / 200
                        border.color: control.activeFocus ? "darkblue" : "gray"
                        border.width: 1
                        Rectangle {
                            visible: control.checked
                            color: "#555"
                            border.color: "#333"
                            radius: mainWidget.height / 400
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
                anchors.rightMargin: mainWidget.width / 8
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

        MouseArea {
            onPressed: parent.state = "held"
            onReleased: {
                if(parent.opacity < 0.7)
                    ItemHandler.removeItem(index)
                else
                    parent.state = "init"

            }
            onClicked: buyItemCheckBox.checked = !buyItemCheckBox.checked

            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis

        }

        states: [
            State {
                name: "init"
                AnchorChanges {
                    target: mainRect
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            },

            State {
                name: "held"
                AnchorChanges {
                    target: mainRect
                    anchors.left: undefined
                    anchors.right: undefined
                }
            }
        ]

        transitions: Transition {
                AnchorAnimation { duration: 300; easing.type: Easing.OutBounce; }
        }
    }
}
