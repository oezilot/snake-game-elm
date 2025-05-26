module ColorPalette exposing (..)

import Element exposing (..)


watermelon : Color
watermelon =
    rgba255 255 71 87 1.0


blue : Color
blue =
    rgba255 83 82 237 1.0


whiteish : Color
whiteish =
    rgba255 241 242 246 1.0


blackish : Color
blackish =
    rgba255 47 53 66 1.0


mango : Color
mango =
    rgba255 255 165 2 1.0


grey : Color
grey =
    rgba255 47 53 66 1.0


light : Color -> Color
light c =
    fromRgb
        { red = min 1.0 (1.3 * (toRgb c).red)
        , green = min 1.0 (1.3 * (toRgb c).green)
        , blue = min 1.0 (1.3 * (toRgb c).blue)
        , alpha = (toRgb c).alpha
        }


lighter : Int -> Color -> Color
lighter n c =
    if n <= 0 then
        c

    else
        lighter (n - 1) (light c)


dark : Color -> Color
dark c =
    fromRgb
        { red = 0.7 * (toRgb c).red
        , green = 0.7 * (toRgb c).green
        , blue = 0.7 * (toRgb c).blue
        , alpha = (toRgb c).alpha
        }


darker : Int -> Color -> Color
darker n c =
    if n <= 0 then
        c

    else
        darker (n - 1) (dark c)
