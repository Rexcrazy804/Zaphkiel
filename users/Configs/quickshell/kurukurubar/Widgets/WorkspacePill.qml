import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  color: Dat.Colors.primary_container
  height: 20
  implicitWidth: workRow.width + 8
  radius: 20

  Behavior on implicitWidth {
    NumberAnimation {
      duration: 100
      easing.bezierCurve: Dat.MaterialEasing.standard
    }
  }

  RowLayout {
    id: workRow

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.top: parent.top
    spacing: 5

    Rectangle {
      Layout.fillHeight: true
      color: Dat.Colors.primary
      implicitWidth: 20
      radius: 20

      Text {
        id: workspaceNumText

        anchors.centerIn: parent
        color: Dat.Colors.on_primary
        font.pointSize: 10
        text: Hyprland.focusedWorkspace?.id ?? "0"
      }
    }
    Text {
      id: windowNameText

      readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

      color: Dat.Colors.on_primary_container
      text: Dat.Globals.actWinName
    }
  }
  Gen.MouseArea {
    clickOpacity: 0.2
    hoverOpacity: 0.08
    layerColor: Dat.Colors.on_primary_container
    layerRadius: 20

    onClicked: {
      Dat.Globals.notchState = "FULLY_EXPANDED";
      Dat.Globals.swipeIndex = 2;
    }
  }
}
