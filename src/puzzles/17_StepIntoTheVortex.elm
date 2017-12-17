module Puzzles.Day17 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Utils exposing (..)
import Array exposing (Array)


{-|
-}
type Msg
    = NoOp
    | InserValue


{-|
-}
type alias Model = 
    { buffer : Array Int
    , value : Int
    , current : Int
    , steps : Int
    , remaining : Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { buffer = [ 0 ] |> Array.fromList
      , value = 1
      , current = 0
      , steps = 3 --348
      , remaining = 2017
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

        InserValue ->
            case model.remaining > 0 of
                True ->
                    let
                        len =
                            Array.length model.buffer

                        newCurrent =
                            (model.current + model.steps) % len

                        leftBuffer =
                            model.buffer |> Array.slice 0 (newCurrent + 1)

                        rightBuffer =
                            case newCurrent + 1 == len of
                                True ->
                                    Array.empty

                                False ->
                                    model.buffer |> Array.slice (newCurrent - len + 1) len

                        newBuffer =
                            rightBuffer
                                |> Array.append
                                    ( [ model.value ]
                                        |> Array.fromList
                                        |> Array.append leftBuffer
                                    )

                        _ = Debug.log "" (model.remaining, model.value, model.current, newCurrent, len)
                    in
                    ( { model
                      | buffer = newBuffer
                      , current = newCurrent + 1 
                      , value = model.value + 1
                      , remaining = model.remaining - 1
                      }
                    , fireAction InserValue
                    --, Cmd.none
                    )

                False ->
                    let
                        _ = Debug.log "" model.buffer
                    in
                    ( model, Cmd.none )
{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-17" ]
        [ puzzleView
            "17 Spinlock"
            [ { partData
                | label = "1) Insert in buffer"
                , desc = "Insert values in circular buffer: "
                , solution = Just "417"
                }
            , { partData
                | label = "2) Value after 0"
                , desc = "Valie after 0 after 50M inserts: "
                , solution = Just "34334221"
                }
            ]
        ]
