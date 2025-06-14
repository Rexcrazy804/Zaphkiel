import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Hyprland

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  required property Notification notif

  color: "transparent"
  height: bodyNActionCol.height

  Behavior on x {
    SmoothedAnimation {
    }
  }

  onXChanged: {
    root.opacity = 1 - (Math.abs(root.x) / width);
  }

  MouseArea {
    id: dragArea

    acceptedButtons: Qt.MiddleButton | Qt.LeftButton
    anchors.fill: parent

    onClicked: mevent => {
      if (mevent.button == Qt.MiddleButton) {
        root.notif.dismiss();
      }
    }

    drag {
      axis: Drag.XAxis
      target: parent

      onActiveChanged: {
        if (dragArea.drag.active) {
          return;
        }
        if (Math.abs(root.x) > (root.width * 0.45)) {
          root.notif.dismiss();
        } else {
          root.x = 0;
        }
      }
    }
  }

  RowLayout {
    id: bodyNActionCol

    anchors.left: parent.left
    anchors.margins: 10
    anchors.right: parent.right
    anchors.top: parent.top
    spacing: 10

    Item {
      Layout.alignment: Qt.AlignTop
      implicitHeight: 60
      implicitWidth: this.implicitHeight
      visible: root.notif?.image ?? false

      Image {
        id: notifIcon

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        source: root.notif?.image ?? ""
        visible: false
      }

      MultiEffect {
        anchors.fill: notifIcon
        antialiasing: true
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
          radius: 10
          width: notifIcon.width
        }
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true

      Rectangle {
        Layout.fillWidth: true
        color: "transparent"
        implicitHeight: sumText.contentHeight + bodText.contentHeight
        topLeftRadius: 20
        topRightRadius: 20

        RowLayout {
          id: infoRow

          anchors.top: parent.top
          height: sumText.contentHeight
          width: parent.width

          Text {
            id: sumText

            Layout.maximumWidth: ((root.width - notifIcon.width) * 0.75)
            color: Dat.Colors.primary
            elide: Text.ElideRight
            text: root.notif?.summary ?? "Kokomi"
          }

          Rectangle {
            Layout.alignment: Qt.AlignRight
            color: "transparent"
            implicitHeight: appText.contentHeight + 2
            implicitWidth: appText.contentWidth + 10
            radius: 20

            Text {
              id: appText

              anchors.centerIn: parent
              color: Dat.Colors.tertiary
              font.bold: true
              font.pointSize: 8
              text: root.notif?.appName ?? "idk"
            }
          }
        }

        Text {
          id: bodText

          anchors.top: infoRow.bottom
          color: Dat.Colors.on_surface
          font.pointSize: 11
          text: root.notif?.body ?? "very cool body that is missing"
          textFormat: Text.MarkdownText
          width: parent.width
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere

          MouseArea {
            id: bodMArea

            acceptedButtons: Qt.LeftButton
            anchors.fill: parent

            // thanks end_4 for this <3
            onClicked: {
              const hovLink = bodText.hoveredLink;
              if (hovLink == "") {
                return;
              }
              Hyprland.dispatch("exec xdg-open " + hovLink);
            }
          }
        }
      }

      Flickable {
        id: flick

        Layout.alignment: Qt.AlignRight
        Layout.bottomMargin: 20
        Layout.leftMargin: this.Layout.rightMargin
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        contentWidth: actionRow.width
        implicitHeight: 23
        // thanks to Aureus :>
        implicitWidth: Math.min(bodyNActionCol.width - 20, actionRow.width)

        RowLayout {
          id: actionRow

          anchors.right: parent.right
          height: parent.height

          Repeater {
            model: root.notif?.actions

            Rectangle {
              required property NotificationAction modelData

              Layout.fillHeight: true
              color: Dat.Colors.secondary
              implicitWidth: actionText.contentWidth + 14
              radius: 20

              Text {
                id: actionText

                anchors.centerIn: parent
                color: Dat.Colors.on_secondary
                font.pointSize: 11
                text: parent.modelData?.text ?? "activate"
              }

              Gen.MouseArea {
                layerColor: actionText.color

                onClicked: parent.modelData.invoke()
              }
            }
          }
        }
      }
    }
  }
}
