module MoveSvg exposing (..)

import Actions exposing (Message)
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
-- so gross ist das spielfeld indem die schlange sich bewegt


fieldDims : Int
fieldDims =
    30



-- "Pixelgrösse", das hier ist das ratio/resoloution (resoloution * einheiten = tatsächliche koordinaten auf dem svg)


resoloution : Int
resoloution =
    10



-- diese zahl besagt nach wie vielen frames gerendered werden soll


tickCount : Int
tickCount =
    10


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
        , food = ( 0, 0 )
        , tick = 0
        }


initialModelMultiple : Model
initialModelMultiple =
    Model
        { snake =
            Snake
                { direction = Up
                , head = ( 15, 15 )
                , body =
                    [ ( 15, 14 )
                    , ( 15, 13 )
                    , ( 15, 12 )
                    , ( 15, 11 )
                    , ( 15, 10 )
                    ]
                , isGrowing = False
                }
        , food = ( 0, 0 )
        , tick = 0
        }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( initialModelMultiple, Cmd.none )



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
                , isGrowing = False
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
                , isGrowing = False
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
                , isGrowing = False
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
                , isGrowing = False
                }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model { snake, food, tick }) =
    let
        (Snake { direction, head, body, isGrowing }) =
            snake
    in
    case msg of
        Move dir ->
            ( Model { snake = changeDirection dir snake, food = food, tick = tick }, Cmd.none )

        FoodCollision ->
            ( Model
                { snake = feedSnake snake -- feedsnake setzt lediglich isGrowing auf true!
                , food = food
                , tick = tick
                }
            , Cmd.none
            )

        TimeTick ->
            if tick < 10 then
                ( Model
                    { snake = snake
                    , food = food
                    , tick = tick + 1
                    }
                , Cmd.none
                )

            else
                ( Model
                    { snake =
                        if head == food then
                            snake |> feedSnake |> moveSnake

                        else
                            moveSnake snake
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


snakeColors : List String
snakeColors =
    [ "red", "yellow", "pink", "purple", "magenta", "blue", "brown" ]


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
            (drawBackground
                :: drawSnakeComponent
                    exampleColor
                    head
                :: drawFoodComponent foodColor food
                :: List.map drawSnakeComponentPink body
            )
        ]


drawBackground : Svg Msg
drawBackground =
    rect [ x (fromInt 0), y (fromInt 0), width "600", height "600", fill "green" ] []


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


drawSnakeComponentPink : Position -> Svg Msg
drawSnakeComponentPink ( x, y ) =
    circle [ cx (fromInt ((x * 24) + 12)), cy (fromInt ((y * 24) + 12)), r "12", fill "pink" ] []


drawSnakeComponent : Color -> Position -> Svg Msg
drawSnakeComponent color ( x, y ) =
    circle [ cx (fromInt ((x * 24) + 12)), cy (fromInt ((y * 24) + 12)), r "12", fill (colorToString color) ] []



-- square components are positioned differently


drawFoodComponent : Color -> Position -> Svg Msg
drawFoodComponent color ( xx, yy ) =
    rect [ x (fromInt (xx * 24)), y (fromInt (yy * 24)), width "24", height "24", fill (colorToString color) ] []



--------------------------------------


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
