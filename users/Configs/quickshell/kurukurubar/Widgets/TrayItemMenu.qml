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
  radius: 20

  ListView {
    id: view

    anchors.fill: parent
    spacing: 3

    delegate: Rectangle {
      id: entry

      property var child: QsMenuOpener {
        menu: entry.modelData
      }
      required property QsMenuEntry modelData

      color: (modelData?.isSeparator) ? Dat.Colors.outline : "transparent"
      height: (modelData?.isSeparator) ? 2 : 28
      radius: 20
      width: root.width

      Gen.MouseArea {
        layerColor: text.color
        visible: (entry.modelData?.enabled && !entry.modelData?.isSeparator) ?? true

        onClicked: {
          if (entry.modelData.hasChildren) {
            root.trayMenu = entry.child;
            view.positionViewAtBeginning();
          } else {
            entry.modelData.triggered();
          }
        }
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: "transparent"

          Text {
            id: text

            anchors.fill: parent
            color: (entry.modelData?.enabled) ? Dat.Colors.on_surface : Dat.Colors.primary
            font.pointSize: 11
            text: entry.modelData?.text ?? ""
            verticalAlignment: Text.AlignVCenter
          }
        }

        Rectangle {
          Layout.fillHeight: true
          color: "transparent"
          implicitWidth: this.height

          Image {
            anchors.fill: parent
            anchors.margins: 3
            fillMode: Image.PreserveAspectFit
            source: entry.modelData?.icon ?? ""
          }
        }

        Rectangle {
          Layout.fillHeight: true
          color: "transparent"
          implicitWidth: this.height
          visible: entry.modelData?.hasChildren ?? false

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            font.pointSize: 11
            text: ""
          }
        }
      }
    }
    model: ScriptModel {
      values: [...root.trayMenu.children.values]
    }
  }
}
