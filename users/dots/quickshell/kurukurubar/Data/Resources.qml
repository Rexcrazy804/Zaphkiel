pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property alias cpu: cpuInfo
  property alias mem: memInfo
  property string uptime: "0:00"

  // property int cpuUsage: 1 - (idleCPU / totalCPU)
  // god fucking knows why this returns zero
  // just use that alg to get cpu cpu usage

  // stolen from what friday stole from pterror
  FileView {
    id: cpuInfo

    property int idle
    property int idleSec
    property int total
    property int totalSec

    path: Qt.resolvedUrl("/proc/stat")

    onLoaded: {
      const data = cpuInfo.text();
      if (!data) {
        return;
      }
      const cpuText = data.match(/^.+/)[0];
      const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuText.match(/\d+/g).map(Number);
      const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice;
      cpuInfo.idleSec = newIdle - cpuInfo.idle;
      cpuInfo.totalSec = newTotal - cpuInfo.total;
      cpuInfo.idle = newIdle;
      cpuInfo.total = newTotal;
    }
  }

  // also stolen https://github.com/FridayFaerie/quickshell/blob/main/io/External.qml
  FileView {
    id: memInfo

    property int free
    property int total

    path: Qt.resolvedUrl("/proc/meminfo")

    onLoaded: {
      const text = memInfo.text();
      if (!text) {
        return;
      }

      memInfo.total = Number(text.match(/MemTotal: *(\d+)/)[1] ?? 1);
      memInfo.free = Number(text.match(/MemAvailable: *(\d+)/)[1] ?? 0);
    }
  }

  Timer {
    interval: 1000
    repeat: true
    running: Globals.notchState == "FULLY_EXPANDED" && Globals.swipeIndex == 4 && Globals.settingsTabIndex == 0

    onTriggered: {
      cpuInfo.reload();
      memInfo.reload();
    }
  }

  Process {
    id: uptime

    command: ["uptime"]

    stdout: StdioCollector {
      onStreamFinished: {
        // my regex skills are segs
        const time = text.match(/((\d+:?)+?(?=,))/)[0];
        const days = text.match(/(\d+) days /) ?? [""];
        root.uptime = days[0] + time;
      }
    }
  }

  Timer {
    interval: 1000 * 60
    repeat: true
    running: Globals.notchState == "FULLY_EXPANDED" && Globals.swipeIndex == 0
    triggeredOnStart: true

    onTriggered: {
      uptime.running = true;
    }
  }
}
