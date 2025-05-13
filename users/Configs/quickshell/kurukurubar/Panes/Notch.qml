import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../Data/" as Dat

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: notch

      required property ShellScreen modelData

      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      height: screen.height * 0.65
      layer: WlrLayer.Top
      namespace: "rexies.notch.quickshell"
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        item: notchRect
      }

      Rectangle {
        id: notchRect

        readonly property int baseHeight: 1
        readonly property int baseWidth: 200
        readonly property int expandedHeight: 28
        readonly property int expandedWidth: 700
        readonly property int fullHeight: 190
        readonly property int fullWidth: this.expandedWidth

        anchors.horizontalCenter: parent.horizontalCenter
        bottomLeftRadius: 20
        bottomRightRadius: 20
        clip: true
        color: Dat.Colors.withAlpha(Dat.Colors.background, (Dat.Globals.actWinName == "desktop" && Dat.Globals.notchState != "FULLY_EXPANDED") ? 0.79 : 0.89)
        state: Dat.Globals.notchState

        Behavior on color {
          ColorAnimation {
            duration: Dat.MaterialEasing.standardTime
          }
        }
        states: [
          State {
            name: "COLLAPSED"

            PropertyChanges {
              notchRect.height: notchRect.baseHeight
              notchRect.width: notchRect.baseWidth
            }
          },
          State {
            name: "EXPANDED"

            PropertyChanges {
              notchRect.height: notchRect.expandedHeight
              notchRect.width: notchRect.expandedWidth
            }
          },
          State {
            name: "FULLY_EXPANDED"

            PropertyChanges {
              notchRect.height: notchRect.fullHeight
              notchRect.width: notchRect.fullWidth
            }
          }
        ]
        transitions: [
          Transition {
            from: "COLLAPSED"
            to: "EXPANDED"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              properties: "width, height"
            }
          },
          Transition {
            from: "EXPANDED"
            to: "COLLAPSED"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              properties: "width, height"
            }
          },
          Transition {
            from: "EXPANDED"
            reversible: true
            to: "FULLY_EXPANDED"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              properties: "width, height"
            }
          },
          Transition {
            from: "COLLAPSED"
            to: "FULLY_EXPANDED"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              properties: "width, height"
            }
          },
          Transition {
            from: "COLLAPSED"
            to: "FULLY_EXPANDED"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              properties: "width, height"
            }
          }
        ]

        // prolly make this a generic later
        MouseArea {
          id: notchArea

          property real prevY: 0
          readonly property real sensitivity: 5
          property bool tracing: false
          property real velocity: 0

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
          onPressed: mevent => {
            notchArea.tracing = true;
            notchArea.prevY = mevent.y;
            notchArea.velocity = 0;
          }
          onReleased: mevent => {
            notchArea.tracing = false;
            notchArea.velocity = 0;
          }

          ColumnLayout {
            anchors.centerIn: parent
            anchors.fill: parent
            spacing: 0

            TopBar {
              Layout.fillWidth: true
              Layout.maximumHeight: notchRect.expandedHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              opacity: (notchRect.width - notchRect.baseWidth) / (notchRect.expandedWidth - notchRect.baseWidth)
              visible: notchRect.height > notchRect.baseHeight
            }
            ExpandedPane {
              Layout.fillHeight: true
              Layout.fillWidth: true
              opacity: ((notchRect.height - notchRect.expandedHeight) / (notchRect.fullHeight - notchRect.expandedHeight))
              visible: notchRect.height > notchRect.expandedHeight
            }
          }
        }
      }
    }
  }
}
