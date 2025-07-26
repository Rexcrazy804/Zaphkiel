import QtQuick
import QtQuick.Effects

import qs.Data as Dat

Item {
  id: root

  // default gradient used by greeter
  property Gradient gradient: Gradient {
    GradientStop {
      color: Dat.Colors.background
      position: 0.0
    }

    GradientStop {
      color: Dat.Colors.on_background
      position: 0.4
    }

    GradientStop {
      color: Dat.Colors.on_background
      position: 1.0
    }
  }
  property bool inverted: false
  required property Text text

  height: text.contentHeight
  width: text.contentWidth

  Component.onCompleted: {
    text.layer.enabled = true;
    text.layer.smooth = true;
    text.renderType = Text.NativeRendering;
    text.visible = false;
  }

  Rectangle {
    id: background

    anchors.fill: parent
    gradient: root.gradient
    visible: false
  }

  MultiEffect {
    anchors.fill: parent
    maskEnabled: true
    maskInverted: root.inverted
    maskSource: root.text
    maskSpreadAtMin: 1.0
    maskThresholdMax: 1.0
    maskThresholdMin: 0.5
    source: background
  }
}
