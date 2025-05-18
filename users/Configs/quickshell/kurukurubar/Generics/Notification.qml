import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

import "../Data/" as Dat

Rectangle {
  id: root

  required property Notification notif

  color: "transparent"

  RowLayout {
    anchors.fill: parent

    Rectangle {
      Layout.fillHeight: true
      color: Dat.Colors.surface_container_low
      implicitWidth: this.height
      radius: 20

      Image {
        id: notifIcon

        anchors.fill: parent
        source: (root.notif?.image) ? root.notif?.image : Quickshell.env("HOME") + "/.face.icon"
        visible: false
      }

      MultiEffect {
        anchors.fill: notifIcon
        maskEnabled: true
        maskSource: notifIconMask
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
        source: notifIcon
      }

      Item {
        id: notifIconMask

        height: this.width
        layer.enabled: true
        visible: false
        width: notifIcon.width

        Rectangle {
          height: this.width
          radius: 20
          width: notifIcon.width
        }
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.margins: 10
      spacing: 4

      Rectangle {
        Layout.fillWidth: true
        color: "transparent"
        implicitHeight: 15

        Text {
          id: sumText

          anchors.fill: parent
          color: Dat.Colors.primary
          elide: Text.ElideRight
          text: root.notif.summary
        }
      }

      Flickable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        clip: true
        // flickableDirection: Qt.
        // color: "transparent"
        contentHeight: bodyText.implicitHeight

        Text {
          id: bodyText
          width: parent.width
          color: Dat.Colors.on_surface
          elide: Text.ElideRight
          font.pointSize: 11
          text: root.notif.body
          verticalAlignment: Text.AlignTop
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere
          textFormat: Text.MarkdownText
        }
      }
    }
  }
}
