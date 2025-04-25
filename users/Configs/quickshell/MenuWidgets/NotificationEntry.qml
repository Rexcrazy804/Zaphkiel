pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

import "../Data"
import "../Assets"
Item {
  id: root
  signal dismissed()

  required property var notif
  property var body
  property var appName
  property var summary
  property var actions

  // doing this to make a copy of all the data so that we don't panic when shit dies
  // robbed from nych
  function updateNotif() {
    if (notif == null) { dismissed() }
    body = notif?.body ?? "";
    appName = notif?.appName ?? "";
    summary = notif?.summary ?? "";
    actions = notif?.actions ?? [];
  }

  Component.onCompleted: {
    updateNotif()
  }

  height: field.height + 10 // unholy I know, maybe I'll clean it up later, but yk if it works, don't break it .w.

  Rectangle {
    id: field
    anchors.centerIn:parent
    width:parent.width - 10
    height: sumText.height + bodText.height + 45

    color: Colors.withAlpha(Colors.surface, 0.79)
    border {
      color: Colors.primary
      width: 2
    }

    ColumnLayout {
      spacing: 0
      id: content
      anchors.fill: parent
      anchors.margins: 20

      Text {
        Layout.fillWidth: true
        id: sumText
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: Colors.primary
        text: root.summary
        font.bold: true
      }

      Text {
        Layout.fillWidth: true
        id: bodText
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: Colors.tertiary
        text: root.body
      }
    }
  }

  Rectangle {
    id: header
    anchors.left: parent.left
    anchors.top: parent.top

    width: text.width + 10
    height: text.height + 2
    color: Colors.primary

    Text {
      id:text
      anchors.centerIn: parent
      color: Colors.on_primary
      text: root.appName
    }
  }

  Rectangle {
    anchors.right: parent.right
    anchors.top: parent.top

    width: header.height
    height: header.height
    color: Colors.error

    Text {
      anchors.centerIn: parent
      color: Colors.surface
      text: ""
      font.bold: true
      font.pointSize: 10
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.dismissed()
    }
  }

  RowLayout {
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: 15

    height: header.height
    width: childrenRect.width
    spacing: 15

    Repeater {
      model: root.actions

      Rectangle {
        id: actionRect
        required property NotificationAction modelData
        color: Colors.tertiary
        Layout.fillHeight: true
        implicitWidth: text2.width + 10
        Text {
          id: text2
          anchors.centerIn: parent
          color: Colors.on_tertiary
          text: actionRect?.modelData?.text ?? ""
          MouseArea {
            anchors.fill: parent
            onClicked: event => {
              actionRect.modelData.invoke()
              root.dismissed()
            }
          }
        }
      }
    }
  }
}
