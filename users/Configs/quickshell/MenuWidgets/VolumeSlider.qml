import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data"
import "../Assets"

Rectangle {
  id: volumeSlider
  Layout.fillWidth: true
  Layout.fillHeight: true
  color: (Audio.volume > 1)? Colors.secondary_container : Colors.tertiary_container

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton | Qt.LeftButton
    onClicked: mouse => {switch (mouse.button) {
      case Qt.LeftButton: break; // TODO audio menu
      case Qt.MiddleButton: Audio.sink.audio.muted = !Audio.muted;  break;
    }}
    onWheel: event => Audio.wheelAction(event)
  }

  Rectangle {
    color: (Audio.volume > 1)? Colors.secondary : Colors.tertiary
    width: parent.width * (Audio.volume % 1)
    anchors.left: volumeSlider.left
    anchors.top: volumeSlider.top
    anchors.bottom: volumeSlider.bottom
  }

  RowLayout {
    visible: true
    anchors.fill: parent
    anchors.leftMargin: 14
    anchors.rightMargin: 14

    Text {
      Layout.alignment: Qt.AlignCenter
      color: {
        (Audio.volume > 1)? 
        (Audio.volume%1 > 0.16)? Colors.on_secondary : Colors.secondary :
        (Audio.volume%1 > 0.16)? Colors.on_tertiary : Colors.tertiary

      }        text: Audio.volIcon
      font.pointSize: 24
    }

    Rectangle {
      implicitWidth: volumeSlider.width * 0.8
      color: "transparent"
      border {
        color: (Audio.debug)? Colors.tertiary : "transparent"
        width: 3
      }
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignCenter
    }
  }
}
