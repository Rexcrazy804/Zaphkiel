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

  function toggleVisibility() {
    if (panel.visible) {
      cardbox.state = "Closed"
    } else {
      panel.visible = true
      grab.active = true
      cardbox.state = "Open"
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [ panel ]

    onActiveChanged: {
      if (!grab.active) {
        cardbox.state = "Closed"
      }
    }
  }


  ColumnLayout {
    id: cardbox
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 8

    state: (panel.debug)? "Open" : "Closed"
    states: [
      State {
        name: "Open"
        PropertyChanges { cardbox.opacity: 1 }
      },
      State {
        name: "Closed"
        PropertyChanges { cardbox.opacity: 0 }
      }
    ]

    onOpacityChanged: {
      if (opacity == 0) {
        panel.visible = false
        grab.active = false
      }
    }

    Behavior on opacity { 
      NumberAnimation { duration: 160 }
    }

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
          Layout.rightMargin: 5
          spacing: 10

          RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            spacing: 10

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
                Layout.fillWidth: true
                Layout.fillHeight: true

                required property var modelData
                node: modelData.node
                foregroundColor: modelData.colors[0]
                backgroundColor: modelData.colors[1]
                icon: modelData.icon
              }
            }
          }

          MprisWidget {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 4
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
            Image {
              fillMode: Image.PreserveAspectCrop
              width: parent.width
              height: this.width
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
