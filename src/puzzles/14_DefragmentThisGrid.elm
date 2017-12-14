module Puzzles.Day14 exposing (..)

import Components.View exposing (puzzleView, partData)
import Components.KnotHash exposing (knotHash)
import Html exposing (..)
import Html.Attributes exposing (..)
import Utils exposing (..)
import Time exposing (Time)

{-|
-}
type Msg
    = NoOp
    | StartUsedBlockCalc
    | ContinueUsedBlockCalc Time
    | NextUsedBlockStep
    | GroupCount


{-|
-}
type alias Model = 
    { partOne : Int
    , partTwo : Int
    , step : Int
    , busyOne : Bool 
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { partOne = 0
      , partTwo = 0
      , step = 0
      , busyOne = False
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.busyOne of
        True ->
            Time.every (Time.millisecond * 500) ContinueUsedBlockCalc

        False ->
            Sub.none


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        StartUsedBlockCalc ->
            ( model, fireAction NextUsedBlockStep)

        ContinueUsedBlockCalc _ ->
            ( model, fireAction NextUsedBlockStep)

        NextUsedBlockStep ->
            case model.step < 128 of
                True ->
                    ( { model
                      | partOne = model.partOne + (countUsedBlocks model.step)
                      , step = model.step + 1
                      , busyOne = True
                      }
                    , Cmd.none
                    )

                False ->
                    ( { model | busyOne = False }, Cmd.none )

        GroupCount ->
            let
                binaryBlocks =
                    2
                        |> List.range 0
                        |> List.foldl (\i b -> b ++ [ getBinaryBlock i ]) []

                (totalGroups, g) =
                    binaryBlocks
                        |> List.foldl
                            (\binary (t, g) ->
                                let
                                    (binaryGroups, _) =
                                        binary
                                            |> String.split ""
                                            |> List.indexedMap (,)
                                            |> List.foldl
                                                (\(i, c) (g, newGroupStartIdx) ->
                                                    case (newGroupStartIdx, c) of
                                                        ( Nothing, "0" ) ->
                                                            ( g, Nothing )

                                                        ( Nothing, "1" ) ->
                                                            ( g, Just i )

                                                        ( Just idx, "0" ) ->
                                                            ( g ++ [ (idx, (i - 1)) ], Nothing)

                                                        _ ->
                                                            ( g, newGroupStartIdx )
                                                )
                                                ([], Nothing)

                                    _ = Debug.log "" (binary, binaryGroups)
                                in
                                (t, g)
                            )
                            (0, [])
            in
            ( { model | partTwo = totalGroups }, Cmd.none )


{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-14" ]
        [ puzzleView
            "14 Disk Defragmentation"
            [ { partData
                | label = "1) Free blocks"
                , desc = "Number of free blocks for defrag: "
                , button = Just StartUsedBlockCalc
                , buttonLabel = Nothing
                , solution = if model.partOne > 0 then Just <| (toString model.partOne) ++ " (" ++ (toString model.step) ++ ")" else Nothing
                }
            , { partData
                | label = "2) Second part"
                , desc = "Solution for this part of the puzzle: "
                , button = Just GroupCount
                , buttonLabel = Nothing
                , solution = if model.partTwo > 0 then Just <| toString model.partOne else Nothing
                }
            ]
        ]


{-|
-}
countUsedBlocks : Int -> Int
countUsedBlocks blockCount =
    [ input, "-", toString blockCount ]
        |> String.join ""
        |> knotHash
        |> String.foldl (\c out -> out + (countOnes c)) 0


{-|
-}
getBinaryBlock : Int -> String
getBinaryBlock blockCount =
    let
        _ = Debug.log "block" blockCount
    in
    [ input, "-", toString blockCount ]
        |> String.join ""
        |> knotHash
        |> String.foldl (\c out -> out ++ (toBinaryString c)) ""


{-|
-}
countOnes : Char -> Int
countOnes c =
    if c == '0' then
        0

    else if c == 'f' then
        4

    else if List.member c ['1', '2', '4', '8'] then
        1

    else if List.member c ['3', '5', '6', '9', 'a', 'c'] then
        2

    else
        3


{-|
-}
toBinaryString : Char -> String
toBinaryString c =
    case c of
        '0' -> "0000"
        '1' -> "0001"
        '2' -> "0010"
        '3' -> "0011"
        '4' -> "0100"
        '5' -> "0101"
        '6' -> "0110"
        '7' -> "0111"
        '8' -> "1000"
        '9' -> "1001"
        'a' -> "1010"
        'b' -> "1011"
        'c' -> "1100"
        'd' -> "1101"
        'e' -> "1110"
        'f' -> "1111"
        _   -> "0000"


{-|
-}
input : String
input =
    "flqrgnkx"
    --"stpzcrnm"