import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  clip: true
  color: Dat.Colors.surface_container_high
  radius: 20

  ListView {
    anchors.fill: parent
    anchors.margins: 10
    spacing: 12

    delegate: Gen.AudioSlider {
      required property PwNode modelData

      implicitWidth: parent?.width ?? 0
      node: modelData
    }
    model: ScriptModel {
      id: sModel

      values: Pipewire.nodes.values.filter(node => node.audio).sort()
    }
  }

  PwObjectTracker {
    objects: sModel.values
  }
}
