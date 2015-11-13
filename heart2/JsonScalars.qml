import "."

// Загрузка скалярных значений и построение цветов по ним. 
// Значения должны идти ф вормате json вида: [ [массив t=0], [массив t=1], ..., [массив t=N] ]
// где массив это массив интересующих значений.

Item {
  id: scen
  
  property alias file: valParam.value
  property alias valFile: valParam.value
  property alias output: pal.output

  FileParam {
    text: "Файл скалярных значений"
//    file: Qt.resolvedUrl("data/voltage_.json")
    id: valParam
  }

  JsonLoader {
    id: loader
    file: valFile
  }
  
  property var   scalars: loader.output
  property var   current: scalars ? (scalars[t] || []) : []

  property alias t: tParam.value
  
  Text {
    text: "Кол-во шагов (t):" + scalars.length
    property var tag:"left"
  }

  Param {
    text: "Текущее время t"
    max: scalars.length-1
    id: tParam
    color: "cyan"
  }
  
  property alias paletter: pal
  Paletter {
    input: current
    id: pal
    useMin: minmaxer.min
    useMax: minmaxer.max
    //revert: true
  }

  MinMax {
    input: scalars
    id: minmaxer
    
  }

}
