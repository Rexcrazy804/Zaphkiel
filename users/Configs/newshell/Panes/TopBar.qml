import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

RowLayout {
  // TOP BAR
  Rectangle {
    // Left
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"
    clip: true

    RowLayout {
      // TODO animations for text change?
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      spacing: 0
      Rectangle {
        // workspace number
        radius: 20
        Layout.leftMargin: 4
        Layout.maximumHeight: 20
        Layout.minimumHeight: 20
        Layout.maximumWidth: 20
        Layout.minimumWidth: 20
        color: Dat.Colors.primary

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          text: Hyprland.focusedWorkspace?.id ?? "0"
          font.pointSize: 10
          font.bold: true
        }
      }
      Text {
        // Active Window name
        readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
        Layout.leftMargin: 8
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter
        color: Dat.Colors.primary
        text: Dat.Globals.actWinName
      }
    }
  }

  Rectangle {
    // Center
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    color: "transparent"

    Wid.TimePill {}
  }

  Rectangle {
    // Right
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"

    RowLayout {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      layoutDirection: Qt.RightToLeft
      spacing: 8

      Text {
        // little arrow to toggle notch expand states
        Layout.rightMargin: 8
        Layout.fillWidth: false
        verticalAlignment: Text.AlignVCenter
        color: Dat.Colors.primary
        text: (Dat.Globals.notchState == "FULLY_EXPANDED") ? "" : ""

        MouseArea {
          anchors.fill: parent
          onClicked: mevent => {
            if (Dat.Globals.notchState == "EXPANDED") {
              Dat.Globals.notchState = "FULLY_EXPANDED";
              return;
            }

            Dat.Globals.notchState = "EXPANDED";
          }
        }
      }

      Wid.BatteryPill {
        implicitHeight: 20
        radius: 20
      }

      Wid.AudioSwiper {
        implicitHeight: 20
        radius: 20
      }

      Rectangle {
        implicitHeight: 20
        implicitWidth: 20
        radius: 20

        color: Dat.Colors.surface_container_high

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_surface
          text: "󰃠"
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton

          onWheel: event => {
            if (event.angleDelta.y > 0) {
              Dat.Brightness.increase();
            } else {
              Dat.Brightness.decrease();
            }
          }

          onClicked: mevent => {
            switch (mevent.button) {
              case Qt.RightButton: Dat.Brightness.increase(); break;
              case Qt.LeftButton: Dat.Brightness.decrease(); break;
            }
          }
        }
      }
    }
  }
}
