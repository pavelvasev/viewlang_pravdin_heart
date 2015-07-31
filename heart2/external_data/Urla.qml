Row 
{
        property var maxw: 300        

        spacing: 10
        TextField {
            placeholderText: "введите URL каталога данных"
            id: txt
            width: maxw
        }
        Button {
            text: "Загрузить выбор"
            width: 150
            onClicked: extdata.path = txt.text
        }
}

