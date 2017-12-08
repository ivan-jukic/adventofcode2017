module Puzzles.Day06 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Regex exposing (regex, HowMany(All))
import Array exposing (Array)
import Task exposing (perform, succeed)


{-|
-}
type Msg
    = NoOp
    | Cycle
    | CycleSecond


{-|
-}
type alias Model = 
    { firstCycles : Int
    , secondCycles : Int
    , memory : Array Int
    , prevStates : Array String
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { firstCycles = 0
      , secondCycles = 0
      , memory = input
      , prevStates = Array.empty
      }
    , perform (\_ -> NoOp) (succeed ())
    )


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Cycle ->
            case cycle model.memory model.prevStates of
                Just ( newMemory, newState, isMember ) ->
                    ( { model
                        | memory = newMemory
                        , firstCycles = model.firstCycles + 1
                        , prevStates =
                            case isMember of
                                False ->
                                    Array.push newState model.prevStates

                                True ->
                                    [ newState ] |> Array.fromList
                        }
                    , case isMember of
                        False ->
                            perform (\_ -> Cycle) (succeed ())

                        True ->
                            perform (\_ -> CycleSecond) (succeed ())
                    )

                Nothing ->
                    ( model, Cmd.none )

        CycleSecond ->
            case cycle model.memory model.prevStates of
                Just ( newMemory, newState, isMember ) ->
                    ( { model
                        | memory = newMemory
                        , secondCycles = model.secondCycles + 1
                        , prevStates = Array.push newState model.prevStates
                        }
                    , case isMember of
                        False ->
                            perform (\_ -> CycleSecond) (succeed ())

                        True ->
                            Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )
                

{-|
-}
cycle : Array Int -> Array String -> Maybe (Array Int, String, Bool)
cycle memory prevStates =
    case findMax memory of
        Just (idx, maxVal) ->
            let
                firstIdx =
                    (idx + 1) % (Array.length memory)

                newMemory =
                    memory
                        |> Array.set idx 0
                        |> updateMem firstIdx maxVal
                
                newState =
                    newMemory
                        |> Array.toList
                        |> List.map toString
                        |> String.join " "

                isMember =
                    prevStates |> Array.foldl (\ps c -> if c then c else newState == ps ) False
            in
            Just ( newMemory, newState, isMember )

        Nothing ->
            Nothing


{-|
-}
updateMem : Int -> Int -> Array Int -> Array Int
updateMem currentIdx remaining memory =
    case ( memory |> Array.get currentIdx, remaining > 0 ) of
        ( Just cv, True ) ->
            let
                newCurrentVal =
                    cv + 1

                newRemaining =
                    remaining - 1

                newCurrentIdx =
                    (currentIdx + 1) % (Array.length memory)
            in
            memory
                |> Array.set currentIdx newCurrentVal
                |> updateMem newCurrentIdx newRemaining

        _ ->
            memory


{-|
-}
findMax : Array Int -> Maybe (Int, Int)
findMax memory =
    memory
        |> Array.indexedMap (,)
        |> Array.foldl
            (\(i, v) c ->
                case c of
                    Just (ci, cv) ->
                        case cv < v of
                            True ->
                                Just (i, v)

                            False ->
                                c

                    Nothing ->
                        Just (i, v)
            )
            Nothing


{-|
-}
view : Model -> Html Msg
view model =
    puzzleView
        "06 Memory Reallocation"
        [ { partData
            | label = "1) First part"
            , desc = "Number of cycles before infinite loop: "
            , button = Just Cycle
            , buttonLabel = Just "Click to solve (11137)"
            , solution = if model.firstCycles > 0 then Just <| toString model.firstCycles else Nothing
            }
        , { partData
            | label = "2) Second part"
            , desc = "Solution for this part is calculated from the first part: "
            , solution = if model.secondCycles > 0 then Just <| toString model.secondCycles else Just "1037"
            }
        ]


{-|
-}
input : Array Int
input =
    --"0 2 7 0"
    "14 0 15 12 11 11 3 5 1 6 8 4 9 1 8 4"
        |> String.trim
        |> Regex.split All (regex "\\s+")
        |> List.map
            (\n -> n
                |> String.trim
                |> String.toInt
                |> Result.withDefault 0
            )
        |> Array.fromList
