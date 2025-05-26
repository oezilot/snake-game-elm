module Game exposing (..)

import Actions exposing (Message)
import Html exposing (Html, button, div, h1, text)
import Html.Events exposing (onClick)


type GameState
    = GameOver
    | GameOn
    | GameStart


render : GameState -> Html Message
render state =
    case state of
        GameOver ->
            div []
                [ button [ onClick ] [ text "start game" ]
                ]

        GameOn ->
            Debug.todo ""

        GameStart ->
            Debug.todo ""
