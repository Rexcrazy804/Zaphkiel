import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat

Rectangle {
  id: root

  clip: true
  color: Dat.Colors.withAlpha(Dat.Colors.surface, 0.9)
  radius: 20

  RowLayout {
    anchors.fill: parent
    spacing: 0

    // ColumnLayout { // left dots (TODO: make the fonts look better??)
    //   Layout.fillWidth: true
    //   Layout.fillHeight: true
    //   Layout.minimumWidth: 28
    //   Layout.maximumWidth: 28
    //
    //   Wid.SessionDots {}
    //   Wid.PowerProfDots {
    //     Layout.bottomMargin: 10
    //   }
    // }

    CentralPane {
      Layout.fillHeight: true
      Layout.fillWidth: true
      radius: root.radius
    }
    KuruKuru {
      Layout.fillHeight: true
      Layout.fillWidth: true
      radius: root.radius
    }
  }
}
