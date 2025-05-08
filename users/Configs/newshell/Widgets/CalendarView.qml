pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Assets/" as Ass
import "../Data/" as Dat

Rectangle {
  property int index: SwipeView.index
  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10
    anchors.rightMargin: 5
    Rectangle {
      radius: 10
      Layout.fillHeight: true
      implicitWidth: 30
      color: Ass.Colors.secondary

      Text {
        id: monthText
        rotation: -90
        anchors.centerIn: parent
        text: Qt.formatDateTime(Dat.Clock?.date, "MMM")
        color: Ass.Colors.on_secondary
      }
    }
    MonthGrid {
      id: monthGrid
      property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1
      property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))

      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 0
      // Layout.leftMargin: 50
      // Layout.rightMargin: this.Layout.leftMargin
      // color: Ass.Colors.surface_container
      // color: "transparent"

      delegate: Rectangle {
        required property var model
        color: (monthGrid.currDay == model.day)? Ass.Colors.secondary : "transparent"
        radius: 10
        Text {
          anchors.centerIn: parent
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignVCenter
          text: parent.model.day
          color: (parent.model.month == monthGrid.currMonth)? (parent.model.day == monthGrid.currDay)? Ass.Colors.on_secondary : Ass.Colors.on_surface : Ass.Colors.withAlpha(Ass.Colors.on_surface_variant, 0.70)
        }
      }
    }
  }
}
