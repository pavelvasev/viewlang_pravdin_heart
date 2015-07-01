Item {
    function lin (ctx) {
      ctx.lineWidth = 3;
      ctx.shadowBlur=10;
      ctx.shadowOffsetX=2;
      ctx.shadowOffsetY=2;
      ctx.shadowColor="black";
      return 1;
    }      

    Component.onCompleted: parent.lineContext=lin;
}    