import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Psys

  Emitter {
    endSize: 10
    emitRate: 60
    lifeSpan: 1000
    lifeSpanVariation: 500
    size: 50
    sizeVariation: 30
    velocity: AngleDirection {
      angle: 90
      angleVariation: 0
      magnitude: 30
      magnitudeVariation: 30
    }
  }
