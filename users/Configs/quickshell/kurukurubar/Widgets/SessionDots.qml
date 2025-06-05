import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../Data/" as Dat
import "../Generics/" as Gen

Repeater {
  // Responsive scaling
  property real scaleFactor: Dat.Globals.scaleFactor

  model: [
    {
      text: "󰐥", // Power off
      action: event => Dat.SessionActions.poweroff()
    },
    {
      text: "󰜉", // Reboot
      action: event => Dat.SessionActions.reboot()
    },
    {
      text: "󰤄", // Suspend
      action: event => Dat.SessionActions.suspend()
    },
  ]

  delegate: Rectangle {
    id: dot

    required property var modelData

    Layout.alignment: Qt.AlignCenter
    clip: true
    color: Dat.Colors.primary
    implicitWidth: 30 * scaleFactor
    implicitHeight: 30 * scaleFactor
    radius: 30 * scaleFactor

    Gen.MouseArea {
      layerColor: Dat.Colors.on_primary
      layerRadius: 30 * scaleFactor

      onClicked: mevent => dot.modelData.action(mevent)
    }

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.on_primary
      font.bold: true
      font.pixelSize: 20 * scaleFactor
      text: dot.modelData.text
    }
  }
}
