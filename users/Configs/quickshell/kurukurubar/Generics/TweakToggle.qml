import QtQuick
import QtQuick.Layouts

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  id: root

  required property bool active
  required property var onClicked
  required property string text

  color: Dat.Colors.surface_container
  implicitHeight: 28
  radius: 10

  RowLayout {
    anchors.fill: parent
    spacing: 0

    Item {
      Layout.fillHeight: true
      implicitWidth: toggleText.contentWidth + 14

      Text {
        id: toggleText

        anchors.centerIn: parent
        color: Dat.Colors.on_surface
        text: root.text
        verticalAlignment: Text.AlignVCenter
      }
    }

    Item {
      Layout.fillHeight: true
      Layout.fillWidth: true
    }

    Rectangle {
      id: checkBox

      Layout.fillHeight: true
      color: root.active ? Dat.Colors.primary : "transparent"
      implicitWidth: this.height
      radius: 10

      Behavior on color {
        ColorAnimation {
          duration: Dat.MaterialEasing.standardTime
          easing.bezierCurve: Dat.MaterialEasing.standard
        }
      }

      border {
        color: Dat.Colors.primary
        width: 3
      }

      Gen.MouseArea {
        cursorShape: Qt.PointingHandCursor
        layerColor: icon.color

        onClicked: root.onClicked()
      }

      Gen.MatIcon {
        id: icon

        anchors.centerIn: parent
        color: root.active ? Dat.Colors.on_primary : Dat.Colors.primary
        font.pointSize: 15
        icon: root.active ? "check" : "close"

        Behavior on color {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
        }
      }
    }
  }
}
