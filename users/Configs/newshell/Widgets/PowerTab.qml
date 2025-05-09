import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass

Rectangle {
    radius: 20
    color: Ass.Colors.surface_container_high

    RowLayout {
      anchors.margins: 10
      anchors.fill: parent
      spacing: 10
      Rectangle {
        id: powerSliderRect
        radius: 40
        Layout.fillHeight: true
        implicitWidth: 40
        color: Ass.Colors.surface_container_low

        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          width: 34
          height: this.width
          radius: this.width
          color: Ass.Colors.primary

          Drag.active: dragArea.drag.active

          MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent
            drag.smoothed: false
            drag.minimumY: 0
            drag.maximumY: powerSliderRect.height - parent.height
          }
        }

        ColumnLayout {
          id: slider
          anchors.fill: parent

          Repeater {
            model: [ "", "", ""]
            DropArea {
              id: powerDrop
              required property string modelData
              Layout.alignment: Qt.AlignCenter
              implicitWidth: 34
              implicitHeight: this.implicitWidth

              Rectangle {
                anchors.fill: parent
                radius: this.implicitWidth
                color: "transparent"

                Text {
                  anchors.centerIn: parent
                  text: powerDrop.modelData
                  color: Ass.Colors.on_surface
                }
              }
            }
          }
        }
      }

      Rectangle { // TODO battery graph
        Layout.fillHeight: true
        Layout.fillWidth: true
        radius: 10

        color: Ass.Colors.surface_container_highest
      }
    }
}
