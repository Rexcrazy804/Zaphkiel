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
  }

  Process {
    id: stoper

    command: ["gpurecording", "stop"]
  }

  IpcHandler {
    function start() {
      root.running = true;
      fullRecording.startDetached();
    }

    function startArea(area: string) {
      root.running = false;
      areaRecording.area = area;
      areaRecording.startDetached();
    }

    function stop() {
      root.running = false;
      stoper.startDetached();
    }

    target: "record"
  }
}
