import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  id: root
  color: Dat.Colors.surface_container_high
  radius: 20

  property real scaleFactor: Dat.Globals.scaleFactor

  RowLayout {
    anchors.fill: parent
    spacing: 2 * scaleFactor

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
        anchors.margins: 4 * scaleFactor
        spacing: 6 * scaleFactor

        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          color: "transparent"

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8 * scaleFactor
            spacing: 6 * scaleFactor

            Repeater {
              id: resourceRepeater

              readonly property real cpuUsage: (1 - (Dat.Resources.cpu.idleSec / Dat.Resources.cpu.totalSec))
              readonly property real memUsage: (1 - (Dat.Resources.mem.free / Dat.Resources.mem.total))

              model: [
                { icon: "", label: "Cpu" },
                { icon: "", label: "Mem" }
              ]

              RowLayout {
                required property int index
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 28 * scaleFactor
                spacing: 8 * scaleFactor

                Rectangle {
                  Layout.alignment: Qt.AlignCenter
                  Layout.fillHeight: true
                  color: Dat.Colors.primary_container
                  implicitWidth: height
                  radius: height

                  Text {
                    anchors.centerIn: parent
                    color: Dat.Colors.on_primary_container
                    font.pointSize: 10 * scaleFactor
                    text: modelData.icon
                  }
                }

                ColumnLayout {
                  Layout.fillHeight: true
                  Layout.fillWidth: true
                  spacing: 4 * scaleFactor

                  Text {
                    color: Dat.Colors.on_surface
                    font.pointSize: 9 * scaleFactor
                    text: modelData.label
                  }

                  Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6 * scaleFactor
                    color: Dat.Colors.primary_container
                    radius: 10 * scaleFactor

                    Rectangle {
                      anchors.fill: parent
                      anchors.rightMargin: parent.width * (1 - ((!index) ? resourceRepeater.cpuUsage : resourceRepeater.memUsage))
                      color: Dat.Colors.on_primary_container
                      radius: parent.radius

                      Behavior on anchors.rightMargin {
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
          Layout.fillWidth: true
          color: Dat.Colors.surface_container_highest
          implicitHeight: 28 * scaleFactor
          radius: 20 * scaleFactor
          topLeftRadius: 0
          topRightRadius: 0
          visible: UPower.displayDevice.percentage > 0

          Wid.PowerInfo {
            anchors.fill: parent
            anchors.leftMargin: 8 * scaleFactor
            anchors.rightMargin: 8 * scaleFactor
          }
        }
      }
    }

    Rectangle {
      id: powerSliderRect

      Layout.margins: 2 * scaleFactor
      color: "transparent"
      implicitHeight: parent.height - (6 * scaleFactor)
      implicitWidth: 40 * scaleFactor
      radius: 40 * scaleFactor

      Slider {
        id: slider

        anchors.fill: parent
        from: 0
        to: 2
        stepSize: 1
        orientation: Qt.Vertical
        snapMode: Slider.SnapAlways
        value: PowerProfiles.profile

        background: ColumnLayout {
          anchors.fill: parent

          Repeater {
            model: ["", "", ""]

            Rectangle {
              required property string modelData
              Layout.alignment: Qt.AlignCenter
              color: "transparent"
              implicitHeight: 30 * scaleFactor
              implicitWidth: 34 * scaleFactor
              radius: width

              Text {
                anchors.centerIn: parent
                color: Dat.Colors.on_surface
                font.pointSize: 15 * scaleFactor
                text: modelData
              }
            }
          }
        }

        handle: Rectangle {
          width: 34 * scaleFactor
          height: width
          color: Dat.Colors.primary
          radius: width
          anchors.horizontalCenter: parent.horizontalCenter
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
            font.pointSize: 15 * scaleFactor
            text: switch (PowerProfiles.profile) {
              case 0: ""; break;
              case 1: ""; break;
              case 2: ""; break;
            }
          }
        }

        onMoved: PowerProfiles.profile = slider.value
      }
    }
  }
}
