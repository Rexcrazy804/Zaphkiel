import QtQuick

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  property string name: "aud"

  Image {
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: "../Assets/methode.png"
    verticalAlignment: Image.AlignTop
  }

  Item {
    anchors.topMargin: 150
    anchors.right: parent.right
    anchors.top: parent.top
    height: 100
    width: 300

    Text {
      anchors.fill: parent
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.WrapAtWordBoundaryOrAnywhere
      text: "I have a spell that lets you see through clothes"
      font.family: Dat.Fonts.hurricane
      font.pointSize: 24
      color: Dat.Colors.secondary
    }
  }

  Gen.AudioSlider {
    anchors.bottomMargin: 160
    anchors.leftMargin: -120
    rotation: -90
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    width: parent.height - 40
    node: Dat.Audio.sink
  }
}
