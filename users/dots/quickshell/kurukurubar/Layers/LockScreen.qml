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
      property list<string> kokomi: ["k", "o", "k", "o", "m", "i"]
      property string maskedBuffer: ""

      Image {
        id: wallpaper

        smooth: true
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        source: Dat.Config.data.wallSrc

        layer.effect: MultiEffect {
          id: walBlur

          autoPaddingEnabled: false
          blurEnabled: true

          NumberAnimation on blur {
            duration: Dat.MaterialEasing.emphasizedTime
            easing.type: Easing.Linear
            from: 0
            to: 0.69
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.5
            easing.type: Easing.Linear
            property: "blur"
            running: surface.active
            target: walBlur
            to: 0
          }
        }
      }

      Item {
        anchors.centerIn: parent
        clip: true
        height: kokomiText.contentHeight
        width: (pam.active) ? 0 : kokomiText.contentWidth

        Behavior on width {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime
            easing.bezierCurve: Dat.MaterialEasing.emphasized
          }
        }

        Text {
          id: kokomiText

          anchors.centerIn: parent
          anchors.verticalCenterOffset: contentHeight * 0.2
          color: (surface.error) ? Dat.Colors.error : Dat.Colors.tertiary
          font.bold: true
          font.family: "Libre Barcode 128"
          font.pointSize: 400
          opacity: fg.opacity
          renderType: Text.NativeRendering
          text: surface.maskedBuffer
        }
      }

      Image {
        id: fg

        anchors.fill: parent
        antialiasing: true
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.smooth: true
        mipmap: true
        smooth: true
        source: Dat.Config.wallFg
        // Don't show the fg if fg is being generated
        visible: !Dat.Config.fgGenProc.running && Dat.Config.data.wallFgLayer

        NumberAnimation on opacity {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.type: Easing.Linear
          from: 0
          to: 1
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime * 1.5
          easing.type: Easing.Linear
          from: 1
          property: "opacity"
          running: surface.active
          target: fg
          to: 0
        }
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
        NumberAnimation on opacity {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.type: Easing.Linear
          from: 0
          to: 1
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
              surface.maskedBuffer = "";
              return;
            }
            surface.inputBuffer = surface.inputBuffer.slice(0, -1);
            surface.maskedBuffer = surface.maskedBuffer.slice(0, -1);
            return;
          }

          if (kevent.text) {
            surface.inputBuffer += kevent.text;
            surface.maskedBuffer += surface.kokomi[Math.floor(Math.random() * 6)];
          }
        }

        SequentialAnimation {
          running: surface.active

          PauseAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.2
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 0.3
            easing.type: Easing.Linear
            from: 1
            property: "opacity"
            target: inputRect
            to: 0
          }
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
            surface.inputBuffer = "";
            surface.maskedBuffer = "";
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
          surface.maskedBuffer = "";
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
