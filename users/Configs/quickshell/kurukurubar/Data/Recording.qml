pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool running: false

  Process {
    id: fullRecording

    command: ["gpurecording", "start"]

    onExited: (ec, estatus) => root.running = false
    onStarted: root.running = true
  }

  Process {
    id: areaRecording

    property string area: ""

    command: ["gpurecording", "start", area]
    stdinEnabled: true

    onExited: (ec, estatus) => root.running = false
    onStarted: root.running = true
  }

  Process {
    // redundant can be called directly and will have the same effect
    id: stoper

    command: ["gpurecording", "stop"]
  }

  IpcHandler {
    function start() {
      fullRecording.running = true;
    }

    function startArea(area: string) {
      areaRecording.area = area;
      areaRecording.running = true;
    }

    function stop() {
      stoper.running = true;
    }

    target: "record"
  }
}
