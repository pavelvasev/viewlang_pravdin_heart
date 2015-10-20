ScatterPlot {
  anchors.fill:parent
  
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