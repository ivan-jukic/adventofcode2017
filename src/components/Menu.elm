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
        [ h1 []
            [ text "Advent Of Code"
            , span [] [ text "Solutions for 2017" ]
            ]
        , ul [ class "nav-menu" ]
            ( pathnames
                |> List.indexedMap
                    (\idx (r, lnk, ttl) ->
                        urlChange |> menuItem idx lnk ttl (r == current)
                    )
            )
        ]

{-|
-}
menuItem : Int -> String -> String -> Bool -> (String -> msg) -> Html msg
menuItem idx lnk ttl isCurrent urlChange =
    let
        idxStr =
            (if idx < 9 then "0" else "") ++ (toString (idx + 1))
    in
    li []
        [ a [ onClick (urlChange lnk)
            , classList [ ("active", isCurrent) ]
            ]
            [ span [ class "day-count" ]
                [ text idxStr]
            , text ttl
            ]
        ]
