import QtQuick
import qs.Data as Dat

Item {
  id: root

  visible: Dat.Recording.running

  Rectangle {
    id: recordDot

    anchors.centerIn: parent
    color: Dat.Colors.tertiary
    height: this.width
    radius: this.width
    width: 10
  }

  Timer {
    interval: 600
    repeat: true
    running: Dat.Globals.notifState != "COLLAPSED" && root.visible
    triggeredOnStart: true

    onTriggered: recordDot.visible = !recordDot.visible
  }
}
