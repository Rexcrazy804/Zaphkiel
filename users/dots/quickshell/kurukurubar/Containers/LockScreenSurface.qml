// heavily referenced soramane's lockscreen code
// https://github.com/caelestia-dots/shell/tree/main/modules/lock
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pam
import QtQuick.Effects
import Quickshell.Wayland

import qs.Data as Dat
import qs.Widgets as Wid
import qs.Generics as Gen

WlSessionLockSurface {
  id: surface

  property bool error: false
  property string inputBuffer: ""
  readonly property list<string> kokomi: ["k", "o", "k", "o", "m", "i"]
  required property WlSessionLock lock
  property string maskedBuffer: ""
  property bool unlocking: false

  Wid.Wallpaper {
    id: wallpaper

    anchors.fill: parent

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
        running: surface.unlocking
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

    Rectangle {
      id: gradient

      anchors.fill: kokomiText
      visible: false

      gradient: Gradient {
        GradientStop {
          color: Dat.Colors.primary
          position: 0.0
        }

        GradientStop {
          color: (surface.error) ? Dat.Colors.error : Dat.Colors.tertiary
          position: 1.0
        }
      }
    }

    Text {
      id: kokomiText

      anchors.centerIn: parent
      anchors.verticalCenterOffset: contentHeight * 0.2
      font.bold: true
      font.family: "Libre Barcode 128"
      font.pointSize: 400
      layer.enabled: true
      layer.smooth: true
      opacity: fg.opacity
      renderType: Text.NativeRendering
      text: surface.maskedBuffer
      visible: false
    }

    MultiEffect {
      anchors.fill: gradient
      maskEnabled: true
      maskSource: kokomiText
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5
      source: gradient
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
      running: surface.unlocking
      target: fg
      to: 0
    }
  }

  Rectangle {
    id: inputRect

    anchors.centerIn: parent
    clip: true
    color: (surface.error) ? Dat.Colors.error : (surface.unlocking) ? Dat.Colors.primary : Dat.Colors.surface
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
      running: surface.unlocking

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

    MouseArea {
      id: rowMarea

      anchors.centerIn: parent
      height: inputRow.height
      hoverEnabled: true
      width: inputRow.width

      RowLayout {
        id: inputRow

        anchors.centerIn: parent
        height: inputRect.height
        spacing: 0

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: rowMarea.containsMouse

          Gen.MatIcon {
            anchors.centerIn: parent
            antialiasing: true
            color: (surface.error) ? Dat.Colors.on_error : (surface.unlocking) ? Dat.Colors.on_primary : Dat.Colors.on_surface
            fill: 1
            font.pointSize: 16
            icon: "bedtime"
          }

          Gen.MouseArea {
            anchors.fill: parent
            anchors.margins: 4

            onClicked: Dat.SessionActions.suspend()
          }
        }

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height

          Gen.MatIcon {
            id: lockIcon

            anchors.centerIn: parent
            antialiasing: true
            color: (surface.error) ? Dat.Colors.on_error : (surface.unlocking) ? Dat.Colors.on_primary : Dat.Colors.on_surface
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

            onRunningChanged: if (lockIcon.rotation < 180) {
              lockIcon.rotation = 360;
            } else {
              lockIcon.rotation = 0;
            }
            onTriggered: lockIcon.rotation += 50
          }
        }

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: pam.message.includes("fingerprint")

          Connections {
            function onMessageChanged() {
              if (pam.message.includes("Failed")) {
                pamText.icon = "fingerprint_off";
                reFingerTimer.start();
              }
            }

            target: pam
          }

          Timer {
            id: reFingerTimer

            interval: 300

            onTriggered: pamText.icon = "fingerprint"
          }

          Gen.MatIcon {
            id: pamText

            anchors.centerIn: parent
            color: (surface.error) ? Dat.Colors.on_error : (surface.unlocking) ? Dat.Colors.on_primary : (reFingerTimer.running) ? Dat.Colors.error : Dat.Colors.on_surface
            font.pointSize: 16
            icon: "fingerprint"

            Behavior on color {
              ColorAnimation {
                duration: 200
              }
            }
          }
        }

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: rowMarea.containsMouse && !pam.active && !surface.unlocking

          Gen.MatIcon {
            anchors.centerIn: parent
            antialiasing: true
            color: (surface.error) ? Dat.Colors.on_error : (surface.unlocking) ? Dat.Colors.on_primary : Dat.Colors.on_surface
            fill: 1
            font.pointSize: 16
            icon: "login"
          }

          Gen.MouseArea {
            anchors.fill: parent
            anchors.margins: 4

            onClicked: pam.start()
          }
        }
      }
    }
  }

  PamContext {
    id: pam

    onCompleted: res => {
      if (res === PamResult.Success) {
        surface.unlocking = true;
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
    running: surface.unlocking

    onTriggered: surface.lock.locked = false
  }
}
