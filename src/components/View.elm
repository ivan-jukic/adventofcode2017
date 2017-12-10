module Components.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias PartData msg =
    { label : String
    , desc : String
    , button : Maybe msg
    , buttonLabel : Maybe String
    , solution : Maybe String
    }


partData : PartData msg
partData =
    { label = "Puzzle Part"
    , desc = "Solution for this part of the puzzle: "
    , button = Nothing
    , buttonLabel = Nothing
    , solution = Nothing
    }


-- VIEW

puzzleView : String -> List (PartData msg) -> Html msg
puzzleView puzzleTitle parts =
    div [ class "puzzle-view" ]
        [ h1 [ class "header" ]
            [ text puzzleTitle ]
        , div [] ( parts |> List.map renderPart )
        ]


renderPart : PartData msg -> Html msg
renderPart part =
    div [ class "mb" ]
        [ h3 []
            [ text part.label ]
        , p [ class "pl" ]
            [ text part.desc
            , case ( part.solution, part.button ) of
                ( Nothing, Just buttonAction ) ->
                    button [ class "button" , onClick buttonAction ]
                        [ text (Maybe.withDefault "Click to start!" part.buttonLabel) ]

                (Just solution, _ ) ->
                    span [] [ text solution ]

                _ ->
                    span [] [ text "-unknown-" ]
            ]
        ]
