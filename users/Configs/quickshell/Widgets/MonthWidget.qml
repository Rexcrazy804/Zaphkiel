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
  color: (root.active)? Colors.on_secondary : Colors.secondary
  Text {
    visible: !root.active
    anchors.centerIn: parent
    id: monthText
    color:  Colors.on_secondary
    text: Time.data?.monthName + " " + Time.data?.dayNumber + " 󰧱"
  }

  Text {
    visible: root.active
    anchors.centerIn: parent
    color: Colors.secondary
    text: "" + Time.data?.dayName
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      root.rightMenu.toggleVisibility()
    }
  }

  Component.onCompleted: () => {
    root.rightMenu.onVisibleChanged.connect(() => {
      root.active = root.rightMenu.visible
    })
  }

  Behavior on color {
    ColorAnimation { duration: 150 }
  }
}
