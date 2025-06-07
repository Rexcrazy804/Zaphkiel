import QtQuick
import QtQuick.Effects

import "../Data/" as Dat

Item {
  id: root

  property int radius: 200
  required property int shellHeight
  required property int shellWidth
  required property real shrunkMult

  states: [
    State {
      name: "FILLED"

      PropertyChanges {
        bgIcon.height: root.shellHeight
        bgIcon.width: root.shellWidth
        maskRect.topLeftRadius: 0
      }
    },
    State {
      name: "SHRUNK"

      PropertyChanges {
        bgIcon.height: root.shellHeight * root.shrunkMult
        bgIcon.width: root.shellWidth
        maskRect.topLeftRadius: root.radius
      }
    }
  ]
  transitions: [
    Transition {
      from: "FILLED"
      to: "SHRUNK"

      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime * 2
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          properties: "height, width"
          target: bgIcon
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          property: "topLeftRadius"
          target: maskRect
        }
      }
    },
    Transition {
      from: "SHRUNK"
      to: "FILLED"

      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.expressiveDefaultSpatialTime
          easing.bezierCurve: Dat.MaterialEasing.expressiveDefaultSpatial
          properties: "height, width"
          target: bgIcon
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          property: "topLeftRadius"
          target: maskRect
        }
      }
    }
  ]

  Image {
    id: bgIcon

    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    fillMode: Image.PreserveAspectCrop
    height: root.shellHeight * root.shrunkMult
    layer.enabled: true
    mipmap: true
    source: "../Assets/7372467.png"
    verticalAlignment: Image.AlignTop
    visible: false
    width: root.shellWidth * root.shrunkMult
  }

  MultiEffect {
    anchors.fill: bgIcon
    antialiasing: true
    maskEnabled: true
    maskSource: bgIconMask
    maskSpreadAtMin: 1.0
    maskThresholdMax: 1.0
    maskThresholdMin: 0.5
    smooth: true
    source: bgIcon
  }

  Item {
    id: bgIconMask

    height: bgIcon.height
    layer.enabled: true
    layer.smooth: true
    visible: false
    width: bgIcon.width

    Rectangle {
      id: maskRect

      height: bgIcon.height
      topRightRadius: this.topLeftRadius
      width: bgIcon.width
    }
  }

  MouseArea {
    anchors.fill: bgIcon

    onClicked: {
      if (Dat.Globals.bgState == "SHRUNK") {
        Dat.Globals.bgState = "FILLED";
        return;
      }
      Dat.Globals.bgState = "SHRUNK";
    }
  }
}
