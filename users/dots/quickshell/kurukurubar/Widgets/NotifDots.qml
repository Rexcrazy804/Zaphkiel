import QtQuick
import QtQuick.Layouts

import qs.Data as Dat
import qs.Generics as Gen

Rectangle {
  implicitWidth: dotContainer.implicitWidth + 10

  RowLayout {
    id: dotContainer

    anchors.centerIn: parent

    Item {
      implicitHeight: this.implicitWidth
      implicitWidth: 28

      Gen.MatIcon {
        id: trashIcon

        property bool clearable: Dat.NotifServer.notifCount > 0

        anchors.centerIn: parent
        color: (clearable) ? Dat.Colors.on_surface : Dat.Colors.on_surface_variant
        fill: (clearable) ? 1 : 0
        icon: "delete"
      }

      Gen.MouseArea {
        layerColor: trashIcon.color
        layerRadius: parent.implicitWidth
        visible: trashIcon.clearable

        onClicked: Dat.NotifServer.clearNotifs()
      }
    }

    Gen.ToggleButton {
      active: !Dat.NotifServer.dndEnabled
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary
      implicitHeight: this.implicitWidth
      implicitWidth: 28
      radius: this.implicitWidth

      icon {
        icon: (this.active) ? "notifications_active" : "notifications_off"
      }

      mArea {
        onClicked: Dat.NotifServer.dndEnabled = !Dat.NotifServer.dndEnabled
      }
    }

    Gen.ToggleButton {
      id: idleButton

      active: Dat.SessionActions.idleInhibited
      activeColor: Dat.Colors.secondary
      activeIconColor: Dat.Colors.on_secondary
      implicitHeight: this.implicitWidth
      implicitWidth: 28
      radius: this.implicitWidth

      icon {
        icon: "coffee"
      }

      mArea {
        onClicked: Dat.SessionActions.toggleIdle()
      }
    }
  }
}
