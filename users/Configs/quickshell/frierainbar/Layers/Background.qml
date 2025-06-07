import QtQuick
import Quickshell
import Quickshell.Wayland

import "../Data/" as Dat
import "../Widgets/" as Wid
import "../Containers/" as Con

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: layerShell

      required property ShellScreen modelData

      anchors.bottom: true
      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      layer: WlrLayer.Bottom
      namespace: "rexies.frierain.bg"
      screen: modelData
      surfaceFormat.opaque: true

      mask: Region {
        item: background
      }

      Item {
        id: background

        anchors.fill: parent

        Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          color: Dat.Colors.background
          height: layerShell.modelData.height * (1 - bgImg.shrunkMult) + container.anchors.bottomMargin

          // entry point to widgets
          Con.Primary {
            id: container

            anchors.bottomMargin: 60
            anchors.fill: parent
          }
        }

        Wid.TransformingBg {
          id: bgImg

          anchors.fill: parent
          radius: 40
          shellHeight: layerShell.modelData.height
          shellWidth: layerShell.modelData.width
          shrunkMult: 0.56
          state: Dat.Globals.bgState
        }
      }
    }
  }
}
