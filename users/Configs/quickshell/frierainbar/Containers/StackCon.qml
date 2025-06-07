pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Particles

import "../Data/" as Dat
import "../ParticleSystem/" as Psys
import "../Widgets/" as Wid

Item {
  id: root

  state: Dat.Globals.bgState

  states: [
    State {
      name: "SHRUNK"

      PropertyChanges {
        view.height: root.height
        view.visible: true
        view.width: root.width
      }
    },
    State {
      name: "FILLED"

      PropertyChanges {
        view.height: 0
        view.visible: false
        view.width: 0
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
          target: view
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedDecelTime
          easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
          properties: "height, width"
          target: view
        }
      }
    },
    Transition {
      from: "SHRUNK"
      to: "FILLED"

      SequentialAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedAccelTime
          easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          properties: "height, width"
          target: view
        }

        PropertyAction {
          property: "visible"
          target: view
        }
      }
    }
  ]

  Rectangle {
    anchors.fill: parent
    color: Dat.Colors.surface_container
    radius: 20
  }

  StackView {
    id: view

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    initialItem: freeRect

    popEnter: Transition {
      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          from: 0
          property: "opacity"
          to: 1
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedDecelTime * 2
          easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
          from: -350
          property: "y"
        }
      }
    }
    popExit: Transition {
      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          from: 1
          property: "opacity"
          to: 0
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedAccelTime
          easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          property: "y"
          to: 350
        }
      }
    }
    pushEnter: Transition {
      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          from: 0
          property: "opacity"
          to: 1
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedDecelTime
          easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
          from: 350
          property: "y"
        }
      }
    }
    pushExit: Transition {
      ParallelAnimation {
        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedTime
          easing.bezierCurve: Dat.MaterialEasing.emphasized
          from: 1
          property: "opacity"
          to: 0
        }
      }

      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedAccelTime
        easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
        property: "y"
        to: -350
      }
    }
    replaceEnter: Transition {
      ParallelAnimation {
        PropertyAnimation {
          duration: 0
          property: "opacity"
          to: 1
        }

        NumberAnimation {
          duration: Dat.MaterialEasing.emphasizedDecelTime
          easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
          from: 100
          property: "y"
        }
      }
    }
    replaceExit: Transition {
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedAccelTime
        easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
        from: 1
        property: "opacity"
        to: 0
      }
    }

    Component.onCompleted: Dat.Globals.stack = view
  }

  Psys.ContainerPsys {
  }

  Component {
    id: freeRect

    Item {
      height: view.height
      width: view.width

      Image {
        anchors.left: parent.left
        anchors.leftMargin: 90
        anchors.right: parent.right
        anchors.rightMargin: this.anchors.leftMargin
        anchors.top: parent.top
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        source: "../Assets/logo.png"
        width: parent.width * 0.6
      }

      Image {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -25
        anchors.right: parent.right
        anchors.rightMargin: -10
        fillMode: Image.PreserveAspectFit
        height: 419 * 0.65
        source: "../Assets/takeTheJourney.png"
        width: 596 * 0.65
      }
    }
  }
}
