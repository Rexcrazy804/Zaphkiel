import QtQuick
import QtQuick.Particles
import Quickshell
import Quickshell.Wayland

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: notch

      required property ShellScreen modelData

      anchors.bottom: true
      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      implicitHeight: 28
      layer: WlrLayer.Bottom
      namespace: "rexies.notch.mouseParticles"
      screen: modelData
      surfaceFormat.opaque: false

      MouseArea {
        id: mArea

        acceptedButtons: Qt.NoButton
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
          pSys.running = true;
          pSys.active = true;
          emitStopTimer.restart();
        }

        ParticleSystem {
          id: pSys

          property bool active: false

          running: false

          ImageParticle {
            autoRotation: true
            color: "#653BE0"
            colorVariation: 0.1
            entryEffect: ImageParticle.Fade
            groups: ["kuru"]
            rotationVariation: 360
            source: "qrc:///particleresources/star.png"
          }

          Emitter {
            id: emitter

            anchors.left: parent.left
            anchors.leftMargin: mArea.mouseX
            anchors.rightMargin: 30
            anchors.top: parent.top
            anchors.topMargin: mArea.mouseY
            emitRate: 60
            enabled: pSys.active
            endSize: 0
            group: "kuru"
            height: 10
            lifeSpan: 1000
            lifeSpanVariation: 500
            size: 50
            sizeVariation: 30
            width: 10

            velocity: AngleDirection {
              angle: 90
              angleVariation: 0
              magnitude: 30
              magnitudeVariation: 10
            }
          }
        }
      }

      Timer {
        id: emitStopTimer

        interval: 100

        onTriggered: pSys.active = false
      }

      Timer {
        interval: emitter.lifeSpan + emitter.lifeSpanVariation
        running: !pSys.active

        onTriggered: pSys.running = false
      }
    }
  }
}
