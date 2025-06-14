pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

import "../Data/" as Dat

RowLayout {
  id: root

  spacing: 10

  Rectangle {
    Layout.leftMargin: 10
    color: "transparent"
    implicitHeight: this.implicitWidth
    implicitWidth: faceIcon.width

    Image {
      id: faceIcon

      anchors.centerIn: parent
      height: this.width
      mipmap: true
      source: Quickshell.env("HOME") + "/.face.icon"
      visible: false
      width: 90
    }

    MultiEffect {
      anchors.fill: faceIcon
      antialiasing: true
      maskEnabled: true
      maskSource: faceIconMask
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5
      source: faceIcon
    }

    Item {
      id: faceIconMask

      height: this.width
      layer.enabled: true
      visible: false
      width: faceIcon.width

      Rectangle {
        height: this.width
        radius: 20
        width: faceIcon.width
      }
    }
  }

  Rectangle {
    id: informationREct

    Layout.fillHeight: true
    Layout.fillWidth: true
    color: Dat.Colors.surface_container
    radius: 20

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.on_surface
      font.pointSize: 14
      text: "Hello cutie"
    }
  }
}
