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

    Rectangle {
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      color: Dat.Colors.primary_container
      height: 20
      radius: 20
      width: workRow.width + 8

      RowLayout {
        id: workRow

        anchors.left: parent.left
        spacing: 5

        Rectangle {
          Layout.fillHeight: true
          // Active Window name
          color: Dat.Colors.primary
          implicitWidth: windowNameText.contentWidth + 10
          radius: 20

          Text {
            id: windowNameText

            readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

            anchors.centerIn: parent
            color: Dat.Colors.on_primary
            text: Dat.Globals.actWinName
          }
        }
        Text {
          Layout.fillHeight: true
          color: Dat.Colors.on_primary_container
          text: Hyprland.focusedWorkspace?.id ?? "0"
          verticalAlignment: Text.AlignVCenter
        }
      }
      Gen.MouseArea {
        clickOpacity: 0.2
        hoverOpacity: 0.08
        layerColor: Dat.Colors.on_primary_container
        layerRadius: 20

        onClicked: {
          Dat.Globals.notchState = "FULLY_EXPANDED";
          Dat.Globals.swipeIndex = 2;
        }
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
