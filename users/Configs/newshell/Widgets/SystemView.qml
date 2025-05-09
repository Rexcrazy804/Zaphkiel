pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: root
  property int index: SwipeView.index
  property bool isCurrent: SwipeView.isCurrentItem
  color: "transparent"

  RowLayout {
    anchors.margins: 10
    anchors.rightMargin: 5
    anchors.fill: parent
    spacing: 5
    Rectangle {
      clip: true
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 5
      radius: 10
      color: Ass.Colors.surface_container_high

      Image {
        id: nixLogo
        // y: this.x
        x: -(this.width / 2.5)
        rotation: 10
        opacity: 0.15
        width: parent.height
        height: this.width
        fillMode: Image.PreserveAspectCrop
        source: "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/logo/nix-snowflake-white.svg"

        Timer {
          interval: 500
          running: Dat.Globals.notchState == "FULLY_EXPANDED"
          repeat: true
          onTriggered:  parent.rotation = (parent.rotation + 3) % 360
        }

        Behavior on rotation {
          NumberAnimation {
            duration: 500
            easing.type: Easing.Linear
          }
        }
      }
    }

    ColumnLayout {
      // radius: 10
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      // color: Ass.Colors.surface_container_high

      Wid.SessionDots {}
    }
  }
}
