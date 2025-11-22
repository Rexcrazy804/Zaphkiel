pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris
import "../Assets"

Rectangle {
  id: root
  color: "transparent"
  clip: true

  Text {
    visible: list.count == 0
    anchors.centerIn: parent
    color: Colors.primary
    text: "Play some music"
  }

  SwipeView {
    id: list
    anchors.fill: parent
    orientation: Qt.Horizontal

    Repeater {
      model: ScriptModel {
        values: [...Mpris.players.values]
      }
      MprisItem {
        id: rect
        required property MprisPlayer modelData
        required property int index
        property int increaseOrDecrease: 0
        property bool readyToShow: false
        player: modelData

        width: root.width
        height: root.height
      }
    }
  }

  PageIndicator {
    visible: this.count > 1
    id: pageIndicator
    interactive: false
    count: list.count
    currentIndex: list.currentIndex

    anchors.right: parent.right
    anchors.top: parent.top

    delegate: Rectangle {
      id: smallrect
      required property int index
      width: 6
      height: this.width
      color: (index == list.currentIndex)? Colors.primary : Colors.primary_container

      Behavior on color { ColorAnimation { duration: 500 } }
    }
  }
}
