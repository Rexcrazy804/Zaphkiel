import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../Data/" as Dat

RowLayout {
  id: info

  property real scaleFactor: Dat.Globals.scaleFactor
  property UPowerDevice bat: UPower.displayDevice
  spacing: 4 * scaleFactor

  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"

    Text {
      anchors.fill: parent
      color: Dat.Colors.on_surface
      font.pointSize: 10 * scaleFactor
      horizontalAlignment: Text.AlignLeft
      verticalAlignment: Text.AlignVCenter
      text: "󰂏 " + info.bat.energyCapacity
    }
  }

  Rectangle {
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2 * scaleFactor
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
      font.pointSize: 10 * scaleFactor

      text: switch (info.bat.state) {
        case UPowerDeviceState.Charging:
          "  " + ((text.timeToFull[0] > 0) ? text.timeToFull[0] + " hours" : text.timeToFull[1] + " minutes");
        case UPowerDeviceState.Discharging:
          "󰥕  " + ((text.timeToEmpty[0] > 0) ? text.timeToEmpty[0] + " hours" : text.timeToEmpty[1] + " minutes");
        default:
          " idle";
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
      font.pointSize: 10 * scaleFactor
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      text: "󱐋 " + info.bat.changeRate.toFixed(3)
    }
  }
}
