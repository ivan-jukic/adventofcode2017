module Puzzles.Day10 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Array exposing (Array)
import Task exposing (perform, succeed)
import Char
import Bitwise
import Hex


{-|
-}
type Msg
    = NoOp
    | CalcPartOne
    | CalcPartTwo
    | PartTwoRounds


{-|
-}
type alias Model = 
    { lengths : List Int
    , numbers : Array Int
    , position : Int
    , skipSize : Int
    , roundCount : Int
    , partOne : Maybe Int
    , partTwo : Maybe String
    }


init : Model
init =
    { lengths = []
    , numbers = numberList
    , position = 0
    , skipSize = 0
    , roundCount = 0
    , partOne = Nothing
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
                    { init
                    | lengths = getInput
                    , partTwo = model.partTwo
                    } |> hashRound

                solution =
                    case updated.numbers |> Array.toList of
                        a::b::_ ->
                            Just <| a * b

                        _ ->
                            Nothing
            in
            ( { updated | partOne = solution }, Cmd.none )

        CalcPartTwo ->
            ( { init | partOne = model.partOne }
            , perform (\_ -> PartTwoRounds) (succeed ())
            )

        PartTwoRounds ->
            case model.roundCount < 64 of
                True ->
                    ( hashRound
                        { model
                            | lengths = getInputAscii
                            , roundCount = model.roundCount + 1
                            }
                    , perform (\_ -> PartTwoRounds) (succeed ())
                    )

                False ->
                    let
                        hash =
                            List.range 0 15
                                |> List.foldl
                                    (\i out ->
                                        let
                                            sliceIdx =
                                                16 * i

                                            addToOut =
                                                model.numbers
                                                    |> Array.slice sliceIdx (sliceIdx + 16)
                                                    |> Array.toList
                                                    |> List.foldl (\n p -> Bitwise.xor p n) 0
                                                    |> Hex.toString
                                                    |> (\h -> (if String.length h == 1 then "0" else "") ++ h)
                                        in
                                        out ++ [ addToOut ]
                                    )
                                    []
                                |> String.join ""
                    in
                    ( { model | partTwo = Just hash }, Cmd.none )


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
hashRound : Model -> Model
hashRound model =
    case List.head model.lengths of
        Just len ->
            let
                numCount =
                    Array.length model.numbers

                ( takeRight, takeStart ) =
                    case model.position + len > numCount of
                        True ->
                            ( numCount - model.position
                            , model.position + len - numCount
                            )

                        False ->
                            ( len
                            , 0
                            )

                updatedNumbers =
                    model.numbers
                        |> Array.indexedMap (,)
                        |> (\indexed ->
                                Array.append
                                    (indexed |> Array.filter (\(i, _) -> i >= model.position && i < model.position + takeRight))
                                    (indexed |> Array.filter (\(i, _) -> takeStart > 0 && i >= 0 && i < takeStart))
                            )
                        |> invertArray 0
                        |> Array.foldl (\(i, v) c -> Array.set i v c ) model.numbers
            in
            hashRound
                { model
                | lengths = List.drop 1 model.lengths
                , numbers = updatedNumbers
                , skipSize = model.skipSize + 1
                , position = (model.position + len + model.skipSize) % numCount
                }

        Nothing ->
            model


{-|
-}
invertArray : Int -> Array (Int, Int) -> Array (Int, Int)
invertArray step slice =
    let
        numCount =
            Array.length slice
    in
    case (toFloat numCount) / 2 > (toFloat step) of
        True ->
            let
                leftIdx =
                    0 + step

                rightIdx =
                    numCount - step - 1
            in
            case (slice |> Array.get leftIdx, slice |> Array.get rightIdx) of
                ( Just (il, vl), Just (ir, vr) ) ->
                    invertArray
                        (step + 1)
                        (slice
                            |> Array.set leftIdx (il, vr)
                            |> Array.set rightIdx (ir, vl)
                        )

                _ ->
                    slice

        False ->
            slice


{-|
-}
numberList : Array Int
numberList =
    --[ 0, 1, 2, 3, 4 ] |> Array.fromList
    List.range 0 255 |> Array.fromList


{-|
-}
getInput : List Int
getInput =
    --"3,4,1,5"
    "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88"
        |> String.split ","
        |> List.map (\n -> n |> String.trim |> String.toInt |> Result.withDefault 0)


{-|
-}
getInputAscii : List Int
getInputAscii =
    (
        --"AoC 2017"
        "183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88"
            |> String.toList
            |> List.map (\c -> Char.toCode c)
    )
    ++ [ 17, 31, 73, 47, 23 ]
  