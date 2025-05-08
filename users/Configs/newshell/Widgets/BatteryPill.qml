import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../Assets/" as Ass

Rectangle {
  Layout.minimumWidth: batText.width + 20
  color: Ass.Colors.primary

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

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
      batText.chargeIconIndex = batText.chargeIconIndex % 10;
      batText.chargeIconIndex += 1;
    }
  }
}
