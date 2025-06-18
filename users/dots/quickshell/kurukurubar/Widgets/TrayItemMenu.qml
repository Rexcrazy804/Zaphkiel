pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: root

  required property QsMenuOpener trayMenu

  Behavior on trayMenu {
    SequentialAnimation {
      NumberAnimation {
        target: root
        property: "opacity"
        from: 1
        to: 0
        duration: Dat.MaterialEasing.standardTime
        easing.bezierCurve: Dat.MaterialEasing.standard
      }
      PropertyAction {
        target: root
        property: "trayMenu"
      }
      NumberAnimation {
        target: root
        property: "opacity"
        from: 0
        to: 1
        duration: Dat.MaterialEasing.standardDecelTime
        easing.bezierCurve: Dat.MaterialEasing.standardDecel
      }
    }
  }

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
        anchors.leftMargin: (entry.modelData?.buttonType == QsMenuButtonType.None) ? 10 : 2
        anchors.rightMargin: 10

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: entry.modelData?.buttonType == QsMenuButtonType.CheckBox

          Gen.MatIcon {
            anchors.centerIn: parent
            color: Dat.Colors.primary
            fill: entry.modelData?.checkState == Qt.Checked
            font.pixelSize: parent.width * 0.8
            icon: (entry.modelData?.checkState != Qt.Checked) ? "check_box_outline_blank" : "check_box"
          }
        }

        // untested cause nothing I use have radio buttons
        // if you use this and find somethings wrong / "yes rexi everything is fine" lemme know by opening an issue
        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: entry.modelData?.buttonType == QsMenuButtonType.RadioButton

          Gen.MatIcon {
            anchors.centerIn: parent
            color: Dat.Colors.primary
            fill: entry.modelData?.checkState == Qt.Checked
            font.pixelSize: parent.width * 0.8
            icon: (entry.modelData?.checkState != Qt.Checked) ? "radio_button_unchecked" : "radio_button_checked"
          }
        }

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

        Item {
          Layout.fillHeight: true
          implicitWidth: this.height
          visible: entry.modelData?.icon ?? false

          Image {
            anchors.fill: parent
            anchors.margins: 3
            fillMode: Image.PreserveAspectFit
            source: entry.modelData?.icon ?? ""
          }
        }

        Item {
          Layout.fillHeight: true
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
      values: [...root.trayMenu?.children.values]
    }
  }
}
