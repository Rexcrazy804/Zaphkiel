import QtQuick
import QtGraphs
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat

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
        anchors.fill: graphDesc
        color: Dat.Colors.surface_container
        radius: 20
      }
      ColumnLayout {
        id: graphDesc

        anchors.fill: parent
        anchors.margins: 5
        anchors.rightMargin: 0
        spacing: 0

        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          color: "transparent"
          radius: 0

          GraphsView {
            anchors.fill: parent
            marginBottom: 0
            marginLeft: 0
            marginRight: 0
            marginTop: 0
            panStyle: GraphsView.PanStyle.Drag
            // TODO complete this and make it segsy
            visible: false

            axisX: ValueAxis {
              max: 4
              subTickCount: 0
              tickInterval: 1
            }
            axisY: ValueAxis {
              max: 4
              subTickCount: 0
              tickInterval: 1
            }
            // anchors.margins: -40
            theme: GraphsTheme {
              axisX.labelTextColor: Dat.Colors.on_surface
              axisX.mainColor: "transparent"
              axisX.subColor: "transparent"
              axisXLabelFont.pointSize: 8
              axisY.labelTextColor: Dat.Colors.on_surface
              axisY.mainColor: "transparent"
              axisY.subColor: "transparent"
              axisYLabelFont.pointSize: 8
              backgroundColor: "transparent"
              borderColors: ["#807040", "#706030"]
              colorScheme: GraphsTheme.ColorScheme.Dark
              grid.mainColor: "transparent"
              grid.subColor: "transparent"
              plotAreaBackgroundColor: "transparent"
              seriesColors: ["#E0D080", "#B0A060"]
            }

            LineSeries {
              XYPoint {
                x: 0
                y: 0
              }
              XYPoint {
                x: 1.1
                y: 2.1
              }
              XYPoint {
                x: 1.9
                y: 3.3
              }
              XYPoint {
                x: 2.1
                y: 2.1
              }
              XYPoint {
                x: 2.9
                y: 4.9
              }
              XYPoint {
                x: 3.4
                y: 3.0
              }
              XYPoint {
                x: 4.1
                y: 3.3
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

          PowerInfo {
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
        snapMode: Slider.SnapOnRelease
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
