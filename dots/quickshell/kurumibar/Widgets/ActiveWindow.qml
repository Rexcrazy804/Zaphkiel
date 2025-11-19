import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Assets"

Rectangle {
  // day light robbery from end_4
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

  id: container
  color: "transparent"
  implicitHeight: parent.height
  implicitWidth: text.implicitWidth + 20

  Text {
    id: text
    color: Colors.primary
    anchors.centerIn: parent
    text: activeWindow?.activated?activeWindow?.appId : "desktop"
    font.pointSize: 11
  }
}

