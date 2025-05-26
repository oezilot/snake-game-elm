module Counters exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List exposing (indexedMap, length)
import String exposing (fromInt)
import StylesComponents exposing (..)


type alias Counter =
    Int


type alias Model =
    List Counter



-- zu beginn existieren noch keine counters


initialCounterValue : Counter
initialCounterValue =
    0


initialModel : Model
initialModel =
    []



-- message type


type Msg
    = Inc Int -- mit int ist der index des counters in der model-liste gemeint
    | Dec Int
    | Reset Int
    | Add
    | Remove Int



-- update with an udater (änderungen am counter)


updateCounterAtIndex : Int -> (Counter -> Maybe Counter) -> Int -> Model -> Model
updateCounterAtIndex list_id updater index counters =
    case counters of
        [] ->
            []

        c :: cs ->
            if list_id == index then
                case updater c of
                    Just c_ ->
                        c_ :: cs

                    Nothing ->
                        cs

            else
                c :: updateCounterAtIndex (list_id + 1) updater index cs


update : Msg -> Model -> Model
update msg counters =
    case msg of
        Inc index ->
            updateCounterAtIndex 0 (\ctr -> Just (ctr + 1)) index counters

        Dec index ->
            updateCounterAtIndex 0 (\ctr -> Just (ctr - 1)) index counters

        Reset index ->
            updateCounterAtIndex 0 (\_ -> Just 0) index counters

        Add ->
            initialCounterValue :: counters

        Remove index ->
            updateCounterAtIndex 0 (\_ -> Nothing) index counters


renderCounter : Int -> Counter -> Html Msg
renderCounter index counter =
    div []
        [ button [ onClick (Dec index) ] [ text "-" ]
        , text (fromInt counter)
        , button [ onClick (Inc index) ] [ text "+" ] -- das onclick ist eine html message was asgesendet wird falls der button gedrückt wird (bei diesem button wird die Inc-Message ausgesendet)
        , button [ onClick (Reset index) ] [ text "reset" ]
        , button [ onClick (Remove index) ] [ text "remove" ]
        ]


render : Model -> Html Msg
render counters =
    div []
        [ button [ onClick Add ] [ text "Add Counter" ]
        , div [] (indexedMap renderCounter counters)
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init =
            -- der input der mainfunktion, das model zu beginn
            initialModel
        , update =
            -- if a message comes from tho browser
            update
        , view =
            -- if the model has changed: the input of this function will automatic be the global variable=initialstate which is contrantly changed
            render
        }
