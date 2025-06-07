-- hier habe ich probiert mit svg und html ein image zu displayes...ohne erfolg -> das image wird zwar korrekt im html eingebettetmmit korrektem pfad etc aber nicht kann man sehen...


module ImageSVG exposing (main)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Svg exposing (..)
import Svg.Attributes as SA exposing (..)



-- snak definieren


type alias Snake =
    List ( Int, Int )


snakeiii : Snake
snakeiii =
    [ ( 5, 5 )
    , ( 6, 5 )
    , ( 7, 5 )
    ]



-- der schlangenkopf als html-message


headSvg =
    img [ HA.width 300, src "/eugis.svg", alt "Logo" ] []


view : Snake -> Html msg
view snake =
    svg
        [ SA.width "120", SA.height "120", SA.viewBox "0 0 120 120" ]
        [ foreignObject [] [ headSvg ] ]


main : Program () Snake msg
main =
    Browser.sandbox
        { init = snakeiii
        , view = view
        , update = \_ model -> model
        }
