import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Data/" as Dat
import "../Widgets" as Wid

Item {
  id: root

  state: Dat.Globals.bgState

  states: [
    State {
      name: "SHRUNK"

      AnchorChanges {
        anchors.left: root.left
        target: base
      }

      PropertyChanges {
        base.opacity: 1
        base.visible: true
      }
    },
    State {
      name: "FILLED"

      AnchorChanges {
        anchors.left: root.right
        target: base
      }

      PropertyChanges {
        base.opacity: 0
        base.visible: false
      }
    }
  ]
  transitions: [
    Transition {
      from: "FILLED"
      to: "SHRUNK"

      SequentialAnimation {
        PropertyAction {
          property: "visible"
          target: base
        }

        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.5
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            property: "opacity"
            target: base
          }

          AnchorAnimation {
            duration: Dat.MaterialEasing.emphasizedTime * 1.5
            easing.bezierCurve: Dat.MaterialEasing.emphasized
            targets: [base]
          }
        }
      }
    },
    Transition {
      from: "SHRUNK"
      to: "FILLED"

      SequentialAnimation {
        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "opacity"
            target: base
          }

          AnchorAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            targets: [base]
          }
        }

        PropertyAction {
          property: "visible"
          target: base
        }
      }
    }
  ]

  Rectangle {
    id: base

    anchors.bottom: parent.bottom
    anchors.top: parent.top
    color: Dat.Colors.surface_container
    radius: 20
    width: root.width

    ColumnLayout {
      anchors.fill: parent
      spacing: 0

      Wid.StackController {
        id: controller

        Layout.fillWidth: true
        implicitHeight: 55
        Layout.margins: 10
      }

      Wid.Mpris {
        Layout.fillHeight: true
        Layout.fillWidth: true
      }
    }
  }
}
