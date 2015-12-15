ScatterPlot {
  anchors.fill:parent
  z: 20
  //color: [1,0,1]

  ScatterSolidLine { }

  independentFromTree: true
  
  property alias file: fs.file
  property alias fileParam: fs

  color: [0.7,0,0.7] // purple
  //color: [0.9,0.9,0] //yellow
  
  FileParam {
    id: fs
    text: "Файл ЭКГ *.dat"
    tag: "right"
    //showChosenFile: false
  }
  
  CsvLoader {
    file: fs.file
    id: loader
  }

  positions: {
    if (!loader.output || !loader.output.length) return [];
    if (!loader.output[0]) return;

    // если в данных только 1 колонка - добавим слева еще одну, для X
    if (loader.output[0].length == 1) {
      var newarr = loader.output.map( function(line,index) { return [index,line[0]] } );
      //console.log(">>>>>>>>>>>>>>",newarr);
      return newarr;
    }
    return loader.output;
  }

}