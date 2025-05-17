import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower

import "../Assets"

PopupWindow {
  id: panel
  required property PanelWindow bar

  visible: false
  color: "transparent"
  anchor.window: bar
  anchor.rect.x: bar.width - width - 10
  anchor.rect.y: bar.height + 10
  width: 400
  height: 160

  HyprlandFocusGrab {
    id: grab
    windows: [ panel ]

    onActiveChanged: {
      if (!grab.active) {
        panel.visible = false
      }
    }
  }

  onVisibleChanged: {
    if (visible) {
      grab.active = true
    }
  }

  Rectangle {
    color: Colors.withAlpha(Colors.surface, 0.79)
    anchors.centerIn: parent
    width: parent.width - 10
    height: parent.height - 10
    border {
      color: Colors.secondary
      width: 2
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 10
      anchors.topMargin: 26
      anchors.bottomMargin: 10
      spacing: 0

      Slider {
        id: slider
        Layout.topMargin: 20
        Layout.leftMargin: 30
        Layout.rightMargin: 30
        Layout.bottomMargin: 20
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop
        snapMode: Slider.SnapOnRelease

        background: Rectangle {
          anchors.centerIn: parent
          color: Colors.on_secondary
          height: slider.height
          width: slider.availableWidth
          Layout.alignment: Qt.AlignTop
          clip: true

          Rectangle {
            color: Colors.secondary
            width: slider.visualPosition * slider.availableWidth
            height: slider.height
          }
        }

        handle: Rectangle {
          x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
          y: slider.topPadding + slider.availableHeight / 2 - height / 2
          width: 35
          height: 35
          visible: true
          color: Colors.surface
          border {
            color: Colors.secondary
            width: 4
          }

          Text {
            anchors.centerIn: parent
            color: Colors.secondary
            text: switch (PowerProfiles.profile) {
              case 0: ""; break;
              case 1: ""; break;
              case 2: ""; break;
            }
          }
        }

        value: PowerProfiles.profile
        from: 0
        to: 2
        stepSize: 1

        onMoved: {
          PowerProfiles.profile = slider.value
        }
      }

      RowLayout {
        id: info
        property UPowerDevice bat: UPower.displayDevice
        Layout.leftMargin: 20
        Layout.rightMargin: 20
        Layout.fillWidth: true
        Layout.fillHeight: true


        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "transparent"
          Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: Colors.secondary
            text: "󰂏 " + info.bat.energyCapacity
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
              const hours  = Math.floor(seconds / 3600)
              const minutes = Math.floor((seconds - (hours * 3600)) / 60)
              return [ hours, minutes ]
            }

            anchors.centerIn: parent
            color: Colors.secondary
            text: switch (info.bat.state) {
              case UPowerDeviceState.Charging:
                "  " + ((text.timeToFull[0] > 0)? text.timeToFull[0] + " hours" :  + text.timeToFull[1] + " minutes");
                break;
              case UPowerDeviceState.Discharging:
                "󰥕  " + ((text.timeToEmpty[0] > 0)? text.timeToEmpty[0] + " hours" :  + text.timeToEmpty[1] + " minutes");
                break;
              default: 
                " idle"; 
                break;
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "transparent"
          Text {
            anchors.fill: parent
            color: Colors.secondary
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: "󱐋 " + info.bat.changeRate
          }
        }
      }
    }

    Rectangle { // Header
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.topMargin: -5
      anchors.leftMargin: -5
      height: headerText.height + 5
      width: headerText.width + 10
      color: Colors.secondary

      Text {
        anchors.centerIn: parent
        id: headerText
        text: "Power"
        color: Colors.on_secondary
      }
    }
  }
}

