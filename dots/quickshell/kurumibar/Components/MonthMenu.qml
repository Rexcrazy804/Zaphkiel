import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import QtQuick.Controls

import "../Assets"
import "../Data"

PopupWindow {
  id: panel
  required property PanelWindow bar

  visible: true
  color: "transparent"
  anchor.window: bar
  anchor.rect.x: bar.width / 2 - width / 2
  anchor.rect.y: bar.height + 10
  width: 330
  height: 250

  HyprlandFocusGrab {
    id: grab
    windows: [ panel ]
    onActiveChanged:  if (!grab.active) { baseRect.state = "Closed" }
  }

  function toggleVisibility() {
    if (panel.visible) {
      baseRect.state = "Closed"
    } else {
      panel.visible = true
      grab.active = true
      baseRect.state = "Open"
    }
  }

  Rectangle {
    id: baseRect
    color: Colors.withAlpha(Colors.secondary_container, 0.79)
    anchors.centerIn: parent
    width: parent.width
    height: parent.height

    state: "Closed"
    states: [
      State {
        name: "Closed"
        PropertyChanges { baseRect.opacity: 0 }
      },
      State {
        name: "Open"
        PropertyChanges { baseRect.opacity: 1 }
      }
    ]
    Behavior on opacity { NumberAnimation { duration: 150 } }

    onOpacityChanged: if (opacity == 0) {
      panel.visible = false
      grab.active = false
    }


    RowLayout {
      anchors.fill: parent
      spacing:0

      Rectangle {
        implicitWidth: 30
        Layout.fillHeight: true
        color: Colors.secondary

        Text {
          rotation: -90
          anchors.centerIn: parent
          color: Colors.on_secondary
          text: Time.data?.dayName + ", " + Time.data?.monthName + " " + Time.data?.year
          font.pointSize: 13
          font.italic: true
        }
      }

      MonthGrid {
        id: cal
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
        spacing: 5

        delegate: Rectangle {
          id: calRect
          required property var model
          color: (model.month === cal.month)?
          (calRect.model.day == Time.data?.dayNumber)? Colors.tertiary : Colors.secondary
          : Colors.on_secondary

          Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignVCenter
            text: calRect.model.day
            color: (model.month === cal.month)?
            (calRect.model.day == Time.data?.dayNumber)? Colors.on_tertiary : Colors.on_secondary
            : Colors.secondary
          }
        }
      }
    }
  }
}

