import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../Data"
import "../Assets"
import "../Components"

Text {
  id: root
  required property PanelWindow bar
  text: Math.round(Audio.volume * 100) + "%" + " " + Audio.volIcon
  color: Colors.primary_fixed_dim
  font.pointSize: 11
  font.bold: true

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    onClicked: mouse => { 
      switch (mouse.button) {
        case Qt.LeftButton:
          popup.visible = !popup.visible
          break;
        case Qt.MiddleButton:
          Audio.sink.audio.muted = !Audio.muted
          break;
        case Qt.RightButton:
          Audio.source.audio.muted = !Audio.source.audio.muted
          break;
      }
    }
    onWheel: event => Audio.wheelAction(event)
  }

  SoundChannelMenu {
    id: popup
    bar: root.bar
  }
}

