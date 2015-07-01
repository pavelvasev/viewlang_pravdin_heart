// подстветка текущего t на графике
Rectangle { 
 property var gra: parent
 property var t: 0

        width: 6
        opacity: 0.5
        height: gra.height-30
        x: gra.chartBorderSize + gra.chartWidth * (t/(gra.positions ? gra.positions.length-1 :1) )  -3
        y:0
        z:100
        color: "lime"
        id: ra
        visible: (gra.selection[1]-gra.selection[0] >= 0.999)
}
