Item {
    property int big: 1
    property var ctag: "right"
    
    anchors.fill: undefined
    x: parent.leftWidgets.right+15
    y: parent.height - height - 15
    width: parent.width - x - 10 - Math.max( parent.rightBottomWidgets.width, parent.rightWidgets.width ) - 10
    height: [ 0, 250, parent.height * 0.8 ][big]
    
    Button {
      text: "Размер графика"
      width: 150
      property var tag: ctag
      onClicked: big = (big+1)%3
    }    
}    