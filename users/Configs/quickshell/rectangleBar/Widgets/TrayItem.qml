import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

IconImage {
  id: root
  required property SystemTrayItem item

  source: root.item.icon
  implicitSize: 15
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: event => {
      switch (event.button) {
        case Qt.LeftButton: root.item.activate(); break;
        case Qt.RightButton: 
          if (root.item.hasMenu) {
            const window = QsWindow.window;
            // the bellow is kinda hard coded, find a better solution
            const widgetRect = window.contentItem.mapFromItem(root, 80, root.height + 10 , root.width, root.height);
            menuAnchor.anchor.rect = widgetRect;
            menuAnchor.open();
          } 
          break;
      }
    }
  }
  QsMenuAnchor {
    id: menuAnchor
    menu: root.item.menu
    anchor.window: root.QsWindow.window?? null
    anchor.adjustment: PopupAdjustment.Flip
  }
}
