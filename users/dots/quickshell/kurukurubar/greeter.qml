pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import qs.Data as Dat
import qs.Widgets as Wid
import qs.Generics as Gen

ShellRoot {
  id: root

  readonly property string session_cmd: Quickshell.env("KURU_DM_SESSION")
  readonly property string wallpaper_path: Quickshell.env("KURU_DM_WALLPATH")

  WlSessionLock {
    id: sessionLock

    property string user_passwd

    locked: true

    WlSessionLockSurface {
      Wid.Wallpaper {
        anchors.fill: parent
        source: root.wallpaper_path
      }

      Rectangle {
        anchors.fill: parent

        gradient: Gradient {
          GradientStop {
            color: "transparent"
            position: 0.0
          }

          GradientStop {
            color: Dat.Colors.background
            position: 1.0
          }
        }

        Text {
          color: Dat.Colors.on_background
          font.family: "DejaVu Sans"
          font.pointSize: 16
          renderType: Text.NativeRendering
          text: users.current_user

          anchors {
            bottom: parent.bottom
            bottomMargin: anchors.leftMargin
            left: parent.left
            leftMargin: 10
          }
        }

        Text {
          color: Dat.Colors.on_background
          font.family: "DejaVu Sans"
          font.pointSize: 32
          renderType: Text.NativeRendering
          text: Qt.formatDateTime(Dat.Clock.date, "HH MM AP")

          anchors {
            bottom: parent.bottom
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
          }
        }
      }

      Rectangle {
        anchors.centerIn: parent
        color: Dat.Colors.surface
        height: this.width
        radius: this.width
        width: 50

        Gen.MouseArea {
          anchors.fill: parent

          onClicked: {
            Greetd.createSession(users.current_user);
          }
        }

        Gen.MatIcon {
          anchors.centerIn: parent
          color: Dat.Colors.on_surface
          font.pointSize: 18
          icon: "lock"
        }
      }
    }
  }

  Connections {
    function onAuthMessage(message, error, responseRequired, echoResponse) {
      console.log("[MSG] " + message);
      console.log("[ERR] " + error);
      if (responseRequired) {
        Greetd.respond("kokomi");
      }
    }

    function onReadyToLaunch() {
      sessionLock.locked = false;
      Greetd.launch([(root.session_cmd ? root.session_cmd : "hyprland")]);
    }

    target: Greetd
  }

  Process {
    id: users

    property string current_user: list[current_user_index]
    property int current_user_index: 0
    property list<string> list: []

    command: ["awk", `BEGIN { FS = ":"} /\\/home/ { print $1 }`, "/etc/passwd"]
    running: true

    stderr: SplitParser {
      onRead: data => console.log("[ERR] " + data)
    }
    stdout: SplitParser {
      onRead: data => {
        console.log("[USERS] " + data);
        users.list.push(data);
      }
    }
  }
}
