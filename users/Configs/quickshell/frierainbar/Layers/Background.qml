import QtQuick
import QtQuick.Effects
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
          color: Dat.Colors.background
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          height: layerShell.modelData.height * (1 - bgImg.shrunkMult) + container.anchors.bottomMargin

          // entry point to widgets
          Con.Primary {
            id: container
            anchors.fill: parent
            anchors.bottomMargin: 60
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

          MouseArea {
            anchors.fill: parent

            onClicked: {
              if (Dat.Globals.bgState == "SHRUNK") {
                Dat.Globals.bgState = "FILLED";
                return;
              }
              Dat.Globals.bgState = "SHRUNK";
            }
          }
        }
      }
    }
  }
}
