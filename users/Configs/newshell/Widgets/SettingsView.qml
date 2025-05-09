pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"
  ColumnLayout {
    anchors.fill: parent
    spacing: 3
    anchors.topMargin: this.spacing

    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 20
      Layout.rightMargin: 20
      implicitHeight: 20
      color: "transparent"

      RowLayout {
        id: tabLay
        property int activeIndex: 0
        anchors.fill: parent
        Repeater {
          model: ["Power", "Audio", "Network"]
          Rectangle {
            id: tabRect
            required property string modelData
            required property int index
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            state: (index == tabLay.activeIndex) ? "ACTIVE" : "INACTIVE"
            states: [
              State {
                name: "ACTIVE"
                PropertyChanges {
                  tabText.opacity: 1
                  bgRect.opacity: 1
                }
              },
              State {
                name: "INACTIVE"
                PropertyChanges {
                  tabText.opacity: 0.8
                  bgRect.opacity: 0
                }
              }
            ]

            transitions: [
              Transition {
                from: "INACTIVE"
                to: "ACTIVE"

                NumberAnimation {
                  properties: "bgRect.opacity,tabText.opacity"
                  duration: Dat.MaterialEasing.emphasizedAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
                }
              },
              Transition {
                from: "ACTIVE"
                to: "INACTIVE"

                NumberAnimation {
                  properties: "bgRect.opacity,tabText.opacity"
                  duration: Dat.MaterialEasing.emphasizedDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                }
              }
            ]

            Rectangle {
              id: bgRect
              anchors.bottom: parent.bottom
              anchors.left: parent.left
              anchors.right: parent.right
              radius: 10
              height: tabRect.height

              color: Ass.Colors.surface_container_high
            }

            Text {
              id: tabText

              Behavior on opacity {
                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                }
              }

              anchors.centerIn: parent
              text: parent.modelData
              color: Ass.Colors.on_surface
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                // TODO hover animation
                // onContainsMouseChanged: parent.opacity += (containsMouse)? 0.2 : -0.2
                onClicked: mevent => {
                  tabLay.activeIndex = tabRect.index;
                }
              }
            }
          }
        }
      }
    }

    StackLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: tabLay.activeIndex

      Wid.PowerTab {}

      Repeater {
        // TODO: props for volume sliders and network (veeeery unlikely i'll be doing network impl here)
        model: 2

        Rectangle {
          required property int index
          radius: 20
          color: Ass.Colors.surface_container_high

          Text {
            anchors.centerIn: parent
            text: "tab " + index
            color: Ass.Colors.on_surface
          }
        }
      }
    }
  }
}
