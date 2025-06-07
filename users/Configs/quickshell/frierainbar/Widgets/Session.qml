import QtQuick

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  id: root

  property bool hovered: powerConMouse.containsMouse
  property string name: "ses"

  Text {
    color: Dat.Colors.secondary
    font.family: Dat.Fonts.hurricane
    font.pointSize: 24
    lineHeight: 0.5
    text: "Why didn't I try to get to know him better?"
    width: 300
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    x: 50
    y: 100
  }

  Image {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: -20
    anchors.horizontalCenter: parent.horizontalCenter
    fillMode: Image.PreserveAspectCrop
    source: "../Assets/sleepOnHimmel.png"

    Component.onCompleted: {
      const mult = 0.4;
      width = width * mult;
      height = height * mult;
    }
  }

  Item {
    id: powerCon

    anchors.centerIn: parent
    anchors.horizontalCenterOffset: 240
    anchors.verticalCenterOffset: -60
    // color: Dat.Colors.surface_container_high
    height: this.width
    // radius: this.width
    state: "HIDE"

    states: [
      State {
        name: "HIDE"

        PropertyChanges {
          exitIcon.color: Dat.Colors.on_primary
          powerButCon.dotSize: 46
          powerButCon.iconOpacity: 0
          powerCon.width: 50
        }
      },
      State {
        name: "REVEAL"

        PropertyChanges {
          exitIcon.color: Dat.Colors.on_surface
          powerButCon.dotSize: 56
          powerButCon.iconOpacity: 1
          powerCon.width: 170
        }
      }
    ]
    transitions: [
      Transition {
        from: "HIDE"
        to: "REVEAL"

        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedDecelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            property: "width"
            target: powerCon
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedDecelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
            property: "dotSize"
            target: powerButCon
          }

          ColorAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            target: exitIcon
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.type: Easing.Linear
            property: "iconOpacity"
            target: powerButCon
          }
        }
      },
      Transition {
        from: "REVEAL"
        to: "HIDE"

        ParallelAnimation {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccelTime
            property: "iconOpacity"
            target: powerButCon
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.expressiveDefaultSpatialTime
            easing.bezierCurve: Dat.MaterialEasing.expressiveDefaultSpatial
            property: "width"
            target: powerCon
          }

          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
            property: "dotSize"
            target: powerButCon
          }

          ColorAnimation {
            duration: Dat.MaterialEasing.standardTime
            easing.bezierCurve: Dat.MaterialEasing.standard
            target: exitIcon
          }
        }
      }
    ]

    MouseArea {
      id: powerConMouse

      anchors.fill: parent
      hoverEnabled: true

      onEntered: powerCon.state = "REVEAL"
      onExited: powerCon.state = "HIDE"

      Item {
        id: powerButCon

        property real dotSize: 40
        property real iconOpacity: 0

        anchors.fill: parent
        anchors.margins: 5

        Gen.SessionDot {
          function onClick() {
            Dat.SessionActions.suspend();
          }

          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
          icon: "bedtime"
          iconOpacity: powerButCon.iconOpacity
          width: parent.dotSize
        }

        Gen.SessionDot {
          function onClick() {
            Dat.SessionActions.reboot();
          }

          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          icon: "rotate_90_degrees_cw"
          iconOpacity: powerButCon.iconOpacity
          width: parent.dotSize
        }

        Gen.SessionDot {
          function onClick() {
            Dat.SessionActions.poweroff();
          }

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          icon: "skull"
          iconOpacity: powerButCon.iconOpacity
          width: parent.dotSize
        }

        Gen.SessionDot {
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          icon: "lock"
          iconOpacity: powerButCon.iconOpacity
          width: parent.dotSize

          // TODO lock screen function
        }
      }

      Item {
        anchors.centerIn: parent
        height: this.width
        width: 50

        Gen.MatIcon {
          id: exitIcon

          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          font.pointSize: 18
          icon: "logout"
        }
      }
    }
  }
}
