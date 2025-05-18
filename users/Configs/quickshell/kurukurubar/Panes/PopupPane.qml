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
      if (!e) {
        return;
      }
      stack.push(Qt.createComponent("../Generics/Notification.qml"), {
        "notif": e,
        "width": stack.width,
        "height": stack.height,
        "radius": "20"
      });
      if (Dat.Globals.notifState != "INBOX") {
        Dat.Globals.notifState = "POPUP";
      }
      if (stack.depth == 0) {
        popupClose.start();
      } else {
        popupClose.restart();
      }
    });
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
        // stack.clear()
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    hoverEnabled: true
    onEntered: popupClose.stop()
    onExited: popupClose.restart()
  }
}
