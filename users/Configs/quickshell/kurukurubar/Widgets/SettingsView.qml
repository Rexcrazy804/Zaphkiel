pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat

Rectangle {
  color: "transparent"

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: this.spacing
    spacing: 3

    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 20
      Layout.rightMargin: 20
      color: "transparent"
      implicitHeight: 20

      RowLayout {
        id: tabLay

        property int activeIndex: Dat.Globals.settingsTabIndex

        anchors.fill: parent

        Repeater {
          model: ["Power", "Audio", "Network"]

          Rectangle {
            id: tabRect

            required property int index
            required property string modelData

            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            state: (index == tabLay.activeIndex) ? "ACTIVE" : "INACTIVE"

            states: [
              State {
                name: "ACTIVE"

                PropertyChanges {
                  bgRect.opacity: 1
                  tabText.opacity: 1
                }
              },
              State {
                name: "INACTIVE"

                PropertyChanges {
                  bgRect.opacity: 0
                  tabText.opacity: 0.8
                }
              }
            ]
            transitions: [
              Transition {
                from: "INACTIVE"
                to: "ACTIVE"

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
                  properties: "bgRect.opacity,tabText.opacity"
                }
              },
              Transition {
                from: "ACTIVE"
                to: "INACTIVE"

                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasizedDecel
                  properties: "bgRect.opacity,tabText.opacity"
                }
              }
            ]

            Rectangle {
              id: bgRect

              anchors.centerIn: parent
              color: Dat.Colors.surface_container_high
              height: tabRect.height
              radius: 10
              width: tabText.contentWidth + 20
            }
            Text {
              id: tabText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              horizontalAlignment: Text.AlignHCenter
              text: parent.modelData
              verticalAlignment: Text.AlignVCenter

              Behavior on opacity {
                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                // TODO hover animation
                // onContainsMouseChanged: parent.opacity += (containsMouse)? 0.2 : -0.2
                onClicked: mevent => {
                  Dat.Globals.settingsTabIndex = tabRect.index;
                }
              }
            }
          }
        }
      }
    }
    StackLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      currentIndex: tabLay.activeIndex

      PowerTab {
      }
      Repeater {
        // TODO: props for volume sliders and network (veeeery unlikely i'll be doing network impl here)
        model: 2

        Rectangle {
          required property int index

          color: Dat.Colors.surface_container_high
          radius: 20

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            text: "tab " + index
          }
        }
      }
    }
  }
}
