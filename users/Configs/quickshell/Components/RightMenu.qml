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
  height: cardbox.height

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
      Layout.preferredHeight: 205
      RowLayout {
        spacing: 5
        anchors.fill: parent

        ColumnLayout { // slider and mpris
          Layout.preferredWidth: 3
          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.margins: 10
          Layout.rightMargin: 0
          Layout.leftMargin: 5 // see, forwhatever reason after visual inspection 5 here likes to act like 10?
          spacing: 10

          RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            spacing: -2

            Repeater {
              model: [
                {
                  node: Audio.sink,
                  colors: [Colors.on_tertiary_container, Colors.tertiary_container],
                  icon: Audio.volIcon
                },
                {
                  node: Audio.source,
                  colors: [Colors.on_secondary_container, Colors.secondary_container],
                  icon: Audio.micIcon
                },
              ]

              GenericAudioSlider {
                required property var modelData
                node: modelData.node
                foregroundColor: modelData.colors[0]
                backgroundColor: modelData.colors[1]
                icon: modelData.icon

                Layout.fillWidth: true
                Layout.fillHeight: true
              }
            }
          }

          MonthGrid {
            id: cal
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 4

            delegate: Rectangle {
              id: calRect
              required property var model
              color: "transparent"

              Text {
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignVCenter
                opacity: model.month === cal.month ? 1 : 0.6
                text: calRect.model.day
                font: cal.font
                color: (model.month === cal.month && calRect.model.day == Time.data?.dayNumber)? Colors.tertiary : Colors.primary
              }
            }
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

    ListView { // Notification Inbox
      id: listView
      Layout.fillWidth: true
      Layout.minimumHeight: 0
      Layout.preferredHeight: childrenRect.height + 20
      Layout.maximumHeight: Screen.height * 0.95 - this.y
      clip: true
      model: NotifServer.notifications
      delegate: NotificationEntry {
        id: toast
        width: parent?.width
        required property Notification modelData
        notif: modelData

        // no destruction animation for now
        NumberAnimation on opacity {
          from: 0
          to: 1
          duration: 320
        }
      }
    }
  }
}
