import QtQuick
import QtQuick.Particles
import "../Data/" as Dat
import "../ParticleSystem/" as Par

ParticleSystem {
  id: root
  required property var velocity
  required property bool mouseIn
  required property real mouseX
  required property real mouseY

  anchors.fill: parent
  running: true

  Par.StarParticle {
    groups: ["mousetrail"]
  }

  Par.BasicEmiter {
    height: 10
    width: 10
    group: "mousetrail"
    emitRate: 80 + Math.max(root.velocity.x, root.velocity.y) * 2
    enabled: root.mouseIn
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: root.mouseX
    anchors.topMargin: root.mouseY
  }
}
