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
  property var popup
  property StackView view

  color: "transparent"
  height: bodyNActionCol.height

  onNotifChanged: {
    root.view?.clear();
    if (root.popup) {
      root.popup.closed = true;
    }
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

    ColumnLayout {
      id: bodyNActionCol

      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      spacing: 0

      Rectangle {
        Layout.fillWidth: true
        Layout.margins: 10
        color: "transparent"
        implicitHeight: sumText.contentHeight + bodText.contentHeight
        topLeftRadius: 20
        topRightRadius: 20

        Text {
          id: sumText

          anchors.top: parent.top
          color: Dat.Colors.primary
          text: root.notif?.summary ?? "summary"
        }

        Text {
          id: bodText

          anchors.top: sumText.bottom
          color: Dat.Colors.on_surface
          font.pointSize: 10
          text: root.notif?.body ?? "very cool body that is missing"
          textFormat: Text.MarkdownText
          width: parent.width
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
      }

      Flickable {
        id: flick
        Layout.alignment: Qt.AlignCenter
        Layout.bottomMargin: 10
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        contentWidth: actionRow.width
        implicitHeight: 23
        implicitWidth: bodyNActionCol.width - 20

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
