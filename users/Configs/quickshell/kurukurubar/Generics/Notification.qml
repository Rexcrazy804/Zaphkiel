import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  required property Notification notif
  property Rectangle popup
  property StackView view

  color: "transparent"
  height: (bodyText.contentHeight > 120)? bodyText.contentHeight + 50: 120

  onNotifChanged: {
    root.view?.clear();
  }

  MouseArea {
    acceptedButtons: Qt.NoButton
    anchors.fill: parent
    hoverEnabled: true

    onEntered: root.popup?.closeTimer.stop()
    onExited: {
      if (root.view?.depth > 0) {
        root.popup?.closeTimer.restart();
      }
    }

    RowLayout {
      anchors.fill: parent

      Rectangle {
        Layout.alignment: Qt.AlignTop
        Layout.leftMargin: 10
        Layout.topMargin: 10
        color: Dat.Colors.surface_container_low
        implicitHeight: 100
        implicitWidth: this.height
        radius: 20

        Image {
          id: notifIcon

          fillMode: Image.PreserveAspectCrop
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
            text: root.notif?.summary ?? "empty summary"
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

            color: Dat.Colors.on_surface
            elide: Text.ElideRight
            font.pointSize: 11
            text: root.notif?.body ?? "no body here"
            textFormat: Text.MarkdownText
            verticalAlignment: Text.AlignTop
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
          }
        }

        Rectangle {
          Layout.fillWidth: true
          color: "transparent"
          implicitHeight: 20
          visible: root.notif?.actions.length ?? false

          RowLayout {
            anchors.centerIn: parent
            height: parent.height

            Repeater {
              model: root.notif?.actions ?? null

              Rectangle {
                id: actionButton

                required property NotificationAction modelData

                color: Dat.Colors.surface_container_high
                height: 20
                radius: 20
                width: actionText.contentWidth + 10

                Text {
                  id: actionText

                  anchors.centerIn: parent
                  color: Dat.Colors.on_surface
                  text: actionButton.modelData.text
                }

                Gen.MouseArea {
                  onClicked: {
                    actionButton.modelData.invoke();
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
