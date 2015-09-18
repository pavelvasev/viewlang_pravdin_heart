import "."

// Выбор чего угодно двойным кликом мышки
Item {
  id: item
  property var source: parent
  property var currentIndex: -1
  property var currentPos: null
  property alias text: txt

  property var mode: 1

/*  
  Spheres {
    positions: currentPos || []
    id: sel
    color: scen.points.colors && curPt >= 0 ? scen.points.colors.slice( curPt*3, curPt*3+3 ) : []
    radius: 0.3 + 0.1 * scen.points.radius * 3
    visible: positions.length>0
  }
*/  

  function doIntersect( setCenter ) {
      var r = source.intersect( sceneMouse );
      //console.log(r);
      if (r) {
        currentIndex = r.index;
        currentPos = [ r.point.x, r.point.y, r.point.z ];
        // выставляем центр поворота камеры
        
        /* это отстой. лучше сделаем по отдельной кнопке
        if (setCenter) {
          var rootScene = findRootScene(this);
          console.log( "rootScene=",rootScene);
          if (rootScene) rootScene.cameraCenter = currentPos;
        }
        */
      }
      else
      {
        currentIndex = -1;
        currentPos = null;
      }
  }

  SceneMouseEvents {
    onDoubleClicked: if (mode == 1 || (mode == 2 && event.ctrlKey)) doIntersect(event.ctrlKey);
    onPositionChanged: if ((mode == 1 && event.altKey) || (mode == 2 && event.ctrlKey)) doIntersect(event.ctrlKey);
  }
  
  Text {
    y:3
    id: txt
    text: (mode == 1 ? "Двойной клик на сцене или движение с нажатым Alt" : "Движение мышки с нажатым Ctrl") + " - выбор. Сейчас выбрано: N"+ (currentIndex+1)
    property var tag: "top"
  }
 
  Component.onCompleted: {
    document.addEventListener('keydown', function(e) {
       // e.ctrlKey && 
       if ( ( String.fromCharCode(e.which) === 'c' || String.fromCharCode(e.which) === 'C' ) ) {
          var rootScene = findRootScene(item);
          if (rootScene && currentPos) rootScene.cameraCenter = currentPos;
       }
    }, false);
  
  }

}
