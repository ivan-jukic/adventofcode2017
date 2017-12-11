module Puzzles.Day11 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (perform, succeed)


{-|
-}
type Msg
    = NoOp
    | NextStep


{-|
-}
type Moves
    = None | N | NE | SE | S | SW | NW


{-|
-}
type alias HexPosition =
    { x : Int
    , y : Int
    }


{-|
-}
type alias Model = 
    { current: HexPosition
    , moves : List Moves
    , running : Bool
    , partOne : Maybe Int
    , partTwo : Maybe Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { current = HexPosition 0 0
      , moves = getInput
      , running = False
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

        NextStep ->
            let
                ( updated, solution ) =
                    model |> takeStep
            in
            ( { updated
                | partOne = solution
                , running = solution == Nothing
                }
            , case solution of
                Nothing ->
                    perform (\_ -> NextStep) (succeed ())

                Just _ ->
                    Cmd.none
            )


{-|
-}
takeStep : Model -> ( Model, Maybe Int )
takeStep model =
    let
        c =
            model.current
    in
    case List.head model.moves of
        Just step ->
            let
                newCurrent =
                    case step of
                        N ->
                            { x = c.x + 1, y = c.y }

                        NE ->                            
                            { x = c.x, y = c.y + 1 }

                        SE ->
                            { x = c.x - 1, y = c.y + 1 }

                        S ->
                            { x = c.x - 1, y = c.y }

                        SW ->
                            { x = c.x, y = c.y - 1 }

                        NW ->
                            { x = c.x + 1, y = c.y - 1 }

                        _ ->
                            c

                currentDistance =
                    hexDistance newCurrent
            in
            ( { model
                | current = newCurrent
                , moves = List.drop 1 model.moves
                , partTwo =
                    case model.partTwo of
                        Just dist ->
                            Just <| if dist < currentDistance then currentDistance else dist

                        Nothing ->
                            Just <| currentDistance
                }
            , Nothing
            )

        Nothing ->
            ( model
            , Just <| hexDistance c
            )


{-|
-}
hexDistance : HexPosition -> Int
hexDistance c =
    case (c.x < 0 && c.y > 0) || (c.x > 0 && c.y < 0) of
        True ->
            [ abs c.x, abs c.y ]
                |> List.maximum
                |> Maybe.withDefault 0

        False ->
            abs c.x + abs c.y



{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-x" ]
        [ puzzleView
            "11 Hex Ed"
            [ { partData
                | label = "1) Shorthest path"
                , desc = "Shortest path in hex grid: "
                , button = Just NextStep
                , buttonLabel = Just "Shortest path!"
                , solution =
                    case model.running of
                        True ->
                            Just <| "Remaining " ++ (model.moves |> List.length |> toString)
                        
                        False ->
                            model.partOne |> Maybe.andThen (toString >> Just)
                }
            , { partData
                | label = "2) Furthest ever"
                , desc = "Furthest distance ever while solving part 1: "
                , solution = model.partTwo |> Maybe.andThen (toString >> Just)
                }
            ]
        ]


{-|
-}
getInput : List Moves
getInput =
    hugeInput
        |> String.split ","
        |> List.map
            (\dir ->
                case String.trim dir of
                    "n"  -> N
                    "ne" -> NE
                    "se" -> SE
                    "s"  -> S
                    "sw" -> SW
                    "nw" -> NW
                    _    -> None
            )


hugeInput : String
hugeInput =
    """se,sw,s,sw,s,s,nw,se,se,s,se,se,se,se,ne,sw,ne,nw,ne,ne,se,ne,s,sw,nw,se,ne,n,s,nw,ne,ne,n,sw,nw,sw,n,n,n,nw,n,n,n,n,n,sw,sw,nw,nw,nw,n,n,sw,n,nw,nw,n,nw,nw,se,nw,nw,nw,ne,nw,ne,nw,sw,s,nw,ne,nw,nw,s,sw,nw,nw,sw,nw,n,sw,sw,sw,sw,sw,sw,s,n,sw,n,sw,sw,sw,s,sw,se,sw,sw,s,se,sw,sw,ne,sw,sw,sw,n,s,sw,s,s,sw,sw,sw,sw,sw,sw,sw,sw,s,sw,s,sw,se,s,s,s,nw,s,s,ne,s,s,sw,s,nw,s,s,s,s,s,s,s,n,nw,se,sw,se,s,sw,nw,ne,s,sw,se,s,ne,s,s,s,s,s,s,s,se,s,sw,s,nw,ne,se,s,sw,s,se,s,s,s,s,s,s,se,n,se,nw,se,se,ne,ne,s,se,ne,se,s,se,se,se,nw,s,s,n,ne,se,se,sw,sw,s,se,n,se,s,se,se,nw,se,se,se,se,nw,se,se,se,n,sw,ne,se,se,ne,ne,se,se,se,nw,se,se,ne,se,se,se,ne,ne,se,se,n,se,ne,ne,se,se,n,sw,se,se,ne,s,se,ne,se,n,se,ne,se,se,ne,se,ne,se,ne,se,se,se,se,ne,se,se,s,se,ne,ne,se,sw,se,n,ne,ne,ne,ne,nw,ne,ne,ne,nw,ne,nw,ne,ne,ne,ne,ne,ne,ne,ne,se,ne,s,se,ne,ne,ne,ne,ne,se,ne,sw,ne,ne,nw,s,ne,ne,ne,ne,ne,s,nw,ne,ne,ne,ne,ne,ne,ne,ne,sw,ne,n,n,n,ne,ne,ne,ne,ne,sw,ne,s,ne,n,ne,ne,se,ne,se,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,n,n,n,n,ne,se,ne,n,ne,ne,nw,ne,n,nw,ne,n,s,nw,n,se,ne,ne,n,n,n,se,ne,ne,n,n,sw,n,n,ne,se,ne,n,n,se,se,ne,ne,se,s,n,se,se,n,n,ne,ne,sw,s,ne,ne,ne,ne,n,ne,ne,n,n,ne,ne,n,n,n,n,n,n,n,n,se,n,n,n,n,n,se,se,n,n,ne,n,nw,n,n,n,n,s,n,s,n,nw,n,n,n,n,n,n,n,s,ne,se,n,n,n,ne,n,n,n,nw,n,n,n,n,n,s,n,n,n,n,nw,nw,n,n,nw,n,n,n,n,n,n,ne,ne,n,n,n,n,n,n,s,nw,nw,nw,ne,n,n,s,sw,n,n,n,n,n,nw,sw,nw,sw,nw,ne,nw,nw,n,sw,nw,n,n,s,nw,sw,nw,nw,se,nw,nw,n,n,n,nw,n,nw,nw,n,nw,n,nw,n,n,n,sw,nw,nw,nw,n,ne,nw,nw,nw,n,sw,n,n,nw,n,n,nw,n,s,n,nw,n,se,n,s,sw,ne,n,nw,nw,nw,ne,nw,n,n,ne,nw,n,s,nw,s,sw,nw,n,n,sw,nw,nw,n,nw,n,nw,nw,n,n,nw,n,n,se,n,se,n,n,n,nw,s,nw,nw,n,nw,s,n,n,nw,ne,nw,nw,n,nw,n,nw,nw,sw,nw,s,nw,nw,n,nw,nw,n,nw,s,n,s,n,nw,nw,nw,nw,nw,nw,nw,nw,nw,ne,nw,nw,nw,sw,nw,nw,nw,nw,nw,nw,se,nw,nw,nw,nw,nw,ne,nw,s,nw,nw,n,n,nw,nw,nw,nw,nw,nw,nw,nw,nw,s,nw,n,nw,nw,nw,nw,sw,nw,ne,nw,nw,nw,nw,ne,sw,nw,nw,nw,nw,nw,sw,ne,nw,ne,nw,se,nw,sw,nw,nw,s,se,nw,nw,n,nw,nw,nw,nw,nw,se,nw,nw,nw,sw,ne,n,nw,sw,nw,nw,nw,nw,sw,nw,nw,nw,sw,ne,n,nw,nw,n,se,s,sw,nw,nw,nw,nw,nw,nw,sw,sw,s,sw,nw,s,nw,nw,ne,nw,nw,sw,nw,nw,n,n,sw,nw,nw,nw,nw,nw,sw,se,s,nw,sw,nw,nw,sw,nw,sw,nw,nw,se,nw,nw,sw,s,nw,sw,n,nw,nw,sw,nw,nw,nw,nw,nw,sw,se,sw,sw,nw,ne,sw,nw,sw,nw,nw,sw,sw,sw,sw,nw,nw,sw,nw,nw,sw,nw,n,nw,sw,nw,nw,sw,sw,nw,se,nw,sw,sw,sw,nw,sw,nw,nw,sw,sw,sw,nw,s,nw,sw,sw,sw,sw,sw,nw,sw,nw,sw,sw,sw,sw,nw,n,nw,sw,ne,nw,nw,nw,sw,ne,ne,sw,nw,ne,sw,sw,sw,sw,sw,nw,sw,ne,nw,sw,sw,sw,sw,nw,sw,n,nw,n,sw,sw,sw,nw,sw,se,sw,sw,nw,nw,n,nw,sw,sw,sw,sw,se,s,nw,n,sw,sw,nw,n,s,sw,sw,sw,sw,sw,ne,sw,se,sw,sw,sw,sw,sw,se,sw,sw,sw,sw,sw,sw,sw,sw,sw,ne,sw,se,sw,sw,sw,s,sw,sw,sw,sw,n,sw,sw,sw,sw,sw,se,sw,sw,ne,sw,sw,nw,sw,s,sw,sw,ne,sw,nw,sw,sw,sw,sw,sw,n,sw,ne,n,sw,sw,sw,sw,sw,se,sw,sw,sw,nw,s,sw,sw,sw,ne,sw,s,sw,n,sw,se,s,sw,sw,ne,s,s,sw,sw,se,se,sw,s,sw,sw,sw,sw,ne,sw,ne,se,sw,sw,s,sw,s,sw,sw,sw,sw,sw,s,sw,sw,se,sw,sw,sw,sw,ne,sw,nw,s,sw,sw,nw,sw,sw,s,sw,sw,s,s,sw,nw,sw,sw,sw,sw,n,sw,sw,sw,sw,s,sw,sw,n,sw,s,sw,ne,sw,s,sw,sw,s,sw,n,s,se,sw,sw,sw,sw,sw,sw,sw,s,s,s,sw,sw,sw,s,se,sw,sw,ne,sw,sw,sw,ne,sw,sw,nw,sw,sw,sw,n,sw,ne,sw,s,ne,s,sw,s,sw,s,s,s,sw,s,sw,s,ne,sw,sw,s,n,s,sw,s,s,sw,s,n,s,s,sw,sw,nw,sw,sw,s,sw,sw,se,sw,s,s,sw,se,s,s,s,sw,s,s,se,s,ne,s,sw,sw,nw,sw,n,s,sw,s,s,s,s,s,sw,s,sw,se,sw,s,s,sw,sw,n,sw,s,sw,sw,sw,s,sw,sw,s,s,s,s,sw,s,s,s,n,s,s,sw,s,sw,s,se,sw,s,sw,sw,n,s,s,s,s,nw,s,n,s,s,sw,sw,s,s,s,nw,s,se,s,s,n,sw,sw,n,sw,s,s,s,n,ne,ne,sw,sw,s,sw,s,s,s,s,s,s,s,s,s,s,s,sw,s,s,sw,sw,s,s,s,s,s,n,s,s,s,s,s,sw,sw,se,s,s,s,n,se,sw,n,s,s,sw,s,sw,sw,s,s,ne,sw,sw,sw,ne,s,s,se,s,s,s,s,s,s,s,s,nw,s,s,s,s,sw,s,s,s,s,s,s,s,s,s,s,s,sw,nw,s,s,se,s,s,s,s,s,s,sw,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,se,s,s,nw,s,s,s,s,s,s,n,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,se,s,sw,s,s,s,s,sw,ne,s,ne,s,ne,s,s,s,s,s,n,s,ne,sw,s,s,n,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,ne,se,s,s,se,s,s,se,s,s,se,s,se,s,s,nw,se,s,s,s,s,ne,s,s,nw,se,ne,n,nw,s,s,sw,s,s,s,s,s,s,ne,s,s,s,sw,s,s,se,s,s,s,s,ne,se,s,s,s,se,n,se,se,s,s,se,s,ne,s,sw,s,s,s,s,nw,s,s,s,se,n,s,sw,s,s,s,s,se,s,s,ne,se,se,nw,se,s,s,se,s,sw,sw,s,se,n,s,s,se,s,s,sw,se,s,s,s,s,n,s,s,s,n,se,s,s,se,s,s,se,s,se,se,se,s,ne,s,s,s,s,se,s,se,se,s,s,s,s,s,s,s,s,ne,s,s,se,se,se,s,s,s,s,s,nw,nw,s,s,se,se,sw,ne,se,s,ne,n,se,s,s,s,s,s,s,s,s,s,se,s,s,se,se,s,se,se,s,se,s,se,s,se,s,s,nw,s,s,s,s,n,s,se,sw,se,s,s,ne,se,se,s,s,s,ne,s,sw,se,s,s,s,s,se,nw,s,se,se,se,s,nw,s,s,se,s,sw,se,s,se,s,s,s,s,se,n,ne,s,s,s,sw,se,s,se,se,se,s,ne,s,s,nw,s,sw,se,se,s,se,se,s,se,s,s,se,se,se,s,se,s,s,s,s,se,ne,se,s,s,s,se,s,s,s,s,se,s,n,s,se,n,s,s,sw,se,se,s,s,se,s,s,s,s,s,se,se,s,n,nw,s,se,se,se,se,se,sw,se,se,s,se,se,se,se,s,se,se,se,s,se,se,se,se,se,se,s,se,se,se,ne,s,se,se,s,se,ne,se,se,se,se,s,se,se,s,n,s,se,s,se,s,se,nw,se,se,se,se,se,se,s,se,se,se,n,s,se,se,nw,se,s,sw,se,s,se,n,se,s,se,s,se,s,se,se,n,se,sw,se,se,s,se,s,se,se,se,se,se,se,s,se,se,se,sw,se,se,n,nw,se,se,se,s,se,se,sw,se,s,se,se,n,se,s,se,ne,se,nw,s,s,n,se,se,se,se,s,se,se,sw,se,se,se,se,se,s,nw,se,se,ne,se,se,nw,n,se,se,se,ne,se,se,se,se,se,se,se,se,se,se,s,nw,se,se,se,nw,ne,se,se,se,se,se,se,nw,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,se,nw,se,se,se,se,se,se,se,ne,se,se,s,se,se,se,se,s,se,se,n,se,se,ne,se,se,n,se,n,se,se,se,nw,se,sw,se,s,se,se,sw,se,se,se,se,se,se,se,s,se,se,se,se,se,s,se,se,se,se,nw,se,ne,n,se,se,se,se,se,se,se,se,nw,se,se,sw,se,se,se,n,se,ne,se,se,ne,se,se,se,se,se,ne,nw,se,se,se,se,s,se,se,se,se,se,se,s,nw,se,se,se,se,se,se,se,se,se,se,se,ne,se,se,ne,se,se,se,ne,se,se,s,n,ne,ne,s,se,se,n,se,se,ne,se,ne,ne,se,se,se,ne,se,se,sw,se,se,n,ne,nw,se,se,s,ne,se,ne,se,s,se,ne,se,se,se,ne,ne,se,se,se,n,s,ne,ne,ne,ne,ne,ne,se,se,ne,se,se,se,n,se,se,se,se,se,se,s,nw,se,s,se,se,ne,n,se,n,ne,se,n,n,se,se,s,se,se,ne,se,ne,ne,se,sw,n,n,ne,se,sw,ne,se,se,se,se,se,se,sw,sw,se,ne,se,se,nw,ne,se,se,ne,se,se,se,se,se,se,se,se,ne,se,ne,se,se,ne,ne,se,n,ne,ne,n,n,se,ne,se,se,ne,ne,se,se,se,n,se,se,se,n,se,sw,se,ne,n,n,se,se,nw,ne,se,nw,se,se,sw,se,se,se,ne,se,se,se,ne,se,se,se,sw,n,ne,ne,se,nw,ne,se,se,n,se,se,ne,se,se,ne,se,nw,ne,se,se,se,nw,n,se,se,ne,ne,s,ne,se,ne,sw,se,se,se,se,s,se,se,se,se,ne,n,se,sw,se,ne,ne,se,ne,sw,ne,se,se,ne,ne,se,se,se,ne,sw,ne,sw,ne,n,se,se,se,nw,ne,se,ne,ne,se,ne,se,ne,s,se,ne,ne,se,se,se,ne,se,ne,sw,ne,se,sw,ne,n,se,ne,se,se,nw,ne,ne,se,ne,ne,ne,ne,ne,s,se,ne,se,se,s,ne,ne,se,ne,ne,ne,nw,ne,ne,ne,se,ne,se,ne,se,se,se,ne,se,se,ne,se,se,se,ne,se,se,ne,ne,ne,se,nw,nw,se,ne,s,se,se,se,se,se,n,s,ne,ne,n,ne,ne,se,se,ne,ne,ne,ne,ne,ne,se,ne,ne,ne,ne,se,se,se,se,n,ne,se,sw,se,se,ne,nw,s,nw,se,ne,se,ne,sw,se,sw,n,n,s,ne,ne,nw,se,se,sw,se,se,se,se,se,n,ne,se,ne,se,nw,ne,ne,se,nw,se,ne,se,ne,ne,s,se,ne,ne,ne,se,se,ne,se,se,ne,s,ne,ne,ne,sw,ne,se,se,ne,n,se,ne,nw,se,ne,nw,se,ne,ne,ne,nw,se,se,se,ne,se,n,ne,ne,se,n,nw,se,se,sw,sw,ne,nw,ne,ne,ne,se,s,ne,sw,se,se,ne,ne,se,ne,ne,ne,se,sw,se,ne,se,se,ne,ne,n,ne,se,ne,ne,s,ne,ne,ne,ne,ne,ne,ne,se,ne,ne,ne,ne,ne,se,ne,sw,ne,nw,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,se,se,ne,ne,ne,sw,sw,ne,ne,nw,ne,ne,ne,nw,ne,se,ne,ne,ne,n,ne,sw,nw,ne,se,ne,ne,ne,s,se,ne,n,ne,ne,ne,ne,sw,ne,ne,ne,se,ne,se,s,ne,nw,ne,n,se,ne,ne,ne,ne,se,ne,ne,ne,se,ne,ne,ne,ne,se,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,nw,ne,ne,ne,ne,s,ne,ne,ne,sw,ne,n,ne,ne,ne,ne,ne,ne,nw,ne,ne,ne,sw,ne,n,ne,n,sw,se,ne,sw,ne,ne,ne,se,ne,ne,ne,nw,ne,ne,ne,s,ne,se,ne,s,ne,ne,ne,ne,ne,se,sw,ne,s,ne,ne,n,ne,ne,ne,nw,n,ne,ne,n,ne,ne,s,ne,ne,se,n,ne,ne,ne,sw,s,ne,se,ne,ne,ne,ne,ne,sw,ne,ne,s,ne,n,ne,ne,ne,ne,ne,ne,ne,sw,s,ne,ne,ne,n,nw,nw,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,sw,ne,ne,se,ne,ne,ne,ne,ne,ne,se,se,sw,sw,ne,ne,ne,ne,ne,se,ne,ne,ne,sw,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,nw,n,ne,ne,ne,ne,ne,sw,nw,sw,ne,ne,ne,nw,ne,ne,ne,ne,ne,n,ne,ne,ne,ne,ne,ne,ne,ne,ne,nw,n,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,sw,ne,ne,ne,sw,n,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,nw,sw,nw,ne,ne,ne,ne,n,n,n,s,n,ne,n,ne,nw,sw,s,n,ne,ne,ne,se,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,n,ne,ne,ne,s,s,s,ne,ne,ne,ne,ne,ne,ne,ne,ne,n,ne,ne,ne,n,ne,ne,ne,se,ne,ne,ne,nw,ne,ne,ne,ne,s,ne,ne,n,ne,ne,n,ne,n,ne,ne,ne,nw,nw,ne,ne,ne,s,ne,ne,se,n,ne,ne,ne,ne,se,sw,n,n,ne,n,sw,ne,n,ne,ne,s,ne,ne,se,ne,n,se,ne,ne,nw,ne,ne,se,ne,n,ne,ne,sw,ne,ne,n,ne,ne,ne,ne,ne,ne,nw,ne,ne,ne,nw,n,n,ne,n,ne,n,sw,ne,ne,n,n,ne,ne,s,ne,sw,s,nw,n,ne,n,ne,s,n,n,n,n,ne,s,ne,ne,se,sw,ne,n,n,n,s,ne,n,ne,ne,ne,n,ne,ne,ne,se,ne,n,ne,ne,nw,ne,sw,n,n,sw,nw,n,se,ne,ne,ne,se,n,ne,n,n,ne,ne,n,ne,ne,ne,ne,n,n,ne,ne,ne,n,n,ne,nw,ne,se,ne,ne,ne,ne,se,ne,n,ne,n,n,ne,n,ne,se,ne,ne,se,ne,n,n,ne,ne,ne,ne,se,nw,nw,ne,ne,ne,ne,n,ne,n,ne,n,ne,n,ne,sw,ne,ne,s,n,ne,ne,n,n,ne,sw,ne,n,ne,ne,n,ne,se,ne,se,n,ne,n,sw,ne,n,ne,s,n,ne,ne,ne,ne,ne,nw,n,s,se,n,n,n,nw,ne,ne,ne,n,ne,ne,ne,ne,ne,ne,ne,se,ne,ne,ne,ne,ne,n,ne,ne,ne,ne,n,ne,ne,n,se,ne,sw,ne,ne,s,se,n,n,ne,s,nw,n,ne,ne,n,sw,se,ne,ne,n,n,n,n,n,n,ne,sw,ne,ne,n,ne,ne,n,n,n,nw,ne,n,ne,n,ne,n,s,ne,n,n,n,n,ne,ne,ne,n,n,s,ne,ne,s,se,ne,ne,nw,n,n,n,ne,ne,ne,nw,se,n,ne,nw,ne,n,ne,ne,ne,s,n,ne,se,n,n,n,ne,ne,ne,se,n,n,ne,n,n,ne,sw,ne,n,n,n,n,n,n,ne,n,n,sw,n,se,n,n,n,se,ne,ne,n,s,se,nw,ne,ne,ne,n,ne,se,sw,n,se,se,n,ne,n,n,n,n,ne,n,ne,n,nw,ne,ne,n,sw,ne,n,sw,ne,ne,ne,ne,ne,n,n,n,ne,n,s,s,n,nw,ne,sw,n,nw,n,ne,ne,ne,n,ne,n,se,n,n,n,ne,ne,n,s,n,n,ne,ne,n,s,n,n,n,ne,n,n,ne,sw,n,n,s,n,n,n,ne,se,ne,sw,ne,ne,sw,n,n,se,n,n,n,ne,ne,n,nw,nw,n,ne,n,ne,n,se,ne,n,n,ne,n,ne,n,nw,n,ne,sw,sw,ne,sw,ne,ne,n,n,s,n,ne,n,se,ne,n,n,n,n,ne,n,n,n,n,n,ne,n,n,n,n,n,se,sw,se,n,ne,n,ne,sw,n,ne,n,n,ne,ne,n,n,ne,ne,ne,se,n,n,nw,n,se,n,ne,n,n,s,s,n,ne,n,n,n,n,n,n,n,n,n,ne,ne,n,ne,n,ne,ne,s,n,se,n,se,n,n,ne,s,n,ne,n,ne,n,ne,ne,se,s,sw,n,se,n,se,ne,n,n,n,ne,n,ne,n,ne,sw,ne,s,sw,n,sw,n,ne,ne,n,se,n,n,n,ne,ne,nw,n,n,ne,n,n,n,n,n,ne,ne,n,ne,n,n,n,n,ne,n,n,sw,n,n,n,n,n,ne,n,n,n,sw,ne,ne,n,sw,s,n,n,n,n,n,n,ne,ne,ne,n,s,ne,n,sw,s,n,n,n,se,n,n,n,n,n,n,n,n,se,n,ne,s,n,n,nw,n,ne,s,n,se,sw,n,n,ne,n,ne,sw,n,n,n,n,n,nw,ne,n,n,ne,ne,n,ne,se,nw,ne,n,n,n,ne,nw,n,n,se,n,n,ne,n,n,s,se,ne,se,sw,n,nw,n,s,n,n,se,se,n,n,n,n,n,n,n,n,n,n,n,sw,n,n,ne,nw,n,n,sw,sw,s,ne,n,n,n,n,n,n,n,n,n,s,n,nw,n,ne,s,n,sw,n,ne,s,n,n,sw,n,n,nw,s,se,n,n,s,n,n,n,n,n,n,n,n,n,n,n,sw,ne,n,ne,sw,nw,n,n,s,n,n,n,n,n,n,n,n,nw,nw,n,n,n,ne,se,se,n,n,n,nw,se,sw,n,n,n,n,n,n,n,n,n,se,ne,n,n,n,n,n,n,n,nw,n,s,n,n,n,ne,n,n,sw,n,n,n,n,n,n,n,n,n,n,se,n,n,n,n,n,n,ne,n,n,n,n,n,n,s,n,n,n,n,sw,sw,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,nw,n,s,ne,n,s,n,n,n,sw,n,n,n,se,n,n,nw,n,n,n,sw,n,n,n,n,n,n,s,n,n,n,n,ne,n,n,ne,n,n,s,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,s,n,n,n,n,se,n,nw,n,n,n,n,n,n,n,n,n,n,n,sw,n,n,n,n,s,n,nw,n,n,ne,n,sw,n,sw,n,n,n,n,n,nw,nw,ne,nw,ne,n,n,s,s,n,n,n,nw,nw,n,se,n,n,n,n,n,n,s,sw,n,n,n,n,n,n,n,n,n,n,se,n,n,n,n,n,n,n,nw,n,n,n,nw,nw,n,n,nw,n,ne,n,n,n,n,sw,n,n,n,n,ne,n,nw,se,nw,n,n,ne,s,se,n,n,n,nw,nw,sw,n,n,n,se,n,n,n,n,n,n,n,n,n,n,se,n,se,n,n,se,n,n,n,nw,n,ne,n,se,n,n,ne,se,n,n,n,n,n,sw,ne,n,n,se,n,n,n,n,n,n,se,n,s,n,n,nw,n,n,s,n,n,n,n,n,n,n,n,n,n,nw,n,n,n,n,n,s,nw,n,n,n,s,n,n,n,n,sw,n,n,nw,nw,se,n,n,n,nw,n,n,n,nw,ne,n,n,nw,n,se,n,nw,nw,nw,n,nw,n,s,n,n,nw,nw,se,n,n,s,nw,n,n,se,n,n,n,nw,n,n,n,n,sw,n,n,nw,n,n,n,n,nw,nw,n,n,n,n,n,n,nw,nw,n,nw,n,n,n,n,sw,n,n,n,n,n,sw,n,n,n,n,n,sw,n,n,n,n,n,n,n,nw,n,n,s,nw,n,ne,n,n,sw,sw,se,n,s,n,n,nw,ne,s,n,n,n,nw,nw,n,nw,n,s,nw,n,n,nw,nw,n,n,n,s,n,nw,n,n,nw,ne,n,sw,s,n,n,n,nw,n,n,nw,n,n,nw,s,nw,nw,n,s,ne,nw,n,n,nw,ne,n,n,n,n,n,n,n,n,nw,nw,n,n,nw,sw,sw,s,n,n,ne,n,n,n,n,n,n,n,n,n,sw,n,n,n,nw,s,nw,nw,n,n,nw,s,n,n,n,n,nw,n,n,n,n,n,s,n,nw,sw,n,se,nw,s,sw,n,n,se,se,n,nw,n,n,n,n,n,n,nw,n,n,n,nw,nw,n,n,n,n,n,n,n,n,n,n,nw,nw,n,n,n,se,sw,n,s,n,se,n,n,s,n,sw,nw,nw,n,se,nw,n,nw,n,n,nw,ne,n,n,n,n,n,n,n,nw,n,n,nw,nw,n,n,nw,se,s,n,n,nw,nw,s,n,n,sw,n,n,ne,nw,n,nw,n,nw,n,nw,se,sw,n,n,nw,nw,n,nw,sw,nw,n,nw,n,nw,ne,n,nw,n,n,nw,n,nw,nw,sw,n,sw,nw,n,n,nw,n,n,nw,se,nw,se,n,nw,nw,nw,nw,n,se,n,nw,n,nw,sw,nw,s,nw,n,nw,nw,nw,ne,nw,n,ne,nw,nw,nw,nw,n,n,nw,n,nw,n,sw,se,sw,sw,ne,n,sw,n,n,n,n,n,nw,n,n,nw,nw,n,se,nw,n,nw,n,n,nw,n,nw,nw,n,nw,nw,n,n,nw,nw,n,nw,n,nw,n,nw,nw,n,nw,s,n,n,n,nw,nw,n,nw,n,s,n,nw,nw,n,se,nw,se,n,n,nw,n,n,n,nw,n,nw,nw,ne,nw,nw,n,nw,n,nw,n,nw,n,nw,nw,n,n,nw,nw,n,n,nw,nw,ne,n,sw,nw,n,s,n,n,nw,nw,n,n,n,n,nw,nw,ne,ne,n,se,n,n,n,s,s,nw,n,s,n,nw,nw,nw,n,n,s,sw,ne,n,n,nw,n,n,n,se,se,ne,s,n,nw,n,nw,nw,n,nw,n,n,nw,ne,sw,n,nw,n,n,nw,ne,se,nw,se,nw,n,n,n,n,nw,nw,n,nw,nw,nw,n,nw,n,nw,n,n,se,n,nw,n,n,nw,n,nw,nw,nw,n,n,se,n,n,n,nw,nw,n,nw,nw,ne,nw,n,s,n,n,n,nw,sw,nw,n,nw,s,sw,n,nw,nw,n,s,nw,n,nw,nw,nw,n,nw,n,n,n,s,nw,nw,n,nw,s,nw,nw,n,nw,nw,nw,nw,nw,nw,nw,nw,nw,n,n,nw,nw,ne,nw,n,nw,se,n,ne,nw,nw,nw,n,nw,n,n,n,n,nw,n,n,n,nw,nw,nw,se,nw,nw,n,nw,nw,s,n,n,n,sw,n,nw,nw,s,nw,n,n,ne,nw,n,sw,n,nw,sw,nw,nw,nw,nw,nw,s,n,nw,nw,n,ne,n,sw,se,n,nw,n,s,n,n,n,n,nw,sw,nw,n,nw,ne,nw,nw,n,se,n,sw,s,nw,nw,n,nw,nw,nw,nw,n,nw,nw,nw,se,s,ne,se,n,nw,s,nw,sw,nw,nw,se,nw,n,nw,nw,n,nw,nw,nw,sw,n,n,s,n,n,n,nw,s,n,n,n,nw,nw,n,nw,nw,nw,s,nw,nw,n,n,ne,nw,nw,nw,sw,n,n,n,nw,nw,n,n,n,nw,nw,nw,nw,nw,nw,nw,s,sw,nw,n,nw,s,n,ne,nw,nw,nw,nw,nw,s,nw,sw,nw,n,nw,nw,n,n,s,ne,n,nw,nw,n,nw,n,nw,n,nw,sw,nw,n,n,nw,nw,se,s,sw,se,nw,sw,n,nw,nw,n,n,nw,sw,nw,ne,n,s,se,nw,se,nw,n,n,n,n,sw,nw,nw,n,nw,nw,n,n,nw,s,nw,nw,ne,nw,nw,nw,nw,nw,nw,sw,s,nw,ne,nw,n,s,nw,n,nw,n,n,nw,nw,nw,s,nw,nw,n,sw,nw,n,n,nw,nw,nw,nw,n,n,nw,nw,nw,nw,n,nw,nw,nw,ne,nw,nw,sw,nw,n,nw,nw,n,n,sw,sw,nw,nw,nw,se,nw,sw,n,nw,n,nw,se,nw,nw,nw,nw,nw,n,n,n,nw,nw,nw,nw,nw,nw,n,n,nw,nw,nw,nw,s,nw,n,sw,nw,nw,sw,nw,nw,n,nw,n,s,nw,sw,n,nw,n,nw,nw,n,nw,se,n,nw,nw,n,nw,n,nw,nw,ne,nw,se,nw,s,s,se,n,nw,nw,nw,nw,se,se,nw,s,nw,nw,nw,nw,s,sw,se,nw,nw,nw,nw,nw,se,n,n,nw,s,nw,nw,sw,ne,nw,sw,nw,nw,nw,s,sw,ne,nw,ne,sw,nw,s,nw,nw,nw,nw,nw,nw,nw,se,nw,nw,nw,nw,se,nw,nw,nw,ne,se,n,ne,nw,nw,nw,s,nw,nw,n,nw,s,n,nw,sw,nw,s,sw,n,nw,n,nw,nw,nw,nw,n,nw,nw,nw,ne,nw,nw,n,nw,nw,n,n,nw,s,nw,nw,nw,nw,nw,sw,se,nw,nw,sw,nw,ne,se,nw,nw,se,n,nw,nw,n,se,n,nw,n,sw,nw,nw,nw,nw,nw,n,nw,se,s,se,nw,sw,nw,s,sw,nw,nw,nw,se,nw,sw,s,nw,n,nw,nw,nw,se,ne,nw,nw,nw,nw,nw,ne,ne,nw,nw,sw,ne,nw,nw,nw,nw,se,n,nw,s,sw,s,nw,nw,nw,ne,ne,n,nw,s,nw,nw,nw,sw,n,nw,nw,n,nw,nw,nw,ne,se,nw,nw,nw,nw,nw,nw,sw,nw,sw,nw,nw,nw,nw,nw,nw,nw,nw,s,se,s,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,se,nw,nw,nw,nw,nw,nw,nw,ne,nw,nw,n,nw,n,nw,n,nw,nw,s,ne,nw,nw,s,ne,nw,nw,nw,ne,s,nw,nw,nw,sw,nw,se,nw,ne,nw,s,nw,se,nw,nw,nw,ne,nw,nw,nw,n,nw,nw,sw,ne,nw,n,n,nw,n,nw,n,ne,nw,n,s,nw,nw,sw,nw,nw,nw,nw,nw,nw,nw,se,se,sw,n,nw,nw,ne,nw,nw,nw,nw,nw,n,nw,nw,s,nw,nw,nw,ne,nw,n,nw,nw,nw,nw,n,nw,nw,sw,nw,nw,n,nw,s,sw,nw,n,nw,sw,nw,n,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,nw,se,se,sw,nw,nw,nw,nw,nw,s,n,sw,sw,se,se,se,se,nw,se,se,s,sw,s,s,s,s,s,s,sw,sw,s,sw,sw,nw,sw,s,sw,sw,n,s,nw,sw,nw,s,se,n,ne,nw,nw,nw,nw,nw,n,nw,nw,nw,n,nw,nw,n,n,nw,s,n,n,sw,n,n,n,n,n,ne,n,n,sw,ne,nw,n,n,n,n,ne,n,se,n,n,n,ne,ne,n,ne,ne,n,n,se,ne,se,ne,ne,ne,ne,ne,s,n,n,ne,ne,ne,se,ne,ne,ne,nw,ne,ne,se,ne,se,ne,ne,ne,ne,ne,ne,ne,ne,ne,nw,se,se,ne,sw,se,se,se,ne,se,ne,s,ne,se,ne,se,se,se,se,se,se,se,se,se,n,se,se,n,n,se,se,se,nw,se,nw,se,s,se,se,se,s,se,ne,se,se,sw,se,se,se,se,nw,nw,se,se,se,ne,s,s,se,ne,s,s,se,sw,n,se,s,se,n,se,se,nw,s,n,s,se,nw,s,sw,s,s,ne,s,s,s,s,s,s,ne,s,n,se,se,s,s,sw,s,n,se,ne,s,s,s,se,s,s,s,s,nw,s,s,s,sw,sw,se,s,s,n,s,s,sw,s,s,s,n,s,sw,s,s,sw,s,nw,s,s,nw,s,sw,s,s,s,s,s,se,ne,s,sw,s,s,s,sw,sw,s,nw,ne,nw,sw,sw,sw,sw,s,s,s,sw,ne,nw,s,s,s,s,sw,s,sw,sw,s,sw,sw,sw,nw,sw,sw,sw,sw,s,s,s,sw,sw,sw,s,sw,sw,sw,sw,sw,sw,ne,sw,sw,s,sw,sw,se,sw,sw,sw,n,sw,n,nw,nw,ne,sw,sw,sw,sw,sw,sw,sw,s,nw,sw,sw,sw,n,sw,sw,sw,sw,n,sw,sw,n,sw,sw,sw,n,sw,sw,n,sw,sw,se,sw,sw,sw,sw,sw,sw,sw,nw,sw,se,nw,nw,sw,nw,se,sw,sw,nw,sw,sw,nw,sw,sw,sw,nw,sw,sw,sw,sw,sw,sw,nw,sw,nw,ne,sw,sw,ne,s,sw,nw,sw,sw,nw,nw,nw,se,nw,nw,nw,sw,sw,s,nw,sw,n,nw,sw,nw,nw,nw,sw,nw,sw,nw,sw,sw,sw,nw,se,sw,nw,ne,nw,ne,sw,s,sw,n,nw,s,nw,nw,nw,se,nw,nw,nw,nw,nw,nw,s,nw,sw,nw,nw,nw,nw,sw,nw,ne,nw,s,nw,ne,nw,nw,nw,nw,nw,se,nw,nw,nw,nw,nw,nw,sw,s,nw,nw,nw,nw,s,nw,s,nw,nw,se,se,nw,n,nw,nw,se,n,nw,nw,nw,nw,nw,nw,se,sw,nw,sw,nw,nw,nw,nw,nw,nw,nw,nw,n,nw,nw,s,nw,nw,n,sw,nw,n,n,n,se,ne,n,nw,nw,nw,s,n,nw,n,nw,n,nw,nw,nw,n,n,nw,ne,n,nw,s,s,nw,ne,ne,nw,n,s,n,nw,nw,nw,n,nw,se,se,s,nw,n,n,nw,n,ne,nw,se,nw,n,ne,sw,ne,sw,n,nw,n,n,nw,n,n,n,nw,n,nw,n,n,n,nw,n,n,n,nw,sw,n,n,n,n,nw,n,nw,ne,nw,ne,ne,n,n,nw,n,nw,n,nw,n,n,sw,n,n,nw,nw,nw,n,nw,n,nw,sw,n,s,ne,n,nw,nw,ne,n,n,n,n,n,s,ne,nw,n,se,nw,n,n,n,n,n,n,se,n,n,n,n,ne,n,s,n,n,n,n,ne,n,n,n,n,sw,n,n,n,n,n,s,n,n,n,nw,n,sw,n,n,n,n,n,n,n,n,ne,n,n,n,n,n,n,n,n,ne,n,ne,n,ne,s,n,n,sw,n,n,ne,ne,n,sw,n,n,se,se,n,n,s,n,n,n,n,n,n,n,n,n,n,se,n,n,n,n,ne,n,n,n,se,nw,ne,sw,n,sw,ne,n,n,n,n,n,n,nw,ne,n,ne,se,n,n,n,sw,sw,ne,n,n,n,n,ne,n,n,n,ne,n,ne,n,n,ne,n,n,n,ne,se,ne,nw,n,n,n,n,ne,n,n,n,n,ne,n,n,ne,sw,n,n,n,n,se,n,ne,ne,n,n,n,ne,nw,ne,n,ne,n,n,se,n,n,ne,n,n,ne,ne,n,nw,n,nw,ne,nw,n,nw,ne,ne,n,ne,n,ne,nw,ne,ne,n,n,n,n,ne,ne,s,ne,ne,n,ne,ne,ne,ne,n,ne,ne,n,nw,s,s,n,nw,n,ne,ne,ne,ne,ne,n,n,n,s,n,ne,ne,ne,ne,nw,nw,n,ne,n,n,ne,n,ne,ne,nw,n,ne,n,n,n,ne,ne,ne,se,n,ne,n,ne,n,ne,nw,s,ne,n,n,n,ne,n,nw,ne,se,ne,ne,n,ne,ne,ne,ne,se,n,ne,n,n,ne,n,ne,ne,ne,ne,ne,ne,n,nw,ne,ne,ne,n,ne,ne,ne,ne,n,ne,sw,se,ne,ne,ne,ne,n,ne,ne,ne,ne,ne,ne,ne,sw,sw,s,s,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,n,ne,ne,se,s,ne,nw,ne,ne,se,s,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,ne,se,se,ne,ne,se,se,ne,sw,n,ne,sw,ne,se,s,s,ne,ne,se,ne,se,se,n,se,ne,se,ne,ne,sw,ne,ne,ne,nw,n,ne,ne,ne,ne,sw,ne,ne,ne,s,se,ne,ne,ne,ne,se,ne,sw,ne,nw,ne,ne,ne,ne,ne,ne,ne,ne,se,ne,ne,ne,se,ne,se,sw,ne,ne,ne,sw,nw,n,se,se,ne,ne,ne,ne,n,ne,ne,se,se,ne,se,ne,sw,ne,ne,ne,ne,ne,se,ne,ne,ne,ne,se,ne,s,se,ne,ne,ne,ne,se,se,ne,se,se,se,nw,ne,ne,ne,ne,ne,se,ne,nw,nw,ne,s,ne,ne,se,ne,ne,ne,se,s,ne,ne,ne,ne,ne,ne,se,ne,sw,se,ne,se,sw,nw,se,ne,n,ne,se,ne,s,ne,se,ne,ne,ne,sw,ne,sw,se,ne,se,se,ne,ne,ne,ne,ne,ne,se,ne,sw,ne,se,ne,nw,se,ne,se,ne,ne,sw,se,s,se,sw,sw,ne,se,ne,ne,ne,se,se,n,se,sw,se,sw,n,ne,se,se,se,sw,se,se,sw,ne,se,ne,se,nw,nw,se,se,n,se,se,se,ne,se,se,ne,ne,ne,se,se,ne,se,nw,s,sw,se,se,ne,se,se,se,se,se,ne,se,ne,se,se,se,s,s,ne,se,se,se,sw,se,se,ne,se,sw,ne,se,se,ne,se,s,s,nw,se,se,se,ne,s,ne,se,se,se,n,se,s,ne,s,se,ne,se,ne,ne,se,nw,s,se,ne,se,ne,se,se,nw,sw,se,ne,ne,se,se,se,se,se,se,se,ne,se,sw,se,se,se,se,se,s,se,se,se,se,nw,nw,nw,s,sw,se,se,se,se,se,s,se,ne,se,se,se,se,s,se,se,se,se,nw,se,se,se,se,se,ne,se,se,sw,se,nw,se,se,se,se,se,se,se,se,se,se,se,ne,se,se,se,sw,se,s,se,se,se,nw,se,se,se,se,se,n,se,se,se,sw,se,se,se,s,se,se,nw,se,se,se,se,se,se,se,se,se,se,se,se,se,sw,nw,se,se,se,se,se,sw,se,se,se,nw,se,se,ne,se,se,se,sw,se,sw,se,n,se,se,se,se,s,se,se,s,se,ne,n,se,nw,se,se,se,se,se,se,sw,s,s,se,se,s,sw,se,se,se,se,s,s,ne,se,se,se,ne,sw,se,se,se,se,s,se,s,s,se,se,n,se,se,nw,se,se,s,sw,nw,se,nw,s,se,s,ne,se,sw,se,se,se,se,se,se,s,se,se,se,se,se,n,ne,s,se,se,se,se,se,sw,se,se,s,se,se,s,se,s,se,nw,se,s,se,se,ne,se,se,se,se,se,se,se,se,s,se,s,s,se,se,se,se,s,se,se,sw,se,se,se,se,s,s,se,se,se,se,se,s,s,se,se,se,se,se,se,se,se,s,s,se,se,se,s,sw,s,s,s,nw,se,se,s,se,s,se,se,s,s,s,s,se,se,s,sw,ne,s,se,nw,se,se,se,sw,se,ne,se,s,s,se,se,s,s,nw,n,se,n,se,se,se,n,s,se,sw,se,n,s,nw,se,se,se,n,se,se,se,s,sw,s,se,se,ne,s,s,n,s,se,s,s,ne,se,se,nw,nw,se,s,s,s,se,n,s,s,nw,se,sw,s,se,s,n,se,s,s,nw,se,s,s,se,sw,s,se,n,se,n,nw,nw,s,s,s,nw,se,se,s,s,se,se,s,s,se,se,s,s,se,n,nw,s,se,se,se,s,se,se,s,se,s,ne,se,s,se,s,se,s,s,s,s,n,s,s,n,se,nw,s,se,s,se,s,se,s,se,s,s,s,se,se,s,s,se,s,s,se,s,nw,s,s,n,se,s,se,s,n,se,s,s,se,s,se,ne,se,ne,s,s,s,s,s,s,s,s,s,s,ne,se,s,se,s,se,se,s,ne,s,s,se,s,ne,sw,s,s,s,s,s,ne,s,n,se,s,s,nw,s,s,se,se,s,s,nw,nw,sw,se,s,s,se,s,s,s,s,s,nw,s,s,s,se,sw,se,nw,s,s,s,s,se,n,se,se,s,ne,s,s,nw,se,s,s,s,s,sw,s,s,nw,s,s,se,s,n,s,ne,s,s,sw,se,s,s,s,s,s,s,s,s,s,s,s,s,sw,se,n,s,s,s,sw,s,s,s,s,se,s,s,se,se,s,s,s,ne,se,nw,s,s,s,s,s,nw,s,s,s,se,s,s,s,s,s,s,n,s,s,s,s,se,nw,s,s,s,ne,n,s,s,se,s,s,sw,s,se,s,s,s,s,n,s,s,s,s,s,se,s,s,s,s,s,s,s,n,ne,s,n,sw,s,sw,s,sw,s,se,s,s,nw,s,s,s,s,nw,s,s,s,s,ne,s,sw,s,s,s,se,s,s,s,s,se,se,se,s,s,s,ne,s,se,s,s,s,se,s,sw,nw,sw,s,s,se,sw,s,s,s,s,n,s,s,s,s,n,s,s,ne,se,s,s,s,s,s,ne,ne,s,s,s,s,s,n,nw,s,s,s,s,s,s,s,s,s,s,sw,sw,s,s,nw,nw,s,se,se,s,n,s,s,s,ne,sw,s,n,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,nw,nw,s,se,s,s,s,sw,se,s,sw,s,s,s,s,sw,sw,sw,s,sw,s,s,n,s,sw,s,s,s,sw,sw,s,s,sw,ne,ne,s,s,nw,s,s,s,s,s,s,sw,sw,s,s,ne,s,s,s,s,n,nw,se,sw,n,sw,s,nw,s,s,s,ne,s,s,sw,s,se,s,s,s,n,ne,s,nw,n,s,s,s,sw,n,s,ne,s,sw,s,n,s,s,se,sw,s,se,ne,se,s,sw,s,s,s,s,ne,se,sw,se,se,s,s,sw,se,s,s,se,s,se,sw,sw,s,ne,s,s,s,s,ne,s,s,ne,sw,sw,s,s,n,s,s,ne,s,n,s,sw,s,s,se,s,nw,s,sw,s,s,s,s,s,s,s,s,s,s,n,se,n,sw,s,sw,sw,sw,ne,sw,s,sw,s,s,sw,sw,n,s,sw,s,s,s,n,sw,sw,n,ne,s,sw,ne,s,s,ne,sw,sw,s,sw,s,se,se,s,sw,nw,s,nw,s,sw,ne,s,s,sw,s,s,sw,sw,sw,sw,s,ne,n,s,sw,s,s,sw,s,s,ne,s,se,sw,nw,s,s,s,s,sw,s,nw,sw,sw,s,nw,sw,s,sw,s,n,se,sw,s,s,s,se,sw,sw,nw,s,s,sw,s,sw,sw,sw,s,sw,sw,s,s,sw,s,sw,sw,nw,s,s,s,s,s,s,sw,sw,s,sw,sw,s,sw,sw,sw,se,sw,s,s,s,sw,sw,s,sw,s,nw,s,s,s,sw,sw,sw,s,sw,s,s,s,sw,se,sw,nw,sw,s,nw,sw,nw,ne,sw,s,sw,s,nw,sw,s,sw,sw,s,s,n,s,sw,sw,n,sw,nw,sw,s,s,nw,sw,sw,sw,ne,sw,nw,s,s,s,s,sw,n,sw,sw,n,sw,s,s,nw,sw,sw,sw,sw,s,sw,sw,ne,sw,sw,s,ne,sw,sw,ne,s,sw,s,s,s,sw,s,s,sw,s,se,nw,sw,se,s,s,sw,sw,s,nw,sw,nw,sw,s,sw,sw,sw,sw,s,sw,sw,sw,sw,sw,s,s,sw,s,sw,s,sw,sw,sw,sw,s,s,s,se,sw,sw,ne,s,sw,se,se,sw,sw,sw,sw,ne,nw,sw,s,s,s,n,s,s,sw,s,s,se,s,n,n,sw,sw,s,s,sw,sw,s,sw,nw,nw,s,sw,sw,sw,s,sw,ne,nw,ne,sw,sw,s,n,sw,sw,s,sw,s,sw,sw,sw,sw,sw,s,sw,sw,ne,sw,nw,sw,n,sw,sw,sw,s,sw,nw,se,sw,sw,s,s,sw,sw,sw,s,sw,sw,se,sw,sw,sw,sw,se,sw,ne,se,ne,sw,sw,s,ne,sw,ne,s,sw,sw,sw,sw,sw,sw,s,sw,sw,sw,sw,sw,sw,sw,sw,s,sw,sw,n,ne,sw,n,sw,sw,ne,s,sw,sw,sw,sw,sw,s,sw,sw,n,sw,sw,nw,sw,sw,sw,s,s,s,sw,sw,n,sw,s,nw,sw,sw,s,sw,sw,sw,s,sw,sw,se,ne,sw,sw,sw,se,sw,sw,sw,sw,sw,sw,sw,sw,ne,sw,sw,sw,sw,s,sw,s,sw,sw,sw,sw,sw,ne,s,sw,sw,sw,nw,n,n,sw,ne,sw,sw,sw,sw,sw,sw,sw,se,sw,sw,ne,sw,sw,sw,sw,sw,s,ne,sw,sw,ne,s,sw,sw,n,sw,sw,sw,sw,se,sw,sw,sw,sw,sw,s,sw,sw,sw,sw,sw,n,sw,sw,sw,sw,sw,sw,sw,sw,sw,sw"""
