import QtQuick.Controls 1.0

// Просто тупо тетраэдр из файла

Scene  {
    info: "Отображение тетраэдральной сетки сердечного желудочка. Укажите файл в формате GEO.<br>
         Двойной клик на изображении - выбрать тетраэдр.
  "

    property alias file: fs.file
    FileSelect {
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

                Tetramesh {
                    id:tetra
                    opacity: oParam.value/100
                    wire: wireParam.value > 0
                    visible: oParam.value > 0
                    property var originalTetraNumbers: parent.originalTetraNumbers
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

    /////////////// Работа с выбором мышкою

    Tetras {
        color: 0xff00
        id: sel
        positions: []
    }

    Spheres {
        id: selVersh
        positions: []
        color: 0xff00
        radius: 0.15
    }

    property var selected: []

    Text {
        property var tag: "left"
        text: selected.join(":")
        property var tag: "right"
    }

    Param {
      text: "Выбор"
      id: selTypeParam
      values: [null,"tetra","vershina"]
      value: selected.slice(0,1)[0]
      onValueChanged: selected = [ values[value], 0]
      property var tag: "right"
    }

    Param {
      text: "Номер вершины"
      id: vershinaNumParam
      value: selected.slice(1,1)[0]
      visible: selected[0] == "vershina"
      max: tetrar.positions.length/3-1
      onValueChanged: selected = ["vershina",value]
      property var tag: "right"
    }

    Param {
      text: "Номер тетраэдра"
      id: tetraNumParam
      value: selected[1]
      visible: selected[0] == "tetra"
      onValueChanged: selected = ["tetra",value]
      min: 0
      max: tetrar.indices.length/4-1
      property var tag: "right"
    }
    
    onSelectedChanged: {

        if (selected[0] !== "tetra") {
            sel.visible = false;
            sel.positions = [];
        }
        if (selected[0] !== "vershina") {
            //debugger;
            selVersh.visible = false;
            selVersh.positions = [];
        }

        if (selected[0] === "tetra") {
            //debugger;
            var a = [];
            var i = selected[1];
            for (var j=0; j< 4; j++) {
                a.push( tetra.positions[ 3*tetrar.indices[4*i+j] ] );
                a.push( tetra.positions[ 3*tetrar.indices[4*i+j]+1 ] );
                a.push( tetra.positions[ 3*tetrar.indices[4*i+j]+2 ] );
            }
            sel.visible = true;
            sel.positions = a;
        }
        else
        if (selected[0] === "vershina") {
            var i = selected[1];
            var a = [];
            a.push( tetra.positions[ 3*i ] );
            a.push( tetra.positions[ 3*i+1 ] );
            a.push( tetra.positions[ 3*i+2 ] );
            selVersh.positions = a;
            selVersh.visible = true;
        }
    }

    SceneMouseEvents {

        property var oldSm

        onPositionChanged: {
            //console.log(sceneMouse.x);
            /* при большом числе тетраэдров мышка все-равно убегает далеко
// так что нужно разбивать фигуру на мелкие под-фигуры и делать первый поиск по сферам (или еще как-то)
if (oldSm)  {
var t = sceneMouse.distanceToSquared(oldSm,sceneMouse);
// console.log(t,oldSm);
if (t < 0.01) return;
}
*/
            if (!event.ctrlKey) return;
            oldSm = sceneMouse.clone();
            select();
        }

        onDoubleClicked: {
            select();
        }

        function select() {
            //console.log("intersecting..");
            var r = tetra.visible ? tetra.intersect( sceneMouse ) : null;
            var p = vershinas.visible ? vershinas.intersect( sceneMouse ) : null;
            //debugger;
            console.log("intersect res",r,p);

            if (!r && !p) return doselect();

            if (!r) return doselect("vershina", p );
            if (!p) return doselect("tetra", r );

            if (r.distance < p.distance)
                return doselect("tetra", r );

            return doselect("vershina", p );
        }

        function doselect( who, r )
        {
            if (!who) {
                selected = [];
                return;
            }

            if (who == "tetra") {
                var r1 = originalTetraNumbers[r.faceIndex];

                if (selected[0] == "tetra" && selected[1] == r1) return;
                selected = ["tetra",r1 ];
            }
            else
            {
                var r1 = originalPointNumbers[r.index];

                if (selected[0] == "vershina" && selected[1] == r1) return;
                selected = ["vershina",r1 ];
            }
        }

    } // SceneMouseEvents

}
