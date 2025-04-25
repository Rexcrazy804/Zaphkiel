import QtQuick
import "../Data"
import "../Assets"

Rectangle {
  id: container
  color: "transparent"
  implicitHeight: parent.height
  implicitWidth: dateText.implicitWidth + 20

  Text {
    id: dateText
    anchors.centerIn: parent
    font.pointSize: 11
    font.family: "CaskaydiaMono Nerd font"
    font.bold: true
    text: Time.time
    color: Colors.secondary
  }
}
