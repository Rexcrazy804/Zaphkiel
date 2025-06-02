import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  id: root

  property string name: "pow"
  property int wanderMult: PowerProfiles.profile

  Item {
    anchors.bottom: coffeeImg.top
    anchors.left: coffeeImg.left
    anchors.right: coffeeImg.right
    anchors.top: parent.top

    Text {
      anchors.centerIn: parent
      text: (100 * UPower.displayDevice.percentage).toFixed(2) + "%"
      font.family: Dat.Fonts.rye
      font.pointSize: 32
      color: Dat.Colors.tertiary
    }
  }

  Image {
    id: coffeeImg

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    antialiasing: true
    mipmap: true
    mirror: true
    smooth: true
    source: "../Assets/friecoffee.png"

    Component.onCompleted: {
      const mult = 0.19;
      width = width * mult;
      height = height * mult;
    }
  }

  Item {
    anchors.bottom: parent.bottom
    anchors.margins: 10
    anchors.right: parent.right
    anchors.top: parent.top
    // radius: 10 + this.border.width
    // color: "transparent"
    // border.color: Dat.Colors.surface_container_high
    // border.width: 10
    width: 480

    ColumnLayout {
      anchors.fill: parent

      Item {
        id: stateText

        Layout.fillHeight: true
        Layout.fillWidth: true

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.secondary
          font.family: Dat.Fonts.hurricane
          font.pointSize: 20
          text: "I got to know an idiot who complimented the spells I gathered"
        }
      }

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 4

        RowLayout {
          anchors.fill: parent

          Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 5

            ColumnLayout {
              anchors.fill: parent

              Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 4

                RowLayout {
                  anchors.fill: parent

                  Rectangle {
                    id: fernSpin

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 4
                    color: Dat.Colors.surface_container_high
                    radius: 10

                    AnimatedImage {
                      anchors.fill: parent
                      fillMode: AnimatedImage.PreserveAspectFit
                      source: "https://media.tenor.com/acilvVkkz6YAAAAj/fern-sousou-no-frieren.gif"
                      speed: 1 + (root.wanderMult / 4)
                    }
                  }

                  Rectangle {
                    id: battery

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    color: Dat.Colors.surface_container_highest
                    radius: 10 + border.width

                    Rectangle {
                      anchors.bottom: parent.top
                      anchors.bottomMargin: -5
                      anchors.horizontalCenter: parent.horizontalCenter
                      color: (UPower.displayDevice.percentage == 1) ? batteryPercRect.color : parent.color
                      height: 10
                      radius: 20
                      width: 25
                    }

                    Gen.MatIcon {
                      anchors.horizontalCenter: parent.horizontalCenter
                      anchors.top: parent.top
                      anchors.topMargin: 10
                      color: batteryPercRect.color
                      fill: 1
                      font.pointSize: 16
                      icon: "power"
                      visible: UPower.displayDevice.state == UPowerDeviceState.Charging
                    }

                    Rectangle {
                      id: batteryPercRect

                      anchors.bottom: parent.bottom
                      anchors.left: parent.left
                      anchors.margins: parent.border.width
                      anchors.right: parent.right
                      color: Dat.Colors.secondary
                      height: parent.height * UPower.displayDevice.percentage
                      radius: 10

                      Gen.MatIcon {
                        anchors.centerIn: parent
                        color: Dat.Colors.on_secondary
                        fill: UPower.displayDevice.state == UPowerDeviceState.Charging
                        font.pointSize: 20
                        icon: "bolt"
                      }
                    }
                  }
                }
              }

              Rectangle {
                id: infoRect

                Layout.fillHeight: true
                Layout.fillWidth: true
                color: Dat.Colors.surface_container_high
                radius: 10

                RowLayout {
                  id: info

                  property UPowerDevice bat: UPower.displayDevice

                  anchors.fill: parent
                  anchors.margins: 14

                  Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"

                    Text {
                      anchors.fill: parent
                      color: Dat.Colors.secondary
                      font.pointSize: 14
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
                      color: Dat.Colors.secondary
                      font.pointSize: 14
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
                      color: Dat.Colors.secondary
                      font.pointSize: 14
                      horizontalAlignment: Text.AlignRight
                      text: "󱐋 " + info.bat.changeRate
                      verticalAlignment: Text.AlignVCenter
                    }
                  }
                }
              }
            }
          }

          Rectangle {
            id: profileSlider

            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Dat.Colors.surface_container_high
            radius: 10

            // basically copy pasted from kuru kuru bar
            // I am gradually losing my sanity and creativity
            // as I succumb to the mortal fallacy of sleep
            // (and lets not forget my sickness fucking me over)
            Slider {
              id: slider

              anchors.fill: parent
              from: 0
              orientation: Qt.Vertical
              snapMode: Slider.SnapAlways
              stepSize: 1
              to: 2
              value: PowerProfiles.profile

              background: ColumnLayout {
                anchors.fill: parent

                Repeater {
                  model: ["speed", "balance", "eco"]

                  Rectangle {
                    required property string modelData

                    Layout.alignment: Qt.AlignCenter
                    color: "transparent"
                    implicitHeight: this.implicitWidth
                    implicitWidth: 34
                    radius: this.implicitWidth

                    Gen.MatIcon {
                      anchors.centerIn: parent
                      color: Dat.Colors.on_surface
                      font.pointSize: 20
                      icon: parent.modelData
                    }
                  }
                }
              }
              handle: Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Dat.Colors.primary
                height: this.width
                radius: 20
                visible: true
                width: profileSlider.width
                y: slider.visualPosition * (slider.availableHeight - height)

                Behavior on y {
                  NumberAnimation {
                    duration: Dat.MaterialEasing.emphasizedTime
                    easing.bezierCurve: Dat.MaterialEasing.emphasized
                  }
                }

                Gen.MatIcon {
                  anchors.centerIn: parent
                  color: Dat.Colors.on_primary
                  font.pointSize: 20
                  icon: switch (PowerProfiles.profile) {
                  case 0:
                    "eco";
                    break;
                  case 1:
                    "balance";
                    break;
                  case 2:
                    "speed";
                    break;
                  }
                }
              }

              onMoved: {
                PowerProfiles.profile = slider.value;
              }
            }
          }
        }
      }
    }
  }
}
