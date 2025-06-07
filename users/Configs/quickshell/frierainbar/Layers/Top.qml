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

      // THIS SHOULD MIRROR THE 1 - SHRINKMULTIPLIER in background
      implicitHeight: 0.44 * modelData.height
      layer: WlrLayer.Top
      namespace: "rexies.frierain.top"
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
