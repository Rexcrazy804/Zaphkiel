pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import qs.Data as Dat
import qs.Generics as Gen

Item {
  id: inboxItem

  property alias list: inbox
  required property ShellScreen screen

  ListView {
    id: inbox

    property int prevContentHeight: 0

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: Math.min(inboxItem.screen.height * 0.6, contentHeight)
    model: Dat.NotifServer.notifications
    removeDisplaced: this.addDisplaced
    spacing: 5

    add: Transition {
      NumberAnimation {
        duration: Dat.MaterialEasing.standardDecelTime
        easing.bezierCurve: Dat.MaterialEasing.standardDecel
        from: 1000
        property: "x"
      }
    }
    addDisplaced: Transition {
      NumberAnimation {
        duration: Dat.MaterialEasing.standardTime
        easing.bezierCurve: Dat.MaterialEasing.standard
        properties: "x,y"
      }
    }
    delegate: Gen.Notification {
      required property Notification modelData

      color: Dat.Colors.surface_container
      notif: modelData
      radius: 20
      width: inbox.width
    }
    Behavior on height {
      id: inboxExpandBehv

      NumberAnimation {
        duration: Dat.MaterialEasing.standardTime
        easing.bezierCurve: Dat.MaterialEasing.standard
      }
    }
    remove: Transition {
      NumberAnimation {
        duration: Dat.MaterialEasing.standardAccelTime
        easing.bezierCurve: Dat.MaterialEasing.standardAccel
        property: "x"
        to: 1000
      }
    }

    onContentHeightChanged: {
      // lets us see the add animation when inbox has no notifications and a
      // new notification is added
      inboxExpandBehv.enabled = !(prevContentHeight == 0);
      prevContentHeight = this.contentHeight;
    }
  }
}
