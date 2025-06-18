import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  clip: true
  color: Dat.Colors.primary_container
  height: 20
  implicitWidth: workRow.width + 8
  radius: 20

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Dat.MaterialEasing.standardDecelTime
      easing.bezierCurve: Dat.MaterialEasing.standardDecel
    }
  }

  RowLayout {
    id: workRow

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.top: parent.top
    spacing: 5

    Rectangle {
      color: Dat.Colors.primary
      implicitHeight: 20
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

      Layout.maximumWidth: 100
      color: Dat.Colors.on_primary_container
      elide: Text.ElideRight
      font.pointSize: 11
      text: Dat.Globals.actWinName
    }
  }

  Gen.MouseArea {
    layerColor: Dat.Colors.on_primary_container
    layerRadius: 20

    onClicked: {
      if (Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 2) {
        Dat.Globals.notchState = "EXPANDED";
      } else {
        Dat.Globals.notchState = "FULLY_EXPANDED";
        Dat.Globals.swipeIndex = 2;
      }
    }
    onWheel: event => {
      if (event.angleDelta.y < 0 || Hyprland.focusedWorkspace?.id > 1)
        Hyprland.dispatch(`workspace r${event.angleDelta.y > 0 ? "-" : "+"}1`);
    }
  }
}
