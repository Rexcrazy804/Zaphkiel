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
  signal popupVisible(visbile: bool)
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
      panel.visible = this.active
      panel.popupVisible(panel.visible)
    }
  }

  function toggleVisibility() {
    if (panel.visible) { // uhh don't ask me why its like this I tried
      grab.active = false
      panel.visible = false
    } else {
      grab.active = true
      panel.visible = true
    }
  }

  ColumnLayout {
    id: cardbox
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 8

    Rectangle {
      color: Colors.withAlpha(Colors.background, 0.79)
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop
      implicitHeight: 200
      RowLayout {
        spacing: 0
        anchors.fill: parent
        Layout.alignment: Qt.AlignCenter

        ColumnLayout { // slider and mpris
          Layout.preferredWidth: 200
          Layout.fillHeight: true
          Layout.fillWidth: true
          Layout.horizontalStretchFactor: 2
          Layout.margins: 10

          SliderWidgets { 
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 25
            Layout.verticalStretchFactor: 1
            debug: panel.debug
          }

          Rectangle { // MPRIS + Settings
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.verticalStretchFactor: 3
            color: "#aa303030"
            border {
              color: (debug)? Colors.tertiary : "transparent"
              width: 3
            }

            Text {
              wrapMode: Text.WordWrap
              anchors.centerIn: parent
              color: Colors.primary
              text: "There is nothing here"
              font.pointSize: 16
            }
          }
        }

        ColumnLayout { // profile and Name
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.horizontalStretchFactor: 1
          Layout.margins: 10
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
            color: Colors.secondary
            Text {
              anchors.centerIn: parent
              color: Colors.on_secondary
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
      Layout.preferredHeight: childrenRect.height
      Layout.maximumHeight: Screen.height - this.y
      clip: true
      model: ListModel {
        id: data
        Component.onCompleted: () => {
          NotifServer.incomingAdded.connect(n => {
            data.insert(0, { notif: n });
          });

          // I wasted way too much tiem on this crap bro
          NotifServer.incomingRemoved.connect(id => {
            for (let i = 0; i < data.count; i++) {
              if (data.get(i).notif.id == id) {
                data.get(i).notif.dismiss()
                data.remove(i, 1)
              }
            }
          })
        }
      }
      delegate: NotificationEntry {
        id: toast
        width: parent?.width
        required property Notification modelData
        required property int index
        notif: modelData

        Component.onCompleted: () => {
          notif.closed.connect(() => {
            if (!toast || toast.index < 0) return;
            listView.model.remove(toast.index, 1);
          })
        }

        onDismissed: () => {
          if (!toast || toast.index < 0) return;
          listView.model.remove(toast.index, 1);
          toast.notif.dismiss()
        }
      }
    }
  }
}
