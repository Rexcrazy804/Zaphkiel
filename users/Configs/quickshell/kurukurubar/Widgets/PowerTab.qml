import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  color: Dat.Colors.surface_container_high
  radius: 20

  RowLayout {
    anchors.fill: parent
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      radius: 20

      Rectangle {
        anchors.fill: infoCol
        color: Dat.Colors.surface_container
        radius: 20
      }

      ColumnLayout {
        id: infoCol

        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          color: "transparent"
          radius: 0

          // text: ""
          // text: ""

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Repeater {
              id: resourceRepeater

              readonly property real cpuUsage: (1 - (Dat.Resources.cpu.idleSec / Dat.Resources.cpu.totalSec))
              readonly property real memUsage: (1 - (Dat.Resources.mem.free / Dat.Resources.mem.total))

              model: [
                {
                  icon: "",
                  label: "Cpu"
                },
                {
                  icon: "",
                  label: "Mem"
                }
              ]

              RowLayout {
                id: resourceItem

                required property int index
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 28
                spacing: 10

                Rectangle {
                  Layout.alignment: Qt.AlignCenter
                  Layout.fillHeight: true
                  color: Dat.Colors.primary_container
                  implicitWidth: this.height
                  radius: this.height

                  Text {
                    anchors.centerIn: parent
                    color: Dat.Colors.on_primary_container
                    font.pointSize: 11
                    text: modelData.icon
                  }
                }

                ColumnLayout {
                  Layout.bottomMargin: 5
                  Layout.fillHeight: true
                  Layout.fillWidth: true
                  Layout.topMargin: 5

                  Text {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 3
                    color: Dat.Colors.on_surface
                    text: resourceItem.modelData.label
                    verticalAlignment: Text.AlignVCenter
                  }

                  Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Dat.Colors.primary_container
                    // Layout.leftMargin: 20
                    // Layout.rightMargin: this.Layout.leftMargin
                    radius: 20

                    Rectangle {
                      anchors.bottom: parent.bottom
                      anchors.left: parent.left
                      anchors.top: parent.top
                      color: Dat.Colors.on_primary_container
                      radius: parent.radius
                      // wonky hacky way of doing this cause otherwise the value will reset with each change
                      // which is not nice
                      width: parent.width * ((!index) ? resourceRepeater.cpuUsage : resourceRepeater.memUsage)

                      Behavior on width {
                        NumberAnimation {
                          duration: Dat.MaterialEasing.emphasizedTime
                          easing.bezierCurve: Dat.MaterialEasing.emphasized
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        Rectangle {
          // BATTERY information
          Layout.fillWidth: true
          color: Dat.Colors.surface_container_highest
          implicitHeight: 28
          radius: 20
          topLeftRadius: 0
          topRightRadius: 0
          visible: UPower.displayDevice.percentage > 0

          Wid.PowerInfo {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
          }
        }
      }
    }

    Rectangle {
      id: powerSliderRect

      Layout.margins: 3
      color: "transparent"
      implicitHeight: parent.height - 14
      implicitWidth: 40
      radius: 40

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
            model: ["", "", ""]

            Rectangle {
              required property string modelData

              Layout.alignment: Qt.AlignCenter
              color: "transparent"
              implicitHeight: this.implicitWidth
              implicitWidth: 34
              radius: this.implicitWidth

              Text {
                anchors.centerIn: parent
                color: Dat.Colors.on_surface
                text: parent.modelData
              }
            }
          }
        }
        handle: Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          color: Dat.Colors.primary
          height: this.width
          radius: this.width
          visible: true
          width: 34
          y: slider.visualPosition * (slider.availableHeight - height)

          Behavior on y {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
            }
          }

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_primary
            text: switch (PowerProfiles.profile) {
            case 0:
              "";
              break;
            case 1:
              "";
              break;
            case 2:
              "";
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
