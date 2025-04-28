pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  // TODO stop assuming its false and figure out if it is running or not
  property bool idleInhibited: false

  function toggleIdle() {
    if (root.idleInhibited) {
      thaw.running = true
    } else {
      freeze.running = true
    }
    root.idleInhibited = !root.idleInhibited
	}

  function suspend() {
		suspend.running = true
	}
  function reboot() {
		reboot.running = true
	}
  function poweroff() {
		poweroff.running = true
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
