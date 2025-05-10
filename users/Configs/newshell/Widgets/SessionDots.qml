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
    clip: true
    id: dot
    required property var modelData
    Layout.alignment: Qt.AlignCenter

    radius: 28
    implicitWidth: 28
    implicitHeight: this.implicitWidth
    color: Dat.Colors.surface_container_high

    Gen.MouseArea {
      hoverOpacity: 0.1
      clickOpacity: 0.2
      layerColor: Dat.Colors.on_surface
      onClicked: mevent => dot.modelData.action(mevent)
    }

    Text {
      anchors.centerIn: parent
      text: dot.modelData.text
      color: Dat.Colors.on_surface
      font.bold: true
    }
  }
}
