import QtQuick

import "../Data/" as Dat
import "../Generics/" as Gen

Text {
  id: timeText

  anchors.centerIn: parent
  color: Dat.Colors.secondary
  text: Qt.formatDateTime(Dat.Clock?.date, "h:mm:ss AP")

  Gen.MouseArea {
    anchors.centerIn: parent
    anchors.fill: null
    height: 20
    layerColor: Dat.Colors.secondary
    layerRadius: 20
    width: timeText.contentWidth + 12

    onClicked: {
      Dat.Globals.notchState = "FULLY_EXPANDED";
      Dat.Globals.swipeIndex = 1;
    }
  }
}
