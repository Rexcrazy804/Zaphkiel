import QtQuick
import QtQuick.Controls.Basic
import Quickshell.Services.Pipewire
import "../Assets"

Slider {
  required property PwNode node
  required property color foregroundColor
  required property color backgroundColor
  required property string icon
  padding: 0
  topInset: 0
  bottomInset: 0
  rightInset: 0
  leftInset: 0

  id: slider
  snapMode: Slider.NoSnap
  live: false

  background: Rectangle {
    id: sliderback
    anchors.centerIn: parent
    color: slider.backgroundColor
    height: slider.height
    width: slider.availableWidth

    Rectangle {
      color: slider.foregroundColor
      width: slider.visualPosition * slider.availableWidth
      height: slider.height
    }

    Text {
      id: text
      anchors.leftMargin: 15
      verticalAlignment: Text.AlignVCenter
      anchors.fill: parent
      color: (slider.value % 101 > 18)? slider.backgroundColor : slider.foregroundColor
      text: slider.icon
      font.pointSize: 20
    }
  }

  handle: Rectangle {visible: false}
  value: slider.node?.audio?.volume * 100 ?? 0
  from: 0
  to: 100

  onValueChanged: {
    if (slider.node?.audio) {
      slider.node.audio.volume = slider.value / 100
    }
  }
}
