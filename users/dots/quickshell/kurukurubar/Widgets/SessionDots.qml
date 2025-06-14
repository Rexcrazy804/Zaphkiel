import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../Data/" as Dat
import "../Generics/" as Gen

Repeater {
  model: [
    {
      text: "󰐥",
      action: event => Dat.SessionActions.poweroff()
    },
    {
      text: "󰜉",
      action: event => Dat.SessionActions.reboot()
    },
    {
      text: "󰤄",
      action: event => Dat.SessionActions.suspend()
    },
  ]

  delegate: Rectangle {
    id: dot

    required property var modelData

    Layout.alignment: Qt.AlignCenter
    clip: true
    color: Dat.Colors.primary
    implicitHeight: this.implicitWidth
    implicitWidth: 28 * Dat.Globals.notchScale
    radius: this.implicitWidth

    Gen.MouseArea {
      layerColor: Dat.Colors.on_primary

      onClicked: mevent => dot.modelData.action(mevent)
    }

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.on_primary
      font.bold: true
      font.pointSize: 12 * Dat.Globals.notchScale
      text: dot.modelData.text
    }
  }
}
