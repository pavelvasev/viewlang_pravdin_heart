Tetras {
  id: sel

  color: 0xff0000
//  wire: true

  positions: []
  
  Text {
    text: "Подсветить тетраэдры NN"
    property var tag: "left"
  }

  property var hiliteTetras: []

  onHiliteTetrasChanged: hiliteTetrasEdit.text = hiliteTetras.join(" ")
  
  Row {
    property var tag: "left"
    TextInput {
      width: 150
      id: hiliteTetrasEdit
    }
    Button {
      text: "Ввод"
      onClicked: {
        hiliteTetras = hiliteTetrasEdit.text.split(/\s+/).map( function(f) { return parseInt(f) } );
        perform();
      }
    }
  }

  function perform() {
        if (!hiliteTetras || hiliteTetras.length <= 0) {
            sel.visible = false;
            sel.positions = [];
            return;
        }
        var a = [];
        for (var k=0; k<hiliteTetras.length; k++) {
          var i = hiliteTetras[k];
          for (var j=0; j< 4; j++) {
            a.push( source.positions[ 3*source.indices[4*i+j] ] );
            a.push( source.positions[ 3*source.indices[4*i+j]+1 ] );
            a.push( source.positions[ 3*source.indices[4*i+j]+2 ] );
          }
        }
        sel.visible = true;
        sel.positions = a;
        console.log("Подсвечены тетраэдры NN",hiliteTetras );
  }

}  