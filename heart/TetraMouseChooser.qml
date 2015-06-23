Item {
  id: tetraChooser

  property var source
  property var selected

  property var togetherWith
  property var enabled: true

  SceneMouseEvents {
      onDoubleClicked: {
          if (!tetraChooser.enabled) return; // если совместный режим, а мы не мастер - выходим
          select();
      }
  } // scene mouse
  
  function select(onlyIntersect) {
    var r = source.visible ? source.intersect( sceneMouse ) : null;
    console.log("2=>",r,source,sceneMouse);

    if (onlyIntersect) return r;
    
    if (togetherWith) {
       var bestR = r ? r : null;
       var bestObj = r ? this : null;

       for (var i=0; i<togetherWith.length; i++) {
         var res = togetherWith[i].select( true );
         if (res) {
           if (!bestR || res.distance < bestR.distance) {
             bestR = res;
             bestObj = togetherWith[i];
           }
         }
       } // for

       // дезактивируем всех остальных   
       for (var i=0; i<togetherWith.length; i++)  {
         //if (togetherWith[i] !== bestObj) 
         console.log( "Дизактивируем ",togetherWith );
         togetherWith[i].applySelect( null );
       }

       //if (this !== bestObj) 
       console.log("Дизактивируем себя",this );
       applySelect( null );

       // активируем победителя
       if (bestR) {
          console.log("Активируем победителя obj=",bestObj,"bestR=",bestR);
          bestObj.applySelect( bestR );
       }
       else
         console.log("Никого не активируем");

       return;
    }
    
    applySelect( r );
  }

  function applySelect( r ) {
    
    tetraChooser.selected = r ? (r.faceIndex || r.index) : null;
  }
  

}
