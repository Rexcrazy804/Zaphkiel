// warning my notification implementation WORKS but it has a feww rough edges here and there
// do NOT steal blindly, understand the need for each component and maybe you'll have a better
// notifcation Server impl
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
  id: notif
  property NotificationServer notifServer: server
  property ScriptModel notifications: sList
  property int notifCount: server.trackedNotifications.values.length

  NotificationServer {
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
    }
  }

  ScriptModel {
    id: sList
    values: [...server.trackedNotifications.values]
  }

  function clearNotifs() {
    for (var i = 0; i < server.trackedNotifications.values.length; i++) {
      // TODO this is still a bit wonky idk why
      server.trackedNotifications.values[i].dismiss()
    }
  }
}
