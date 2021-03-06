ECG {
  id: ecg

  fileParam.parent: coco

  
 
  GroupBox {
    title: "ЭКГ"
    property var tag: "right"
    Column {
    spacing:5
    id: coco
  TextParam {
    id: xx
    text: "Координаты через пробел"
    //sliderEnabled: false
    fastUpdate: true
    tag: "right"
    value: "0 0 0"
  }
  Button {
    text: "Загрузить "+ (coords ? coords.join(",") : "")
    onClicked: {
      var dir = typeof(presetDataDir) == "undefined" ? "http://umt.imm.uran.ru:7001/temp/v1-testdata/" : presetDataDir;
      var urla = dir + "/ECGinput.dat?ecgonly=1&x=" + coords[0] + "&y=" + coords[1] + "&z=" + coords[2];
      ecg.file = urla;
    }
  }
  /*
  CheckBoxParam {
    id: cmShowSphere
    text: "Показать сферу"
    value: 1
  }*/
  Param {
    text: "Показать сферу"
    id: cmShowSphereR
    max: 5
    step: 0.25
    value: 1
    comboEnabled:false
  }

  }
  }
  
  property var coords: {
    if (!xx.value) return [0,0,0]
    var s1 = xx.value.split("=");
    var nums = s1[ s1.length-1 ].split(" ");
    var acc = [];
    acc.push( parseInt( nums[0] ) );
    acc.push( parseInt( nums[1] ) );
    acc.push( parseInt( nums[2] ) );
    return acc;
  }

  Spheres {
    positions: coords
    onPositionsChanged: console.log(positions)
    //color: [1,1,0]
    color: ecg.color
    radius: cmShowSphereR.value * cmShowSphereR.value
    visible: radius > 0 //cmShowSphere.checked
  }
  
}