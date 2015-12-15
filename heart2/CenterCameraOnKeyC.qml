Item {
  property var currentPos: parent.currentPos

  Component.onCompleted: {
    document.addEventListener('keydown', function(e) {
       // e.ctrlKey && 
       if ( ( String.fromCharCode(e.which) === 'r' || String.fromCharCode(e.which) === 'R' ) ) {
          var rootScene = findRootScene(item);
          if (rootScene && currentPos) rootScene.cameraCenter = currentPos;
       }
    }, false);
  
  }
}  