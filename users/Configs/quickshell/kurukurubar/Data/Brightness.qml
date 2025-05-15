pragma Singleton
import QtQuick
import Quickshell.Io

Item {
  function decrease() {
    dec.running = true;
  }

  function increase() {
    inc.running = true;
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
