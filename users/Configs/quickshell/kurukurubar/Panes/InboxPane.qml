import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat

Rectangle {
  id: inboxRect
  Text {
    anchors.centerIn: parent
    color: Dat.Colors.on_surface
    text: "inbox"
  }
}
