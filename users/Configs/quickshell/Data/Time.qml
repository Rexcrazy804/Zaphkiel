pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string time
  property string date
  property string month

  Process {
    id: timeProc
    command: ["date", "+%r"]

    running: true
    stdout: SplitParser {
      onRead: data => root.time = data
    }
  }

  Process {
    id: monthProc
    command: ["date", "+%B %d"]

    running: true
    stdout: SplitParser {
      onRead: data => root.month = data
    }
  }
  Timer {
    interval: 1000 // time ine ms 1000ms => 1s
    running: true
    repeat: true
    onTriggered: timeProc.running = true
  }

  Timer {
    // runs once every hour
    interval: 3600
    running: true
    repeat: true
    onTriggered: monthProc.running = true
  }
}
