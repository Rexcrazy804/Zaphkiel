import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat
import "../Widgets/" as Wid
import "../Generics/" as Gen

Rectangle {
  implicitWidth: dotContainer.implicitWidth + 10

  RowLayout {
    id: dotContainer

    anchors.centerIn: parent

    Rectangle {
      color: "transparent"
      implicitHeight: this.implicitWidth
      implicitWidth: 28
      radius: this.implicitWidth

      Text {
        id: trashIcon
        property bool clearable: Dat.NotifServer.notifCount > 0
        anchors.centerIn: parent
        color: Dat.Colors.on_surface
        text: (clearable)? "󰩹" : "󰩺"
      }

      Gen.MouseArea {
        visible: trashIcon.clearable
        layerColor: trashIcon.color

        onClicked: Dat.NotifServer.clearNotifs()
      }
    }

    Rectangle {
      color: "transparent"
      implicitHeight: this.implicitWidth
      implicitWidth: 28
      radius: this.implicitWidth

      Text {
        id: notifIcon
        anchors.centerIn: parent
        color: Dat.Colors.on_surface
        text: (Dat.NotifServer.dndEnabled)? "󰂛" : "󰂚"
      }

      Gen.MouseArea {
        layerColor: notifIcon.color
        onClicked: Dat.NotifServer.dndEnabled = !Dat.NotifServer.dndEnabled
      }
    }
  }
}
