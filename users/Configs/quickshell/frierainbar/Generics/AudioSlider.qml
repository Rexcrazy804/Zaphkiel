pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  property color bgColor: node?.isStream ? Dat.Colors.tertiary_container : Dat.Colors.primary_container
  property color fgColor: node?.isStream ? Dat.Colors.tertiary : Dat.Colors.primary
  property string icon: "volume_up"
  required property PwNode node

  color: "transparent"
  implicitHeight: 38

  Item {
    anchors.fill: parent

    Slider {
      id: slider

      anchors.fill: parent
      bottomInset: 0
      from: 0
      leftInset: 0
      padding: 0
      rightInset: 0
      snapMode: Slider.NoSnap
      to: 1
      topInset: 0
      value: root.node?.audio?.volume ?? 1

      background: ClippingRectangle {
        id: bgRect

        anchors.bottomMargin: 1
        anchors.fill: parent
        anchors.topMargin: 1
        antialiasing: true
        color: root.bgColor
        layer.smooth: true
        radius: 20

        Rectangle {
          id: progRect

          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.top: parent.top
          antialiasing: true
          color: root.fgColor
          layer.smooth: true
          visible: true
          width: slider.visualPosition * parent.width

          Rectangle {
            anchors.horizontalCenter: parent.right
            height: parent.height
            width: this.height
            radius: this.height
            color: Dat.Colors.primary

            Gen.MatIcon {
              fill: 1
              anchors.centerIn: parent
              icon: root.icon
              color: Dat.Colors.on_primary
              font.pointSize: 16
            }
          }
        }
      }
      handle: Rectangle { visible: false}

      onMoved: {
        root.node.audio.volume = slider.value;
      }
    }
  }
}
