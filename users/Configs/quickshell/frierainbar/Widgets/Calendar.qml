pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  property string name: "cal"

  // onYChanged: {
  //   console.log(y);
  // }

  Item {
    id: calContainer
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.margins: 10
    anchors.right: serImg.left
    anchors.top: parent.top

    ColumnLayout {
      anchors.fill: parent

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        RowLayout {
          anchors.fill: parent

          Item {
            Layout.fillHeight: true
            // just to ignore random warnings
            implicitWidth: (this.height > 0) ? this.height : 1

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true

              onClicked: {
                if (monthGrid.month == 0) {
                  monthGrid.year -= 1;
                  monthGrid.month = 11;
                } else {
                  monthGrid.month -= 1;
                }
              }
              onEntered: leftIcon.fill = 1
              onExited: leftIcon.fill = 0
            }

            Gen.MatIcon {
              id: leftIcon

              anchors.centerIn: parent
              color: Dat.Colors.secondary
              font.pointSize: 25
              icon: "arrow_circle_left"
            }
          }

          Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text {
              anchors.fill: parent
              color: Dat.Colors.secondary
              font.bold: true
              font.family: Dat.Fonts.rye
              font.pointSize: 16
              horizontalAlignment: Text.AlignHCenter
              text: monthGrid.title
              verticalAlignment: Text.AlignVCenter
            }
          }

          Item {
            Layout.fillHeight: true
            // just to ignore random warnings
            implicitWidth: (this.height > 0) ? this.height : 1

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true

              onClicked: {
                if (monthGrid.month == 11) {
                  monthGrid.year += 1;
                  monthGrid.month = 0;
                } else {
                  monthGrid.month += 1;
                }
              }
              onEntered: rightIcon.fill = 1
              onExited: rightIcon.fill = 0
            }

            Gen.MatIcon {
              id: rightIcon

              anchors.centerIn: parent
              color: Dat.Colors.secondary
              font.pointSize: 25
              icon: "arrow_circle_right"
            }
          }
        }
      }

      MonthGrid {
        id: monthGrid

        property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))
        property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 8
        spacing: 4

        delegate: Rectangle {
          id: dayRect

          required property var model

          color: (monthGrid.currDay == model.day && monthGrid.currMonth == model.month) ? Dat.Colors.secondary : Dat.Colors.surface_container_highest
          radius: 10

          Text {
            anchors.centerIn: parent
            color: (monthGrid.currDay == model.day && monthGrid.currMonth == model.month) ? Dat.Colors.on_secondary : (parent.model.month == monthGrid.month) ? Dat.Colors.on_surface_variant : Dat.Colors.withAlpha(Dat.Colors.on_surface_variant, 0.70)
            font.family: Dat.Fonts.rye
            font.pointSize: 15
            horizontalAlignment: Text.AlignVCenter
            text: parent.model.day
            verticalAlignment: Text.AlignVCenter
          }
        }
        Behavior on month {
          SequentialAnimation {
            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              from: 1
              property: "opacity"
              target: monthGrid
              to: 0
            }

            PropertyAction {
              property: "month"
            }

            NumberAnimation {
              duration: Dat.MaterialEasing.standardTime
              easing.bezierCurve: Dat.MaterialEasing.standard
              from: 0
              property: "opacity"
              target: monthGrid
              to: 1
            }
          }
        }
      }
    }
  }

  Item {
    id: dayNameText

    anchors.left: serImg.left
    anchors.right: parent.right
    anchors.rightMargin: 18
    anchors.top: parent.top
    anchors.topMargin: 18
    height: 40

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.secondary
      font.family: Dat.Fonts.hurricane
      font.pointSize: 32
      text: Qt.formatDateTime(Dat.Clock?.date, "dddd")
    }
  }

  Image {
    id: serImg

    anchors.bottom: parent.bottom
    anchors.bottomMargin: -20
    anchors.right: parent.right
    anchors.rightMargin: 15
    antialiasing: true
    mipmap: true
    smooth: true
    source: "../Assets/seriesit.png"

    Component.onCompleted: {
      width = width * 0.49;
      height = height * 0.49;
    }
  }
}
