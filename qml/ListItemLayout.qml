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

        color: {
            if(done)
                return "darkgray"

            switch(priority) {
               case 1: return "green"
               case 2: return Qt.darker("yellow")
               case 3: return Qt.darker("red")
               }
        }

        radius: mainWidget.height / 100
        border.width: 3
        border.color: Qt.darker("gray")

        CheckBox {
            id: buyItemCheckBox
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            checked: done
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
                ItemHandler.sort()
            }
        }

        Text {
            id: buyItemName
            anchors.left: buyItemCheckBox.right
            anchors.right:  splitter.left
            anchors.margins: 8
            anchors.verticalCenter: parent.verticalCenter
            text: name
            color: "white"
            font.bold: true
            wrapMode: Text.Wrap
        }

        Rectangle {
            id: splitter
            anchors.right: parent.right
            anchors.rightMargin: mainWidget.width / 6
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            width: 1
            color: "black"
        }

        Text {
            id: buyItemAmount
            anchors.right: parent.right
            anchors.left: splitter.right
            anchors.verticalCenter: parent.verticalCenter
            text: amount
            font.pointSize: 10
            horizontalAlignment: Qt.AlignHCenter
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
