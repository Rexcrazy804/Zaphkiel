import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell
import "../Assets"
import "../Data"

Text {
  readonly property bool inhibited: SessionActions.idleInhibited
  color: Colors.secondary
  text: (inhibited)? "󰌾" : "󰍁"
  font.pointSize: 11

  MouseArea {
    anchors.fill: parent
    onClicked: {
      SessionActions.toggleIdle()
    }
  }
}
