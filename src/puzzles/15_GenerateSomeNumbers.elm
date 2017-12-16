module Puzzles.Day15 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Utils exposing (..)
import Bitwise


{-|
-}
type Msg
    = NoOp
    | FindPairs

{-|
-}
type alias Model = 
    { step : Int
    , prevA : Int
    , prevB : Int
    , partOne : Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { step = 0
      , prevA = startA
      , prevB = startB
      , partOne = 0
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

        FindPairs ->
            case model.step < (4 * 10^7) of
                True ->
                    let
                        genA =
                            (model.prevA * factorA) % divide

                        genB =
                            (model.prevB * factorB) % divide

                        bitA =
                            Bitwise.and genA mask

                        bitB =
                            Bitwise.and genB mask
                    in
                    ( { model
                      | step = model.step + 1
                      , prevA = genA
                      , prevB = genB
                      , partOne = if bitA == bitB then model.partOne + 1 else model.partOne
                      }
                    , fireAction FindPairs
                    )

                False ->
                    ( model, Cmd.none )

{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-15" ]
        [ puzzleView
            "15 Dueling Generators"
            [ { partData
                | label = "1) Pairs"
                , desc = "Number of generated pairs in 40M numbers: "
                , solution = Just "612"
                }
            , { partData
                | label = "2) Pairs of multiples"
                , desc = "Number of generated pairs in 5M numbers: "
                , solution = Just "285"
                }
            ]
        , p []
            [ text
                """First part of this puzzle was implemented in Elm, but unfortunatelly calculating this would be too slow in Elm,
                so the task was solved using Js and Node. With Node it ran in a couple of seconds, while with elm would take tens of minutes."""
            ]
        ]



{-|
-}
factorA : Int
factorA =
    16807

factorB : Int
factorB =
    48271

divide : Int
divide =
    (2 ^ 31) - 1

mask : Int
mask =
    (2 ^ 16) - 1

startA : Int
startA =
    65
    --722

startB : Int
startB =
    8921
    --354
