pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
  id: root
  property var weatherData: ""
  property string weatherJson: ""

  Process {
    id: proc
    command: ["curl", "https://wttr.in/shj?format=j1"] // replace shj with relevant airport code
    stdout: SplitParser {
      onRead: data => {
        root.weatherJson += data
      }
    }

    onExited: (code, stat) => {
      root.weatherData = JSON.parse(root.weatherJson)
    }
  }

  Timer {
    running: true
    interval: 1800000
    repeat: true
    onTriggered: {
      proc.running = true
    }
  }
}
