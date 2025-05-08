import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Generics/" as Gen

ClippingRectangle {
  id: audRect
  color: Ass.Colors.secondary
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
      color: Ass.Colors.on_secondary
      font.pointSize: 11
      text: Math.round(Dat.Audio.sinkVolume * 100) + "%" + " " + Dat.Audio.sinkIcon

      Gen.MouseArea {
        clickOpacity: 0.2
        layerColor: Ass.Colors.on_secondary
        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.sink)
        onClicked: mouse => Dat.Audio.toggleMute(Dat.Audio.sink)
      }
    }

    Text {
      width: audRect.width
      height: audRect.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      color: Ass.Colors.on_secondary
      font.pointSize: 11
      text: Math.round(Dat.Audio.sourceVolume * 100) + "%" + " " + Dat.Audio.sourceIcon

      Gen.MouseArea {
        clickOpacity: 0.2
        layerColor: Ass.Colors.on_secondary
        onWheel: event => Dat.Audio.wheelAction(event, Dat.Audio.source)
        onClicked: mouse => Dat.Audio.toggleMute(Dat.Audio.source)
      }
    }
  }
}
