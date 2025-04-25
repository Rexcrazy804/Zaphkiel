import QtQuick
import Quickshell
import "../Data"
import "../Assets"

Text {
  id: root
  required property PanelWindow bar

  text: "󰃠"
  color: Colors.primary_fixed_dim
  font.pointSize: 11
  font.bold: true

  MouseArea {
    anchors.fill: parent

    onWheel: event => {
      if (event.angleDelta.y > 0) {
        Brightness.increase()
      } else {
        Brightness.decrease()
      }
    }
  }
}
