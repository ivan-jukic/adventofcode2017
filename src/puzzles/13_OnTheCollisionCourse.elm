module Puzzles.Day13 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Regex exposing (..)
import Utils exposing (..)

{-|
-}
type Msg
    = NoOp
    | Step
    | FindZeroSeverity
    | IsSafePassage


{-|
-}
type alias Model = 
    { firewallLayers : List (Int, Int)
    , time : Int
    , partOne : Maybe Int
    , partTwo : Maybe Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { firewallLayers = getInput
      , time = 0
      , partOne = Nothing
      , partTwo = Nothing
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

        Step ->
            let
                pos = getPositionByTime model.time 4
            in
            ( { model | time = model.time + 1 }
            , Cmd.none
            )

        FindZeroSeverity ->
            let
                maxLayer =
                    model.firewallLayers |> List.foldl (\(i, _) c -> if c < i then i else c) 0

                fixedLayers =
                    maxLayer
                        |> List.range 0
                        |> List.map
                            (\i -> (i, model.firewallLayers |> List.foldl (\(layer, count) c -> if layer == i then count else c) 0 ))

                ( t, severity ) =
                    fixedLayers
                        |> List.foldl
                            (\(layer, maxDepth) (t, c) ->
                                let
                                    pos =
                                        if maxDepth == 0 then -1 else getPositionByTime t maxDepth
                                in
                                case pos == 0 of
                                    True ->
                                        ( t + 1, c + layer * maxDepth )

                                    False ->
                                        ( t + 1, c )
                            )
                            (0, 0)
            in
            ( { model | partOne = Just severity }
            , Cmd.none
            )

        IsSafePassage ->
            case model.partTwo of
                Nothing ->
                    let
                        isSafe =
                            model.firewallLayers
                                |> List.foldl
                                    (\(i, d) c ->
                                        let
                                            pos = getPositionByTime (model.time + i) d
                                        in
                                        case c of
                                            True ->
                                                if pos /= 0 then True else False

                                            False ->
                                                c
                                    )
                                    True
                    in
                    ( { model
                      | time = model.time + 1
                      , partTwo = if isSafe then Just model.time else Nothing
                      }
                    , fireAction IsSafePassage
                    )

                Just _ ->
                    ( model, Cmd.none )


{-|
-}
getPositionByTime : Int -> Int -> Int
getPositionByTime time maxSize =
    case maxSize > 1 of
        True ->
            let
                fullStepCycles = 
                    (toFloat time) / (toFloat (maxSize - 1)) |> floor

                goingDown =
                    fullStepCycles % 2 == 0

                stepsInNewCycle =
                    (time % (maxSize - 1))

                pos =
                    if goingDown then stepsInNewCycle else maxSize - stepsInNewCycle - 1

                -- _ = Debug.log "" (time, goingDown, stepsInNewCycle, pos)
            in
            pos

        False ->
            0
    


{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-13" ]
        [ puzzleView
            "13 Packet Scanners"
            [ { partData
                | label = "1) Severity of being caught"
                , desc = "Total severity of all the points we would get caught in (t = 0): "
                , button = Just FindZeroSeverity
                , buttonLabel = Just "Get severity? (1580)"
                , solution = toMaybeString model.partOne
                }
            , { partData
                | label = "2) Crossing safely"
                , desc = "How long should we wait before we can cross firewall safely: "
                , button = Just IsSafePassage
                , buttonLabel = Just "Delay for? (3943252)"
                , solution =
                    case model.partTwo of
                        Nothing ->
                            if model.time > 0 then Just <| toString model.time else Nothing
                        Just _ ->
                            toMaybeString model.partTwo
                }
            ]
        ]


{-|
-}
getInput : List (Int, Int)
getInput =
    input
        |> String.trim
        |> String.lines
        |> List.foldl
            (\column data ->
                data ++
                    ( column
                        |> String.trim
                        |> find All (regex "^([0-9]+)\\s*\\:\\s*([0-9]+)$")
                        |> List.head                        
                        |> Maybe.andThen
                            (\g ->
                                Just <|
                                    case g.submatches of
                                        (Just a)::(Just b)::[] ->
                                            [ (Utils.toNum a, Utils.toNum b) ]

                                        _ ->
                                            []
                            )
                        |> Maybe.withDefault []
                    )
            )
            []


{-|
-}
input : String
input =
{-- }
    """0: 3
1: 2
4: 4
6: 4"""
--}
{--}
    """0: 4
1: 2
2: 3
4: 4
6: 6
8: 5
10: 6
12: 6
14: 6
16: 12
18: 8
20: 9
22: 8
24: 8
26: 8
28: 8
30: 12
32: 10
34: 8
36: 12
38: 10
40: 12
42: 12
44: 12
46: 12
48: 12
50: 14
52: 14
54: 12
56: 12
58: 14
60: 14
62: 14
66: 14
68: 14
70: 14
72: 14
74: 14
78: 18
80: 14
82: 14
88: 18
92: 17"""
--}