pragma Singleton
import QtQuick
import Quickshell.Io

Item {
  function increase() {
    inc.running = true
  }

  function decrease() {
    dec.running = true
  }
  Process {
    id: inc
    command: ["brightnessctl", "set", "1%+"]
  }

  Process {
    id: dec
    command: ["brightnessctl", "set", "1%-"]
  }
}
