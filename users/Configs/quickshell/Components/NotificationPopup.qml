pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../MenuWidgets"
import "../Data"
import "../Assets"

PopupWindow {
  id: root
  required property var bar
  required property var rightMenu

  visible: false
  anchor.window: bar
  anchor.rect.x: bar.width - width - 10
  anchor.rect.y: bar.height + 10
  width: 450
  height: popup.height
  color: "transparent"

  NotificationEntry {
    id: popup
    width: parent.width
    notif: null
  }

  Component.onCompleted: () => {
    NotifServer.incomingAdded.connect(n => {
      popup.notif = n
      popup.updateNotif()
      root.visible = true && !rightMenu.visible
      timer.start()
    });

    rightMenu.popupVisible.connect(visible => {
      root.visible = !visible && timer.running
    })

    popup.dismissed.connect(() => {
      root.visible = false
      timer.running = false
      NotifServer.remove(popup.notif?.id)
    })
  }

  Timer {
    id: timer
    interval: 3000
    onTriggered: {
      root.visible = false
    }
  }
}
