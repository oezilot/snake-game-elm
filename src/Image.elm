-- ein image nur mit html darstellen


module Image exposing (main)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


main : Program () () msg
main =
    Browser.sandbox
        { init = ()
        , view = \_ -> img [ src "/image.png", alt "Logo" ] []
        , update = \_ model -> model
        }
