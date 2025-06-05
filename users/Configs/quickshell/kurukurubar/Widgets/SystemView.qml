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
  property real scaleFactor: Dat.Globals.scaleFactor

  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10 * scaleFactor
    anchors.rightMargin: 5 * scaleFactor
    spacing: 5 * scaleFactor

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 5 * scaleFactor
      clip: true
      color: Dat.Colors.surface_container_high
      radius: 10 * scaleFactor

      Image {
        id: nixLogo

        fillMode: Image.PreserveAspectCrop
        height: width
        width: parent.height
        opacity: 0.9
        rotation: 0
        x: -(width / 2.5)
        source: "https://raw.githubusercontent.com/NixOS/nixos-artwork/4ad062cee62116f6055e2876e9638e7bb399d219/logo/nix-snowflake-white.svg"

        layer.enabled: true
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
          onTriggered: nixLogo.rotation = (nixLogo.rotation + 3) % 360
        }
      }

      ColumnLayout {
        id: rightArea

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10 * scaleFactor
        anchors.rightMargin: 11 * scaleFactor
        width: 150 * scaleFactor

        Rectangle {
          id: monitorRect

          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          color: Dat.Colors.surface_container
          radius: 10 * scaleFactor

          RowLayout {
            anchors.fill: parent
            anchors.margins: 10 * scaleFactor

            Text {
              id: hyprIcon

              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.topMargin: 20 * scaleFactor
              Layout.bottomMargin: 20 * scaleFactor
              color: Dat.Colors.primary
              font.pointSize: 32 * scaleFactor
              text: ""
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
            }

            GridLayout {
              columns: 3
              rows: 3
              implicitWidth: 60 * scaleFactor
              implicitHeight: 60 * scaleFactor

              Repeater {
                model: 9

                Rectangle {
                  required property int index

                  width: 18 * scaleFactor
                  height: 18 * scaleFactor
                  radius: 9 * scaleFactor
                  color: (Hyprland.focusedWorkspace?.id == index + 1)
                         ? Dat.Colors.primary
                         : Dat.Colors.surface_container_high

                  Gen.MouseArea {
                    layerColor: Dat.Colors.primary
                    layerRadius: 9 * scaleFactor
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                  }
                }
              }
            }
          }
        }

        Rectangle {
          Layout.alignment: Qt.AlignCenter
          antialiasing: true
          color: Dat.Colors.outline
          implicitWidth: 80 * scaleFactor
          implicitHeight: 10 * scaleFactor
          radius: 10 * scaleFactor
        }
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1

      Wid.SessionDots { }
    }
  }
}
