import QtQuick
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
        console.log("[WARN] wallpaper source invalid, disabling background");
        Dat.Config.data.setWallpaper = false;
      }
    }

    Connections {
      function onWallSrcChanged() {
        wallpaper.source = Dat.Config.data.wallSrc;
      }

      target: Dat.Config.data
    }
  }

  // Text {
  //   anchors.centerIn: parent
  //   color: Dat.Colors.tertiary
  //   font.bold: true
  //   font.family: "Rubik Glitch"
  //   font.pointSize: 340
  //   renderType: Text.NativeRendering
  //   text: {
  //     const time = Qt.formatDateTime(Dat.Clock?.date, "h-mm A").split(" ")[0].split("-");
  //     const hours = time[0];
  //     const minutes = time[1];
  //
  //     return (parseInt(hours) >= 10) ? `${hours}${minutes}` : `${hours}-${minutes}`;
  //   }
  // }
  //
  // Image {
  //   anchors.fill: parent
  //   antialiasing: true
  //   mipmap: true
  //   smooth: true
  //   source: Quickshell.env("HOME") + "/.config/foreground.png"
  // }
}
