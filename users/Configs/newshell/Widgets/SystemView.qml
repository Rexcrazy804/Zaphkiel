pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

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
      color: Dat.Colors.surface_container_high

      Image {
        id: nixLogo
        x: -(this.width / 2.5)
        rotation: 0
        opacity: 0.15
        width: parent.height
        height: this.width
        fillMode: Image.PreserveAspectCrop
        source: "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/logo/nix-snowflake-white.svg"

        Component.onCompleted: {
          // silly hack to not have a 500ms delay before animation starts
          Dat.Globals.notchStateChanged.connect(() => {
            nixLogo.rotation += 3;
          });
          root.isCurrentChanged.connect(() => {
            nixLogo.rotation += 3;
          });
        }

        Timer {
          interval: 500
          running: Dat.Globals.notchState == "FULLY_EXPANDED" && root.isCurrent
          repeat: true
          onTriggered: parent.rotation = (parent.rotation + 3) % 360
        }

        Behavior on rotation {
          NumberAnimation {
            duration: 500
            easing.type: Easing.Linear
          }
        }
      }

      ColumnLayout { // area to the right of the image
        id: rightArea
        // radius: 10
        anchors.margins: 10
        anchors.rightMargin: 11
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 150

        Rectangle {
          // TODO fill this with resource monitor data
          clip: true
          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 10
          color: Dat.Colors.surface_container
        }

        Rectangle {
          // no longer system tray, its gonna be the base of a monitor
          Layout.alignment: Qt.AlignCenter
          implicitWidth: 80
          implicitHeight: 10
          radius: 10
          // color: "transparent"
          color: Dat.Colors.outline
          antialiasing: true
        }
      }
    }

    ColumnLayout {
      // radius: 10
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      // color: Dat.Colors.surface_container_high

      Wid.SessionDots {}
    }
  }
}
