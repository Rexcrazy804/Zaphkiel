import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell

import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  AnimatedImage {
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    playing: Mpris.players.values.length == 0
    source: Dat.Paths.getPath(this, "https://media.tenor.com/JtofR661NDIAAAAi/honkai-star-rail-hsr.gif")
  }

  Text {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter
    color: Dat.Colors.on_surface
    text: "Play some music"
  }

  SwipeView {
    id: list

    anchors.fill: parent
    orientation: Qt.Vertical

    Repeater {
      model: ScriptModel {
        values: [...Mpris.players.values]
      }

      Wid.MprisItem {
        id: rect

        property int increaseOrDecrease: 0
        required property int index
        required property MprisPlayer modelData
        property bool readyToShow: false

        player: modelData
      }
    }
  }

  PageIndicator {
    id: pageIndicator

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    count: list.count
    currentIndex: list.currentIndex
    interactive: false
    rotation: 90
    visible: this.count > 1

    delegate: Rectangle {
      id: smallrect

      required property int index

      color: (index == list.currentIndex) ? "white" : Dat.Colors.withAlpha("white", 0.5)
      height: this.width
      radius: 6
      width: 6

      Behavior on color {
        ColorAnimation {
          duration: 500
        }
      }
    }
  }
}
