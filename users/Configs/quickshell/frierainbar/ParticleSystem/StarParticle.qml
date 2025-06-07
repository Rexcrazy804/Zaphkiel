import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Psys

ImageParticle {
  autoRotation: false
  color: Dat.Colors.withAlpha(Dat.Colors.primary, 0.55)
  colorVariation: 0.2
  entryEffect: ImageParticle.Fade
  rotationVariation: 0
  source: "qrc:///particleresources/star.png"
}
