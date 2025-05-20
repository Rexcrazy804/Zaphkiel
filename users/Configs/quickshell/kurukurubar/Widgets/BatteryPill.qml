import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  Layout.minimumWidth: batText.width + 20
  color: Dat.Colors.primary
  visible: UPower.displayDevice.percentage > 0

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  Text { // Battery Text
    id: batText

    readonly property real batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
    readonly property string batIcon: {
      (batPercentage > 0.98) ? batIcons[0] : (batPercentage > 0.90) ? batIcons[1] : (batPercentage > 0.80) ? batIcons[2] : (batPercentage > 0.70) ? batIcons[3] : (batPercentage > 0.60) ? batIcons[4] : (batPercentage > 0.50) ? batIcons[5] : (batPercentage > 0.40) ? batIcons[6] : (batPercentage > 0.30) ? batIcons[7] : (batPercentage > 0.20) ? batIcons[8] : (batPercentage > 0.10) ? batIcons[9] : batIcons[10];
    }
    readonly property list<string> batIcons: ["󰁹", "󰂂", "󰂁", "󰂀", "󰁿", "󰁾", "󰁽", "󰁼", "󰁻", "󰁺", "󰂃"]
    readonly property real batPercentage: UPower.displayDevice.percentage
    readonly property string chargeIcon: batIcons[10 - chargeIconIndex]
    property int chargeIconIndex: 0

    anchors.centerIn: parent
    color: Dat.Colors.on_primary
    font.pointSize: 11
    text: Math.round(batPercentage * 100) + "% " + ((batCharging) ? chargeIcon : batIcon)
  }

  Timer {
    interval: 600
    repeat: true
    running: batText.batCharging && (Dat.Globals.notchState != "COLLAPSED")

    onTriggered: () => {
      batText.chargeIconIndex = batText.chargeIconIndex % 10;
      batText.chargeIconIndex += 1;
    }
  }

  Gen.MouseArea {
    layerColor: Dat.Colors.on_primary

    onClicked: {
      if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex == 0) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 4;
        Dat.Globals.settingsTabIndex = 0;
      }
    }
  }
}
