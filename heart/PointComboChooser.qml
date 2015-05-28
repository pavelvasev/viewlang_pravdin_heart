Item {

    property var source
    property var selected

    Param {
      id: tetraParam
      text: "Номер вершины"
      value: selected
      onValueChanged: selected = value
      min: -1
      max: source ? source.positions.length/3-1 : 0
      property var tag: "right"
      //enableSliding: false
    }

    Spheres {
        id: selVersh
        positions: []
        color: 0xff00
        radius: 0.15
    }

    onSelectedChanged: {
        tetraParam.value = selected;

        if (!selected || selected < 0) {
            selVersh.visible = false;
            selVersh.positions = [];
            return;
        }
            var i = selected;
            var a = [];
            a.push( tetra.positions[ 3*i ] );
            a.push( tetra.positions[ 3*i+1 ] );
            a.push( tetra.positions[ 3*i+2 ] );
            selVersh.positions = a;
            selVersh.visible = true;
            console.log("Выбрана точка N",selected," координаты: ",a );            
    }

}
