import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

TabView {
    id: mainWidget
    focus: true
    width: 300
    height: 600

    FirstLaunchScreen {}

    style: TabViewStyle {
        frameOverlap: 1
        tabsMovable: true
        tab: Rectangle {
            border.color:  "darkgray"
            implicitWidth: styleData.availableWidth / (control.count) + 1
            implicitHeight: mainWidget.height / 20
            Text {
                id: text
                anchors.centerIn: parent
                text: styleData.title
                font.bold: true
                color: styleData.selected ? "gray" : "black"
            }
            gradient: Gradient {
                GradientStop { position: 0.0; color: styleData.selected ? "white" : "gray" }
                GradientStop { position: 1.0; color:  "lightgray" }
            }
        }

        rightCorner: Rectangle {
            implicitWidth: mainWidget.width / 300 * 20
            implicitHeight: mainWidget.height / 20
            border.color:  "darkgray"
            gradient: Gradient {
                GradientStop { position: 0.0; color: menuClick.pressed ? "white" : "gray" }
                GradientStop { position: 1.0; color:  "lightgray" }
            }

            Column {
                anchors.centerIn: parent
                spacing: mainWidget.width / 300 * 2
                Repeater {
                    model: 3

                    Rectangle {
                        color: "darkgray"
                        width: mainWidget.width / 300 * 7
                        height: mainWidget.width / 300 * 7
                    }
                }
            }

            MouseArea {
                id: menuClick
                anchors.fill: parent
                onClicked: mainWidget.Keys.onMenuPressed(undefined)
            }
        }
    }

    Tab {
        id: buyItemsTab
        title: qsTr("List")

        ListLayout {}
    }

    Tab {
        title: qsTr("By hand")

        ByHandTabLayout {}
    }

    Tab {
        title: qsTr("Parameters")
        visible: Qt.platform.os === "android" // does not work now

        PreferencesLayout {}
    }

    ColumnLayout {
        id: topMenu
        anchors.left: parent.left
        anchors.leftMargin: mainWidget.width / 5
        anchors.right: parent.right
        anchors.rightMargin: mainWidget.width / 5
        anchors.bottom: parent.bottom
        height: 0

        Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutBack } }

        Rectangle {
            id: deleteAll
            Layout.fillWidth: true
            height: mainWidget.height / 600 * 50
            color: "black"
            border.color: "grey"
            border.width: 2

            Text {
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                text: qsTr("Delete all")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    ItemHandler.removeAll()
                    mainWidget.Keys.onMenuPressed(undefined)
                }
            }
        }
    }

    Keys.onMenuPressed: {
        if(topMenu.height == 0)
            topMenu.height = topMenu.implicitHeight
        else
            topMenu.height = 0
    }
}
