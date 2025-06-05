pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Data/" as Dat

Rectangle {
  property int index: SwipeView.index

  // Get screen and scaling
  property real scaleFactor: Dat.Globals.scaleFactor


  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10 * scaleFactor
    anchors.rightMargin: 5 * scaleFactor

    ColumnLayout {
      Layout.fillHeight: true
      Layout.minimumWidth: 30 * scaleFactor
      spacing: 0

      // Day rectangle
      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 18 * scaleFactor
        radius: 20 * scaleFactor
        bottomLeftRadius: 0
        bottomRightRadius: 0
        color: Dat.Colors.primary_container

        Text {
          id: weekDayText
          anchors.centerIn: parent
          color: Dat.Colors.on_primary_container
          font.pointSize: 8 * scaleFactor
          text: Qt.formatDateTime(Dat.Clock?.date, "ddd")
        }
      }

      // Month rectangle
      Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        radius: 10 * scaleFactor
        topLeftRadius: 0
        topRightRadius: 0
        color: Dat.Colors.primary

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          font.pointSize: 10 * scaleFactor
          rotation: -90
          text: Qt.formatDateTime(Dat.Clock?.date, "MMM")
        }
      }
    }

    MonthGrid {
      id: monthGrid

      property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))
      property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1

      Layout.fillHeight: true
      Layout.fillWidth: true
      spacing: 0

      delegate: Rectangle {
        required property var model

        radius: 10 * scaleFactor
        color: (monthGrid.currDay == model.day && monthGrid.currMonth == model.month)
               ? Dat.Colors.primary : "transparent"

        Text {
          anchors.centerIn: parent
          font.pointSize: 8 * scaleFactor
          text: parent.model.day
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: (parent.model.month == monthGrid.currMonth)
                 ? (parent.model.day == monthGrid.currDay
                    ? Dat.Colors.on_primary
                    : Dat.Colors.on_surface)
                 : Dat.Colors.withAlpha(Dat.Colors.on_surface_variant, 0.70)
        }
      }
    }
  }
}
