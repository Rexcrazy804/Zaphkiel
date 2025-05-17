import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import "../Data/" as Dat
import "../Generics/" as Gen

Repeater {
  model: [
    {
      icon: "",
      profile: PowerProfile.PowerSaver,
      action: event => PowerProfiles.profile = (PowerProfiles.profile != PowerProfile.PowerSaver) ? PowerProfile.PowerSaver : PowerProfile.Balanced
    },
    {
      icon: "",
      profile: PowerProfile.Performance,
      action: event => PowerProfiles.profile = (PowerProfiles.profile != PowerProfile.Performance) ? PowerProfile.Performance : PowerProfile.Balanced
    },
  ]

  delegate: Rectangle {
    id: dot

    property color bgColor
    property color fgColor
    required property var modelData

    Layout.alignment: Qt.AlignCenter
    color: dot.bgColor
    implicitHeight: this.implicitWidth
    implicitWidth: 20
    radius: 20

    // Component.onCompleted { }
    state: (modelData.profile == PowerProfiles?.profile) ? "ACTIVE" : "INACTIVE"

    states: [
      State {
        name: "ACTIVE"

        PropertyChanges {
          dot.bgColor: Dat.Colors.primary
          dot.fgColor: Dat.Colors.on_primary
        }
      },
      State {
        name: "INACTIVE"

        PropertyChanges {
          dot.bgColor: Dat.Colors.surface_container
          dot.fgColor: Dat.Colors.on_surface
        }
      }
    ]
    transitions: [
      Transition {
        from: "ACTIVE"
        reversible: true
        to: "INACTIVE"

        ColorAnimation {
          duration: Dat.MaterialEasing.standardTime
          easing.bezierCurve: Dat.MaterialEasing.standard
        }
      }
    ]

    Gen.MouseArea {
      layerColor: dot.fgColor

      onClicked: mevent => dot.modelData.action(mevent)
    }

    Text {
      anchors.centerIn: parent
      color: dot.fgColor
      font.bold: true
      font.pointSize: 8
      text: dot.modelData.icon
    }
  }
}
