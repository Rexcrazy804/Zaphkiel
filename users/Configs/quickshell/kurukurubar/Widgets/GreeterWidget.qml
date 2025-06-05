pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

import "../Data/" as Dat

RowLayout {
  id: root

  property real scaleFactor: Dat.Globals.scaleFactor

  spacing: 10 * scaleFactor

  Rectangle {
    Layout.leftMargin: 10 * scaleFactor
    color: "transparent"
    implicitHeight: implicitWidth
    implicitWidth: faceIcon.width

    Image {
      id: faceIcon

      anchors.centerIn: parent
      width: 90 * scaleFactor
      height: width
      mipmap: true
      source: Quickshell.env("HOME") + "/.face.icon"
      visible: false
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

      width: faceIcon.width
      height: width
      visible: false
      layer.enabled: true

      Rectangle {
        width: faceIcon.width
        height: width
        radius: 20 * scaleFactor
      }
    }
  }

  Rectangle {
    id: informationREct

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 20 * scaleFactor
    color: Dat.Colors.surface_container

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.on_surface
      font.pointSize: 14 * scaleFactor
      text: "Hello cutie"
      wrapMode: Text.Wrap
    }
  }
}
