import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  clip: true
  id: audRect
  color: Dat.Colors.primary_container
  Layout.minimumWidth: swiper.currentItem?.contentWidth + 20

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
      width: audRect.width
      height: audRect.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      color: Dat.Colors.on_primary_container
      font.pointSize: 11
      text: Math.round(Dat.Audio.sinkVolume * 100) + "%" + " " + Dat.Audio.sinkIcon

      Gen.MouseArea {
        layerRadius: audRect.radius
        clickOpacity: 0.2
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        layerColor: Dat.Colors.on_primary_container
        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.sink)
        onClicked: mouse => {
          switch (mouse.button)  {
            case Qt.MiddleButton: 
              Dat.Audio.toggleMute(Dat.Audio.sink); 
              break;
            case Qt.LeftButton:
              Dat.Globals.notchState = "FULLY_EXPANDED"
              Dat.Globals.swipeIndex = 4
              Dat.Globals.settingsTabIndex = 1
              break;
          }
        }
      }
    }

    Text {
      width: audRect.width
      height: audRect.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      color: Dat.Colors.on_primary_container
      font.pointSize: 11
      text: Math.round(Dat.Audio.sourceVolume * 100) + "%" + " " + Dat.Audio.sourceIcon

      Gen.MouseArea {
        layerRadius: audRect.radius
        clickOpacity: 0.2
        layerColor: Dat.Colors.on_primary_container
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.source)
        onClicked: mouse => {
          switch (mouse.button)  {
            case Qt.MiddleButton: 
              Dat.Audio.toggleMute(Dat.Audio.source); 
              break;
            case Qt.LeftButton:
              Dat.Globals.notchState = "FULLY_EXPANDED"
              Dat.Globals.swipeIndex = 4
              Dat.Globals.settingsTabIndex = 1
              break;
          }
        }
      }
    }
  }
}
