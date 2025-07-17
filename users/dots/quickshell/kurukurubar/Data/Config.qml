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
  readonly property string wallFg: Dat.Paths.urlToPath(Dat.Paths.cache + "/wallpaper-foreground")

  Process {
    id: generateFg

    command: ["rembg", "i", "-m", "birefnet-general", Dat.Paths.urlToPath(jsonData.wallSrc), root.wallFg]

    onExited: ec => {
      if (ec) {
        console.log("[ERROR] Failed to generate foreground image");
        return
      }

      console.log("[INFO] wallpaper forground generated");
    }
  }

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

      console.log("[INFO] gerating wallpaper foreground...");
      generateFg.running = true;
    }

    target: "config"
  }
}
