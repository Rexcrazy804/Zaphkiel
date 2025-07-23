pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Greetd
import QtQuick
import qs.Layers as Lay

ShellRoot {
  Lay.LockScreen {
    id: lockScreen
  }

  Connections {
    target: lockScreen.lock

    function onLockedChanged() {
      if (!lockScreen.lock.locked) {
        Greetd.launch("hyprland")
      }
    }
  }
}
