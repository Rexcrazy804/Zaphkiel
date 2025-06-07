pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets" as Wid

Item {
  id: root

  property var app: Wid.Apps {
  }
  property var aud: Wid.Audio {
  }
  property var cal: Wid.Calendar {
  }
  property var not: Wid.Notifications {
  }
  property var pow: Wid.Power {
  }
  property var ses: Wid.Session {
  }
  property StackView stack: Dat.Globals.stack

  // DEBUGGING
  // Connections {
  //   function onStackChanged() {
  //     Dat.Globals.stack.push(root.aud);
  //   }
  //
  //   target: Dat.Globals
  // }

  RowLayout {
    anchors.fill: parent

    Repeater {
      model: [
        {
          icon: "calendar_month",
          item: root.cal
        },
        {
          icon: "logout",
          item: root.ses
        },
        {
          icon: "lightbulb",
          item: root.pow
        },
        {
          icon: "notifications",
          item: root.not
        },
        {
          icon: "volume_up",
          item: root.aud
        },
        {
          icon: "videogame_asset",
          item: root.app
        }
      ]

      Gen.ToggleButton {
        required property var modelData

        Layout.fillHeight: true
        Layout.fillWidth: true
        active: root.stack.currentItem === this.modelData.item
        color: Dat.Colors.surface_container_high
        radius: 10

        icon {
          anchors.centerIn: this
          font.pointSize: 14
          icon: this.modelData.icon
        }

        mArea {
          onClicked: {
            if (root.stack.depth > 1) {
              if (root.stack.currentItem == this.modelData.item) {
                root.stack.pop();
              } else {
                root.stack.replace(this.modelData.item, {
                  "width": root.stack.width,
                  "height": root.stack.height
                }, StackView.ReplaceTransition);
              }
            } else {
              root.stack.push(this.modelData.item);
            }
          }
        }
      }
    }
  }
}
