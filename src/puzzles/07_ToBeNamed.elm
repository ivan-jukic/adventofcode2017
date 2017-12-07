module Puzzles.Day07 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)


{-|
-}
type Msg = NoOp


{-|
-}
type alias Model = 
    {}


initialModel : ( Model, Cmd Msg )
initialModel =
    ({}, Cmd.none )


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


{-|
-}
view : Model -> Html Msg
view model =
    puzzleView
        "Task title"
        [ { partData
            | label = "1) First part"
            , desc = "Solution for this part of the puzzle: "
            , button = Nothing
            , buttonLabel = Nothing
            , solution = Nothing
            }
        , { partData
            | label = "2) Second part"
            , desc = "Solution for this part of the puzzle: "
            , button = Nothing
            , buttonLabel = Nothing
            , solution = Nothing
            }
        ]
