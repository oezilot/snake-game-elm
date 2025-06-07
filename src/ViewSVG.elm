module ViewSVG exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (fromFloat, fromInt)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Tuple exposing (..)


zip2 : List a -> List b -> List ( a, b )
zip2 l1 l2 =
    case ( l1, l2 ) of
        ( [], _ ) ->
            []

        ( _, [] ) ->
            []

        ( x :: xs, y :: ys ) ->
            ( x, y ) :: zip2 xs ys


type alias Position =
    ( Float, Float )



-- so viele pixels hat ein schlangensegment


pixelSize : Float
pixelSize =
    80



-- dimansionen des spielbretts in schlangensegmenten


spielbrettSize : ( Float, Float )
spielbrettSize =
    ( 20, 20 )


type alias Snake =
    List Position


snakeiii : Snake
snakeiii =
    [ ( 5, 5 )
    , ( 6, 5 )
    , ( 7, 5 )
    , ( 7, 6 )
    , ( 7, 7 )
    , ( 7, 8 )
    , ( 7, 9 )
    ]


eugis : Html msg
eugis =
    Html.img [] [ src "../eugis.svg" ]


snakiiiColors : List String
snakiiiColors =
    [ "red", "yellow", "pink", "purple", "magenta", "blue", "brown" ]


food : Position
food =
    ( 0, 4 )


renderSegment : Position -> String -> Svg msg
renderSegment ( x, y ) color =
    circle [ fill color, cx (fromFloat (x * pixelSize + pixelSize / 2)), cy (fromFloat (y * pixelSize - pixelSize / 2)), r (fromFloat (pixelSize / 2)) ] []


main =
    svg
        [ width (fromFloat (first spielbrettSize * pixelSize))
        , height (fromFloat (second spielbrettSize * pixelSize))
        ]
        -- render the background (blank segments)
        -- render the snake
        (renderSegment food "green"
            :: List.map (\( seg, col ) -> renderSegment seg col) (zip2 snakeiii snakiiiColors)
        )
