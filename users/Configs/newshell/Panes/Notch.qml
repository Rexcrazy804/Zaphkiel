import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../Assets/" as Ass
import "../Data/" as Dat

Scope {
  Variants {
    model: Quickshell.screens
    delegate: WlrLayershell {
      id: notch
      required property ShellScreen modelData

      screen: modelData
      layer: WlrLayer.Top
      namespace: "rexies.notch.quickshell"
      anchors.top: true
      anchors.left: true
      anchors.right: true
      height: screen.height * 0.65
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      surfaceFormat.opaque: false
      color: "transparent"
      mask: Region {
        item: notchRect
      }

      Rectangle {
        id: notchRect
        clip: true
        readonly property int baseWidth: 200
        readonly property int baseHeight: 2
        readonly property int expandedWidth: 600
        readonly property int expandedHeight: 28
        readonly property int fullHeight: 170
        readonly property int fullWidth: 600

        state: Dat.Globals.notchState
        states: [
          State {
            name: "COLLAPSED"
            PropertyChanges {
              notchRect.width: notchRect.baseWidth
              notchRect.height: notchRect.baseHeight
            }
          },
          State {
            name: "EXPANDED"
            PropertyChanges {
              notchRect.width: notchRect.expandedWidth
              notchRect.height: notchRect.expandedHeight
            }
          },
          State {
            name: "FULLY_EXPANDED"
            PropertyChanges {
              notchRect.width: notchRect.fullWidth
              notchRect.height: notchRect.fullHeight
            }
          }
        ]

        transitions: [
          Transition {
            reversible: true
            from: "COLLAPSED"
            to: "EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                property: "width"
                duration: 150
                easing.type: Easing.InOutCubic
              }
              NumberAnimation {
                property: "height"
                duration: 180
                easing.type: Easing.Linear
              }
            }
          },
          Transition {
            reversible: true
            from: "EXPANDED"
            to: "FULLY_EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                property: "width"
                duration: 150
                easing.type: Easing.InOutCubic
              }
              NumberAnimation {
                property: "height"
                duration: 100
                easing.type: Easing.Linear
              }
            }
          },
          Transition {
            reversible: true
            from: "COLLAPSED"
            to: "FULLY_EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                property: "width"
                duration: 150
                easing.type: Easing.InOutCubic
              }
              NumberAnimation {
                property: "height"
                duration: 200
                easing.type: Easing.Linear
              }
            }
          }
        ]

        anchors.horizontalCenter: parent.horizontalCenter
        color: Ass.Colors.withAlpha(Ass.Colors.background, 0.89)
        bottomLeftRadius: 20
        bottomRightRadius: 20

        MouseArea {
          id: notchArea
          readonly property real sensitivity: 5
          property real prevY: 0
          property real velocity: 0
          property bool tracing: false

          anchors.fill: parent
          hoverEnabled: true

          onContainsMouseChanged: {
            Dat.Globals.notchHovered = notchArea.containsMouse;
            if (Dat.Globals.notchState == "FULLY_EXPANDED" || Dat.Globals.actWinName == "desktop") {
              return;
            }
            if (notchArea.containsMouse) {
              Dat.Globals.notchState = "EXPANDED";
            } else {
              Dat.Globals.notchState = "COLLAPSED";
            }
          }

          onPressed: mevent => {
            notchArea.tracing = true;
            notchArea.prevY = mevent.y;
            notchArea.velocity = 0;
          }

          onPositionChanged: mevent => {
            if (!tracing) {
              return;
            }
            notchArea.velocity = notchArea.prevY - mevent.y;
            notchArea.prevY = mevent.y;

            // swipe down behaviour
            if (velocity < -notchArea.sensitivity) {
              Dat.Globals.notchState = "FULLY_EXPANDED";
              notchArea.tracing = false;
              notchArea.velocity = 0;
            }

            // swipe up behaviour
            if (velocity > notchArea.sensitivity) {
              Dat.Globals.notchState = "EXPANDED";
              notchArea.tracing = false;
              notchArea.velocity = 0;
            }
          }

          onReleased: mevent => {
            notchArea.tracing = false;
            notchArea.velocity = 0;
          }

          ColumnLayout {
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: 0

            TopBar {
              opacity: (notchRect.width - notchRect.baseWidth) / (notchRect.expandedWidth - notchRect.baseWidth)
              visible: notchRect.height > notchRect.baseHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              Layout.maximumHeight: notchRect.expandedHeight
              Layout.fillWidth: true
            }

            ClippingRectangle {
              // Full Expand Card
              visible: notchRect.height > notchRect.expandedHeight
              opacity: ((notchRect.height - notchRect.expandedHeight) / (notchRect.fullHeight - notchRect.expandedHeight))
              Layout.fillWidth: true
              Layout.fillHeight: true
              clip: true
              radius: 20
              color: "transparent"

              RowLayout {
                anchors.fill: parent
                Rectangle {
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  Layout.preferredWidth: 2
                  color: "transparent"
                }
                Rectangle {
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  Layout.preferredWidth: 3
                  radius: 20

                  color: Ass.Colors.withAlpha(Ass.Colors.surface, 0.8)
                  RowLayout {
                    anchors.fill: parent
                    Rectangle {
                      Layout.fillWidth: true
                      Layout.fillHeight: true
                      Layout.preferredWidth: 1.45
                      color: "transparent"
                      Text {
                        color: Ass.Colors.secondary
                        anchors.centerIn: parent
                        text: " Kuru Kuru Kuru Kuru"
                      }
                    }
                    AnimatedImage {
                      playing: parent.visible
                      Layout.fillWidth: true
                      Layout.fillHeight: true
                      Layout.preferredWidth: 1

                      fillMode: Image.PreserveAspectCrop
                      horizontalAlignment: Image.AlignRight
                      source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
