module PuzzleView exposing (..)

import Html exposing (Html, Attribute, div, h1, h3, p, span, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import PuzzleMenu exposing (menuView)


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

--puzzleView : String -> ( String, String ) -> ( String, String ) -> Html msg
--puzzleView puzzleTitle (label1, solution1) (label2, solution2) =
puzzleView : String -> List (PartData msg) -> Html msg
puzzleView puzzleTitle parts =
    div [ pageStyles ]
        [ menuView
        , h1 [ headerStyle ] [ text puzzleTitle ]
        , div []
            ( parts
                |> List.map
                    (\part ->
                        div [ marginBottom ]
                            [ h3 [ partStyle ]
                                [ text part.label ]
                            , p [ partStyle ]
                                [ text part.desc
                                , case ( part.solution, part.button ) of
                                    ( Nothing, Just buttonAction ) ->
                                        button [ buttonStyle, onClick buttonAction ]
                                            [ text (Maybe.withDefault "Click to start!" part.buttonLabel) ]

                                    (Just solution, _ ) ->
                                        span [] [ text solution ]

                                    _ ->
                                        span [] [ text "-unknown-" ]
                                ]
                            ]
                    )
            )
        ]


-- STYLES

pageStyles : Attribute msg
pageStyles =
    style
        [ ( "padding", "100px" )
        , ( "font-family", "Courier New" )
        , ( "font-size", "24px" )
        , ( "line-height", "32px" )
        , ( "color", "#FFF" )
        , ( "background-color", "#121E29" )
        , ( "height", "100%" )
        , ( "box-sizing", "border-box" )
        ]


headerStyle : Attribute msg
headerStyle =
    style
        [ ( "margin-bottom", "50px" )
        , ( "color", "#3674AD" )
        , ( "padding-top", "36px" )
        , ( "border-top", "3px solid #3674AD" )
        ]


partStyle : Attribute msg
partStyle =
    style
        [ ( "margin", "0" )
        , ( "padding-left", "12px" )
        ]


marginBottom : Attribute msg
marginBottom =
    style
        [ ( "margin-bottom", "50px" )
        ]


buttonStyle : Attribute msg
buttonStyle =
    style
        [ ( "background", "#1e4b75" )
        , ( "border", "none" )
        , ( "border-radius", "4px" )
        , ( "color", "#FFF" )
        , ( "padding", "12px 16px" )
        , ( "cursor", "pointer" )
        ]
