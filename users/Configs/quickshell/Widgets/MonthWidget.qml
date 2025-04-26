import QtQuick
import Quickshell
import Quickshell.Io
import "../Data"
import "../Assets"

Rectangle {
  id: root
  required property PopupWindow rightMenu
  property bool active: false

  implicitHeight: parent.height
  implicitWidth: dayText.implicitWidth + 20
  color: (root.active)? Colors.on_tertiary : Colors.tertiary
  Text {
    anchors.centerIn: parent
    id: dayText
    color: (root.active)? Colors.tertiary : Colors.on_tertiary
    text: ((root.active)? Time.data?.dayName : Time.data?.monthName + " " + Time.data?.dayNumber) + " 󰧱"
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      rightMenu.toggleVisibility()
    }
  }

  Component.onCompleted: () => {
    rightMenu.popupVisible.connect(visible => {
      root.active = visible
    })
  }
}
