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

      width: root.width
      height: root.height

      state: "Hidden"
      states: [
        State {
          name: "Hidden"
          PropertyChanges { rect.opacity: 0 }
        },
        State {
          name: "Shown"
          PropertyChanges { rect.opacity: 1 }
        }
      ]

      Behavior on opacity {
        NumberAnimation {
          duration: 300;
          easing.type: Easing.InOutQuart
        }
      }

      Component.onCompleted: {
        ListView.currentItemChanged.connect(() => {
          if (ListView.isCurrentItem) { rect.state = "Shown" }
        })
      }

      onOpacityChanged: {
        if (opacity != 0) { return; }
        switch (increaseOrDecrease) {
          case 1:
            list.incrementCurrentIndex();
            break;
          case -1:
            list.decrementCurrentIndex();
            break;
        }
        rect.increaseOrDecrease = 0;
      }
    }
  }
}
