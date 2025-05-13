import QtQuick
import Quickshell.Services.Mpris

import "../Data/" as Dat

Rectangle {
  visible: Mpris.players.values.length
  color: Dat.Colors.surface_container_high

  Text {
    id: icon
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    font.pointSize: 11
    text: "󰽰"
    Behavior on  rotation {
      NumberAnimation {
        duration: 500
        easing.type: Easing.Linear
      }
    }

    Component.onCompleted: {
      Dat.Globals.notchStateChanged.connect(() => {
        if (Dat.Globals.notchState != "COLLAPSED") {
          rotation += 10
        }
      })
    }
  }
  MouseArea {
    acceptedButtons: Qt.LeftButton
    anchors.fill: parent

    onClicked: mevent => {
      Dat.Globals.notchState = "FULLY_EXPANDED"
      Dat.Globals.swipeIndex = 3
    }
  }

  Timer {
    running: parent.visible && Dat.Globals.notchState != "COLLAPSED"
    interval: 500
    repeat: true
    onTriggered: {
      icon.rotation = icon.rotation + 10
    }
  }

}
