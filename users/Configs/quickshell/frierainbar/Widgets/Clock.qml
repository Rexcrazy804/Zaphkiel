import QtQuick
import "../Data/" as Dat

Rectangle {
  id: clock

  Rectangle {
    anchors.fill: parent
    // anchors.right: parent.right
    // anchors.rightMargin: 10
    // anchors.top: parent.top
    // anchors.topMargin: 10
    color: Dat.Colors.surface_container_high
    // height: this.width
    radius: 20

    // width: 260

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.tertiary
      font.family: Dat.Fonts.jpKaisei
      font.pointSize: 22
      text: "永遠の愛"
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: 3
      color: Dat.Colors.tertiary
      font.family: Dat.Fonts.glitch
      font.pointSize: 32
      text: "12"
    }

    Text {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 3
      anchors.horizontalCenter: parent.horizontalCenter
      color: Dat.Colors.tertiary
      font.family: Dat.Fonts.glitch
      font.pointSize: 32
      text: "6"
    }

    Text {
      anchors.right: parent.right
      anchors.rightMargin: 3
      anchors.verticalCenter: parent.verticalCenter
      color: Dat.Colors.tertiary
      font.family: Dat.Fonts.glitch
      font.pointSize: 32
      text: "3"
    }

    Text {
      anchors.left: parent.left
      anchors.leftMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      color: Dat.Colors.tertiary
      font.family: Dat.Fonts.glitch
      font.pointSize: 32
      text: "9"
    }

    Item {
      id: hoursHand

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      rotation: (360 * parseInt(Qt.formatDateTime(Dat.Clock?.date, "hh")) / 12) + (30 * (minutesHand.rotation) / 360)
      // rotation: 360 * 0 / 60
      width: 28

      Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height / 2

        Image {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          anchors.topMargin: -26
          antialiasing: true
          fillMode: Image.PreserveAspectFit
          height: this.width * 2
          mipmap: true
          rotation: 180
          source: "../Assets/frichibbi.png"
          width: 70
        }
      }
    }

    Item {
      id: minutesHand

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      rotation: (360 * parseInt(Qt.formatDateTime(Dat.Clock?.date, "mm")) / 60) + (6 * (secondsHand.rotation / 360))
      width: 28

      Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height / 2

        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          anchors.topMargin: 3
          color: Dat.Colors.tertiary
          height: 10
          radius: 10
          width: 10
        }
      }
    }

    Item {
      id: secondsHand

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height
      rotation: 360 * parseInt(Qt.formatDateTime(Dat.Clock?.date, "ss")) / 60
      width: 28

      Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: -7
        height: parent.height / 2

        Image {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          antialiasing: true
          fillMode: Image.PreserveAspectFit
          height: this.width * 2
          mipmap: true
          rotation: 180
          source: "../Assets/himchibbi.png"
          width: 60
        }
      }
    }
  }
}
