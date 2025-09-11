import QtQuick
import Quickshell.Services.Mpris

import qs.Data as Dat
import qs.Generics as Gen

Rectangle {
  color: Dat.Colors.current.surface_container_high
  visible: Mpris.players.values.length

  Text {
    id: icon

    anchors.centerIn: parent
    color: Dat.Colors.current.tertiary
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
    layerColor: Dat.Colors.current.tertiary

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
