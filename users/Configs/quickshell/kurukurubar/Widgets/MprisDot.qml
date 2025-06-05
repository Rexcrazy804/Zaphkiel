import QtQuick
import Quickshell.Services.Mpris

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  property real scaleFactor: Dat.Globals.scaleFactor

  color: Dat.Colors.surface_container_high
  visible: Mpris.players.values.length > 0
  radius: scaleFactor * 11
  implicitWidth: scaleFactor * 26
  implicitHeight: scaleFactor * 26

  Text {
    id: icon

    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: scaleFactor * 12
    rotation: Dat.Globals.mprisDotRotation
    text: "󰽰"

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
    layerRadius: scaleFactor * 11

    onClicked: mevent => {
      if (Dat.Globals.notchState === "FULLY_EXPANDED" && Dat.Globals.swipeIndex === 3) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 3;
      }
    }
  }
}
