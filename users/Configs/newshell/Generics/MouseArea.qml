import QtQuick
import "../Data/" as Dat

MouseArea {
  id: area

  // default Material values
  property real hoverOpacity: 0.08
  property real clickOpacity: 0.10
  property color layerColor: "white"
  property int layerRadius: parent?.radius ?? 0
  property NumberAnimation layerOpacityAnimation: NumberAnimation {
    duration: Dat.MaterialEasing.standardTime
    easing.bezierCurve: Dat.MaterialEasing.standard
  }

  Rectangle {
    id: layer
    radius: area.layerRadius
    opacity: 0
    anchors.fill: parent
    color: area.layerColor

    Behavior on opacity {
      animation: area.layerOpacityAnimation
    }
  }

  anchors.fill: parent
  hoverEnabled: true
  onContainsMouseChanged: layer.opacity = (area.containsMouse)? area.hoverOpacity : 0
  onContainsPressChanged: layer.opacity = (area.containsPress)? area.clickOpacity : area.hoverOpacity
}
