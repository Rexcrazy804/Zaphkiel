pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import "../Data/" as Dat

Singleton {
  id: root

  property alias data: jsonData
  property alias fgGenProc: generateFg
  property string wallFg: ""

  FileView {
    path: Dat.Paths.config + "/config.json"
    watchChanges: true

    onAdapterUpdated: writeAdapter()
    onFileChanged: reload()

    JsonAdapter {
      id: jsonData

      property bool mousePsystem: false
      property bool reservedShell: false
      property bool setWallpaper: true
      property string wallSrc: Quickshell.env("HOME") + "/.config/background"
    }
  }

  IpcHandler {
    function setWallpaper(path: string) {
      path = Qt.resolvedUrl(path);
      jsonData.wallSrc = path;
      jsonData.setWallpaper = true;
    }

    target: "config"
  }

  Process {
    id: generateFg

    property string script: Dat.Paths.urlToPath(Qt.resolvedUrl("../scripts/extractFg.sh"))

    command: [script, Dat.Paths.urlToPath(jsonData.wallSrc), Dat.Paths.urlToPath(Dat.Paths.cache)]

    stdout: StdioCollector {
      onStreamFinished: {
        let output = text.split("\n");
        root.wallFg = output[output.length - 2];
        console.log(output[output.length - 3]);
      }
    }

    onExited: ec => {
      if (ec) {
        console.log("[ERROR] Foreground exaction script failed");
        root.wallFg = "";
      }
    }
    onRunningChanged: {
      if (running && root.wallFg != "") {
        console.log("[INFO] generating wallpaper foreground...");
      }
    }
  }

  Connections {
    function onWallSrcChanged() {
      if (jsonData.wallSrc != "") {
        generateFg.running = true;
      }
    }

    target: jsonData
  }
}
