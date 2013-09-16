import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

RadioButton {
    id: syncButton
    property color pointColor: "#000"
    property string syncValue: "0"

    style: RadioButtonStyle {
        indicator: Rectangle {
            implicitWidth: mainWidget.height / 32
            implicitHeight: mainWidget.height / 32
            radius: mainWidget.height / 64
            border.color: control.activeFocus ? "darkblue" : "gray"
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: control.checked
                color: pointColor
                radius: mainWidget.height / 64
                anchors.margins: 4
            }
        }
    }

    onCheckedChanged: if(checked) AndroidPrefs.syncMode = syncValue

    Binding {
        target: syncButton
        property: "checked"
        value: true
        when: AndroidPrefs.syncMode === syncValue
    }
}
