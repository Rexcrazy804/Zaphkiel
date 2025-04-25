import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../Data"
import "../Assets"

Text {
  text: Math.round(Audio.volume * 100) + "%" + " " + Audio.volIcon
  color: Colors.secondary_fixed_dim
  font.pointSize: 11
  font.bold: true

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton
    onClicked: mouse => Audio.sink.audio.muted = !Audio.muted
    onWheel: event => Audio.wheelAction(event)
  }
}

