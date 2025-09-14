module RollDice exposing (..)

import Browser
import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import Platform.Sub exposing (batch)
import Random exposing (..)
import String exposing (fromInt)


type alias Model =
    Int


type Msg
    = RollDice Int
    | Click


init () =
    ( 1, Cmd.none )


view model =
    div
        []
        [ text (fromInt model)
        , button [ onClick Click ] [ text "Roll Dice!" ]
        ]


update : Msg -> Model -> ( Model, Cmd.Cmd Msg )
update msg model =
    case msg of
        RollDice randomZahl ->
            ( randomZahl, Cmd.none )

        Click ->
            ( model, roll )


generator : Random.Generator Int
generator =
    Random.int 1 6


roll : Cmd Msg
roll =
    Random.generate RollDice generator


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
