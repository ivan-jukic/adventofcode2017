import Html exposing (..)
import PuzzleView exposing (puzzleView, partData)
import Regex exposing (regex, HowMany(All))
import Array exposing (Array)


main: Program Never Model Msg
main = 
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL

type alias Model = 
    {}

init : ( Model, Cmd Msg )
init =
    ({}, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- UPDATE

type Msg = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


-- VIEW

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


calculate : Int
calculate =
    0


input : Array Int
input =
    "0 2 7 0"
        |> String.trim
        |> Regex.split All (regex "\\s+")
        |> List.map
            (\n -> n
                |> String.trim
                |> String.toInt
                |> Result.withDefault 0
            )
        |> Array.fromList
