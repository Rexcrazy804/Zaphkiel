pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  required property QsMenuOpener trayMenu
  clip: true
  color: Dat.Colors.surface_container

  ListView {
    anchors.fill: parent
    model: root.trayMenu.children
    spacing: 3

    delegate: Rectangle {
      required property QsMenuEntry modelData

      color: (modelData?.isSeparator) ? Dat.Colors.outline : "transparent"
      height: (modelData?.isSeparator) ? 2 : 28
      width: root.width
      radius: 20

      Gen.MouseArea {
        layerColor: text.color
        onClicked: {
          parent.modelData.triggered()
        }
      }

      Text {
        id: text
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        anchors.leftMargin: 10
        color: Dat.Colors.on_surface
        text: parent.modelData?.text ?? ""
        font.pointSize: 11
      }
    }
  }
}
