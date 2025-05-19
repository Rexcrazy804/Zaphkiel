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
  Behavior on x {
    SmoothedAnimation {}
  }
  onXChanged: {
    root.opacity = 1 - (Math.abs(root.x) / width)
  }

  MouseArea {
    id: dragArea
    anchors.fill: parent
    drag {
      target: parent
      axis: Drag.XAxis

      onActiveChanged: {
        if (dragArea.drag.active) { return }
          if ( Math.abs(root.x) > (root.width / 2)) {
            root.notif.dismiss()
          } else {
            root.x = 0
          }
      }
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

      RowLayout {
        id: infoRow
        anchors.top: parent.top
        height: sumText.contentHeight
        width: parent.width
        Text {
          Layout.maximumWidth: root.width * 0.8
          id: sumText

          elide: Text.ElideRight

          color: Dat.Colors.primary
          text: root.notif?.summary ?? "summary"
        }

        Rectangle {
          Layout.alignment: Qt.AlignRight
          implicitHeight: appText.contentHeight + 2
          implicitWidth: appText.contentWidth + 10
          radius: 20
          color: "transparent"
          Text {
            anchors.centerIn: parent
            id: appText
            color: Dat.Colors.tertiary
            text: root.notif?.appName ?? "idk"
            font.pointSize: 8
            font.bold: true
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

    Flickable {
      visible: root.notif?.actions.length != 0
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
