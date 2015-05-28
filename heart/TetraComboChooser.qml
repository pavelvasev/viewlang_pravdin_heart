Item {

    property var source
    property var selected

    function setselected( n ) {
        selected = n;
    }

    Param {
      id: tetraParam
      text: "Номер тетраэдра"
      value: selected
      onValueChanged: selected = value
      min: -1
      max: source ? source.indices.length/4-1 : 0
      property var tag: "right"
//      enableSliding: false
    }

    Tetras {
        color: 0xff00
        id: sel
        positions: []
    }

    Spheres {
        positions: sel.positions
        radius: 0.1
    }
    
    /*
    Text {
      property var tag: "right"
      height: 50
      text: { 
        var t = "Координаты тетраэдра<br/><table><tr>";
        for (var i=0; i<sel.positions.length; i++)
        {
          if (i % 3 == 2) 
            t = t + "</tr><tr>";
          t = t + "<td>" + sel.positions[i] + "</td>";
        }
        t = t + "</table>";
        //sel.positions.join(" ")
        return t;
      }
    }
    */

    onSelectedChanged: {
        tetraParam.value = selected;

        if (!selected || selected < 0) {
            sel.visible = false;
            sel.positions = [];
            return;
        }
        var a = [];
        var i = selected;
        for (var j=0; j< 4; j++) {
            a.push( source.positions[ 3*source.indices[4*i+j] ] );
            a.push( source.positions[ 3*source.indices[4*i+j]+1 ] );
            a.push( source.positions[ 3*source.indices[4*i+j]+2 ] );
        }
        sel.visible = true;
        sel.positions = a;
        console.log("Выбран тетраэдр N",selected," координаты: ",a );
    }

}
