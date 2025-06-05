import QtQuick

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  // Responsive scale factor
  property real scaleFactor: Dat.Globals.scaleFactor

  color: Dat.Colors.surface_container_high
  radius: scaleFactor * 11
  implicitWidth: scaleFactor * 26
  implicitHeight: scaleFactor * 26

  Text {
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: scaleFactor * 12
    text: "󰃠"
  }

  Gen.MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    layerColor: Dat.Colors.tertiary
    layerRadius: root.radius

    onClicked: mevent => {
      switch (mevent.button) {
      case Qt.RightButton:
        Dat.Brightness.increase();
        break;
      case Qt.LeftButton:
        Dat.Brightness.decrease();
        break;
      }
    }

    onWheel: event => {
      if (event.angleDelta.y > 0) {
        Dat.Brightness.increase();
      } else {
        Dat.Brightness.decrease();
      }
    }
  }
}
