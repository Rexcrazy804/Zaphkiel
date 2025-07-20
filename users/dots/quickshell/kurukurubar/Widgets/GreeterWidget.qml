import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

import qs.Data as Dat

RowLayout {
  id: root

  spacing: 10

  Item {
    Layout.leftMargin: 10
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

      // stops ugly emptyness when there is no ~/.face.icon
      onStatusChanged: {
        if (faceIcon.status == Image.Error) {
          source = Dat.Paths.getPath(faceIcon, "https://i.pinimg.com/736x/8e/56/1a/8e561a4d6d29e03a93f261eea13a6fe0.jpg");
        }
      }
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
