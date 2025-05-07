import QtQuick
import Quickshell.Widgets
import Quickshell.Services.UPower
import "../Data/" as Dat
import "../Generics/" as Gen
import "../Assets/" as Ass

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

  delegate: ClippingRectangle {
    id: dot
    required property var modelData
    property color bgColor
    property color fgColor

    // Component.onCompleted { }
    state: (modelData.profile == PowerProfiles?.profile) ? "ACTIVE" : "INACTIVE"
    states: [
      State {
        name: "ACTIVE"
        PropertyChanges {
          dot.bgColor: Ass.Colors.primary
          dot.fgColor: Ass.Colors.on_primary
        }
      },
      State {
        name: "INACTIVE"
        PropertyChanges {
          dot.bgColor: Ass.Colors.surface_container
          dot.fgColor: Ass.Colors.on_surface
        }
      }
    ]

    transitions: [
      Transition {
        reversible: true
        from: "ACTIVE"
        to: "INACTIVE"

        ColorAnimation {
          duration: Dat.MaterialEasing.standardTime
          easing.bezierCurve: Dat.MaterialEasing.standard
        }
      }
    ]

    radius: 20
    implicitWidth: 20
    implicitHeight: this.implicitWidth
    color: dot.bgColor

    Gen.MouseArea {
      hoverOpacity: 0.3
      clickOpacity: 0.5
      layerColor: dot.fgColor
      onClicked: mevent => {
        dot.modelData.action(mevent);
        console.log(dot.state);
      }
    }

    Text {
      anchors.centerIn: parent
      text: dot.modelData.icon
      color: dot.fgColor
      font.bold: true
      font.pointSize: 8
    }
  }
}
