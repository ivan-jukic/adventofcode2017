module PuzzleMenu exposing (menuView)

import Html exposing (Html, Attribute, nav, ul, li, a, text)
import Html.Attributes exposing (style, href)


links : List String
links =
    [ "01_50LittleBugsOnTheWall.elm"
    , "02_FixingSpreadsheets.elm"
    , "03_DizzySpiral.elm"
    , "04_ValidatingPassphrases.elm"
    , "05_EscapingInstructionHell.elm"
    ]


menuView : Html msg
menuView =
    nav [ navStyle ]
        [ text "Select puzzle"
        , ul [ listStyle ]
            ( links
                |> List.indexedMap
                    (\i l ->
                        li [ listItemStyle ]
                            [ a [ linkStyle, href l ]
                                [ text ((if i < 9 then "0" else "") ++ (toString (i + 1)))
                                ]
                            ]
                    )
            )
        ]


navStyle : Attribute msg
navStyle =
    style
        [ ( "color", "#3674AD" )
        ]


listStyle : Attribute msg
listStyle =
    style
        [ ( "list-style", "none" )
        , ( "margin", "0" )
        , ( "display", "inline-block" )
        ]


listItemStyle : Attribute msg
listItemStyle =
    style
        [ ( "display", "inline-block" )
        , ( "margin-right", "16px" )
        ]


linkStyle : Attribute msg
linkStyle =
    style
        [ ( "color", "#FFF" )
        ]
