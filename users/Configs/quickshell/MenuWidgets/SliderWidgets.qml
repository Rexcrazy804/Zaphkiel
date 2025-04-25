import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../Data"

RowLayout {
  required property bool debug
  spacing: 20
  VolumeSlider {}
  MicSlider {}
}

