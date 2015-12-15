Item {
  anchors.fill: parent
  CheckBoxParam {
    text: "Добавить ЭКГ"
    width: 150
    id: cbekg
    tag: "right"
  }
  Loader {
    source: Qt.resolvedUrl("ECGUMT.qml")
    active: cbekg.checked
    onLoaded: scen.findRootSpace().refineAll()
  }
}  