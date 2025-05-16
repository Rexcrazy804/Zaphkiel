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
          width: stack.width
          height: stack.height
        }
      }
    }

    Rectangle {
      Layout.alignment: Qt.AlignCenter
      color: Dat.Colors.surface_container
      implicitHeight: (stack.depth > 1)? 5 : 28
      implicitWidth: trayItemRow.width + 20
      radius: 20

      Behavior on implicitHeight {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve:  Dat.MaterialEasing.emphasized
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
