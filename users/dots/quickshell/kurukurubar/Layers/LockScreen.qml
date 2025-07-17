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

      property bool error: false
      property string inputBuffer: ""

      Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        source: Dat.Config.data.wallSrc

        layer.effect: MultiEffect {
          autoPaddingEnabled: false
          blur: 0.69
          blurEnabled: true
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
        // Don't show the fg if fg is being generated
        visible: !Dat.Config.fgGenProc.running
        anchors.fill: parent
        antialiasing: true
        mipmap: true
        smooth: true
        source: Dat.Config.wallFg
        fillMode: Image.PreserveAspectCrop
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
            lock.locked = false;
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
