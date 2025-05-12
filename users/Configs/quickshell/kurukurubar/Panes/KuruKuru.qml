import QtQuick
// import QtMultimedia
import QtQuick.Layouts

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
      RowLayout {
        anchors.fill: parent
        spacing: 10
        Text {
          id: muteIcon
          property bool muted: false

          Layout.leftMargin: 10
          Layout.fillWidth: true
          Layout.fillHeight: true
          horizontalAlignment: Text.AlignRight
          verticalAlignment: Text.AlignVCenter

          color: Dat.Colors.on_surface
          text: (muted) ? "󰖁" : "󰕾"

          MouseArea {
            anchors.fill: parent
            onClicked: parent.muted = !parent.muted
          }
        }
        Text {
          id: kuruText
          Layout.fillWidth: true
          Layout.fillHeight: true
          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter
          color: Dat.Colors.on_surface
          text: "くるくる～――っと。"
        }
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
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton
          onPressedChanged: {
            squishRect.state = (squishRect.state == "SQUISH") ? "NOSQUISH" : "SQUISH";

            if (muteIcon.muted) { return }
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
