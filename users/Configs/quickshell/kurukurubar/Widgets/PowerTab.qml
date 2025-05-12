import QtQuick
import QtGraphs
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

import "../Data/" as Dat

Rectangle {
  radius: 20
  color: Dat.Colors.surface_container_high

  RowLayout {
    anchors.fill: parent
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      radius: 20
      color: "transparent"

      Rectangle {
        anchors.fill: graphDesc
        radius: 20
        color: Dat.Colors.surface_container
      }

      ColumnLayout {
        id: graphDesc
        anchors.fill: parent
        anchors.margins: 5
        anchors.rightMargin: 0
        spacing: 0
        Rectangle {
          clip: true
          Layout.fillHeight: true
          Layout.fillWidth: true
          radius: 0
          color: "transparent"
          GraphsView {
            // TODO complete this and make it segsy
            visible: false
            marginTop: 0
            marginLeft: 0
            marginRight: 0
            marginBottom: 0
            panStyle: GraphsView.PanStyle.Drag
            anchors.fill: parent
            // anchors.margins: -40
            theme: GraphsTheme {
              colorScheme: GraphsTheme.ColorScheme.Dark
              backgroundColor: "transparent"
              plotAreaBackgroundColor: "transparent"
              seriesColors: ["#E0D080", "#B0A060"]
              borderColors: ["#807040", "#706030"]

              grid.mainColor: "transparent"
              grid.subColor: "transparent"

              axisY.mainColor: "transparent"
              axisY.subColor: "transparent"
              axisX.mainColor: "transparent"
              axisX.subColor: "transparent"
              axisX.labelTextColor: Dat.Colors.on_surface
              axisY.labelTextColor: Dat.Colors.on_surface
              axisYLabelFont.pointSize: 8
              axisXLabelFont.pointSize: 8
            }
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

            LineSeries {
              XYPoint { x: 0; y: 0 }
              XYPoint { x: 1.1; y: 2.1 }
              XYPoint { x: 1.9; y: 3.3 }
              XYPoint { x: 2.1; y: 2.1 }
              XYPoint { x: 2.9; y: 4.9 }
              XYPoint { x: 3.4; y: 3.0 }
              XYPoint { x: 4.1; y: 3.3 }
            }
          }
        }
        Rectangle { // BATTERY information
          Layout.fillWidth: true
          implicitHeight: 28
          radius: 20
          topLeftRadius: 0
          topRightRadius: 0
          color: Dat.Colors.surface_container_highest

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
                color: Dat.Colors.on_surface
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

          color: Dat.Colors.secondary
          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_secondary
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
