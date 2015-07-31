SimpleDialog {
    id: extdata

    property var path: ""
    property var resolvedPath:""

    property var datasets: []
    
    width: 550
    height: extdata.parent.height/2

    Button {
        property var tag: "top"
        text: "Загрузка данных.."
        width: 150
        onClicked: extdata.open();
    }

    ParamScopedUrlHashing {
      name: "datapath"
      target: extdata
      property: "path"
    }
    
    title: "Укажите источник"

    onAfterOpen: umt.perform();
    
    TabView {
        id: tabs

        Tab {
            title: "Суперкомпьютер"
            Umt {
                id: umt
                maxh: extdata.height-100
                maxw: extdata.width-200
            }
        }
        Tab {
            title: "Заготовки"
            Statica {
                maxh: extdata.height-100
                maxw: extdata.width-200
            }
        }
        Tab {
            title: "Url"
            Urla {
                maxw: extdata.width-200
            }
        }

    }
    
    onResolvedPathChanged: txt.text = extdata.resolvedPath;
    
    
    TextField {
      y: extdata.height-50
      x: 2
      id: txt
      width: extdata.width-200
      onAccepted: extdata.path = txt.text
    }

}
