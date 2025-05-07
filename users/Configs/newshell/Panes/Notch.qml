import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../Assets/" as Ass
import "../Animations/" as Anim
import "../Data/" as Dat
import "../Generics/" as Gen

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
        property int expandedWidth: 400
        property int expandedHeight: 28
        property int fullHeight: 140
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
          duration: 150
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
            anchors.fill:parent
            anchors.centerIn: parent
            RowLayout {
              visible: notchRect.height > notchRect.baseHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              Layout.maximumHeight: notchRect.expandedHeight - 10
              Layout.alignment: Qt.AlignHCenter
              Rectangle {
                color: Ass.Colors.primary
                Layout.minimumWidth: timeText.contentWidth + 20
                Layout.fillHeight: true
                radius: 5
                Text {
                  anchors.centerIn: parent
                  id: timeText
                  color: Ass.Colors.on_primary
                  text: Qt.formatDateTime(Dat.Clock.date, "h:mm:ss AP")
                }
                Anim.SmoothIncreaseBehaviour on opacity { duration: 100; easing: Easing.InOutQuad }
                Gen.MouseArea {}
              }
            }

            Rectangle {
              visible: notchRect.height > notchRect.expandedHeight
              Layout.fillWidth: true
              Layout.fillHeight: true
              color: "transparent"
              opacity: ((notchRect.height - notchRect.expandedHeight) / (notchRect.fullHeight - notchRect.expandedHeight))
              Rectangle {
                anchors.fill: parent
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
