pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../MenuWidgets"
import "../Data"
import "../Assets"

PopupWindow {
  id: root
  required property PanelWindow bar
  required property PopupWindow rightMenu

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

    onNotifChanged: {
      if (!notif) { root.visible = false }
      timer.restart()
    }
  }

  Component.onCompleted: () => {
    NotifServer.notifServer.onNotification.connect(n => {
      popup.notif = n
      root.visible = true
      timer.start()
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
