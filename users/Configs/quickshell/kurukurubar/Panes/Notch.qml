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
      implicitHeight: screen.height * 0.65
      layer: WlrLayer.Top
      namespace: "rexies.notch.quickshell"
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        Region {
          item: notchRect
        }

        Region {
          item: notificationRect
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

            TopBar {
              id: topBar

              Layout.alignment: Qt.AlignTop
              Layout.fillWidth: true
              Layout.maximumHeight: notchRect.expandedHeight
              // makes collapse animation look a tiny bit neater
              Layout.minimumHeight: notchRect.expandedHeight - 10
            }

            ExpandedPane {
              id: expandedPane

              Layout.fillHeight: true
              Layout.fillWidth: true
            }
          }
        }
      }

      Rectangle {
        id: notificationRect

        readonly property int baseHeight: 0
        readonly property int baseWidth: 0
        // readonly property int fullHeight: 300
        readonly property int fullWidth: 500
        readonly property int popupHeight: 100
        readonly property int popupWidth: 430

        anchors.horizontalCenter: notchRect.horizontalCenter
        anchors.top: notchRect.bottom
        anchors.topMargin: 10
        color: Dat.Colors.surface
        radius: 20
        state: Dat.Globals.notifState

        states: [
          State {
            name: "HIDDEN"

            PropertyChanges {
              inboxRect.opacity: 0
              inboxRect.visible: false
              notificationRect.color: "transparent"
              notificationRect.implicitHeight: 0
              notificationRect.implicitWidth: 0
              notificationRect.visible: false
              popupRect.opacity: 0
              popupRect.visible: false
            }
          },
          State {
            name: "POPUP"

            PropertyChanges {
              inboxRect.opacity: 0
              inboxRect.visible: false
              notificationRect.color: Dat.Colors.surface_container
              notificationRect.implicitHeight: notificationRect.popupHeight
              notificationRect.implicitWidth: notificationRect.popupWidth
              notificationRect.visible: true
              popupRect.opacity: 1
              popupRect.visible: true
            }
          },
          State {
            name: "INBOX"

            PropertyChanges {
              inboxRect.opacity: 1
              inboxRect.visible: true
              notificationRect.color: "transparent"
              notificationRect.implicitHeight: (Dat.NotificationServer.notifCount == 0) ? 0 : inboxRect.list.height
              notificationRect.implicitWidth: notificationRect.fullWidth
              notificationRect.visible: true
              popupRect.opacity: 0
              popupRect.visible: false
            }
          }
        ]
        transitions: [
          Transition {
            from: "HIDDEN"
            to: "INBOX"

            SequentialAnimation {
              PropertyAction {
                properties: "visible, implicitWidth"
                targets: [inboxRect, notificationRect]
              }

              ParallelAnimation {
                ColorAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standard
                  property: "color"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "implicitHeight"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "opacity"
                  target: inboxRect
                }
              }
            }
          },
          Transition {
            from: "INBOX"
            to: "HIDDEN"

            SequentialAnimation {
              ParallelAnimation {
                ColorAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime * 3
                  easing.bezierCurve: Dat.MaterialEasing.standard
                  property: "color"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "implicitHeight"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "opacity"
                  target: inboxRect
                }
              }

              PropertyAction {
                properties: "visible, implicitWidth"
                targets: [inboxRect, notificationRect]
              }
            }
          },
          Transition {
            from: "POPUP"
            to: "INBOX"

            ParallelAnimation {
              ColorAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                property: "color"
                target: notificationRect
              }

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                properties: "implicitWidth, implicitHeight"
                target: notificationRect
              }

              PropertyAction {
                property: "opacity"
                target: popupRect
              }

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                property: "opacity"
                target: inboxRect
              }

              PropertyAction {
                property: "visible"
                targets: [popupRect, inboxRect]
              }
            }
          },
          Transition {
            from: "INBOX"
            to: "POPUP"

            ParallelAnimation {
              ColorAnimation {
                // take a lil bit longer to animate this to smoothen the overal effect
                duration: Dat.MaterialEasing.emphasizedTime * 1.5
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                property: "color"
                target: notificationRect
              }

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                properties: "implicitWidth, implicitHeight"
                target: notificationRect
              }

              SequentialAnimation {
                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime / 2
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                  property: "opacity"
                  target: inboxRect
                }

                PropertyAction {
                  property: "visible"
                  targets: [popupRect, inboxRect]
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime / 2
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                  property: "opacity"
                  target: popupRect
                }
              }
            }
          },
          Transition {
            from: "HIDDEN"
            to: "POPUP"

            SequentialAnimation {
              PropertyAction {
                property: "visible"
                targets: [popupRect, notificationRect]
              }

              ParallelAnimation {
                ColorAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standard
                  property: "color"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  properties: "implicitWidth, implicitHeight"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  properties: "opacity"
                  target: popupRect
                }
              }
            }
          },
          Transition {
            from: "POPUP"
            to: "HIDDEN"

            SequentialAnimation {
              ParallelAnimation {
                ColorAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standard
                  property: "color"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  properties: "implicitWidth, implicitHeight"
                  target: notificationRect
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  properties: "opacity"
                  target: popupRect
                }
              }

              PropertyAction {
                property: "visible"
                targets: [popupRect, notificationRect]
              }
            }
          }
        ]

        Component.onCompleted: {
          Dat.Globals.notchStateChanged.connect(() => {
            switch (Dat.Globals.notchState) {
            case "FULLY_EXPANDED":
              Dat.Globals.notifState = "INBOX";
              break;
            default:
              Dat.Globals.notifState = (!popupRect?.closed ?? false) ? "POPUP" : "HIDDEN";
              break;
            }
          });
        }

        ColumnLayout {
          anchors.fill: parent

          PopupPane {
            id: popupRect

            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            radius: notificationRect.radius
          }

          InboxPane {
            id: inboxRect

            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            radius: notificationRect.radius
          }
        }
      }
    }
  }
}
