import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat
import "../Widgets/" as Wid
import "../Generics/" as Gen

Rectangle {
  property real scaleFactor: Dat.Globals.scaleFactor

  implicitWidth: dotContainer.implicitWidth + 10 * scaleFactor

  RowLayout {
    id: dotContainer

    anchors.centerIn: parent

    Rectangle {
      color: "transparent"
      implicitWidth: 28 * scaleFactor
      implicitHeight: implicitWidth
      radius: implicitWidth / 2

      Gen.MatIcon {
        id: trashIcon

        property bool clearable: Dat.NotifServer.notifCount > 0

        anchors.centerIn: parent
        color: clearable ? Dat.Colors.on_surface : Dat.Colors.on_surface_variant
        fill: clearable ? 1 : 0
        icon: "delete"
      }

      Gen.MouseArea {
        layerColor: trashIcon.color
        visible: trashIcon.clearable

        onClicked: Dat.NotifServer.clearNotifs()
      }
    }

    Gen.ToggleButton {
      implicitWidth: 28 * scaleFactor
      implicitHeight: implicitWidth
      radius: implicitWidth / 2

      active: !Dat.NotifServer.dndEnabled
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary

      icon {
        icon: active ? "notifications_active" : "notifications_off"
      }

      mArea {
        onClicked: Dat.NotifServer.dndEnabled = !Dat.NotifServer.dndEnabled
      }
    }

    Gen.ToggleButton {
      id: idleButton

      implicitWidth: 28 * scaleFactor
      implicitHeight: implicitWidth
      radius: implicitWidth / 2

      active: Dat.SessionActions.idleInhibited
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary

      icon {
        icon: "coffee"
      }

      mArea {
        onClicked: Dat.SessionActions.toggleIdle()
      }
    }
  }
}
