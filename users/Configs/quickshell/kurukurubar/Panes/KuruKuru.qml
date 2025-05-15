import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat

Rectangle {
  color: "transparent"

  RowLayout {
    anchors.fill: parent

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1.45
      color: "transparent"

      RowLayout {
        anchors.fill: parent
        spacing: 10

        Text {
          id: muteIcon

          property bool muted: false

          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.leftMargin: 10
          color: Dat.Colors.on_surface
          horizontalAlignment: Text.AlignRight
          text: (muted) ? "󰖁" : "󰕾"
          verticalAlignment: Text.AlignVCenter

          MouseArea {
            anchors.fill: parent

            onClicked: parent.muted = !parent.muted
          }
        }

        Text {
          id: kuruText

          Layout.fillHeight: true
          Layout.fillWidth: true
          color: Dat.Colors.on_surface
          horizontalAlignment: Text.AlignLeft
          text: "くるくる～――っと。"
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1

      Rectangle { // the hando that squishes the kuru kuru
        id: squishRect

        Layout.fillWidth: true
        color: "transparent"
        implicitHeight: 0
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
              duration: 100
              easing.bezierCurve: Dat.MaterialEasing.standardAccel
              property: "implicitHeight"
            }
          },
          Transition {
            from: "SQUISH"
            to: "NOSQUISH"

            NumberAnimation {
              duration: Dat.MaterialEasing.standardDecelTime
              easing.bezierCurve: Dat.MaterialEasing.standardDecel
              property: "implicitHeight"
            }
          }
        ]
      }

      AnimatedImage {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.rightMargin: 8
        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignRight
        playing: true
        source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
        speed: 0.8

        Component.onCompleted: {
          Dat.Globals.notchStateChanged.connect(() => {
            if (Dat.Globals.notchState == "FULLY_EXPANDED") {
              playing = true;
            }
          });
        }

        Timer {
          interval: 500
          running: Dat.Globals.notchState != "FULLY_EXPANDED" && parent.playing == true

          onTriggered: {
            parent.playing = false;
          }
        }

        Timer {
          id: squisher

          interval: 50
          repeat: true
          running: squishRect.state == "SQUISH"

          onTriggered: parent.speed += 0.1
        }

        Timer {
          id: stoptheKuruKuru

          interval: 50
          repeat: true
          running: squishRect.state != "SQUISH" && parent.speed > 0.8

          onTriggered: parent.speed -= 0.05
        }

        // Video {
        //   id: kururin
        //   source: "https://static.wikia.nocookie.net/houkai-star-rail/images/e/e4/VO_JA_Herta_Talent_02.ogg/revision/latest?cb=20230616201845"
        //   muted: muteIcon.muted
        // }
        // Video {
        //   id: kurukuru
        //   source: "https://static.wikia.nocookie.net/houkai-star-rail/images/1/11/VO_JA_Herta_Talent_01.ogg/revision/latest?cb=20230616201843"
        //   muted: muteIcon.muted
        // }

        MouseArea {
          acceptedButtons: Qt.LeftButton
          anchors.fill: parent

          onPressedChanged: {
            squishRect.state = (squishRect.state == "SQUISH") ? "NOSQUISH" : "SQUISH";

            if (muteIcon.muted) {
              return;
            }
            if (Math.round((Math.random() * 10)) % 2 == 0) {
              // kurukuru.play();
              kuruText.text = "くるくる～――っと。";
            } else {
              // kururin.play();
              kuruText.text = "くるりん～っと。";
            }
          }
        }
      }
    }
  }
}
