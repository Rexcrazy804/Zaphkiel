import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../Assets/" as Ass
import "../Animations/" as Anim

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
        property int baseWidth: 200
        property int baseHeight: 2
        property int expandedWidth: 500
        property int expandedHeight: 28
        property int fullHeight: 200
        property bool revealed: false

        width: notchRect.baseWidth
        height: notchRect.baseHeight

        anchors.horizontalCenter: parent.horizontalCenter
        color: Ass.Colors.withAlpha(Ass.Colors.background, 0.89)
        bottomLeftRadius: 20
        bottomRightRadius: 20

        Anim.SmoothIncreaseBehaviour on width {
          duration: 150
          easing: Easing.InOutCubic
        }
        Anim.SmoothIncreaseBehaviour on height {
          duration: 180
          easing: Easing.Linear
        }

        MouseArea {
          id: notchArea
          readonly property real sensitivity: 5
          property real prevY: 0
          property real velocity: 0
          property bool tracing: false

          anchors.fill: parent
          hoverEnabled: true

          onEntered: {
            if (notchRect.revealed) {
              return;
            }
            notchRect.width = notchRect.expandedWidth;
            notchRect.height = notchRect.expandedHeight;
          }
          onExited: {
            if (notchRect.revealed) {
              return;
            }
            notchRect.width = notchRect.baseWidth;
            notchRect.height = notchRect.baseHeight;
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
              notchRect.width = notchRect.expandedWidth;
              notchRect.height = notchRect.fullHeight;
              notchRect.revealed = true;
              notchArea.tracing = false;
              notchArea.velocity = 0;
            }

            // swipe up behaviour
            if (velocity > notchArea.sensitivity) {
              notchRect.height = notchRect.expandedHeight;
              notchArea.tracing = false;
              notchRect.revealed = false;
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
              opacity: notchRect.height / notchRect.expandedHeight
              visible: notchRect.height > notchRect.baseHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              Layout.maximumHeight: notchRect.expandedHeight
              Layout.fillWidth: true
            }

            Rectangle { // Full Expand Contents
              visible: notchRect.height > notchRect.expandedHeight
              opacity: ((notchRect.height - notchRect.expandedHeight) / (notchRect.fullHeight - notchRect.expandedHeight))
              Layout.fillWidth: true
              Layout.fillHeight: true
              clip:true
              radius: 20
              color: Ass.Colors.surface

              RowLayout {
                anchors.fill: parent
                AnimatedImage {
                  playing: parent.visible
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  Layout.preferredWidth: 1

                  fillMode: Image.PreserveAspectCrop
                  horizontalAlignment: Image.AlignRight
                  source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
                }
                Rectangle {
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  Layout.preferredWidth: 1.6
                  color: "transparent"
                  Text {
                    color: Ass.Colors.primary
                    anchors.centerIn: parent
                    text: "Kuru Kuru Kuru Kuru"
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
