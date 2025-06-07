import QtQuick
import QtQuick.Layouts
import "../Containers/" as Con

Item {
  id: root

  // why is this not in a the layout? well I need the Stack con to be above
  // this in terms of z value and I couldn't think of a better solution for the
  // time being I am out of time so please excuse me
  Con.RightPrimary {
    id: rightPrim
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.margins: 10
    anchors.leftMargin: 0
    width: 376

    onWidthChanged: {
      console.log(this.width);
    }
  }

  RowLayout {
    anchors.left: parent.left
    anchors.right: rightPrim.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
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

  }
}
