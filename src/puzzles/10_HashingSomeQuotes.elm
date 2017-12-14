module Puzzles.Day10 exposing (..)

import Components.View exposing (puzzleView, partData)
import Components.KnotHash exposing (..)
import Array exposing (Array)
import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (perform, succeed)


{-|
-}
type Msg
    = NoOp
    | CalcPartOne
    | CalcPartTwo


{-|
-}
type alias Model = 
    { partOne : Maybe Int
    , partTwo : Maybe String
    }


init : Model
init =
    { partOne = Nothing
    , partTwo = Nothing
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( init, Cmd.none )


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CalcPartOne ->
            let
                updated =
                    hashRound
                        { hashModel | lengths = getPartOneInput }

                solution =
                    case updated.numbers |> Array.toList of
                        a::b::_ ->
                            Just <| a * b
                        _ ->
                            Nothing
            in
            ( { model | partOne = solution }, Cmd.none )

        CalcPartTwo ->
            let
                hash =
                    knotHash getPartTwoInput
            in
            ( { init | partTwo = Just hash }
            , Cmd.none
            )


{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-10" ]
        [ puzzleView
            "10 Knot Hash"
            [ { partData
                | label = "1) Result of the multiplication"
                , desc = "...of the first two numbers in the list after one hashing round: "
                , button = Just CalcPartOne
                , buttonLabel = Just "Get result!"
                , solution = model.partOne |> Maybe.andThen (\n -> Just <| toString n)
                }
            , { partData
                | label = "2) Hash string"
                , desc = "Full hash string for input: "
                , button = Just CalcPartTwo
                , buttonLabel = Just "Get hash!"
                , solution = model.partTwo
                }
            ]
        ]


{-|
-}
getPartOneInput : List Int
getPartOneInput =
    --"3,4,1,5"
    "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88"
        |> String.split ","
        |> List.map (\n -> n |> String.trim |> String.toInt |> Result.withDefault 0)


{-|
-}
getPartTwoInput : String
getPartTwoInput =
    --"AoC 2017"
    "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88"
  