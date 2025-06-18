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
    }
  }
}
