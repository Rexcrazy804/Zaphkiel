import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat

Rectangle {
  color: "transparent"

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
        text: " Kuru Kuru Kuru"
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      Rectangle { // the hando that squishes the kuru kuru
        id: squishRect
        Layout.fillWidth: true
        implicitHeight: 0
        color: "transparent"

        state: "NOSQUISH"

        states: [
          State {
            name: "NOSQUISH"
            PropertyChanges {
              squishRect.implicitHeight: 0
            }
          },
          State {
            name: "SQUISH"
            PropertyChanges {
              squishRect.implicitHeight: 40
            }
          }
        ]

        transitions: [
          Transition {
            from: "NOSQUISH"
            to: "SQUISH"

            NumberAnimation {
              property: "implicitHeight"
              duration: 100
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
            }
          },
          Transition {
            from: "SQUISH"
            to: "NOSQUISH"

            NumberAnimation {
              property: "implicitHeight"
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
            }
          }
        ]
      }

      AnimatedImage {
        Layout.fillWidth: true
        Layout.fillHeight: true
        playing: true
        speed: 0.8

        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignRight
        source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"

        Component.onCompleted: {
          Dat.Globals.notchStateChanged.connect(() => {
            if (Dat.Globals.notchState == "FULLY_EXPANDED") {
              playing = true;
            }
          });
        }

        Timer {
          running: Dat.Globals.notchState != "FULLY_EXPANDED" && parent.playing == true
          interval: 500
          onTriggered: {
            parent.playing = false;
          }
        }

        Timer {
          id: squisher
          running: squishRect.state == "SQUISH"
          interval: 50
          repeat: true
          onTriggered: parent.speed += 0.1
        }

        Timer {
          id: stoptheKuruKuru
          running: squishRect.state != "SQUISH" && parent.speed > 0.8
          interval: 50
          repeat: true
          onTriggered:parent.speed -= 0.05
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton
          onPressedChanged: {
            squishRect.state = (squishRect.state == "SQUISH")? "NOSQUISH" : "SQUISH"
          }
        }
      }
    }
  }
}
