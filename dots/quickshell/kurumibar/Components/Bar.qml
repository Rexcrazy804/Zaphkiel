pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Widgets"
import "../Assets"
import "../Data"

Scope {
  Variants {
    model: Quickshell.screens
    delegate: Component {
      PanelWindow {
        id: bar
        property var modelData
        readonly property color barColor: Colors.withAlpha(Colors.background, 0.79)
        readonly property color barColorLight: Colors.withAlpha(Colors.background, 0.5)
        readonly property color dynamicBarColor: (HyprWindow.hasActiveWindow)? barColor : barColorLight
        screen: modelData
        height: 24
        color: "transparent"

        anchors {
          top: true
          left: true
          right: true
        }

        RightMenu { 
          id: rightMenu
          bar: bar 
        }
        NotificationPopup { bar: bar; rightMenu: rightMenu}

        Rectangle {
          id: barShape
          // animation stuff
          state: (HyprWindow.hasActiveWindow)? "Opaque" : "Translucent"

          states: [
            State {
              name: "Opaque"
              PropertyChanges { barShape.color: bar.barColor }
            },
            State {
              name: "Translucent"
              PropertyChanges { barShape.color: bar.barColorLight }
            }
          ]

          Behavior on color {
            ColorAnimation {
              duration: 150
            }
          }

          color: bar.dynamicBarColor
          anchors.centerIn: parent
          height: parent.height
          width: parent.width
          RowLayout { // left
            spacing: 0
            layoutDirection: Qt.LeftToRight
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Workspace { bar: bar }
            ActiveWindow {}
          }

          RowLayout { // Centre
            spacing: 0
            anchors.centerIn: parent
            height:parent.height

            ClockWidget {bar: bar}
          }

          RowLayout { // Right
            spacing: 0
            layoutDirection: Qt.RightToLeft
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            MonthWidget { rightMenu: rightMenu}
            TrayWidget {bar: bar}
            SysInfo {bar: bar}
          }
        }
      }
    }
  }
}
