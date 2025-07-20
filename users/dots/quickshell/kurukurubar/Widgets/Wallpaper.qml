import QtQuick
import qs.Data as Dat

Image {
  antialiasing: true
  asynchronous: true
  fillMode: Image.PreserveAspectCrop
  layer.enabled: true
  retainWhileLoading: true
  smooth: true
  source: Dat.Config.data.wallSrc
}
