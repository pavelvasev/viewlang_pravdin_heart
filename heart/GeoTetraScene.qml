import QtQuick.Controls 1.0

// Просто тупо тетраэдр из файла

Scene  {
    info: "Отображение тетраэдральной сетки сердечного желудочка. Укажите файл в формате GEO.<br>
         Двойной клик на изображении - выбрать тетраэдр.
  "
 
    id: theScene

    property alias file: fs.file
//    property alias file
    FileParam {
        text: "Укажите файл *.GEO"
        property var tag: "left"
        id: fs
    }

    Param {
        id: wireParam
        title: "wire on"
        values: ["нет","да"]
    }
    Param {
        id: oParam
        title: "opacity"
        min:0
        max:100
        value:100
    }
    Param {
        id: vParam
        title: "Вершины"
        values: ["нет","да"]
        value:1
    }
    
    Param {
        id: ptcParam
        title: "Точки в центрах"
        min:0
        max:1
        value:0
        //visible: false
    }

    TetrameshGeoLoad {
        //src: "init0.geo"
        src: Qt.resolvedUrl( fs.file )

        TetrameshRotate {
            id: tetrar
            
            TetrameshZFilter {
                id: tetraz

                Tetramesh {
                    title: "Main body of zheludochek after ZFilter"
                    id:tetra
                    opacity: oParam.value/100
                    wire: wireParam.value > 0
                    visible: oParam.value > 0
                    // shading: paramShading.value
                }

                TetrameshCenters {
                    Points {
                        visible: ptcParam.value > 0
                    }
                }


                Points {
                    id: vershinas
                    // тут тупо все точки..
                    color: [0.5,0,0]
                    visible: vParam.value == 1

                    positions: compute ? compute[0] : []
                    property var originalPointNumbers: compute ? compute[1] : []
                    property var compute: makeit()

                    function makeit() {
                        var origs = [];
                        console.log("making vershinas")

                        var k = tetra.indices.length;
                        var arr = [];
                        var added = {};
                        // индексы идут по 4 чиселки на тетраэдр
                        // а еще нам надо помнить оригинальные номера
                        // бежим по каждой вершинке
                        for (var i=0; i<k; i++) {
                            var n = tetra.indices[i];
                            // n - номер вершины в массиве вершин tetra.positions
                            if (!added[n]) { // если мы ее еще недобавляли
                                arr.push( tetra.positions[3*n] );
                                arr.push( tetra.positions[3*n+1] );
                                arr.push( tetra.positions[3*n+2] );
                                // запомним, что эта вершина в точках соответствует номеру n в массиве tetra.positions
                                origs.push( n );
                                added[n] = 1;
                            }
                        }
                        return [arr,origs];
                    }
                }

            } // zfilter
        } // rotate

    } // geoload

    ////////////// Работа с подсветкой
    property alias hiliteTetras: tetrh.hiliteTetras
    TetraHilite {
      id: tetrh
      source: tetrar
    }
    TetraMouseChooser {
      enabled: false
      id: selTetraMouseHilited
      source: tetrh
      onSelectedChanged: {
//        console.log("Выбранное selected изменено selected=",selected);
        if (selected === null) {
          selectedTetra = -1;
          return;
        }
        console.log("Клик на подсвеченный тетраэдр N",selected);
        selectedTetra = tetrh.hiliteTetras[selected];
        console.log("ориг. нумерация ",selectedTetra);        
        //selectedTetra = tetraz.originalTetraNumbers[ selected ];
      }
    }    
    

    /////////////// Работа с выбором 
    
    property var selectedTetra
    onSelectedTetraChanged: {
      selTetraCombo.selected = selectedTetra;
    }

    TetraComboChooser {
      id: selTetraCombo
      source: tetrar
      onSelectedChanged: selectedTetra = selected;
    }
    TetraMouseChooser {
      id: selTetraMouse
      source: tetra
      onSelectedChanged: {
        selectedTetra = (selected === null ? -1 : tetraz.originalTetraNumbers[ selected ])
      }
      //enabled: false
      togetherWith: [selPointMouse,selTetraMouseHilited ]
    }
    
    ////////////////////// точка
    property var selectedPoint

    onSelectedPointChanged: selPointCombo.selected = selectedPoint

    PointComboChooser {
      id: selPointCombo
      source: tetrar
      onSelectedChanged: selectedPoint = selected;
    }
    TetraMouseChooser {
      enabled: false
      id: selPointMouse
      source: vershinas
      onSelectedChanged: {
        selectedPoint = (selected === null ? -1 : vershinas.originalPointNumbers[ selected ])
      }
    }
    
      
}
