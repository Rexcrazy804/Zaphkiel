import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Assets/" as Ass

Rectangle {
  radius: 20
  color: Ass.Colors.surface_container_high

  RowLayout {
    // anchors.margins: 10
    anchors.fill: parent
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      radius: 20
      color: Ass.Colors.surface_container_highest

      Rectangle {
        anchors.fill: graphDesc
        radius: 20
        color: Ass.Colors.surface_container
      }

      ColumnLayout {
        id: graphDesc
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0
        Rectangle {
          // TODO battery graph
          Layout.fillHeight: true
          Layout.fillWidth: true
          radius: 0
          color: "transparent"

          Text {
            anchors.centerIn: parent
            color: Ass.Colors.on_surface
            text: "cool graph here soon"
          }
        }
        Rectangle {
          Layout.fillWidth: true
          implicitHeight: 28
          radius: 20
          color: Ass.Colors.surface_container_high

          PowerInfo {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
          }
        }
      }
    }

    Rectangle {
      Layout.margins: 3
      id: powerSliderRect
      radius: 40
      implicitWidth: 40
      implicitHeight: parent.height - 14
      // color: Ass.Colors.surface_container_low
      color: "transparent"

      Slider {
        id: slider
        anchors.fill: parent

        orientation: Qt.Vertical
        value: PowerProfiles.profile
        from: 0
        to: 2
        stepSize: 1
        snapMode: Slider.SnapOnRelease

        onMoved: {
          PowerProfiles.profile = slider.value;
        }

        background: ColumnLayout {
          anchors.fill: parent

          Repeater {
            model: ["", "", ""]
            Rectangle {
              required property string modelData
              Layout.alignment: Qt.AlignCenter
              implicitWidth: 34
              implicitHeight: this.implicitWidth
              radius: this.implicitWidth
              color: "transparent"

              Text {
                anchors.centerIn: parent
                text: parent.modelData
                color: Ass.Colors.on_surface
              }
            }
          }
        }

        handle: Rectangle {
          y: slider.visualPosition * (slider.availableHeight - height)
          width: 34
          height: this.width
          radius: this.width
          visible: true
          anchors.horizontalCenter: parent.horizontalCenter

          color: Ass.Colors.secondary
          Text {
            anchors.centerIn: parent
            color: Ass.Colors.on_secondary
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
      }
    }
  }
}
