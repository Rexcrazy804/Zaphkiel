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

    locked: true

    WlSessionLockSurface {
      Wid.Wallpaper {
        anchors.fill: parent
        source: root.wallpaper_path
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
            Greetd.createSession("rexies");
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
}
