pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.SystemTray
import Quickshell

import qs.Data as Dat
import qs.Widgets as Wid

Item {
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 3
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: Dat.Colors.surface_container
      radius: 20

      StackView {
        // visible: false
        id: stack

        anchors.fill: parent

        initialItem: Wid.GreeterWidget {
          height: stack.height
          width: stack.width
        }
        popEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: -100
              property: "y"
            }
          }
        }
        popExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedAccelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
              property: "y"
              to: 100
            }
          }
        }
        pushEnter: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100
              property: "y"
            }
          }
        }
        pushExit: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime
              easing.bezierCurve: Dat.MaterialEasing.emphasized
              from: 1
              property: "opacity"
              to: 0
            }
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "y"
            to: -100
          }
        }
        replaceEnter: Transition {
          ParallelAnimation {
            PropertyAnimation {
              duration: 0
              property: "opacity"
              to: 1
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedDecelTime
              easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
              from: 100
              property: "y"
            }
          }
        }
        replaceExit: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            from: 1
            property: "opacity"
            to: 0
          }
        }

        Component.onCompleted: {
          Dat.Globals.notchStateChanged.connect(() => {
            if (Dat.Globals.notchState != "FULLY_EXPANDED") {
              stack.pop();
            }
          });
        }
      }
    }

    Item {
      Layout.fillWidth: true
      implicitHeight: 20
      visible: SystemTray.items.values.length != 0

      Behavior on implicitHeight {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Item {
          Layout.fillHeight: true
          Layout.fillWidth: true

          ListView {
            id: trayItemRow

            anchors.fill: parent
            orientation: ListView.Horizontal
            snapMode: ListView.SnapToItem
            spacing: 10

            add: Transition {
              SequentialAnimation {
                NumberAnimation {
                  duration: 0
                  property: "opacity"
                  to: 0
                }

                PauseAnimation {
                  duration: addDisAni.duration / 2
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                  from: 0
                  property: "opacity"
                  to: 1
                }
              }
            }
            addDisplaced: Transition {
              SequentialAnimation {
                NumberAnimation {
                  id: addDisAni

                  duration: Dat.MaterialEasing.emphasizedDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                  properties: "x"
                }
              }
            }
            delegate: Wid.TrayItem {
              stackView: stack
            }
            model: ScriptModel {
              values: [...SystemTray.items.values]
            }
            remove: Transition {
              NumberAnimation {
                id: removeAni

                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                from: 1
                property: "opacity"
                to: 0
              }
            }
            removeDisplaced: Transition {
              SequentialAnimation {
                PauseAnimation {
                  duration: removeAni.duration / 2
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                  properties: "x"
                }
              }
            }

            onCountChanged: stack.pop()
          }
        }

        Item {
          Layout.fillHeight: true
          implicitWidth: uptimeText.contentWidth + 10

          Text {
            id: uptimeText

            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            font.pointSize: 10
            text: Dat.Resources.uptime
          }
        }
      }
    }
  }
}
