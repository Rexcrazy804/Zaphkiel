import QtQuick
import QtQuick.Layouts
import "../Data/" as Dat
import "../Containers/" as Con

Item {
  id: root

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10

    Con.ClockCon {
      Layout.fillHeight: true
      Layout.fillWidth: true
    }

    Con.StackCon {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 2
    }

    Con.RightPrimary {
      Layout.fillHeight: true
      Layout.fillWidth: true
    }
  }
}
