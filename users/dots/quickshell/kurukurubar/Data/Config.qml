pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

import "../Data/" as Dat

Singleton {
  property alias data: jsonData

  FileView {
    path: Dat.Paths.config + "/config.json"

    onAdapterUpdated: writeAdapter()
    onFileChanged: reload()
    watchChanges: true

    JsonAdapter {
      id: jsonData
      property bool reservedShell: false
      property bool mousePsystem: false
    }
  }
}
