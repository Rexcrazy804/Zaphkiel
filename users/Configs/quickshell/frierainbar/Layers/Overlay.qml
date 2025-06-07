import QtQuick
import Quickshell
import Quickshell.Wayland

import "../Data/" as Dat
import "../Generics/" as Gen

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
      exclusionMode: ExclusionMode.Auto
      focusable: false
      layer: WlrLayer.Overlay
      namespace: "rexies.frierain.overlay"
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        item: hoverRect
      }

      Item {
        id: hoverRect

        anchors.right: parent.right
        height: (mArea.containsMouse || Dat.Globals.bgState == "SHRUNK") ? this.width : 1
        width: 70

        MouseArea {
          id: mArea

          anchors.fill: parent
          hoverEnabled: true

          onClicked: {
            Dat.Globals.bgState = (Dat.Globals.bgState == "SHRUNK") ? "FILLED" : "SHRUNK";
          }
        }

        Rectangle {
          id: floatingCirc

          anchors.right: parent.right
          anchors.rightMargin: 10
          height: this.width
          radius: this.width
          state: (mArea.containsMouse || Dat.Globals.bgState == "SHRUNK") ? "REVEALED" : "HIDDEN"
          width: 50
          color: Dat.Colors.surface

          states: [
            State {
              name: "REVEALED"

              PropertyChanges {
                floatingCirc.visible: true
                floatingCirc.y: 10
              }
            },
            State {
              name: "HIDDEN"

              PropertyChanges {
                floatingCirc.visible: false
                floatingCirc.y: -100
              }
            }
          ]
          transitions: [
            Transition {
              from: "HIDDEN"
              to: "REVEALED"

              SequentialAnimation {
                PropertyAction {
                  property: "visible"
                  target: floatingCirc
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                  property: "y"
                  target: floatingCirc
                }
              }
            },
            Transition {
              from: "REVEALED"
              to: "HIDDEN"

              SequentialAnimation {
                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                  property: "y"
                  target: floatingCirc
                }

                PropertyAction {
                  property: "visible"
                  target: floatingCirc
                }
              }
            }
          ]

          Gen.MatIcon {
            Behavior on rotation {
              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
              }
            }
            anchors.centerIn: parent
            font.pointSize: 24
            icon: "arrow_upward"
            rotation: (Dat.Globals.bgState == "SHRUNK") ? 0 : 180
            color: Dat.Colors.on_surface
          }
        }
      }
    }
  }
}
