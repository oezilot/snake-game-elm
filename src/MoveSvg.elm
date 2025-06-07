module MoveSvg exposing (..)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (..)
import Json.Decode as Decode
import Svg exposing (circle, rect, svg)
import Svg.Attributes exposing (cx, cy, fill, height, r, width, x)
import Tuple exposing (first, second)


fieldDims : Int
fieldDims =
    30


type Direction
    = Left
    | Up
    | Right
    | Down


type alias Position =
    ( Int, Int )


type Snake
    = Snake
        { direction : Direction -- 0, 1, 2, 3 -> nord, ost, sud, west
        , head : Position
        , body : List Position
        , isGrowing : Bool
        }


type Model
    = Model
        { snake : Snake
        , food : Position
        }



--------------------------------------------


initialModel : Model
initialModel =
    Model
        { snake =
            Snake
                { direction = Up
                , head = ( fieldDims // 2, fieldDims // 2 )
                , body = []
                , isGrowing = False
                }
        , food = ( 10, 10 )
        }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



--------------------------------------------


type Msg
    = Move Direction
    | FoodCollision
    | TimeTick


feedSnake : Snake -> Snake
feedSnake (Snake snake) =
    Snake { snake | isGrowing = True }


changeDirection : Direction -> Snake -> Snake
changeDirection newDirection (Snake snake) =
    Snake { snake | direction = newDirection }


allButLast : List l -> List l
allButLast list =
    case list of
        [] ->
            []

        [ _ ] ->
            []

        l :: ls ->
            l :: allButLast ls


moveSnake : Snake -> Snake
moveSnake (Snake { direction, head, body, isGrowing }) =
    case direction of
        Left ->
            Snake
                { direction = direction
                , head = ( first head - 1, second head )
                , body =
                    head
                        :: (if isGrowing then
                                body

                            else
                                allButLast body
                           )
                , isGrowing = isGrowing
                }

        Up ->
            Snake
                { direction = direction
                , head = ( first head, second head - 1 )
                , body =
                    head
                        :: (if isGrowing then
                                body

                            else
                                allButLast body
                           )
                , isGrowing = isGrowing
                }

        Down ->
            Snake
                { direction = direction
                , head = ( first head, second head + 1 )
                , body =
                    head
                        :: (if isGrowing then
                                body

                            else
                                allButLast body
                           )
                , isGrowing = isGrowing
                }

        Right ->
            Snake
                { direction = direction
                , head = ( first head + 1, second head )
                , body =
                    head
                        :: (if isGrowing then
                                body

                            else
                                allButLast body
                           )
                , isGrowing = isGrowing
                }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model { snake, food }) =
    case msg of
        Move direction ->
            ( Model { snake = changeDirection direction snake, food = food }, Cmd.none )

        FoodCollision ->
            ( Model
                { snake = feedSnake snake
                , food = food
                }
            , Cmd.none
            )

        TimeTick ->
            ( Model
                { snake = moveSnake snake
                , food = food
                }
            , Cmd.none
            )



--------------------------------------------


view : Model -> Html msg
view model =
    Html.text (Debug.toString model)



--------------------------------------------


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


str2msg : String -> Msg
str2msg str =
    case str of
        "ArrowUp" ->
            Move Up

        "ArrowDown" ->
            Move Down

        "ArrowLeft" ->
            Move Left

        _ ->
            Move Right


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.map str2msg <| onKeyDown (Decode.field "key" Decode.string)



--------------------------------------------
{-
   view : Schlange -> Html Msg
   view (Schlange ( x, y )) =
       div []
           [ p [] [ text <| String.fromInt x ++ " : " ++ String.fromInt y ]
           , svg
               [ height "200"
               , width "200"
               ]
               [ rect
                   [ fill "pink"
                   , width "200"
                   , height "200"
                   ]
                   []
               , circle
                   [ r "5"
                   , cx (String.fromInt (20 * x))
                   , cy (String.fromInt (20 * y))
                   , fill "black"
                   ]
                   []
               ]
           ]
-}
