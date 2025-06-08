module Tick exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html)
import String exposing (fromInt)


add : Int -> Int
add zahl =
    zahl + 1


type Message
    = Tick


update : Message -> Model -> ( Model, Cmd Message )
update message (MkModel model) =
    case message of
        Tick ->
            if model.tick < 30 then
                ( MkModel { value = model.value, tick = model.tick + 1 }, Cmd.none )

            else
                ( MkModel { value = model.value + 1, tick = 0 }, Cmd.none )


view : Model -> Html Message
view (MkModel model) =
    Html.text (fromInt model.value)


type Model
    = MkModel
        { value : Int
        , tick : Int
        }



-- das ziel: all sekunde muss eine message Tick vom browser zum programm geschickt werden!!!


main : Program () Model Message
main =
    Browser.element
        { init = \_ -> ( MkModel { value = 0, tick = 1 }, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> onAnimationFrameDelta timeToMessage
        }


timeToMessage : Float -> Message
timeToMessage time =
    Tick
