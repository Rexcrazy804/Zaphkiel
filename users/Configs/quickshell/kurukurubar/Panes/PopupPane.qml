import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat

Rectangle {
  id: popupRect
  Text {
    anchors.centerIn: parent
    color: Dat.Colors.on_surface
    text: "popup"
  }
}
