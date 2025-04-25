pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
  id: notif

  property var notifServer: NotificationServer {
    id: server
    actionIconsSupported: true
    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyImagesSupported: true
    bodyMarkupSupported: true
    bodySupported: true
    imageSupported: true
    persistenceSupported: false

    onNotification: n => {
      n.tracked = true;
      notif.incomingAdded(n);
    }
  }

  property alias list: server.trackedNotifications
  signal incomingAdded(id: Notification)
  signal incomingRemoved(id: int)

  function remove(id: int) {
    notif.incomingRemoved(id)
  }

  signal clear()
}
