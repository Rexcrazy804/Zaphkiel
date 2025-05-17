pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Assets"
import "../Data"

PopupWindow {
  id: panel
  readonly property HyprlandWorkspace mon: Hyprland.focusedWorkspace
  required property PanelWindow bar

  color: Colors.withAlpha(Colors.surface, 0.79)
  visible: false
  anchor.window: bar
  anchor.rect.x: 10
  anchor.rect.y: bar.height + 10
  width: 160
  height: 120

  function toggleVisibility() {
    if (panel.visible) {
      rowie.state = "Closed"
    } else {
      panel.visible = true
      grab.active = true
      rowie.state = "Open"
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [panel]
    onActiveChanged: {
      if (!grab.active) {
        rowie.state = "Closed"
      }
    }
  }

  RowLayout {
    id: rowie
    width: parent.width - 20
    height: parent.height - 20
    anchors.centerIn: parent

    state: "Closed"
    states: [
      State {
        name: "Open"
        PropertyChanges { rowie.opacity: 1 }
      },
      State {
        name: "Closed"
        PropertyChanges { rowie.opacity: 0 }
      }
    ]

    onOpacityChanged: {
      if (opacity == 0) {
        panel.visible = false
        grab.active = false
      }
    }

    Behavior on opacity { 
      NumberAnimation { duration: 160 }
    }

    GridLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 3

      uniformCellWidths: true
      uniformCellHeights: true
      rowSpacing: 5
      columnSpacing: this.rowSpacing
      rows: 3
      columns: this.rows

      Repeater {
        model: 9

        delegate: Rectangle {
          id: square
          required property var modelData
          required property int index

          Layout.fillHeight: true
          Layout.fillWidth: true
          color: (square.index + 1 == mon?.id)? Colors.on_primary : Colors.primary

          MouseArea { // yeah don't wanna over complicate this
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
              Hyprland.dispatch("workspace " + (square.index + 1))
            }
            onClicked: {
              rowie.state = "Closed"
            }
          }
        }
      }
    }

    GridLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1

      uniformCellWidths: true
      uniformCellHeights: true
      rowSpacing: 5
      columnSpacing: this.rowSpacing
      rows: 3
      columns: 1

      Repeater {
        model: [
          {text: "󰐥", action: (event) => { SessionActions.poweroff()} },
          {text: "󰜉", action: (event) => { SessionActions.reboot()} },
          {text: "󰤄", action: (event) => { SessionActions.suspend() } },
        ]

        delegate: Rectangle {
          id: sessionSquare
          required property var modelData

          Layout.fillHeight: true
          Layout.fillWidth: true
          color: Colors.tertiary

          Text {
            color: Colors.on_tertiary
            anchors.centerIn: parent
            text: sessionSquare.modelData.text
            font.pointSize: 14
            font.bold: true
          }

          MouseArea {
            anchors.fill: parent
            onClicked: (mevent) => {
              sessionSquare.modelData.action(mevent)
              panel.visible = false
            }
          }
        }
      }
    }
  }
}
