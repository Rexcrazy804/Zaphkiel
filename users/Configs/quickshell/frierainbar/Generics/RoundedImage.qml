import QtQuick
import QtQuick.Effects

Item {
  id: root

  property alias image: rootIcon
  property real radius
  property string source

  Image {
    id: rootIcon

    anchors.fill: parent
    antialiasing: true
    fillMode: Image.PreserveAspectCrop
    mipmap: true
    smooth: true
    source: root.source
    visible: false
  }

  MultiEffect {
    id: effect

    anchors.fill: rootIcon
    antialiasing: true
    maskEnabled: true
    maskSource: rootIconMask
    maskSpreadAtMin: 1.0
    maskThresholdMax: 1.0
    maskThresholdMin: 0.5
    source: rootIcon
  }

  Item {
    id: rootIconMask

    antialiasing: true
    height: rootIcon.height
    layer.enabled: true
    layer.smooth: true
    smooth: true
    visible: false
    width: rootIcon.width

    Rectangle {
      anchors.fill: parent
      height: this.width
      radius: root.radius
    }
  }
}
