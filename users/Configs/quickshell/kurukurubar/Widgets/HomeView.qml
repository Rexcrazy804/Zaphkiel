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
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: -100
              property: "y"
            }
          }
        }
        popExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedAccelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
              property: "y"
              to: 100
            }
          }
        }
        pushEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100
              property: "y"
            }
          }
        }
        pushExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "y"
            to: -100
          }
        }
        replaceEnter: Transition {
          ParallelAnimation {
            PropertyAnimation {
              duration: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100
              property: "y"
            }
          }
        }
        replaceExit: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            from: 1
            property: "opacity"
            to: 0
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
