pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 10
    spacing: 5

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: Dat.Colors.surface_container
      radius: 20

      StackView {
        // visible: false
        id: stack

        anchors.fill: parent

        initialItem: Wid.GreeterWidget {
          height: stack.height
          width: stack.width
        }
        popEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              property: "opacity"
              from: 0
              to: 1
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            }
            NumberAnimation {
              property: "y"
              from: -100
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            }
          }
        }
        popExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              property: "opacity"
              from: 1
              to: 0
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
            }
            NumberAnimation {
              property: "y"
              to: 100
              duration: Dat.MaterialEasing.emphasizedAccelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            }
          }
        }        
        replaceEnter: Transition {
          ParallelAnimation {
            PropertyAnimation {
              property: "opacity"
              to: 1
              duration: 0
            }
            NumberAnimation {
              property: "y"
              from: 100
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            }
          }
        }
        replaceExit: Transition {
          NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          }
        }
        pushEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              property: "opacity"
              from: 0
              to: 1
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
            }
            NumberAnimation {
              property: "y"
              from: 100
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            }
          }
        }
        pushExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              property: "opacity"
              from: 1
              to: 0
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
            }
          }
          NumberAnimation {
            property: "y"
            to: -100
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          }
        }
      }
    }

    Rectangle {
      Layout.alignment: Qt.AlignCenter
      color: Dat.Colors.surface_container
      implicitHeight: (stack.depth > 1) ? 8 : 28
      implicitWidth: trayItemRow.width + 20
      radius: 20
      visible: SystemTray.items.values.length != 0

      Behavior on implicitHeight {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
        }
      }

      RowLayout {
        id: trayItemRow

        anchors.centerIn: parent
        spacing: 10

        Repeater {
          model: ScriptModel {
            values: [...SystemTray.items.values]
          }

          Wid.TrayItem {
            Layout.alignment: Qt.AlignCenter
            stack: stack
          }
        }
      }
    }
  }
}
