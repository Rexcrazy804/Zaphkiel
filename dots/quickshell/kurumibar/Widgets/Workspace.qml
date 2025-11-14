import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../Data"
import "../Assets"
import "../Components"

Rectangle {
  id: root
  required property PanelWindow bar
  readonly property HyprlandWorkspace mon: Hyprland.focusedWorkspace
  property bool active: false
  property bool recording: Recording.running
  property bool recordIconVisible: true
  property string recordingIcon: "R "

  Timer {
    interval: 600
    running: true
    repeat: true

    onTriggered: {
      root.recordIconVisible = !root.recordIconVisible
      root.recordingIcon = (root.recordIconVisible)? "R " : "  "
    }
  }

  color: root.active? Colors.on_primary : Colors.primary
  implicitHeight: parent.height
  implicitWidth: text.width + 16

  Text {
    anchors.centerIn: parent
    id: text
    text: ((root.recording)? root.recordingIcon : "") + "Workspace " + root.mon?.id
    font.pointSize: 11
    font.bold: true
    color: root.active? Colors.primary : Colors.on_primary
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
    onClicked: event => {
      menu.toggleVisibility()
    }
  }

  WorkspaceMenu {
    id: menu
    bar: root.bar
  }

  Component.onCompleted: () => {
    menu.onVisibleChanged.connect(() => {
      root.active = menu.visible
    })
  }

  Behavior on color {
    ColorAnimation { duration: 150 }
  }
}
