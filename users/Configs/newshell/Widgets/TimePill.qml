import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Generics/" as Gen

Text {
  id: timeText
  anchors.centerIn: parent
  color: Ass.Colors.secondary
  text: Qt.formatDateTime(Dat.Clock?.date, "h:mm:ss AP")

  Gen.MouseArea {
    anchors.fill: null
    anchors.centerIn: parent
    layerColor: Ass.Colors.secondary
    layerRadius: 20

    width: timeText.contentWidth + 12
    height: 20

    onClicked: {
      Dat.Globals.notchState = "FULLY_EXPANDED";
      Dat.Globals.swipeIndex = 1;
    }
  }
}
