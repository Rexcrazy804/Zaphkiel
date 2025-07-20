import QtQuick
import QtQuick.Layouts

import qs.Generics as Gen
import qs.Data as Dat

Rectangle {
  color: Dat.Colors.surface_container_high
  radius: 20

  Flickable {
    id: flickableRoot

    anchors.fill: parent
    anchors.margins: 10
    clip: true
    contentHeight: coL.height

    ColumnLayout {
      id: coL

      width: flickableRoot.width

      Gen.TweakToggle {
        Layout.fillWidth: true
        active: Dat.Config.data.reservedShell
        text: "Exclusive Shell"

        onClicked: () => Dat.Config.data.reservedShell = !Dat.Config.data.reservedShell
      }

      Gen.TweakToggle {
        Layout.fillWidth: true
        active: Dat.Config.data.mousePsystem
        text: "Mouse Particles"

        onClicked: () => Dat.Config.data.mousePsystem = !Dat.Config.data.mousePsystem
      }

      Gen.TweakToggle {
        Layout.fillWidth: true
        active: Dat.Config.data.setWallpaper
        text: "Set Wallpaper"

        onClicked: () => Dat.Config.data.setWallpaper = !Dat.Config.data.setWallpaper
      }

      Gen.TweakToggle {
        Layout.fillWidth: true
        active: Dat.Config.data.wallFgLayer
        text: "Fg Layer Extraction"

        onClicked: () => Dat.Config.data.wallFgLayer = !Dat.Config.data.wallFgLayer
      }

      Item {
        Layout.fillWidth: true
        implicitHeight: 25

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_surface
          text: "kurukurubar <3"
        }
      }
    }
  }
}
