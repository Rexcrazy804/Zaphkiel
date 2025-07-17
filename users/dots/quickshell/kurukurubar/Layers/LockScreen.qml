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

      property string inputBuffer: ""

      Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        source: Dat.Config.data.wallSrc

        layer.effect: MultiEffect {
          autoPaddingEnabled: false
          blur: 0.48
          blurEnabled: true
        }
      }

      Item {
        height: 50
        width: 50

        MouseArea {
          anchors.fill: parent

          onClicked: lock.locked = false
        }
      }

      Rectangle {
        id: inputRect

        anchors.centerIn: parent
        clip: true
        color: Dat.Colors.surface
        focus: true
        height: 40
        radius: 20
        width: inputRow.width

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

        RowLayout {
          id: inputRow
          anchors.centerIn: parent
          height: parent.height
          spacing: 0

          Item {
            implicitHeight: inputRect.height
            implicitWidth: inputRect.height

            Gen.MatIcon {
              id: lockIcon

              anchors.centerIn: parent
              antialiasing: true
              color: Dat.Colors.on_surface
              fill: pam.active
              font.pointSize: 16
              icon: "lock"

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

          Item {
            visible: pamText.text != ""
            implicitWidth: pamText.contentWidth + 18

            Text {
              id: pamText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface_variant
              text: pam.message
            }
          }

          // Item {
          //   Layout.fillHeight: true
          //   Layout.fillWidth: true
          //
          //   ListView {
          //     anchors.fill: parent
          //     orientation: ListView.Horizontal
          //
          //     delegate: Item {
          //       height: inputRect.height
          //       width: this.height
          //
          //       Text {
          //         anchors.centerIn: parent
          //         color: Dat.Colors.on_surface
          //         text: "*"
          //       }
          //     }
          //     model: ScriptModel {
          //       values: surface.inputBuffer.split("")
          //     }
          //   }
          // }
        }
      }

      PamContext {
        id: pam

        onCompleted: res => {
          if (res === PamResult.Success) {
            lock.locked = false;
          }
        }
        onResponseRequiredChanged: {
          if (!responseRequired)
            return;

          respond(surface.inputBuffer);
          surface.inputBuffer = "";
        }
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
