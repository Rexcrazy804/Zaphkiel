pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import "../Assets"

Rectangle {
  id: root
  color: "transparent"
  clip: true
  ListView {
    id: list
    interactive: false
    anchors.fill: parent
    orientation: ListView.Horizontal
    snapMode: ListView.SnapToItem
    highlightFollowsCurrentItem: true
    highlightMoveVelocity: -1
    keyNavigationWraps: true

    model: ScriptModel {
      values: [...Mpris.players.values]
    }

    delegate: MprisItem {
      id: rect
      required property MprisPlayer modelData
      required property int index
      property int increaseOrDecrease: 0
      property bool readyToShow: false
      player: modelData
      view: list

      width: root.width
      height: root.height
    }
  }
}
