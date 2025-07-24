import QtQuick

Text {
  id: userText

  property bool withText: false

  font.bold: true
  font.family: "Libre Barcode 128" + ((withText) ? " TEXT" : "")
  renderType: Text.NativeRendering
}
