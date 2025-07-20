// https://m3.material.io/styles/typography/editorial-treatments#a8196c1e-387e-4303-b0bf-b9bac44e4e72
// a thin wrapper for placing using Material Symbols
// credit to end for leading me down this route
import QtQuick
import qs.Data as Dat

Text {
  id: root

  property real fill: 0
  property int grad: 0
  required property string icon

  font.family: "Material Symbols Rounded"
  font.hintingPreference: Font.PreferFullHinting
  font.variableAxes: {
    "FILL": root.fill,
    "opsz": root.fontInfo.pixelSize,
    "GRAD": root.grad,
    "wght": root.fontInfo.weight
  }
  renderType: Text.NativeRendering
  text: root.icon

  Behavior on fill {
    NumberAnimation {
      duration: Dat.MaterialEasing.standardTime
      easing.bezierCurve: Dat.MaterialEasing.standard
    }
  }
}
