## Build js-file
bei mir
- input_file = `./src/Snake.elm`
- destination_path = `./output/Snake.js`

1. `elm make inputfile_path --output=destinatio_path`

## Run 
- elm reactor

run with debugger, see the model when running (dieser command erstellt ein html-file welches man in den browser ziehen sollte mit drag und drop)
- elm make src/MoveSvg.elm --debug 

## verbesserungen
- schlange kann nicht über den rand hinaus
- shclange bewegt sich immer um eine einheit
- einheiten allgemein
- apfel der immer weiter abgebissen wird iii
- reihenfolge der einzelnen svgschichten
- svg image statt hml element
- kein freeze nachdem isGrowing auf true gesetzt wird

## koordinatensystem vpn elm
- nullpunkt = oben, links
- x-achse = links bis rechts = negativ bis positv
- koordinatenpunkt kreis = mittelpunkt
- koordinatenpunkt = ecke oben links