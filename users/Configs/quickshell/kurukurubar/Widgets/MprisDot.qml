import QtQuick
import Quickshell.Services.Mpris

import "../Data/" as Dat

Rectangle {
  color: Dat.Colors.surface_container_high
  visible: Mpris.players.values.length

  Text {
    id: icon

    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 11
    text: "󰽰"

    Behavior on rotation {
      NumberAnimation {
        duration: 500
        easing.type: Easing.Linear
      }
    }

    Component.onCompleted: {
      Dat.Globals.notchStateChanged.connect(() => {
        if (Dat.Globals.notchState != "COLLAPSED") {
          rotation += 10;
        }
      });
    }
  }
  MouseArea {
    acceptedButtons: Qt.LeftButton
    anchors.fill: parent

    onClicked: mevent => {
      Dat.Globals.notchState = "FULLY_EXPANDED";
      Dat.Globals.swipeIndex = 3;
    }
  }
  Timer {
    interval: 500
    repeat: true
    running: parent.visible && Dat.Globals.notchState != "COLLAPSED"

    onTriggered: {
      icon.rotation = icon.rotation + 10;
    }
  }
}
