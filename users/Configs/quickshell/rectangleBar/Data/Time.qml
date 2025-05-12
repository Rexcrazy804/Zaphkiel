pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property var data 

  Process {
    id: proc
    command: ["date", '+{"year": "%Y", "dayName": "%A", "dayNumber": "%d", "monthName": "%B", "time": {"hours": "%H", "minutes": "%M", "seconds": "%S"}}' ]

    running: true
    stdout: SplitParser {
      onRead: data => {
        root.data = JSON.parse(data)
      }
    }
  }

  Timer {
    interval: 1000 // time ine ms 1000ms => 1s
    running: true
    repeat: true
    onTriggered: proc.running = true
  }
}
