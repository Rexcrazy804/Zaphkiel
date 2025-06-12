import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import "../Generics/" as Gen
import "../Data/" as Dat

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
    }
  }
}
