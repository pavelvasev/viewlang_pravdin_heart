Column {
    spacing: 10
    id: umt
    property var maxh: 100
    property var maxw: 300
    
    property bool asking: false

    //onAfterOpen: perform();
    
    property var mymethod: "find/hearts"

    function perform() {
        umt.asking = true;
        console.log( "asking umt server...");

        loadFile( addr.value + "/" + mymethod, function(data) {
            umt.asking = false;
            console.log("got server data=",data)
            output = parseJson( data );
            console.log("output=",output);
            combo.model = output[1];
            
        },
        function (err) {
            console.log("umt ajax error");
            umt.asking = false;
            combo.model = ["не удалось наладить связь с машиной"];
        }
        
        );
    }
    

    Row {
        spacing: 10
        TextParam {
            value: "http://umt.imm.uran.ru:7000"
            width: maxw
            id: addr
            guid: "data_server_addr"
            tag: undefined
            fastUpdate: true
        }
        
        Button {
            id: btn
            text: "Опросить"
            enabled: !umt.asking
            onClicked: umt.perform();
        }
    }

    Row {
        spacing: 5
        Text {
            text: "Статус: "
        }

        Text {
            text: umt.asking ? "опрашиваю машину..." : ("машина опрошена " + formatDateHuman())

            function formatDateHuman(d) {
                if (!d) d = new Date();
                function pad(num) {
                    var s = "000000000" + num;
                    return s.substr(s.length-2);
                }
                var f = pad(d.getHours()) + ":" + pad(d.getMinutes()) + ":" + pad(d.getSeconds()) + " " + pad(d.getDate()) + "/" + pad(1+d.getMonth()) + "/" + d.getFullYear() ;
                return f;
            }

            function formatDateBack(d) {
                if (!d) d = new Date();
                function pad(num) {
                    var s = "000000000" + num;
                    return s.substr(s.length-2);
                }
                var f = d.getFullYear() + "" + pad(1+d.getMonth()) + "" + pad(d.getDate()) + "-" + pad(d.getHours()) + "" + pad(d.getMinutes()) + "-" + pad(d.getSeconds());
                return f;
            }
        }
        
        ProgressBar {
            indeterminate: true
            visible: umt.asking
        }
    }


    Row {
        spacing: 10
        ComboBox {
            id: combo
            width: maxw
            size: 8
            height: maxh-50
            model: []
        }
        Button {
            text: "Загрузить выбор"
            width: 150
            onClicked: extdata.path = addr.value + "/" + combo.model[ combo.currentIndex ];
        }
    }

    
} // latest column
