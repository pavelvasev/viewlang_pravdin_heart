Row {
        property var maxh: 100
        property var maxw: 300        

        spacing: 10
        ComboBox {
            id: combo
            width: maxw
            size: 8
            height: maxh
            model: extdata.datasets
            Component.onCompleted: {
              console.log("************ extdata.datasets=",extdata.datasets);
            }
        }
        Button {
            text: "Загрузить выбор"
            width: 150
            onClicked: extdata.path = combo.model[ combo.currentIndex ];
        }
    }

