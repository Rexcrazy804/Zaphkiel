import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: audRect

  Layout.minimumWidth: swiper.currentItem?.contentWidth + 20
  clip: true
  color: Dat.Colors.primary_container

  Behavior on Layout.minimumWidth {
    NumberAnimation {
      duration: 150
      easing.type: Easing.Linear
    }
  }

  SwipeView {
    id: swiper

    anchors.fill: parent
    orientation: Qt.Horizontal

    Text {
      color: Dat.Colors.on_primary_container
      font.pointSize: 11
      height: audRect.height
      horizontalAlignment: Text.AlignHCenter
      text: Math.round(Dat.Audio.sinkVolume * 100) + "%" + " " + Dat.Audio.sinkIcon
      verticalAlignment: Text.AlignVCenter
      width: audRect.width

      Gen.MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        clickOpacity: 0.2
        layerColor: Dat.Colors.on_primary_container
        layerRadius: audRect.radius

        onClicked: mouse => {
          switch (mouse.button) {
          case Qt.MiddleButton:
            Dat.Audio.toggleMute(Dat.Audio.sink);
            break;
          case Qt.LeftButton:
            if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex == 1) {
              Dat.Globals.notchState = "EXPANDED";
            } else {
              Dat.Globals.notchState = "FULLY_EXPANDED";
              Dat.Globals.swipeIndex = 4;
              Dat.Globals.settingsTabIndex = 1;
            }
            break;
          }
        }
        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.sink)
      }
    }

    Text {
      color: Dat.Colors.on_primary_container
      font.pointSize: 11
      height: audRect.height
      horizontalAlignment: Text.AlignHCenter
      text: Math.round(Dat.Audio.sourceVolume * 100) + "%" + " " + Dat.Audio.sourceIcon
      verticalAlignment: Text.AlignVCenter
      width: audRect.width

      Gen.MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        clickOpacity: 0.2
        layerColor: Dat.Colors.on_primary_container
        layerRadius: audRect.radius

        onClicked: mouse => {
          switch (mouse.button) {
          case Qt.MiddleButton:
            Dat.Audio.toggleMute(Dat.Audio.source);
            break;
          case Qt.LeftButton:
            if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 4 && Dat.Globals.settingsTabIndex == 1) {
              Dat.Globals.notchState = "EXPANDED";
            } else {
              Dat.Globals.notchState = "FULLY_EXPANDED";
              Dat.Globals.swipeIndex = 4;
              Dat.Globals.settingsTabIndex = 1;
            }
            break;
          }
        }
        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.source)
      }
    }
  }
}
