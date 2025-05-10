import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../Assets/" as Ass

RowLayout {
  id: info
  property UPowerDevice bat: UPower.displayDevice
  Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "transparent"
    Text {
      anchors.fill: parent
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
      color: Ass.Colors.on_surface
      text: "󰂏 " + info.bat.energyCapacity
      font.pointSize: 10
    }
  }

  Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: 2
    color: "transparent"
    Text {
      id: text
      property list<int> timeToFull: standardizedTime(info.bat.timeToFull)
      property list<int> timeToEmpty: standardizedTime(info.bat.timeToEmpty)
      function standardizedTime(seconds: int): list<int> {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds - (hours * 3600)) / 60);
        return [hours, minutes];
      }

      anchors.centerIn: parent
      color: Ass.Colors.on_surface
      text: switch (info.bat.state) {
        case UPowerDeviceState.Charging:
        "  " + ((text.timeToFull[0] > 0) ? text.timeToFull[0] + " hours" : +text.timeToFull[1] + " minutes");
        break;
        case UPowerDeviceState.Discharging:
        "󰥕  " + ((text.timeToEmpty[0] > 0) ? text.timeToEmpty[0] + " hours" : +text.timeToEmpty[1] + " minutes");
        break;
        default:
        " idle";
        break;
      }
      font.pointSize: 10
    }
  }

  Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "transparent"
    Text {
      anchors.fill: parent
      color: Ass.Colors.on_surface
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      text: "󱐋 " + info.bat.changeRate
      font.pointSize: 10
    }
  }
}
