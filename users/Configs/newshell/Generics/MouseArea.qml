import QtQuick
MouseArea {
  id: root
  anchors.fill: parent
  hoverEnabled: true
  onContainsMouseChanged: {
    if (root.containsMouse) {
      parent.opacity = 0.92;
    } else {
      parent.opacity = 1;
    }
  }
  onContainsPressChanged: {
    if (root.containsPress) {
      parent.opacity = 0.85;
    } else {
      parent.opacity = 0.92;
    }
  }
}
