import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell

import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  Text {
    anchors.centerIn: parent
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
        required property MprisPlayer modelData
        required property int index
        property int increaseOrDecrease: 0
        property bool readyToShow: false
        player: modelData
      }
    }
  }

  PageIndicator {
    rotation: 90
    visible: this.count > 1
    id: pageIndicator
    interactive: false
    count: list.count
    currentIndex: list.currentIndex

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    delegate: Rectangle {
      id: smallrect
      required property int index
      radius: 6
      width: 6
      height: this.width
      color: (index == list.currentIndex)? "white" : Dat.Colors.withAlpha("white", 0.5)

      Behavior on color { ColorAnimation { duration: 500 } }
    }
  }
}
