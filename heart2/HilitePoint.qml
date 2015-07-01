Spheres {
    opacity: 0.6

    property var source // Point object
    property var num  // point num

    property var pt: source
    property var curPt: num

    positions: pt.positions && curPt >= 0 ? pt.positions.slice( curPt*3, curPt*3+3 ) : []
    color: pt.colors && curPt >= 0 ? pt.colors.slice( curPt*3, curPt*3+3 ) : []
    radius: 0.3 + 0.1 * pt.radius * 3
    visible: positions.length>0
}