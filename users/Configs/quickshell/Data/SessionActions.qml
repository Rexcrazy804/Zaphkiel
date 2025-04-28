pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

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
    running: root.suspend
    command: ["systemctl", "suspend"]
    onExited: (ec, es) =>  {
      root.suspend = false
    }
  }

  Process {
    id: reboot
    command: ["reboot"]
  }

  Process {
    id: poweroff
    command: ["poweroff"]
  }
}
