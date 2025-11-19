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
    onStarted: root.running = true
    onExited: (ec, estatus) => root.running = false
  }

  Process {
    property string area: ""
    id: areaRecording
    command: ["gpurecording", "start", area]
    stdinEnabled: true
    onStarted: root.running = true
    onExited: (ec, estatus) => root.running = false
  }

  Process {
    // redundant can be called directly and will have the same effect
    id: stoper
    command: ["gpurecording",  "stop"]
  }

  IpcHandler {
    target: "record"

    function start() { fullRecording.running = true }
    function startArea(area: string) {
      areaRecording.area = area
      areaRecording.running = true
    }

    function stop() { stoper.running = true }
  }
}
