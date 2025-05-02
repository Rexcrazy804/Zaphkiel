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

    model: 3

    delegate: Rectangle {
      id: rect
      required property var modelData
      required property int index
      property int increaseOrDecrease: 0
      property bool readyToShow: false

      state: "Hidden"
      states: [
        State {
          name: "Hidden"
          PropertyChanges {
            rect.opacity: 0
          }
        },
        State {
          name: "Shown"
          PropertyChanges {
            rect.opacity: 1
          }
        }
      ]

      Behvaior on opacity {
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


      color: (index)? Colors.primary_container : Colors.on_primary
      width: root.width
      height: root.height
      Text {
        anchors.centerIn: parent
        color: Colors.primary
        text: "Place holder " + rect.index + " for MPRIS"
        font.bold: true

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.RightButton | Qt.LeftButton

          onClicked: (mouse) => {
            if (list.count > 1) { rect.state = "Hidden" }
            switch (mouse.button) {
              case Qt.LeftButton: rect.increaseOrDecrease = -1; break;
              case Qt.RightButton: rect.increaseOrDecrease = 1; break;
            }
          }
        }
      }
    }
  }
}
