import QtQuick
import Quickshell.Services.Mpris

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root
  color: "transparent"
  visible: Dat.Recording.running

  Rectangle {
    id: recordDot
    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    width: 10
    height: this.width
    radius: this.width
  }

  Timer {
    running: Dat.Globals.notifState != "COLLAPSED" && root.visible
    repeat: true
    interval: 600
    onTriggered: recordDot.visible = !recordDot.visible
    triggeredOnStart: true
  }
}
