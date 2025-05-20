pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: root

  required property int index
  property var menu: Wid.TrayItemMenu {
    height: root.stack.height
    trayMenu: trayMenu
    width: root.stack.width
  }
  required property SystemTrayItem modelData
  required property var stack

  color: "transparent"
  implicitHeight: trayItemIcon.implicitSize
  implicitWidth: this.implicitHeight

  IconImage {
    id: trayItemIcon

    anchors.centerIn: parent
    implicitSize: 16
    source: root.modelData.icon

    // too blurry for now
    // layer.enabled: true
    // layer.effect: MultiEffect {
    //   colorizationColor: Dat.Colors.secondary
    //   colorization: 1.0
    //   antialiasing: true
    //   smooth: true
    // }

    MouseArea {
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      anchors.fill: parent

      onClicked: mevent => {
        if (mevent.button == Qt.LeftButton) {
          root.modelData.activate();
          return;
        }
        if (!root.modelData.hasMenu) {
          return;
        }

        if (root.stack.depth > 1) {
          if (root.stack.currentItem == root.menu) {
            // unwind nesting
            if (root.menu.trayMenu != trayMenu) {
              root.menu.trayMenu = trayMenu;
              return;
            }
            root.stack.pop();
          } else {
            root.stack.replace(root.menu, StackView.PopTransition);
          }
        } else {
          root.stack.push(root.menu);
        }
      }
    }
  }

  QsMenuOpener {
    id: trayMenu

    menu: root.modelData.menu
  }
}
