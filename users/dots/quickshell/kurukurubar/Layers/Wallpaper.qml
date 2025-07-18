import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import "../Data" as Dat

WlrLayershell {
  id: layerRoot

  required property ShellScreen modelData

  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  anchors.top: true
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  focusable: false
  implicitHeight: 28
  layer: WlrLayer.Bottom
  namespace: "rexies.notch.background"
  screen: modelData
  surfaceFormat.opaque: false

  Image {
    id: wallpaper

    anchors.fill: parent
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    retainWhileLoading: true

    // results in quality reduction some :woe:
    // sourceSize.height: layerRoot.modelData.height
    // sourceSize.width: layerRoot.modelData.width

    Component.onCompleted: {
      source = Dat.Config.data.wallSrc;
    }
    onStatusChanged: {
      if (this.status == Image.Error) {
        console.log("[ERROR] Wallpaper source invalid");
        console.log("[INFO] Please disable set wallpaper if not required");
      }
    }

    Connections {
      function onWallSrcChanged() {
        wallpaper.source = Dat.Config.data.wallSrc;
      }

      target: Dat.Config.data
    }
  }
}
