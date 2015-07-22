## Запуск

http://viewlang.ru/viewlang/scene.html?s=https://github.com/pavelvasev/viewlang_pravdin_heart/blob/master/heart2/scene4.vl

## Наборы данных

Данные можно объединять в готовые наборы.
Каждый набор размещается в отдельном каталоге.

Каталог должен содержать файлы с именами:
```
coord.txt
tipsHans.info
triangles.txt
voltage_.json
```
Разрешается размещать не все файлы. 

После того как набор создан, надо указать его в переменной datasets в файле сцены [scene4.vl](scene4.vl)
```
  property var datasets: ["","data","data1-simmetric","data2-non-simm","https://dl.dropboxusercontent.com/u/523104/data1-simmetric-fun/"]
```

## Где разместить набор

Каталог можно размещать не только в этом репозитории, а вообще где угодно, лишь бы это было доступно по сети (без CORS-ограничений).
Например, в других репозиториях или на дропбоксе.

[Инструкция по размещению в Dropbox](https://docs.google.com/document/d/1U0NMxt4eFm__sdlOe6_9aS-SN91IZSTx1qpakbBXsq8/edit?usp=sharing)

## Как записать видео

С помощью http://www.screencast-o-matic.com/screen_recorder
