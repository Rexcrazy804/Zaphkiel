import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Widgets/" as Wid

Rectangle {
  id: root
  clip: true
  radius: 20
  color: Ass.Colors.withAlpha(Ass.Colors.surface, 0.9)

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
      Layout.fillWidth: true
      Layout.fillHeight: true
      radius: root.radius
    }

    KuruKuru {
      Layout.fillWidth: true
      Layout.fillHeight: true
      radius: root.radius
    }
  }
}
