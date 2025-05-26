module Snake exposing (..)

import List exposing (length, take)


type Direction
    = N
    | E
    | S
    | W


type alias Position =
    { x : Float
    , y : Float -- hier floats nehmen weil canvas library nicht mit ints umgehen kann
    }



-- aus einer direction (int) eine neue position machen die um 1 in die eingegeben richtugn geshifted wird


shift : Direction -> Position -> Position
shift dir pos =
    case dir of
        N ->
            { pos | y = pos.y - 1 }

        E ->
            { pos | x = pos.x + 1 }

        S ->
            { pos | y = pos.y + 1 }

        _ ->
            { pos | x = pos.x - 1 }



-- dieser fall ist wenn direction 3 ist (in elm müssen immer alle fälle behandelt werden!!!)


type alias Snake =
    { direction : Direction -- 0, 1, 2, 3 -> nord, ost, sud, west
    , head : Position
    , body : List Position
    , isGrowing : Bool
    }


move : Snake -> Snake
move snake =
    { snake
        | head = shift snake.direction snake.head
        , body =
            snake.head
                :: (if snake.isGrowing then
                        snake.body

                    else
                        take (length snake.body - 1) snake.body
                   )
    }


turnLeft : Snake -> Snake
turnLeft snake =
    { snake
        | direction =
            case snake.direction of
                N ->
                    W

                E ->
                    N

                S ->
                    E

                W ->
                    S
    }


turnRight : Snake -> Snake
turnRight snake =
    { snake
        | direction =
            case snake.direction of
                N ->
                    E

                E ->
                    S

                S ->
                    W

                W ->
                    N
    }


grow : Snake -> Snake
grow snake =
    { snake | isGrowing = True }
