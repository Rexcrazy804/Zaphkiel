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
  // Base container color
  color: "transparent"

  property real scaleFactor: Dat.Globals.scaleFactor

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 10 
    spacing: 5 * scaleFactor

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: Dat.Colors.surface_container
      radius: 20 * scaleFactor

      StackView {
        id: stack
        anchors.fill: parent

        initialItem: Wid.GreeterWidget {
          height: stack.height
          width: stack.width
        }

        // === Transitions with Easing and Animations ===
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
            NumberAnimation {
              property: "y"
              to: -100 
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
      }
    }

    // Tray area
    Rectangle {
      Layout.alignment: Qt.AlignCenter
      color: Dat.Colors.surface_container
      radius: 20 * scaleFactor
      implicitHeight: (stack.depth > 1) ? 18 * scaleFactor : 28 * scaleFactor
      implicitWidth: trayItemRow.width + 20 * scaleFactor
      visible: SystemTray.items.values.length !== 0

      Behavior on implicitHeight {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
        }
      }

      RowLayout {
        id: trayItemRow
        anchors.centerIn: parent
        spacing: 10 * scaleFactor

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
