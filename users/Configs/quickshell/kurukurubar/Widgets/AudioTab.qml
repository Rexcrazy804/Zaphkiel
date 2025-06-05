import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  id: audioPanel

  // Responsive scale factor
  property real scaleFactor: Dat.Globals.scaleFactor

  clip: true
  color: Dat.Colors.surface_container_high
  radius: scaleFactor * 20

  ListView {
    id: listView

    anchors.fill: parent
    anchors.margins: scaleFactor * 20
    spacing: scaleFactor * 22

    delegate: Gen.AudioSlider {
      required property PwNode modelData

      implicitWidth: listView.width
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
