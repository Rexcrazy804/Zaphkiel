import QtQuick
import QtQuick.Particles
import QtQuick.Layouts

import "../Data/" as Dat

// god bless sormane for his raining kuru kuru example
// https://github.com/soramanew/rainingkuru
ParticleSystem {
  id: root
  required property real rateMultiplier
  running: false

  ImageParticle {
    autoRotation: true
    color: "#653BE0"
    colorVariation: 0.3
    entryEffect: ImageParticle.Fade
    groups: ["kuru"]
    rotationVariation: 360
    source: "qrc:///particleresources/star.png"
  }

  Emitter {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: 100
    height: 10
    anchors.rightMargin: 30
    group: "kuru"
    emitRate: 120 * (Math.min(root.rateMultiplier - 5.5, 5))
    lifeSpan: 5000
    lifeSpanVariation: 1000
    size: 20
    sizeVariation: 30
    endSize: 0
    velocity: AngleDirection {
      angleVariation: 360
      magnitude: 120
      magnitudeVariation: 20
    }
  }
}
