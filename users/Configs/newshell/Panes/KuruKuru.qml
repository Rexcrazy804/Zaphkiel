import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass

Rectangle {
  color: "transparent"

  RowLayout {
    anchors.fill: parent
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1.45
      color: "transparent"
      Text {
        color: Ass.Colors.secondary
        anchors.centerIn: parent
        text: " Kuru Kuru Kuru"
      }
    }
    AnimatedImage {
      playing: parent.visible
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1

      fillMode: Image.PreserveAspectCrop
      horizontalAlignment: Image.AlignRight
      source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
    }
  }
}
