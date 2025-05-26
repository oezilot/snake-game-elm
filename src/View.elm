module View exposing (..)

import Snake as S


type alias Food =
    S.Position


type alias Grid =
    { height : Int, width : Int }
