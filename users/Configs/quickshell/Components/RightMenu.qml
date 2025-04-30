pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import Quickshell.Hyprland
import "../Data"
import "../MenuWidgets"
import "../Assets"

PopupWindow {
  id: panel
  property bool debug: false
  required property PanelWindow bar
  color: "transparent"
  visible: debug
  anchor.window: bar
  anchor.rect.x: bar.width - width - 10
  anchor.rect.y: bar.height + 10
  width: 480
  height: (panel.visible)? cardbox.height : 1

  HyprlandFocusGrab {
    id: grab
    windows: [ panel ]

    onActiveChanged: { 
      if (!grab.active) {
        panel.visible = false
      }
    }
  }

  onVisibleChanged: {
    if (visible) {
      grab.active = true
    }
  }

  ColumnLayout {
    id: cardbox
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 8

    Rectangle { // FIRST CARD
      color: Colors.withAlpha(Colors.background, 0.79)
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
      Layout.preferredHeight: 205
      RowLayout { 
        spacing: 10
        anchors.fill: parent
        Layout.alignment: Qt.AlignCenter

        ColumnLayout { // slider and mpris
          Layout.preferredWidth: 3
          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.margins: 10
          Layout.rightMargin: 0
          spacing: 10

          SliderWidgets { 
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            spacing: 10
            debug: panel.debug
          }

          RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 3
            spacing: 10
          }
        }

        ColumnLayout { // profile and Name
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredWidth: 1
          Layout.margins: 10
          Layout.leftMargin: 0
          spacing: 5

          Rectangle { // profile
            color: "transparent"
            Layout.alignment: Qt.AlignCenter 
            Layout.preferredWidth: 150
            Layout.preferredHeight: 150
            IconImage {
              implicitSize: parent.width
              source: "root:Assets/.face.icon"
            }
          }

          Rectangle { // User Name
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            Layout.topMargin: 0
            color: Colors.primary
            Text {
              anchors.centerIn: parent
              color: Colors.on_primary
              text: "Rexiel Scarlet"
              font.italic: true
              font.bold: true
              font.pointSize: 12
            }
          }
        }
      }
    }

    RowLayout { // notif bar
      visible: NotifServer.notifCount
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      spacing: 0

      Rectangle {
        Layout.fillHeight: true
        Layout.preferredWidth: notifText.width + 10
        color: Colors.secondary
        Text {
          anchors.centerIn: parent
          id: notifText
          color: Colors.on_secondary
          text: "Notifications"
        }
      }

      Rectangle {
        color: Colors.withAlpha(Colors.background, 0.79)
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

      Rectangle {
        Layout.fillHeight: true
        Layout.preferredWidth: clearText.width + 16
        color: Colors.secondary
        Text {
          anchors.centerIn: parent
          id: clearText
          color: Colors.on_secondary
          text: "󰎟"
          font.pointSize: 16

        }

        MouseArea {
          anchors.fill: parent
          onClicked: () => {
            NotifServer.clearNotifs()
          }
        }
      }
    }

    ListView { // Notification Inbox
      id: listView
      Layout.fillWidth: true
      Layout.minimumHeight: 0
      Layout.preferredHeight: childrenRect.height
      Layout.maximumHeight: Screen.height * 0.95 - this.y
      clip: true
      model: NotifServer.notifications
      delegate: NotificationEntry {
        id: toast
        width: parent?.width
        required property Notification modelData
        notif: modelData
      }
    }
  }
}
