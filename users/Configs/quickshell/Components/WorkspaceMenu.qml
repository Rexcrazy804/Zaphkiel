pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Assets"

PopupWindow {
  id: panel
  readonly property HyprlandWorkspace mon: Hyprland.focusedWorkspace
  required property PanelWindow bar

  color: Colors.withAlpha(Colors.surface, 0.79)
  visible: false
  anchor.window: bar
  anchor.rect.x: 10
  anchor.rect.y: bar.height + 10
  width: 120
  height: 120

  HyprlandFocusGrab {
    id: grab
    windows: [panel]
    onActiveChanged: {
      if (!grab.active) {
        panel.visible = false
      }
    }
  }

  onVisibleChanged: {
    if (panel.visible) {
      grab.active = visible
    }
  }

  GridLayout {
    width: parent.width - 20
    height: parent.height - 20
    anchors.centerIn: parent

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
            panel.visible = false
          }
        }
      }
    }
  }
}
