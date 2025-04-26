import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Assets"

PopupWindow {
  id: panel
  readonly property HyprlandWorkspace mon: Hyprland.focusedWorkspace
  required property PanelWindow bar
  signal popupVisible(visible: bool)

  color: Colors.withAlpha(Colors.surface, 0.79)
  visible: false
  anchor.window: bar
  anchor.rect.x: 10
  anchor.rect.y: bar.height + 10
  width: 140
  height: 140

  HyprlandFocusGrab {
    id: grab
    windows: [panel]
    onActiveChanged: { 
      panel.visible = grab.active
      panel.popupVisible(panel.visible)
    }
  }

  function toggleVisibility() {
    if (panel.visible) { // uhh don't ask me why its like this I tried
      grab.active = false
      panel.visible = false
    } else {
      grab.active = true
      panel.visible = true
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

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true

          onClicked: {
            Hyprland.dispatch("workspace " + (square.index + 1))
          }
        }
      }
    }
  }
}
