module StylesComponents exposing (..)

import ColorPalette as CP
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (..)
import String exposing (fromInt)


button1 : msg -> String -> Element msg
button1 onclickMsg btnText =
    button
        []
        { onPress = Just onclickMsg, label = Element.text btnText }
