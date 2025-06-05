pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  color: "transparent"

  property real scaleFactor: Dat.Globals.scaleFactor

  ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: spacing * scaleFactor
    spacing: 3 * scaleFactor

    Rectangle {
      Layout.fillWidth: true
      Layout.leftMargin: 20 * scaleFactor
      Layout.rightMargin: 20 * scaleFactor
      color: "transparent"
      implicitHeight: 18 * scaleFactor

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
              radius: 10 * scaleFactor
              width: tabText.contentWidth + (20 * scaleFactor)
            }

            Text {
              id: tabText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              horizontalAlignment: Text.AlignHCenter
              text: parent.modelData
              verticalAlignment: Text.AlignVCenter
              font.pointSize: 10 * scaleFactor

              Behavior on opacity {
                NumberAnimation {
                  duration: Dat.MaterialEasing.emphasizedTime
                  easing.bezierCurve: Dat.MaterialEasing.emphasized
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true

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

      Wid.PowerTab {
        Layout.fillHeight: true
        Layout.fillWidth: true
        opacity: visible ? 1 : 0

        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
          }
        }
      }

      Wid.AudioTab {
        Layout.fillHeight: true
        Layout.fillWidth: true
        opacity: visible ? 1 : 0

        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          }
        }
      }

      Rectangle {
        color: Dat.Colors.surface_container_high
        opacity: visible ? 1 : 0
        radius: 20 * scaleFactor

        Behavior on opacity {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedAccelTime
            easing.bezierCurve: Dat.MaterialEasing.emphasizedAccel
          }
        }

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_surface
          text: "Network Tab (unimplemented)"
          font.pointSize: 11 * scaleFactor
        }
      }
    }
  }
}
