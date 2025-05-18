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
        footerPositioning: ListView.OverlayFooter
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
        footer: Rectangle {
          color: "transparent"
          height: 65
          visible: Dat.NotifServer.notifCount >= 1
          width: inbox.width
          z: 2

          Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: Dat.Colors.surface_container_highest
            height: this.width
            layer.enabled: true
            radius: this.width
            width: 50

            layer.effect: MultiEffect {
              shadowEnabled: true
              shadowHorizontalOffset: 1
              shadowOpacity: 0.5
              shadowVerticalOffset: 1
            }

            Text {
              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              font.pointSize: 16
              text: ""
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
