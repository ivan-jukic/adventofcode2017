module PuzzleView exposing (..)

import Html exposing (Html, Attribute, div, h1, h3, p, span, text)
import Html.Attributes exposing (style)
import PuzzleMenu exposing (menuView)


-- VIEW

puzzleView : String -> ( String, String ) -> ( String, String ) -> Html msg
puzzleView puzzleTitle (label1, solution1) (label2, solution2) =
    let
        solutionView lbl sol =
            p [ partStyle ]
                [ text lbl
                , span [] [ text sol ]
                ]
    in
    div [ pageStyles ]
        [ menuView
        , h1 [ headerStyle ] [ text puzzleTitle ]
        , div [ marginBottom ]
            [ h3 [ partStyle ]
                [ text "Part 1" ]
            , solutionView label1 solution1
            ]
        , div [ marginBottom ]
            [ h3 [ partStyle ]
                [ text "Part 2" ]
            , solutionView label2 solution2
            ]
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
