pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import qs.Widgets as Wid

ShellRoot {
  Component.onCompleted: sessionLock.locked = true

  WlSessionLock {
    id: sessionLock

    WlSessionLockSurface {
      Wid.Wallpaper {
        anchors.fill: parent
        source: "/etc/kurukurubar/background"
      }
    }
  }

  IpcHandler {
    function lock() {
      sessionLock.locked = true;
    }

    target: "lockscreen"
  }
}
