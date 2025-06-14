import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: popupRect

  property alias closeTimer: popupClose
  property bool closed: true
  property var currentNotif: stack.currentItem

  function pushNotif(e) {
    if (Dat.NotifServer.dndEnabled) {
      return;
    }
    if (!e) {
      return;
    }
    let notification = Qt.createComponent("../Generics/NotificationPopup.qml");
    stack.push(notification, {
      "notif": e,
      "width": stack.width,
      "implicitHeight": stack.height,
      "radius": "20",
      "view": stack,
      "popup": popupRect
    });
    if (Dat.Globals.notifState == "HIDDEN") {
      Dat.Globals.notifState = "POPUP";
      popupRect.closed = false;
      popupClose.start();
    } else if (Dat.Globals.notifState == "POPUP") {
      popupRect.closed = false;
      popupClose.restart();
    }
  }

  Component.onCompleted: {
    Dat.NotifServer.server.onNotification.connect(e => {
      pushNotif(e);

      // issue #30 where spotify updates a notification
      e.bodyChanged.connect(() => pushNotif(e));
      e.summaryChanged.connect(() => pushNotif(e));
    });

    stack.depthChanged.connect(() => {
      if (stack.depth == 0 && Dat.Globals.notifState == "POPUP") {
        popupClose.running = false;
        Dat.Globals.notifState = "HIDDEN";
      }
    });
  }

  StackView {
    id: stack

    anchors.fill: parent
    clip: true
    initialItem: null

    pushEnter: Transition {
      ParallelAnimation {
        YAnimator {
          duration: Dat.MaterialEasing.standardDecelTime
          easing.bezierCurve: Dat.MaterialEasing.standardDecel
          from: 100
          to: 0
        }
      }
    }
    pushExit: Transition {
      ParallelAnimation {
        YAnimator {
          duration: Dat.MaterialEasing.standardAccelTime
          easing.bezierCurve: Dat.MaterialEasing.standardAccel
          from: 0
          to: -100
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.standardAccelTime
          easing.bezierCurve: Dat.MaterialEasing.standardAccel
          from: 1
          property: "opacity"
          to: 0
        }
      }
    }
  }

  Timer {
    id: popupClose

    interval: 3500

    onTriggered: {
      popupRect.closed = true;
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
