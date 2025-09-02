pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property alias idleInhibited: persist.enabled

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

  PersistentProperties {
    id: persist

    property bool enabled: false

    reloadableId: "idleInhibitor"
  }

  Process {
    command: ["systemd-inhibit", "--what=idle", "--who=kurukurubar", "--why=Manually Blocked Idle", "--mode=block", "sleep", "inf"]
    running: root.idleInhibited
  }
}
