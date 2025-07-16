pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import "../Data/" as Dat

Singleton {
  property alias data: jsonData

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
}
