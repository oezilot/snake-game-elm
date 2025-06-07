-- hier probiere ich es aus wie man trackt welche keyboardtasten gedrückt werden während die seite geöffnet ist ...


module KeyDown exposing (..)

import Browser
import Browser.Events exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (..)


type Model
    = M String


view : Model -> Html msg
view (M model) =
    text model


type alias Message =
    String


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    ( M msg, Cmd.none )



-- diese function wandelt den keydown-key (als zahl) in eine string den wir als menchen verstehe um


subscription : Model -> Sub Message
subscription _ =
    onKeyDown (Decode.field "key" Decode.string)


main : Program () Model Message
main =
    Browser.element
        { init = \flags -> ( M "nothing here", Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscription
        }



--update:
-- Main
--main :
--main init view update
