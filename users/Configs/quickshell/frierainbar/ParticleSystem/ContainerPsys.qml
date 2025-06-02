import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Psys

ParticleSystem {
  id: pSys

  property var stackCur: Dat.Globals.stack.currentItem

  anchors.fill: parent
  running: Dat.Globals.bgState == "SHRUNK"

  Component.onCompleted: Dat.Globals.psys = this

  // running: false

  Psys.StarParticle {
    entryEffect: ImageParticle.Scale
    groups: ["stars"]
  }

  Attractor {
    id: calRepeller

    affectedParameter: Attractor.Acceleration
    anchors.fill: parent
    enabled: pSys.stackCur.name == "cal"
    groups: ["stars"]
    pointX: 600
    pointY: 140
    proportionalToDistance: Attractor.InverseQuadratic
    strength: -100000
  }

  Affector {
    id: sesColorChanger

    property color changeCol: Dat.Colors.error

    anchors.fill: parent
    enabled: (pSys.stackCur.name == "ses")
    groups: ["stars"]

    onAffectParticles: (particles, dt) => {
      if (pSys.stackCur.hovered) {
        particles.forEach(particle => {
          if (particle.red == sesColorChanger.changeCol.r) {
            // tiny optimization
            return;
          }
          particle.red = sesColorChanger.changeCol.r;
          particle.green = sesColorChanger.changeCol.g;
          particle.blue = sesColorChanger.changeCol.b;
          particle.updating = true;
        });
      }
    }
  }

  Emitter {
    id: emitter

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.right: parent.right
    anchors.rightMargin: this.anchors.leftMargin
    emitRate: (powerWander.enabled || audGrav.enabled) ? 30 : 9
    endSize: 0
    group: "stars"
    height: 10
    lifeSpan: 15 * 1000
    lifeSpanVariation: 5 * 1000
    size: 50
    sizeVariation: 30

    velocity: AngleDirection {
      angle: -90
      magnitude: 10
      magnitudeVariation: 4
    }
  }

  Wander {
    affectedParameter: Wander.Velocity
    groups: ["stars"]
    pace: 30
    xVariance: 300
  }

  Wander {
    id: powerWander

    property int mult: (pSys.stackCur.wanderMult ?? -1) + 1

    affectedParameter: Wander.Velocity
    enabled: (pSys.stackCur.name == "pow")
    groups: ["stars"]
    pace: this.mult * 300
    xVariance: this.mult * 1500
    yVariance: this.mult * 500
  }

  Attractor {
    id: arrowRepeller
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 65
    anchors.left: parent.left
    anchors.leftMargin: this.anchors.rightMargin
    anchors.right: parent.right
    anchors.rightMargin: 30
    height: 20
    affectedParameter: Attractor.Velocity
    enabled: pSys.stackCur.name == "game" && pSys.stackCur.fired

    groups: ["stars"]
    pointX: 0
    pointY: height/2
    strength: -5

    // Rectangle {
    //   anchors.fill: parent
    // }
  }

  Affector {
    id: gobColorChanger

    property color changeCol: Dat.Colors.error

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    anchors.right: parent.right
    enabled: (pSys.stackCur.name == "game")
    groups: ["stars"]
    height: 100
    width: 100

    onAffectParticles: (particles, dt) => {
      if (pSys.stackCur.killed) {
        particles.forEach(particle => {
          if (particle.red == sesColorChanger.changeCol.r) {
            // tiny optimization
            return;
          }
          particle.red = sesColorChanger.changeCol.r;
          particle.green = sesColorChanger.changeCol.g;
          particle.blue = sesColorChanger.changeCol.b;
          particle.updating = true;
        });
      }
    }
  }

  Gravity {
    id: audGrav
    enabled: pSys.stackCur.name == "aud"
    angle: -90
    magnitude: 100
  }
}
