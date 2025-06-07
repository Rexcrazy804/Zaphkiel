import QtQuick
import Quickshell
import Quickshell.Wayland

import "../Data/" as Dat

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: layerShell

      required property ShellScreen modelData

      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Auto
      focusable: false
      implicitHeight: 380
      layer: WlrLayer.Bottom
      namespace: "rexies.frierain.bg"
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        item: Rectangle {
          height: 0
          width: 0
        }
      }
    }
  }
}
