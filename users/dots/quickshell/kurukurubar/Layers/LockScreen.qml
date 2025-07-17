// heavily referenced soramane's lockscreen code
// https://github.com/caelestia-dots/shell/tree/main/modules/lock

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pam
import QtQuick.Effects
import Quickshell.Wayland
import Quickshell
import Quickshell.Io

import "../Data" as Dat
import "../Generics" as Gen

Scope {
  WlSessionLock {
    id: lock

    WlSessionLockSurface {
      id: surface

      property bool active: false
      property bool error: false
      property string inputBuffer: ""

      Image {
        id: wallpaper

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        source: Dat.Config.data.wallSrc

        layer.effect: MultiEffect {
          autoPaddingEnabled: false
          blur: (!surface.active) ? 0.69 : 0
          blurEnabled: true

          Behavior on blur {
            NumberAnimation {
              duration: Dat.MaterialEasing.emphasizedTime * 1.6
              easing.type: Easing.Linear
            }
          }
        }
      }

      Text {
        property list<string> kokomi: ["k", "o", "k", "o", "m", "i"]

        anchors.centerIn: parent
        color: (surface.error) ? Dat.Colors.error : Dat.Colors.tertiary
        font.bold: true
        font.family: "Libre Barcode 128"
        font.pointSize: 400
        renderType: Text.NativeRendering
        text: surface.inputBuffer.split('').map(x => {
          const index = Math.floor(Math.random() * 6);
          return kokomi[index];
        }).sort(function () {
          return 0.5 - Math.random();
        }).join('')
      }

      Image {
        anchors.fill: parent
        antialiasing: true
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        smooth: true
        source: Dat.Config.wallFg
        // Don't show the fg if fg is being generated
        visible: !Dat.Config.fgGenProc.running
      }

      Rectangle {
        id: inputRect

        anchors.centerIn: parent
        clip: true
        color: (surface.error) ? Dat.Colors.error : Dat.Colors.surface
        focus: true
        height: 40
        radius: 20
        width: inputRow.width

        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        Behavior on width {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime
            easing.bezierCurve: Dat.MaterialEasing.emphasized
          }
        }

        Keys.onPressed: kevent => {
          if (pam.active) {
            return;
          }

          if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
            pam.start();
            return;
          }

          if (kevent.key === Qt.Key_Backspace) {
            if (kevent.modifiers & Qt.ControlModifier) {
              surface.inputBuffer = "";
              return;
            }
            surface.inputBuffer = surface.inputBuffer.slice(0, -1);
            return;
          }
          surface.inputBuffer += kevent.text;
        }

        Item {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.top: parent.top
          implicitWidth: inputRect.height

          Gen.MatIcon {
            id: lockIcon

            anchors.centerIn: parent
            antialiasing: true
            color: (surface.error) ? Dat.Colors.on_error : Dat.Colors.on_surface
            fill: pam.active
            font.pointSize: 16
            icon: "lock"

            Behavior on color {
              ColorAnimation {
                duration: 200
              }
            }
            Behavior on rotation {
              NumberAnimation {
                duration: lockRotatetimer.interval
                easing.type: Easing.Linear
              }
            }
          }

          Timer {
            id: lockRotatetimer

            interval: 500
            repeat: true
            running: pam.active
            triggeredOnStart: true

            onRunningChanged: lockIcon.rotation = 0
            onTriggered: lockIcon.rotation += 50
          }
        }

        RowLayout {
          id: inputRow

          anchors.centerIn: parent
          height: parent.height
          spacing: 0

          Item {
            implicitHeight: inputRect.height
            implicitWidth: inputRect.height
          }

          Item {
            implicitWidth: pamText.contentWidth + 18
            visible: pamText.text != ""

            Text {
              id: pamText

              anchors.centerIn: parent
              color: (surface.error) ? Dat.Colors.on_error : Dat.Colors.on_surface
              text: pam.message
            }
          }
        }
      }

      PamContext {
        id: pam

        onCompleted: res => {
          if (res === PamResult.Success) {
            surface.active = true;
            return;
          }

          surface.error = true;
          revertColors.running = true;
        }
        onResponseRequiredChanged: {
          if (!responseRequired)
            return;

          respond(surface.inputBuffer);
          surface.inputBuffer = "";
        }
      }

      Timer {
        id: revertColors

        interval: 2000

        onTriggered: surface.error = false
      }

      Timer {
        id: unlockTimer

        interval: Dat.MaterialEasing.emphasizedTime * 1.5
        running: surface.active

        onTriggered: lock.locked = false
      }

      // debugging only
      // Item {
      //   height: 10
      //   width: 10
      //
      //   MouseArea {
      //     anchors.fill: parent
      //     hoverEnabled: true
      //
      //     onEntered: lock.locked = false
      //   }
      // }
    }
  }

  IpcHandler {
    function lock() {
      lock.locked = true;
    }

    function unlock() {
      lock.locked = false;
    }

    target: "lockscreen"
  }
}
