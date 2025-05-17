import QtQuick
import Quickshell.Services.Mpris

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  color: Dat.Colors.surface_container_high
  visible: Mpris.players.values.length

  Text {
    id: icon

    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 11
    rotation: Dat.Globals.mprisDotRotation
    text: "󰽰"

    // MAKE SURE THIS IS THE SAME AS MPRIS ITEM's
    Behavior on rotation {
      NumberAnimation {
        duration: 500
        easing.type: Easing.Linear
      }
    }
  }

  Gen.MouseArea {
    acceptedButtons: Qt.LeftButton
    layerColor: Dat.Colors.tertiary

    onClicked: mevent => {
      if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 3) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 3;
      }
    }
  }
}
