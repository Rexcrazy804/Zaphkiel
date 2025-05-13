import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

RowLayout {
  // Left
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    clip: true
    color: "transparent"

    Wid.WorkspacePill {}
  }

  // Center
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    Wid.TimePill {
    }
  }

  // Right
  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
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
