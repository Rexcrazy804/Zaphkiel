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
  implicitWidth: monthText.implicitWidth + 20
  color: (root.active)? Colors.on_tertiary : Colors.tertiary
  Text {
    visible: !root.active
    anchors.centerIn: parent
    id: monthText
    color:  Colors.on_tertiary
    text: Time.data?.monthName + " " + Time.data?.dayNumber + " 󰧱"
  }

  Text {
    visible: root.active
    anchors.centerIn: parent
    color: Colors.tertiary
    text: "" + Time.data?.dayName
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
