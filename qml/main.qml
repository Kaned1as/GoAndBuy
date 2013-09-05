import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

TabView {
    id: mainWidget
    width: 300
    height: 600

    style: TabViewStyle {
        frameOverlap: 1
        tabsMovable: true
        tab: Rectangle {
            //color: styleData.selected ? "gray" : "darkgray"
            border.color:  "darkgray"
            implicitWidth: styleData.availableWidth / control.count + 1
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
    }

    ListItemLayout {
        id: lil
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
}
