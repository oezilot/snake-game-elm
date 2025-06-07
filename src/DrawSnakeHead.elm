-- weil man keie images importieren kann mit svg muss ich den schlangenkopf nun manuell zeichnen


module DrawSnakeHead exposing (..)

-- hier habe ich probiert mit svg und html ein image zu displayes...ohne erfolg -> das image wird zwar korrekt im html eingebettetmmit korrektem pfad etc aber nicht kann man sehen...

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
--eugis =


view : Snake -> Html msg
view snake =
    svg
        [ SA.width "120", SA.height "120", SA.viewBox "0 0 120 120" ]
        [ ellipse [ fill "black", cx "60", cy "60", rx "30", ry "55" ] [], ellipse [ fill "white", cx "60", cy "60", rx "20", ry "45" ] [], ellipse [ fill "black", cx "60", cy "80", ry "30", rx "20" ] [] ]


main : Program () Snake msg
main =
    Browser.sandbox
        { init = snakeiii
        , view = view
        , update = \_ model -> model
        }
