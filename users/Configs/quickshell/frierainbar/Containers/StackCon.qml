pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import "../Data/" as Dat

Item {
  id: root

  StackView {
    id: view
    anchors.fill: parent
    initialItem: freeRect
  }

  Component {
    id: freeRect
    Rectangle {
      width: root.width
      height: root.height
      radius: 20

      color: Dat.Colors.surface_container

      ColumnLayout {
        anchors.fill: parent
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Image {
            anchors.fill: parent
            source: "https://upload.wikimedia.org/wikipedia/commons/d/d5/S%C5%8Ds%C5%8D_no_Frieren_logo.png"
            fillMode: Image.PreserveAspectFit
          }
        }
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true
        }
      }
    }
  }
}
