module Components.Menu exposing (menuView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Routes exposing (Route(..), pathnames)


{-|
-}
menuView : Route -> (String -> msg) -> Html msg
menuView current urlChange =
    nav []
        [ text "Select puzzle"
        , ul [ class "nav-menu" ]
            ( pathnames
                |> List.indexedMap
                    (\idx (lnk, r) ->
                        urlChange |> menuItem idx lnk (r == current)
                    )
            )
        ]

{-|
-}
menuItem : Int -> String -> Bool -> (String -> msg) -> Html msg
menuItem idx lnk isCurrent urlChange =
    li []
        [ a [ onClick (urlChange lnk)
            , classList [ ("active", isCurrent) ]
            ]
            [ text ((if idx < 9 then "0" else "") ++ (toString (idx + 1)))
            ]
        ]
