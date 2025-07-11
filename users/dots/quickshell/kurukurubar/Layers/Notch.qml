import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../Data/" as Dat
import "../Containers/" as Con

WlrLayershell {
  id: notch

  required property ShellScreen modelData

  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  anchors.top: true
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  focusable: false
  layer: WlrLayer.Top
  namespace: "rexies.notch.quickshell"
  screen: modelData
  surfaceFormat.opaque: false

  mask: Region {
    Region {
      item: notchRect
    }

    Region {
      item: inboxRect.contentItem
    }
  }

  Rectangle {
    id: notchRect

    readonly property int baseHeight: 1
    readonly property int baseWidth: 200 * notchScale
    readonly property int expandedHeight: 28
    readonly property int expandedWidth: 700 * notchScale
    readonly property int fullHeight: 190 * notchScale
    readonly property int fullWidth: this.expandedWidth
    property real notchScale: Dat.Globals.notchScale

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
          expandedPane.opacity: 0
          expandedPane.visible: false
          notchRect.height: notchRect.baseHeight
          notchRect.opacity: 0
          notchRect.width: notchRect.baseWidth
          topBar.opacity: 0
          topBar.visible: false
        }
      },
      State {
        name: "EXPANDED"

        PropertyChanges {
          expandedPane.opacity: 0
          expandedPane.visible: false
          notchRect.height: notchRect.expandedHeight
          notchRect.opacity: 1
          notchRect.width: notchRect.expandedWidth
          topBar.opacity: 1
          topBar.visible: true
        }
      },
      State {
        name: "FULLY_EXPANDED"

        PropertyChanges {
          expandedPane.opacity: 1
          expandedPane.visible: true
          notchRect.height: notchRect.fullHeight
          notchRect.opacity: 1
          notchRect.width: notchRect.fullWidth
          topBar.opacity: 1
          topBar.visible: true
        }
      }
    ]
    transitions: [
      Transition {
        from: "COLLAPSED"
        to: "EXPANDED"

        SequentialAnimation {
          PropertyAction {
            property: "visible"
            target: topBar
          }

          PropertyAction {
            property: "opacity"
            target: notchRect
          }

          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime * 2
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "opacity"
              target: topBar
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              properties: "width, opacity, height"
              target: notchRect
            }
          }
        }
      },
      Transition {
        from: "EXPANDED"
        to: "COLLAPSED"

        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              properties: "width, height"
              target: notchRect
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.standardAccelTime
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              property: "opacity"
              target: topBar
            }
          }

          PropertyAction {
            property: "visible"
            target: topBar
          }

          PropertyAction {
            property: "opacity"
            target: notchRect
          }
        }
      },
      Transition {
        from: "EXPANDED"
        to: "FULLY_EXPANDED"

        SequentialAnimation {
          PropertyAction {
            property: "visible"
            target: expandedPane
          }

          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              property: "height"
              target: notchRect
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime * 3
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "opacity"
              target: expandedPane
            }
          }
        }
      },
      Transition {
        id: fExpToExpTS

        from: "FULLY_EXPANDED"
        to: "EXPANDED"

        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "height"
              target: notchRect
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "opacity"
              target: expandedPane
            }
          }

          PropertyAction {
            property: "visible"
            target: expandedPane
          }
        }
      },
      // sometimes due to the will of kuru kuru this happens
      // so just make sure it isn't very jagged
      Transition {
        from: "COLLAPSED"
        reversible: true
        to: "FULLY_EXPANDED"

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          properties: "height, opacity, width"
          target: notchRect
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

      function revealOrCollapse() {
        // crucial for issue #37
        // basically Do not attempt to change the notchState when the
        // FULLY_EXPANDED to COLLAPSED transition is running this function
        // is called both when containsMouse changes as well as when the
        // aforementioned transition starts and stops running
        if (fExpToExpTS.running) {
          return;
        }

        if (Dat.Globals.notchState == "FULLY_EXPANDED" || Dat.Globals.actWinName == "desktop" || Dat.Config.data.reservedShell) {
          return;
        }

        if (notchArea.containsMouse) {
          Dat.Globals.notchState = "EXPANDED";
        } else {
          Dat.Globals.notchState = "COLLAPSED";
        }
      }

      anchors.fill: parent
      hoverEnabled: true

      Component.onCompleted: fExpToExpTS.runningChanged.connect(notchArea.revealOrCollapse)
      onContainsMouseChanged: {
        Dat.Globals.notchHovered = notchArea.containsMouse;
        notchArea.revealOrCollapse();
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

        Con.TopBar {
          id: topBar

          Layout.alignment: Qt.AlignTop
          Layout.fillWidth: true
          Layout.maximumHeight: notchRect.expandedHeight
          // makes collapse animation look a tiny bit neater
          Layout.minimumHeight: notchRect.expandedHeight - 10
        }

        Con.Primary {
          id: expandedPane

          Layout.fillHeight: true
          Layout.fillWidth: true
        }
      }
    }
  }

  Item {
    id: notificationRect

    readonly property int baseHeight: 0
    readonly property int baseWidth: 0

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: notchRect.bottom
    anchors.topMargin: 10
    height: 500
    state: (Dat.Globals.notchState == "FULLY_EXPANDED") ? "INBOX" : "POPUP"

    onStateChanged: {
      if (state == "INBOX") {
        inboxRect.visible = true;
      } else {
        inboxRect.visible = popupHideTimer.running;
      }
    }

    Connections {
      function onNotification(e) {
        if (popupHideTimer.running) {
          popupHideTimer.restart();
          return;
        }
        popupHideTimer.running = true;
        inboxRect.visible = true;
      }

      target: Dat.NotifServer.server
    }

    Con.Inbox {
      id: inboxRect

      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      model: (notificationRect.state == "INBOX") ? Dat.NotifServer.notifications : Dat.NotifServer.lastNotif
      width: 500
    }

    Timer {
      id: popupHideTimer

      interval: 3000

      onTriggered: {
        if (notificationRect.state == "POPUP") {
          inboxRect.visible = false;
        }
      }
    }
  }
}
