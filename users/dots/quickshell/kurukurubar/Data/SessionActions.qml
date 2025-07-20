pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool idleInhibited: false

  function poweroff() {
    Quickshell.execDetached(["poweroff"]);
  }

  function reboot() {
    Quickshell.execDetached(["reboot"]);
  }

  function suspend() {
    Quickshell.execDetached(["loginctl", "lock-session"]);
    Quickshell.execDetached(["systemctl", "suspend"]);
  }

  function toggleIdle() {
    if (root.idleInhibited) {
      Quickshell.execDetached(["systemctl", "--user", "start", "hypridle.service"]);
    } else {
      Quickshell.execDetached(["systemctl", "--user", "stop", "hypridle.service"]);
    }
    root.idleInhibited = !root.idleInhibited;
  }

  Process {
    command: ["systemctl", "--user", "is-active", "hypridle.service"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        root.idleInhibited = !(data == "active");
      }
    }
  }
}
