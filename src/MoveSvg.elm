module MoveSvg exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Html exposing (..)
import Json.Decode as Decode
import Platform.Sub exposing (batch)
import String exposing (fromInt, join)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Tuple exposing (first, second)



--------------------------------------------


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
        , tick : Int
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
        , tick = 0
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
update msg (Model { snake, food, tick }) =
    case msg of
        Move direction ->
            ( Model { snake = changeDirection direction snake, food = food, tick = tick }, Cmd.none )

        FoodCollision ->
            ( Model
                { snake = feedSnake snake
                , food = food
                , tick = tick
                }
            , Cmd.none
            )

        TimeTick ->
            if tick < 2 then
                ( Model
                    { snake = snake
                    , food = food
                    , tick = tick + 1
                    }
                , Cmd.none
                )

            else
                ( Model
                    { snake = moveSnake snake
                    , food = food
                    , tick = 0
                    }
                , Cmd.none
                )



--------------------------------------------


foodColor : Color
foodColor =
    Rgb { r = 255, g = 0, b = 0 }


exampleColor : Color
exampleColor =
    Rgb { r = 33, g = 33, b = 55 }


view : Model -> Html Msg
view (Model { snake, food, tick }) =
    let
        (Snake { direction, head, body, isGrowing }) =
            snake
    in
    --Html.text (Debug.toString model)
    div
        []
        [ svg
            [ width "600"
            , height "600"
            ]
            [ drawSnakeComponent
                exampleColor
                head
            , drawFoodComponent foodColor food
            ]
        ]


type Color
    = Rgb { r : Int, g : Int, b : Int }


colorToString : Color -> String
colorToString (Rgb { r, g, b }) =
    "rgb("
        ++ fromInt r
        ++ ","
        ++ fromInt g
        ++ ","
        ++ fromInt b
        ++ ")"



-- generiert ein svg für ein einzelnes quadrat


drawSnakeComponent : Color -> Position -> Svg Msg
drawSnakeComponent color ( x, y ) =
    circle [ cx (fromInt x), cy (fromInt y), r "12", fill (colorToString color) ] []


drawFoodComponent : Color -> Position -> Svg Msg
drawFoodComponent color ( x, y ) =
    rect [ cx (fromInt x), cy (fromInt y), width "24", height "24", fill (colorToString color) ] []



-- kreiert die schlange mit all ihren komponenten des körpers
{- renderSnakeComponents : List Position -> Html msg
   renderSnakeComponents  =
       svg
           [ width "120"
           , height "120"
           , viewBox "0 0 120 120"
           ]
           [ circle
               [ cx "50"
               , cy "50"
               , r "50"
               ]
               []
           ]
-}
{-
   snake type as a note:
   Snake
           { direction : Direction -- 0, 1, 2, 3 -> nord, ost, sud, west
           , head : Position
           , body : List Position
           , isGrowing : Bool
           }
-}
--------------------------------------------


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> batch [ subscriptionKey model, subscriptionTick model ]
        }



-- hier wird bestimmt welche message aufgerufen wird


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


subscriptionKey : Model -> Sub Msg
subscriptionKey _ =
    Sub.map str2msg <| onKeyDown (Decode.field "key" Decode.string)


subscriptionTick : Model -> Sub Msg
subscriptionTick _ =
    onAnimationFrameDelta timeToMessage


timeToMessage : Float -> Msg
timeToMessage time =
    TimeTick



--------------------------------------------
