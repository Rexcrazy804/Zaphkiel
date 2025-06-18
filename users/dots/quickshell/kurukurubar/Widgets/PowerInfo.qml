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
      text: "󰂏 " + info.bat.energyCapacity.toFixed(2)
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

      property string timeToEmpty: standardizedTime(info.bat.timeToEmpty)
      property string timeToFull: standardizedTime(info.bat.timeToFull)

      function standardizedTime(seconds: int): string {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds - (hours * 3600)) / 60);
        return (hours > 0) ? (hours == 1) ? "1 hour" : `${hours} hours` : `${minutes} minutes`;
      }

      anchors.centerIn: parent
      color: Dat.Colors.on_surface
      font.pointSize: 10
      text: switch (info.bat.state) {
      case UPowerDeviceState.Charging:
        return `  ${timeToFull}`;
      case UPowerDeviceState.Discharging:
        return `󰥕  ${timeToEmpty}`;
      default:
        return " idle";
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
      text: "󱐋 " + info.bat.changeRate.toFixed(2)
      verticalAlignment: Text.AlignVCenter
    }
  }
}
