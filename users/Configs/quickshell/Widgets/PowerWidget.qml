import QtQuick
import Quickshell.Services.UPower
import Quickshell
import "../Assets"

Text {
  id: root
  readonly property real batPercentage: UPower.displayDevice.percentage
  readonly property real batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
  readonly property string chargeIcon: (batCharging)? "󰚥" : ""
  readonly property string balancedIcon: { 
    (batPercentage > 0.98)? "󰁹" :
    (batPercentage > 0.90)? "󰂂" :
    (batPercentage > 0.80)? "󰂁" :
    (batPercentage > 0.70)? "󰂀" :
    (batPercentage > 0.60)? "󰁿" :
    (batPercentage > 0.50)? "󰁾" :
    (batPercentage > 0.40)? "󰁽" :
    (batPercentage > 0.30)? "󰁼" :
    (batPercentage > 0.20)? "󰁻" :
    (batPercentage > 0.10)? "󰁺" : "󰂃"
  }
  readonly property string pwrProf: switch (PowerProfiles.profile) {
    case 0: ""; break;
    case 1: balancedIcon; break;
    case 2: ""; break;
  }

  text: Math.round(root.batPercentage * 100) + "% " + root.pwrProf + " " + root.chargeIcon
  color: Colors.tertiary_fixed_dim
  font.pointSize: 11
  font.bold: true

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton | Qt.LeftButton | Qt.RightButton
    // TODO incomplete
    onClicked: mouse => {switch (mouse.button) {
      case Qt.LeftButton: PowerProfiles.profile = PowerProfile.PowerSaver; break;
      case Qt.RightButton: PowerProfiles.profile = PowerProfile.Balanced; break;
      case Qt.MiddleButton: PowerProfiles.profile = PowerProfile.Performance; break;
    }}
  }

}
