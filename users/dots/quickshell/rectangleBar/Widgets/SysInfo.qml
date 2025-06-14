import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
  id: root
  required property PanelWindow bar
  Layout.preferredWidth: childrenRect.width + 25
  Layout.fillHeight: true
  color: "transparent"

  RowLayout {
    anchors.centerIn: parent
    id: sysinfo
    layoutDirection: Qt.RightToLeft
    spacing: 15
    PowerWidget {bar: root.bar}
    SoundWidget {bar: root.bar}
    BrightnessWidget { bar: root.bar }
  }
}
