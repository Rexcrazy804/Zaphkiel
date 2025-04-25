import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data"
import "../Assets"

Rectangle {
  id: micSlider
  Layout.fillWidth: true
  Layout.fillHeight: true
  color: Colors.secondary_container

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.MiddleButton | Qt.LeftButton
    onClicked: mouse => {switch (mouse.button) {
      case Qt.LeftButton: break; // TODO audio menu
      case Qt.MiddleButton: Audio.source.audio.muted = !Audio.micMuted;  break;
    }}
    onWheel: event => Audio.micWheelAction(event)
  }

  Rectangle {
    color: Colors.secondary
    width: parent.width * (Audio.micVolume % 1)
    anchors.left: micSlider.left
    anchors.top: micSlider.top
    anchors.bottom: micSlider.bottom
  }

  RowLayout {
    visible: true
    anchors.fill: parent
    anchors.leftMargin: 14
    anchors.rightMargin: 14

    Text {
      Layout.alignment: Qt.AlignCenter
      color: (Audio.micVolume%1 > 0.16)? Colors.on_secondary : Colors.secondary
      text: Audio.micIcon
      font.pointSize: 20
    }

    Rectangle {
      implicitWidth: micSlider.width * 0.8
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
