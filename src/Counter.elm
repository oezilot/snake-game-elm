module Counter exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import String exposing (fromInt)


type alias Counter =
    -- der aktuelle wert des counters
    Int



-- funktion um den counter um 1 zu erhöhen


inc : Counter -> Counter
inc counter =
    counter + 1


dec : Counter -> Counter
dec counter =
    counter - 1



-- html messages sind alle möglichen aktionen die man auf dem html machen kann als nutzer der das spiel besucht


type Msg
    = Inc
    | Dec
    | Reset



-- initialer wert des counters definieren


initialCounterValue : Counter
initialCounterValue =
    0



-- update-funktion (immer dann wann eine html-message vom browser zur app gechict wird muss darauf reagiert werden und das model upgedated werden!)


update : Msg -> Counter -> Counter
update msg counter =
    case msg of
        Inc ->
            inc counter

        Dec ->
            dec counter

        Reset ->
            0



-- counter darstellen (view-function)


render : Counter -> Html Msg
render counter =
    div []
        [ button [ onClick Dec ] [ text "-" ]
        , text (fromInt counter)
        , button [ onClick Inc ] [ text "+" ] -- das onclick ist eine html message was asgesendet wird falls der button gedrückt wird (bei diesem button wird die Inc-Message ausgesendet)
        , button [ onClick Reset ] [ text "reset" ]
        ]


main : Program () Counter Msg
main =
    Browser.sandbox
        { init =
            -- der input der mainfunktion, das model zu beginn
            initialCounterValue
        , update =
            -- if a message comes from tho browser
            update
        , view =
            -- if the model has changed: the input of this function will automatic be the global variable=initialstate which is contrantly changed
            render
        }



{-

    meine architektur:
    - model = counter
    - view = render
    - update = update

    --> html msg = html obj die messages generieren können
    --> msg = die gesendeten messages des browsers zum elm

   fragen:
   - zum testen -> repl

-}
