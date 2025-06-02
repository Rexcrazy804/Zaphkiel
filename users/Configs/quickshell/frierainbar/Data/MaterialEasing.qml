pragma Singleton
import Quickshell

Singleton {
  id: root

  // thanks to Soramane :>
  // expressive curves => thanks end cutie ;)
  readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
  readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
  readonly property int emphasizedAccelTime: 200
  readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
  readonly property int emphasizedDecelTime: 400
  readonly property int emphasizedTime: 500
  readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
  readonly property int expressiveDefaultSpatialTime: 500
  readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
  readonly property int expressiveEffectsTime: 200
  readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1]
  readonly property int expressiveFastSpatialTime: 350
  readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
  readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
  readonly property int standardAccelTime: 200
  readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
  readonly property int standardDecelTime: 250
  readonly property int standardTime: 300
}
