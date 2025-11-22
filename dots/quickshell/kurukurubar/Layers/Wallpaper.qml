import QtQuick
import Quickshell
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

      Dat.Config.data.wallSrcChanged.connect(() => {
        if (walAnimation.running) {
          walAnimation.complete();
        }
        animatingWal.source = Dat.Config.data.wallSrc;
      });
      animatingWal.statusChanged.connect(() => {
        if (animatingWal.status == Image.Ready) {
          walAnimation.start();
        }
      });

      walAnimation.finished.connect(() => {
        wallpaper.source = animatingWal.source;
        animatingWal.source = "";
        animatinRect.width = 0;
      });
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
