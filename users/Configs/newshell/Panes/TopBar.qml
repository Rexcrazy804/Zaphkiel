import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

import "../Assets/" as Ass
import "../Data/" as Dat

RowLayout {
  // TOP BAR
  Rectangle {
    // Left
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"

    RowLayout {
      anchors.fill: parent
      spacing: 0
      Rectangle {
        // workspace number
        radius: 20
        Layout.leftMargin: 4
        Layout.maximumHeight: 20
        Layout.minimumHeight: 20
        Layout.maximumWidth: 20
        Layout.minimumWidth: 20
        color: Ass.Colors.primary

        Text {
          anchors.centerIn: parent
          color: Ass.Colors.on_primary
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
        Layout.fillWidth: true
        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: activeWindow?.activated ? activeWindow?.appId : "desktop"
      }
    }
  }

  Rectangle {
    // Time Center
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    color: "transparent"

    Text {
      anchors.centerIn: parent
      color: Ass.Colors.primary
      text: Qt.formatDateTime(Dat.Clock?.date, "h:mm:ss AP")
    }
  }

  Rectangle {
    // Right
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"

    RowLayout {
      anchors.fill: parent
      layoutDirection: Qt.RightToLeft

      Text {
        Layout.rightMargin: 8
        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: "Nix ^OwO^"
      }
    }
  }
}
