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
  color: "transparent"
  height: bodyNActionCol.height

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
        font.pointSize: 11
        text: root.notif?.body ?? "very cool body that is missing"
        textFormat: Text.MarkdownText
        width: parent.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
      }
    }

    Flickable {
      id: flick
      Layout.alignment: Qt.AlignRight
      Layout.bottomMargin: 10
      Layout.rightMargin: 10
      Layout.leftMargin: this.Layout.rightMargin
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
