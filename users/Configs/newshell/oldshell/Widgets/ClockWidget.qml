import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data"
import "../Assets"
import "../Components"

RowLayout {
  required property PanelWindow bar
  id: container
  implicitHeight: parent.height
  implicitWidth: dateText.implicitWidth + 20
  spacing: 10

  IdleWidget {
    id: lock
    visible: false

    onInhibitedChanged: {
      rehidelock.start()
    }
  }

  Text {
    property var time: Time.data?.time
    id: dateText
    font.pointSize: 11
    font.family: "CaskaydiaMono Nerd font"
    font.bold: true
    text: ((this.time?.hours % 12 == 0)? 12 : this.time?.hours % 12) + ":" + this.time?.minutes + ":" + this.time?.seconds + ((this.time?.hours / 12 > 1)? " PM" : " AM")
    color: Colors.tertiary

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true

      onEntered: {
        lock.visible = true
      }

      onExited: {
        rehidelock.start()
      }

      onClicked: {
        moMenu.toggleVisibility()
      }
    }
  }

  Timer {
    // rehides the lock if we haven't inhibited
    id: rehidelock
    interval: 1000

    onTriggered: {
      lock.visible = lock.inhibited
    }
  }

  MonthMenu {
    id: moMenu
    bar: container.bar
  }
}
