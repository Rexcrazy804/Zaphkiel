import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.Data as Dat

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

    smooth: true
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

  // some redundant work commented
  // Current models aren't good enough for me to use this well
  // Rectangle {
  //   id: gradient
  //
  //   anchors.fill: forground
  //   visible: false
  //
  //   gradient: Gradient {
  //     GradientStop {
  //       color: Dat.Colors.tertiary
  //       position: 0.0
  //     }
  //
  //     GradientStop {
  //       color: Dat.Colors.primary
  //       position: 1.0
  //     }
  //   }
  // }
  //
  // Text {
  //   id: forground
  //
  //   anchors.centerIn: parent
  //   antialiasing: true
  //   color: Dat.Colors.tertiary
  //   font.family: "Gnomon*"
  //   font.pointSize: 450
  //   font.variableAxes: {
  //     "TOTD": 0,
  //     "DIST": 0
  //   }
  //   layer.enabled: true
  //   layer.smooth: true
  //   renderType: Text.NativeRendering
  //   text: Qt.formatDateTime(Dat.Clock?.date, "hh:mm AP").split(" ")[0]
  //   visible: false
  // }
  //
  // MultiEffect {
  //   anchors.fill: gradient
  //   maskEnabled: true
  //   maskSource: forground
  //   maskSpreadAtMin: 1.0
  //   maskThresholdMax: 1.0
  //   maskThresholdMin: 0.5
  //   source: gradient
  // }
  //
  // Image {
  //   id: fg
  //
  //   anchors.fill: parent
  //   layer.enabled: true
  //   layer.smooth: true
  //   fillMode: Image.PreserveAspectCrop
  //   mipmap: true
  //   smooth: true
  //   source: Dat.Config.wallFg
  //   visible: !Dat.Config.fgGenProc.running && Dat.Config.data.wallFgLayer
  // }
}
