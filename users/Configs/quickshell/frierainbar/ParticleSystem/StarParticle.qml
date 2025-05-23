import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Psys

ImageParticle {
  autoRotation: false
  color: Dat.Colors.primary_container
  colorVariation: 0.4
  entryEffect: ImageParticle.Fade
  rotationVariation: 0
  source: "qrc:///particleresources/star.png"
}
