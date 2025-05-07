import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.UPower

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Generics/" as Gen

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
      color: Ass.Colors.secondary
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
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      layoutDirection: Qt.RightToLeft
      spacing: 10

      Text {
        Layout.rightMargin: 8
        Layout.fillWidth: false
        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: ""

        Gen.MouseArea {}
        // TODO send a signal the parent can listen to
        // to expand the notch
      }

      Text { // Battery Text
        readonly property real batPercentage: UPower.displayDevice.percentage
        readonly property real batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
        readonly property string chargeIcon: batIcons[10 - chargeIconIndex]
        property int chargeIconIndex: 0
        readonly property list<string> batIcons: ["󰁹", "󰂂", "󰂁", "󰂀", "󰁿", "󰁾", "󰁽", "󰁼", "󰁻", "󰁺", "󰂃"]
        readonly property string balancedIcon: { 
          (batPercentage > 0.98)? batIcons[0] :
          (batPercentage > 0.90)? batIcons[1] :
          (batPercentage > 0.80)? batIcons[2] :
          (batPercentage > 0.70)? batIcons[3] :
          (batPercentage > 0.60)? batIcons[4] :
          (batPercentage > 0.50)? batIcons[5] :
          (batPercentage > 0.40)? batIcons[6] :
          (batPercentage > 0.30)? batIcons[7] :
          (batPercentage > 0.20)? batIcons[8] :
          (batPercentage > 0.10)? batIcons[9] : batIcons[10]
        }

        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: batPercentage * 100 + "% " + ((batCharging)? chargeIcon : balancedIcon)
      }
    }
  }
}
