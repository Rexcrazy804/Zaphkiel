import QtQuick
import QtQuick.Effects
import "../Data/" as Dat
import "../Widgets/" as Wid

Item {
  id: root

  state: Dat.Globals.bgState

  states: [
    State {
      name: "SHRUNK"

      AnchorChanges {
        anchors.left: root.left
        target: base
      }

      PropertyChanges {
        base.opacity: 1
        base.visible: true
      }
    },
    State {
      name: "FILLED"

      AnchorChanges {
        anchors.right: root.left
        target: base
      }

      PropertyChanges {
        base.opacity: 0
        base.visible: false
      }
    }
  ]
  transitions: [
    Transition {
      from: "FILLED"
      to: "SHRUNK"

      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: base
        }

        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.5
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            property: "opacity"
            target: base
          }

          AnchorAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.5
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            targets: [base]
          }
        }
      }
    },
    Transition {
      from: "SHRUNK"
      to: "FILLED"

      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "opacity"
            target: base
          }

          AnchorAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            targets: [base]
          }
        }

        PropertyAction {
          property: "visible"
          target: base
        }
      }
    }
  ]

  Item {
    id: base

    anchors.bottom: parent.bottom
    anchors.top: parent.top
    width: root.width

    Wid.Clock {
      id: clock

      anchors.fill: parent
      color: Dat.Colors.surface_container
      radius: 20
    }

    Image {
      id: loversIcon

      property real margin: 10

      anchors.bottom: parent.bottom
      anchors.bottomMargin: margin
      anchors.left: parent.left
      anchors.leftMargin: margin
      antialiasing: true
      fillMode: Image.PreserveAspectCrop
      mipmap: true
      source: "../Assets/9151461.png"
      sourceClipRect: Qt.rect(1550, 230, 2200, 2200)
      state: "EXPANDED"
      visible: false

      states: [
        State {
          name: "EXPANDED"

          PropertyChanges {
            clock.visible: false
            effect.opacity: 1
            loversIcon.height: root.height
            loversIcon.margin: 0
            loversIcon.width: root.width
          }
        },
        State {
          name: "MINIMIZED"

          PropertyChanges {
            clock.visible: true
            effect.opacity: 0.9
            loversIcon.height: root.height / 4
            loversIcon.margin: 10
            loversIcon.width: root.width / 4
          }
        }
      ]
      transitions: [
        Transition {
          from: "EXPANDED"
          to: "MINIMIZED"

          SequentialAnimation {
            PropertyAction {
              property: "visible"
              target: clock
            }

            ParallelAnimation {
              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime * 1.5
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                properties: "width, height, margin"
                target: loversIcon
              }

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime * 1.5
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                property: "opacity"
                target: effect
              }
            }
          }
        },
        Transition {
          from: "MINIMIZED"
          to: "EXPANDED"

          SequentialAnimation {
            ParallelAnimation {
              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                properties: "width, height, margin"
                target: loversIcon
              }

              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime * 1.5
                easing.bezierCurve: Dat.MaterialEasing.emphasized
                property: "opacity"
                target: effect
              }
            }

            PropertyAction {
              property: "visible"
              target: clock
            }
          }
        }
      ]

      Connections {
        function onBgStateChanged() {
          if (Dat.Globals.bgState == "FILLED") {
            loversIcon.state = "EXPANDED";
          }
        }

        target: Dat.Globals
      }
    }

    MultiEffect {
      id: effect

      anchors.fill: loversIcon
      antialiasing: true
      maskEnabled: true
      maskSource: loversIconMask
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5
      source: loversIcon
    }

    Item {
      id: loversIconMask

      height: loversIcon.height
      layer.enabled: true
      layer.smooth: true
      visible: false
      width: loversIcon.width

      Rectangle {
        anchors.fill: parent
        height: this.width
        radius: 20
      }
    }

    MouseArea {
      anchors.fill: loversIcon

      onClicked: loversIcon.state = (loversIcon.state == "EXPANDED") ? "MINIMIZED" : "EXPANDED"
    }
  }
}
