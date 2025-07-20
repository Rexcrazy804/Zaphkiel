pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Wayland
import Quickshell
import Quickshell.Io

import qs.Containers as Con

Scope {
  WlSessionLock {
    id: lock

    Con.LockScreenSurface {
      lock: lock
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
