module Puzzles.Day10 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Array exposing (Array)


{-|
-}
type Msg
    = NoOp
    | NextStep


{-|
-}
type alias Model = 
    { lengths : List Int
    , numbers : Array Int
    , position : Int
    , skipSize : Int
    , partOne : Maybe Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { lengths = getInput
      , numbers = numberList
      , position = 0
      , skipSize = 0
      , partOne = Nothing
      }
    , Cmd.none
    )


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NextStep ->
            let
                ( updated, finished ) =
                    model |> nextStep

                solution =
                    case List.length updated.lengths == 0 of
                        True ->
                            case model.numbers |> Array.toList of
                                a::b::_ ->
                                    Just <| a * b

                                _ ->
                                    Nothing

                        False ->
                            Nothing
            in
            ( { updated | partOne = solution }, Cmd.none )


{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-10" ]
        [ puzzleView
            "10 Knot Hash"
            [ { partData
                | label = "1) Result of the multiplication"
                , desc = "...of the first two numbers in the list after hashing: "
                , button = Just NextStep
                , buttonLabel = Nothing
                , solution = model.partOne |> Maybe.andThen (\n -> Just <| toString n)
                }
            , { partData
                | label = "2) Second part"
                , desc = "Solution for this part of the puzzle: "
                , button = Nothing
                , buttonLabel = Nothing
                , solution = Nothing
                }
            ]
        ]


{-|
-}
nextStep : Model -> ( Model, Bool )
nextStep model =
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


                _ = Debug.log "len" updatedNumbers --(model.position, takeRight, takeStart, model.skipSize, model.numbers |> Array.toList)
            in
            ( { model
              | lengths = List.drop 1 model.lengths
              , numbers = updatedNumbers
              , skipSize = model.skipSize + 1
              , position = (model.position + len + model.skipSize) % numCount
              }
            , False
            )

        Nothing ->
            ( model, True )


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