import QtQuick
import QtQuick.Layouts

import qs.Data as Dat
import qs.Containers as Con

Rectangle {
  id: root

  color: Dat.Colors.withAlpha(Dat.Colors.surface, 0.9)
  radius: 20

  RowLayout {
    anchors.fill: parent
    spacing: 0

    Con.CentralSwipable {
      Layout.fillHeight: true
      Layout.fillWidth: true
    }

    KuruKuru {
      Layout.fillHeight: true
      Layout.fillWidth: true
    }
  }
}
