import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: popupRect

  property alias closeTimer: popupClose

  Component.onCompleted: {
    Dat.NotifServer.server.onNotification.connect(e => {
      if (!e) { return; }
      var notification = Qt.createComponent("../Generics/Notification.qml")
      stack.push(notification, {
        "notif": e,
        "width": stack.width,
        "height": stack.height,
        "radius": "20",
        "view": stack,
        "popup": popupRect
      });
      if (Dat.Globals.notifState == "HIDDEN") {
        Dat.Globals.notifState = "POPUP";
        popupClose.start()
      } else if (Dat.Globals.notifState == "POPUP") {
        popupClose.restart()
      }
    });

    stack.depthChanged.connect(() => {
      if (stack.depth == 0) {
        popupClose.running = false
        Dat.Globals.notifState = "HIDDEN"
      }
    })
  }

  StackView {
    id: stack

    anchors.fill: parent
    clip: true
    initialItem: null
  }

  Timer {
    id: popupClose
    interval: 3500
    onTriggered: {
      if (Dat.Globals.notifState != "INBOX") {
        Dat.Globals.notifState = "HIDDEN";
      }
    }
  }

  Timer {
    id: stackClearTimer

    interval: 500
    running: Dat.Globals.notifState == "HIDDEN"

    onTriggered: stack.clear()
  }

}
