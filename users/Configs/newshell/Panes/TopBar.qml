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
        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: Dat.Globals.actWinName
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
      spacing: 8

      Text {
        Layout.rightMargin: 8
        Layout.fillWidth: false
        verticalAlignment: Text.AlignVCenter
        color: Ass.Colors.primary
        text: (Dat.Globals.notchState == "FULLY_EXPANDED")? "" : ""

        MouseArea {
          anchors.fill: parent
          onClicked: mevent => {
            if (Dat.Globals.notchState == "EXPANDED") {
              Dat.Globals.notchState = "FULLY_EXPANDED"
              return;
            }

            Dat.Globals.notchState = "EXPANDED"
          }
        }
      }

      Rectangle {
        Layout.minimumWidth: batText.width + 20
        Layout.minimumHeight: 20
        Layout.maximumHeight: 20
        radius: 20
        color: Ass.Colors.primary

        Behavior on Layout.minimumWidth { NumberAnimation {
          duration: 150
          easing.type: Easing.Linear
        } }

        Text { // Battery Text
          id: batText
          readonly property real batPercentage: UPower.displayDevice.percentage
          readonly property real batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
          readonly property string chargeIcon: batIcons[10 - chargeIconIndex]
          property int chargeIconIndex: 0
          readonly property list<string> batIcons: ["󰁹", "󰂂", "󰂁", "󰂀", "󰁿", "󰁾", "󰁽", "󰁼", "󰁻", "󰁺", "󰂃"]
          readonly property string batIcon: {
            (batPercentage > 0.98) ? batIcons[0] : (batPercentage > 0.90) ? batIcons[1] : (batPercentage > 0.80) ? batIcons[2] : (batPercentage > 0.70) ? batIcons[3] : (batPercentage > 0.60) ? batIcons[4] : (batPercentage > 0.50) ? batIcons[5] : (batPercentage > 0.40) ? batIcons[6] : (batPercentage > 0.30) ? batIcons[7] : (batPercentage > 0.20) ? batIcons[8] : (batPercentage > 0.10) ? batIcons[9] : batIcons[10];
          }

          anchors.centerIn: parent
          color: Ass.Colors.on_primary
          text: Math.round(batPercentage * 100) + "% " + ((batCharging) ? chargeIcon : batIcon)
          font.pointSize: 11
        }

        Timer {
          interval: 600
          running: batText.batCharging
          repeat: true
          onTriggered: () => {
            batText.chargeIconIndex = batText.chargeIconIndex % 10
            batText.chargeIconIndex += 1
          }
        }
      }

      Rectangle {
        Layout.minimumWidth: soundText.width + 20
        Layout.minimumHeight: 20
        Layout.maximumHeight: 20
        radius: 20
        color: Ass.Colors.secondary

        Behavior on Layout.minimumWidth { NumberAnimation {
          duration: 150
          easing.type: Easing.Linear
        } }

        Text {
          anchors.centerIn: parent
          id: soundText
          text: Math.round(Dat.Audio.volume * 100) + "%" + " " + Dat.Audio.volIcon
          color: Ass.Colors.on_secondary
          font.pointSize: 11

          MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            onClicked: mouse => {
              switch (mouse.button) {
                case Qt.MiddleButton: Dat.Audio.sink.audio.muted = !Dat.Audio.muted; break;
                case Qt.RightButton: Dat.Audio.source.audio.muted = !Dat.Audio.source.audio.muted; break;
              }
            }
            onWheel: event => Dat.Audio.wheelAction(event)
          }
        }
      }
    }
  }
}
