import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

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
    clip: true
    color: "transparent"

    RowLayout {
      anchors.bottom: parent.bottom
      // TODO animations for text change?
      anchors.left: parent.left
      anchors.top: parent.top
      spacing: 0

      Rectangle {
        Layout.leftMargin: 4
        Layout.maximumHeight: 20
        Layout.maximumWidth: 20
        Layout.minimumHeight: 20
        Layout.minimumWidth: 20
        color: Dat.Colors.primary
        // workspace number
        radius: 20

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          font.bold: true
          font.pointSize: 10
          text: Hyprland.focusedWorkspace?.id ?? "0"
        }
        Gen.MouseArea {
          clickOpacity: 0.2
          hoverOpacity: 0.1

          onClicked: {
            Dat.Globals.notchState = "FULLY_EXPANDED";
            Dat.Globals.swipeIndex = 2;
          }
        }
      }
      Text {
        // Active Window name
        readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

        Layout.fillHeight: true
        Layout.leftMargin: 8
        color: Dat.Colors.primary
        text: Dat.Globals.actWinName
        verticalAlignment: Text.AlignVCenter
      }
    }
  }
  Rectangle {
    // Center
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    color: "transparent"

    Wid.TimePill {
    }
  }
  Rectangle {
    // Right
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"

    RowLayout {
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.top: parent.top
      layoutDirection: Qt.RightToLeft
      spacing: 8

      Text {
        Layout.fillWidth: false
        // little arrow to toggle notch expand states
        Layout.rightMargin: 8
        color: Dat.Colors.primary
        text: (Dat.Globals.notchState == "FULLY_EXPANDED") ? "" : ""
        verticalAlignment: Text.AlignVCenter

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
      Wid.BrightnessDot {
        implicitHeight: 20
        implicitWidth: 20
        radius: 20
      }
    }
  }
}
