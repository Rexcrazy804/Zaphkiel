import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Par

ParticleSystem {
  id: root

  required property bool mouseIn
  required property real mouseX
  required property real mouseY
  required property var velocity

  anchors.fill: parent
  running: true

  Par.StarParticle {
    groups: ["mousetrail"]
  }

  Par.BasicEmiter {
    anchors.left: parent.left
    anchors.leftMargin: root.mouseX
    anchors.top: parent.top
    anchors.topMargin: root.mouseY
    emitRate: 80 + Math.max(root.velocity.x, root.velocity.y) * 2
    enabled: root.mouseIn
    group: "mousetrail"
    height: 10
    width: 10
  }
}
