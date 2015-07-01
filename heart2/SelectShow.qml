SelectDoubleClick {
  id: sel
  property var radius
  property var color

  Spheres {
    //opacity: 0.5
    property var pt: sel.source
    property var curPt: sel.currentIndex

    positions: pt.positions && curPt >= 0 ? pt.positions.slice( curPt*3, curPt*3+3 ) : []
    color: sel.color ? sel.color : pt.colors && curPt >= 0 ? pt.colors.slice( curPt*3, curPt*3+3 ) : []
    radius: sel.radius ? sel.radius : 0.3 + 0.1 * pt.radius * 3
    visible: positions.length>0
  }

}