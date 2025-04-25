import QtQuick
import Quickshell.Hyprland
import "../Data"
import "../Assets"

Rectangle {
  id: root
  readonly property HyprlandWorkspace mon: Hyprland.focusedWorkspace
  color: Colors.primary
  implicitHeight: parent.height
  implicitWidth: text.implicitWidth + 18

  Text {
    anchors.centerIn: parent
    id: text
    text: "Workspace " + root.mon?.id
    font.pointSize: 11
    font.bold: true
    color: Colors.primary_container
  }

  MouseArea {
    anchors.fill: parent
    onWheel: event => { 
      // TODO streamline this
      if (root.mon?.id <= 10) {
        (event.angleDelta.y > 0)? Hyprland.dispatch("workspace -1") : Hyprland.dispatch("workspace +1") 
      } else {
         Hyprland.dispatch("workspace 10")
      }
    }
  }
}
