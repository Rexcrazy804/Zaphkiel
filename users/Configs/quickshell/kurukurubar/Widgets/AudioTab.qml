import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  color: Dat.Colors.surface_container_high
  radius: 20
  clip: true

  ListView {
    anchors.margins: 10
    anchors.fill: parent
    model: ScriptModel {
      id: sModel
      values: Pipewire.nodes.values.filter(node => node.audio).sort()
    }
    spacing: 8
    delegate: Gen.AudioSlider {
      required property PwNode modelData
      node: modelData
    }

    PwObjectTracker {
      objects: sModel.values
    }
  }
}
