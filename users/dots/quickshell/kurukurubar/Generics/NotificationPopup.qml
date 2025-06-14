import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

import "../Data/" as Dat
import "../Generics/" as Gen

// basically a clone of Notification.qml but this comes with a flickable

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
    acceptedButtons: Qt.MiddleButton
    anchors.fill: parent
    hoverEnabled: true

    onClicked: root.notif.dismiss()
    onEntered: root.popup?.closeTimer.stop()
    onExited: {
      if (root.view?.depth > 0) {
        root.popup?.closeTimer.restart();
      }
    }

    Flickable {
      anchors.fill: parent
      boundsBehavior: Flickable.StopAtBounds
      contentHeight: bodyNActionCol.height

      // height starts at 0 and I needa monitor it changing
      // also thanks to Aureus for this
      onHeightChanged: bodyNActionCol.implicitHeight = Math.max(bodyNActionCol.height, parent.height)

      ColumnLayout {
        id: bodyNActionCol

        anchors.top: parent.top
        spacing: 0
        width: parent.width

        Rectangle {
          Layout.fillWidth: true
          Layout.margins: 10
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

              Layout.maximumWidth: root.width * 0.8
              color: Dat.Colors.primary
              elide: Text.ElideRight
              text: root.notif?.summary ?? "summary"
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
          }
        }

        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: "transparent"
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
          // thanks to Aureus :>
          implicitWidth: Math.min(bodyNActionCol.width - 20, actionRow.width)
          visible: root.notif?.actions.length != 0

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
