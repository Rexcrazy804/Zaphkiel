import QtQuick
import Quickshell.Widgets
import "../Data/" as Dat
import "../Generics/" as Gen
import "../Assets/" as Ass

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

  delegate: ClippingRectangle {
    id: pill
    required property var modelData
    radius: 20
    implicitWidth: 20
    implicitHeight: this.implicitWidth
    color: Ass.Colors.surface_container_high

    Gen.MouseArea {
      hoverOpacity: 0.3
      clickOpacity: 0.5
      layerColor: Ass.Colors.on_surface
      onClicked: mevent => pill.modelData.action(mevent)
    }

    Text {
      anchors.centerIn: parent
      text: pill.modelData.text
      color: Ass.Colors.on_surface
      font.bold: true
    }
  }
}
