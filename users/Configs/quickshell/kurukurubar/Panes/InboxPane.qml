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

        anchors.left: parent.left
        // anchors.margins: 10
        anchors.leftMargin: 80
        anchors.right: parent.right
        anchors.rightMargin: this.anchors.leftMargin
        footerPositioning: ListView.InlineFooter
        height: (contentHeight < 300) ? contentHeight : 300
        model: Dat.NotifServer.notifications
        spacing: 10

        add: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "x"
              from: 1000
            }
          }
        }
        addDisplaced: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            properties: "x,y"
          }
        }

        remove: Transition {
          ParallelAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              property: "opacity"
              to: 0
            }
          }
        }

        removeDisplaced: this.addDisplaced
        delegate: Gen.Notification {
          required property Notification modelData

          color: Dat.Colors.surface_container
          notif: modelData
          radius: 20
          width: inbox.width
        }
        footer: Rectangle {
          color: "transparent"
          height: 60
          visible: Dat.NotifServer.notifCount >= 1
          width: inbox.width
          z: 2

          Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: Dat.Colors.surface_container
            height: this.width
            layer.enabled: true
            radius: this.width
            width: 45

            layer.effect: MultiEffect {
              shadowEnabled: true
              shadowHorizontalOffset: 1
              shadowOpacity: 0.5
              shadowVerticalOffset: 1
            }

            Text {
              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              font.pointSize: 14
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
