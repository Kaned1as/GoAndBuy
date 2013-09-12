import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Button {
    property int currentPriority: 1

    text: switch(currentPriority) {
          case 1: return qsTr("One day")
          case 2: return qsTr("Today")
          case 3: return qsTr("Now")
      }
    style: ButtonStyle {
            background: Rectangle {
                implicitWidth: 60
                implicitHeight: 25
                border.width: control.activeFocus ? 2 : 1
                border.color: "#999"
                radius: 2
                gradient: Gradient {
                    GradientStop { position: 0 ; color: control.pressed ? Qt.darker(colorFromPriority()) : colorFromPriority() }
                    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ddd" }
                }
            }
        }
    function colorFromPriority() {
        switch(currentPriority) {
           case 1: return "green"
           case 2: return Qt.darker("yellow")
           case 3: return Qt.darker("red")
        }
    }

    onClicked: {
        if(currentPriority === 3)
            currentPriority = 1
        else
            ++currentPriority
    }
}
