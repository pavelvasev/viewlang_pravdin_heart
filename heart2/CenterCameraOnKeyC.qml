Item {
  property var currentPos: parent.currentPos

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