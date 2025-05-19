import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

import "../Data/" as Dat
import "../Generics/" as Gen

// basically a clone of notification popup but this comes with a flickable

Rectangle {
  id: root

  required property Notification notif
  required property var popup
  required property StackView view

  color: "transparent"

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

    Flickable {
      anchors.fill: parent
      contentHeight: bodyNActionCol.height

      ColumnLayout {
        id: bodyNActionCol
        anchors.top: parent.top
        width: parent.width
        spacing: 0

        Component.onCompleted: {
          if (bodyNActionCol.height < 200) {
            bodyNActionCol.height = 128
          }
        }

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
            font.pointSize: 11
            text: root.notif?.body ?? "very cool body that is missing"
            textFormat: Text.MarkdownText
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
          }
        }

        Rectangle {
          color: "transparent"
          Layout.fillWidth: true
          Layout.fillHeight: true
        }

        Flickable {
          id: flick

          Layout.alignment: Qt.AlignRight
          Layout.bottomMargin: 10
          Layout.leftMargin: this.Layout.rightMargin
          Layout.rightMargin: 10
          boundsBehavior: Flickable.StopAtBounds
          clip: true
          contentWidth: actionRow.width
          implicitHeight: 23
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
}
