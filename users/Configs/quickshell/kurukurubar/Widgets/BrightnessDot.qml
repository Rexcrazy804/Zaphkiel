import QtQuick

import "../Data/" as Dat

Rectangle {
  color: Dat.Colors.surface_container_high

  Text {
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 11
    text: "󰃠"
  }
  MouseArea {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    anchors.fill: parent

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
