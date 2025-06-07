import QtQuick

import "../Generics/" as Gen
import "../Data/" as Dat

Rectangle {
  id: root
  required property real iconOpacity
  required property string icon
  function onClick() {}

  color: Dat.Colors.primary
  height: this.width
  radius: this.width

  Gen.MouseArea {
    id: mArea
    layerColor: sesIcon.color
    onClicked: root.onClick()
  }

  Gen.MatIcon {
    fill: mArea.containsMouse
    id: sesIcon
    anchors.centerIn: parent
    color: Dat.Colors.on_primary
    font.pointSize: 17
    icon: root.icon
    opacity: root.iconOpacity
  }
}
