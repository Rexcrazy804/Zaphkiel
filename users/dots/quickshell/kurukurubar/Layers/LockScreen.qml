pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Wayland
import Quickshell
import Quickshell.Io

import qs.Data as Dat
import qs.Containers as Con

Scope {
  id: root

  property string prevState
  property alias lock: lock

  WlSessionLock {
    id: lock

    onLockedChanged: {
      Dat.Globals.notchState = root.prevState;
    }

    Con.LockScreenSurface {
      lock: lock
    }
  }

  IpcHandler {
    function lock() {
      root.prevState = Dat.Globals.notchState;
      Dat.Globals.notchState = "COLLAPSED";
      locker.start();
    }

    function unlock() {
      lock.locked = false;
    }

    target: "lockscreen"
  }

  Timer {
    id: locker

    interval: 250

    onTriggered: lock.locked = true
  }
}
