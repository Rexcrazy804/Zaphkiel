import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat

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
      playing: true
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1

      fillMode: Image.PreserveAspectCrop
      horizontalAlignment: Image.AlignRight
      source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"

      Component.onCompleted: {
        Dat.Globals.notchStateChanged.connect(() => {
          if (Dat.Globals.notchState == "FULLY_EXPANDED") {
            playing = true;
          }
        });
      }

      Timer {
        running: Dat.Globals.notchState != "FULLY_EXPANDED" && parent.playing == true
        interval: 500
        onTriggered: {
          parent.playing = false;
        }
      }
    }
  }
}
