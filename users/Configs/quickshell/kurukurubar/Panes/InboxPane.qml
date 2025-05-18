pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: inboxRect

  property alias list: inbox

  ColumnLayout {
    anchors.fill: parent

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: "transparent"

      ListView {
        id: inbox

        anchors.top: parent.top
        height: (contentHeight < 300) ? contentHeight : 300
        model: Dat.NotifServer.notifications
        spacing: 10
        width: parent.width

        delegate: Gen.Notification {
          required property Notification modelData

          color: Dat.Colors.surface_container
          notif: modelData
          radius: 20
          width: inbox.width
        }
        footerPositioning: ListView.OverlayFooter
        footer: Rectangle {
          visible: Dat.NotifServer.notifCount >= 1
          z: 2
          width: inbox.width
          height: 65
          color: "transparent"
          Rectangle {
            width: 50
            height: this.width
            radius: this.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            color: Dat.Colors.surface_container_highest
            layer.enabled: true
            layer.effect: MultiEffect {
              shadowEnabled: true
              shadowOpacity: 0.5
              shadowVerticalOffset: 1
              shadowHorizontalOffset: 1
            }

            Text {
              anchors.centerIn: parent
              text: ""
              color: Dat.Colors.on_surface
              font.pointSize: 16
            }

            Gen.MouseArea {
              onClicked: Dat.NotifServer.clearNotifs()
            }
          }
        }
      }
    }
  }
}
