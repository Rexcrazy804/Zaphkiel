// warning my notification implementation WORKS but it has a feww rough edges here and there
// do NOT steal blindly, understand the need for each component and maybe you'll have a better
// notifcation Server impl
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: notif

  property int notifCount: notifServer.trackedNotifications.values.length
  property ScriptModel notifications: serverNotifications
  property NotificationServer server: notifServer

  function clearNotifs() {
    for (var i = 0; i < notifServer.trackedNotifications.values.length; i++) {
      // TODO this is still a bit wonky idk why
      notifServer.trackedNotifications.values[i].dismiss();
    }
  }

  NotificationServer {
    id: notifServer

    actionIconsSupported: true
    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyImagesSupported: true
    bodyMarkupSupported: true
    bodySupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: n => n.tracked = true
  }

  ScriptModel {
    id: serverNotifications

    values: [...notifServer.trackedNotifications.values].reverse()
  }
}
