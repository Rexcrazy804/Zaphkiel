import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell
import "../Assets"
import "../Components"

RowLayout {
  id: root
  required property PanelWindow bar
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
  readonly property string pwrProf: switch (PowerProfiles.profile) {
    case 0: ""; break;
    case 1: (batCharging)? chargeIcon : balancedIcon; break;
    case 2: ""; break;
  }

  Text {
    id: percentText
    text: Math.round(root.batPercentage * 100) + "%"
    color: Colors.secondary_fixed_dim
    font.pointSize: 11
    font.bold: true

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      onClicked: mouse => popup.visible = !popup.visible
    }
  }

  Text {
    id: batText
    text: root.pwrProf
    color: Colors.secondary_fixed_dim
    font.pointSize: 11
    font.bold: true

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.MiddleButton | Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {switch (mouse.button) {
        case Qt.LeftButton: PowerProfiles.profile = PowerProfile.PowerSaver; break;
        case Qt.RightButton: PowerProfiles.profile = PowerProfile.Balanced; break;
        case Qt.MiddleButton: PowerProfiles.profile = PowerProfile.Performance; break;
      }}
    }
  }

  PowerProfileMenu {
    id: popup
    bar: root.bar
  }

  Timer {
    interval: 600
    running: root.batCharging
    repeat: true
    onTriggered: () => {
      root.chargeIconIndex = root.chargeIconIndex % 10
      root.chargeIconIndex += 1
    }
  }
}
