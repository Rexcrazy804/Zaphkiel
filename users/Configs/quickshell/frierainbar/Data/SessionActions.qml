pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // TODO: improve this
  // assume it is not inhibited by default
  property bool idleInhibited: false

  function poweroff() {
    poweroff.running = true;
  }

  function reboot() {
    reboot.running = true;
  }

  function suspend() {
    suspend.running = true;
  }

  function toggleIdle() {
    if (root.idleInhibited) {
      thaw.running = true;
    } else {
      freeze.running = true;
    }
    root.idleInhibited = !root.idleInhibited;
  }

  Process {
    id: suspend

    command: ["systemctl", "suspend"]
  }

  Process {
    id: reboot

    command: ["reboot"]
  }

  Process {
    id: poweroff

    command: ["poweroff"]
  }

  Process {
    id: freeze

    command: ["systemctl", "--user", "freeze", "hypridle.service"]
  }

  Process {
    id: thaw

    command: ["systemctl", "--user", "thaw", "hypridle.service"]
  }
}
