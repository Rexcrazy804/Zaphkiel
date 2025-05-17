import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../Data/" as Dat

RowLayout {
  id: info

  property UPowerDevice bat: UPower.displayDevice

  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    Text {
      anchors.fill: parent
      color: Dat.Colors.on_surface
      font.pointSize: 10
      horizontalAlignment: Text.AlignLeft
      text: "󰂏 " + info.bat.energyCapacity
      verticalAlignment: Text.AlignVCenter
    }
  }

  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    color: "transparent"

    Text {
      id: text

      property list<int> timeToEmpty: standardizedTime(info.bat.timeToEmpty)
      property list<int> timeToFull: standardizedTime(info.bat.timeToFull)

      function standardizedTime(seconds: int): list<int> {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds - (hours * 3600)) / 60);
        return [hours, minutes];
      }

      anchors.centerIn: parent
      color: Dat.Colors.on_surface
      font.pointSize: 10
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
    }
  }

  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    Text {
      anchors.fill: parent
      color: Dat.Colors.on_surface
      font.pointSize: 10
      horizontalAlignment: Text.AlignRight
      text: "󱐋 " + info.bat.changeRate
      verticalAlignment: Text.AlignVCenter
    }
  }
}
