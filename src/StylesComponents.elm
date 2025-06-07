module StylesComponents exposing (..)

import ColorPalette as CP
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (..)
import String exposing (fromInt)



-- element components mit dem styling


font1 =
    Font.external
        { url = "https://fonts.googleapis.com/css2?family=VT323&display=swap"
        , name = "VT323"
        }



-- farbe ist variael


button1 : msg -> String -> Element msg
button1 onclickMsg btnText =
    button
        [ Background.color (CP.lighter 1 CP.grey)
        , padding 12
        , Border.color CP.watermelon
        , Border.width 3
        , Border.rounded 15
        , Font.family [ font1 ]
        , Font.color CP.whiteish
        , mouseOver
            [ Background.color (CP.lighter 2 CP.grey)

            --, Border.color (CP.darker 1 CP.watermelon)
            ]
        ]
        -- colo, font, padding, posizion
        -- hier kommt das ganze styling hin
        { onPress = Just onclickMsg, label = Element.text btnText }


counter : msg -> msg -> msg -> msg -> Int -> Element msg
counter msg1 msg2 msg3 msg4 counter_number =
    el []
        ( button1 msg1 "+"
        , button1 msg2 "-"
        , button1 msg3 "Reset"
        , button1 msg4 "Remove"
        , text counter_number
        )



{-
   div []
           [ button [ onClick (Dec index) ] []
           , Html.text (fromInt counter)
           , button [ onClick (Inc index) ] [] -- das onclick ist eine html message was asgesendet wird falls der button gedrückt wird (bei diesem button wird die Inc-Message ausgesendet)
           , button [ onClick (Reset index) ] []
           , button [ onClick (Remove index) ] []
           ]
-}
