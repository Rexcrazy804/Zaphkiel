pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

Rectangle {
  id: root

  property int index: SwipeView.index
  property bool isCurrent: SwipeView.isCurrentItem

  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10
    anchors.rightMargin: 5
    spacing: 5

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: Dat.Colors.surface_container_high
      radius: 10

      Image {
        id: nixLogo

        fillMode: Image.PreserveAspectCrop
        height: this.width
        layer.enabled: true
        opacity: 0.9
        rotation: 0
        source: Dat.Paths.getPath(this, "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/logo/nix-snowflake-white.svg")
        width: parent.height
        x: -(this.width / 2.5)

        layer.effect: MultiEffect {
          colorization: 1
          colorizationColor: Dat.Colors.secondary
        }
        Behavior on rotation {
          NumberAnimation {
            duration: 500
            easing.type: Easing.Linear
          }
        }

        Timer {
          interval: 500
          repeat: true
          running: Dat.Globals.notchState == "FULLY_EXPANDED" && root.isCurrent
          triggeredOnStart: true

          onTriggered: parent.rotation = (parent.rotation + 3) % 360
        }
      }

      ColumnLayout { // area to the right of the image
        id: rightArea

        anchors.bottom: parent.bottom
        anchors.left: nixLogo.right
        // radius: 10
        anchors.margins: 10
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.top: parent.top

        Rectangle {
          id: monitorRect

          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          color: Dat.Colors.surface_container
          radius: 10

          RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Item {
              Layout.bottomMargin: this.Layout.topMargin
              Layout.fillHeight: true
              Layout.fillWidth: true
              Layout.topMargin: 20

              Text {
                id: hyprIcon

                anchors.fill: parent
                color: Dat.Colors.primary
                font.pointSize: 32 * Dat.Globals.notchScale
                horizontalAlignment: Text.AlignHCenter
                text: ""
                verticalAlignment: Text.AlignVCenter
              }
            }

            Item {
              Layout.fillWidth: true
              implicitHeight: this.width

              GridLayout {
                anchors.fill: parent
                columns: 3
                rows: 3

                Repeater {
                  model: 9

                  Rectangle {
                    required property int index

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: (Hyprland.focusedWorkspace?.id == this.index + 1) ? Dat.Colors.primary : Dat.Colors.surface_container_high
                    radius: this.width

                    Gen.MouseArea {
                      layerColor: Dat.Colors.primary

                      onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                    }
                  }
                }
              }
            }
          }
        }

        Rectangle {
          // no longer system tray, its gonna be the base of a monitor
          Layout.alignment: Qt.AlignCenter
          antialiasing: true
          // color: "transparent"
          color: Dat.Colors.outline
          implicitHeight: 10 * Dat.Globals.notchScale
          implicitWidth: 80 * Dat.Globals.notchScale
          radius: 10
        }
      }
    }

    Item {
      Layout.fillHeight: true
      implicitWidth: 30 * Dat.Globals.notchScale

      ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width

        Wid.SessionDots {
        }
      }
    }
  }
}
