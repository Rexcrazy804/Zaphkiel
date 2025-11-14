import QtQuick
import QtQuick.Layouts
import Quickshell

import "../Assets"
GridLayout { // Toggles
  Repeater {
    model:[
      {
        icon: "󰖩",
        color: Colors.primary,
        action: (event) => {}
      },
      {
        icon: "󰖩",
        color: Colors.primary,
        action: (event) => {}
      },
      {
        icon: "󰖩",
        color: Colors.primary,
        action: (event) => {}
      },
      {
        icon: "󰖩",
        color: Colors.primary,
        action: (event) => {}
      },
      {
        icon: "󰖩",
        color: Colors.primary,
        action: (event) => {}
      },
      {
        icon: "󰂯",
        color: Colors.primary,
        action: (event) => {}, // do something
      },
    ]

    Rectangle {
      required property var modelData

      Layout.fillHeight: true
      Layout.fillWidth: true
      color: modelData.color

      Text {
        anchors.centerIn: parent
        text: modelData.icon
        font.pointSize: 26
      }
    }
  }
}
