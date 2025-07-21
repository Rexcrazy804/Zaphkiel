import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import qs.Data as Dat
import qs.Widgets as Wid

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

  Wid.Wallpaper {
    id: wallpaper

    anchors.fill: parent
    source: ""

    Component.onCompleted: {
      source = Dat.Config.data.wallSrc;
    }

    Connections {
      function onWallSrcChanged() {
        if (walAnimation.running) {
          walAnimation.complete();
        }
        animatingWal.source = Dat.Config.data.wallSrc;
        walAnimation.start();
      }

      target: Dat.Config.data
    }

    Connections {
      function onFinished() {
        wallpaper.source = animatingWal.source;
        animatingWal.source = "";
        animatinRect.width = 0;
      }

      target: walAnimation
    }
  }

  Rectangle {
    id: animatinRect

    anchors.right: parent.right
    clip: true
    color: "transparent"
    height: layerRoot.screen.height
    width: 0

    NumberAnimation {
      id: walAnimation

      duration: Dat.MaterialEasing.emphasizedTime * 5
      easing.bezierCurve: Dat.MaterialEasing.emphasized
      from: 0
      property: "width"
      target: animatinRect
      to: Math.max(layerRoot.screen.width)
    }

    Wid.Wallpaper {
      id: animatingWal

      anchors.right: parent.right
      height: layerRoot.height
      source: ""
      width: layerRoot.width
    }
  }
}
