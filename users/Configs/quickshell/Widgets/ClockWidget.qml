import QtQuick
import "../Data"
import "../Assets"

Rectangle {
  id: container
  color: "transparent"
  implicitHeight: parent.height
  implicitWidth: dateText.implicitWidth + 20

  Text {
    property var time: Time.data?.time
    id: dateText
    anchors.centerIn: parent
    font.pointSize: 11
    font.family: "CaskaydiaMono Nerd font"
    font.bold: true
    text: (this.time?.hours % 12) + ":" + this.time?.minutes + ":" + this.time?.seconds + ((this.time?.hours / 12 > 1)? " PM" : " AM")
    color: Colors.secondary
  }
}
