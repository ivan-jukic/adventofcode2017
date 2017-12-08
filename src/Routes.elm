module Routes exposing (..)

import UrlParser exposing (Parser, parsePath, oneOf, s, map)
import Navigation


{-|
-}
type Route
    = Unknown
    | Day01
    | Day02
    | Day03
    | Day04
    | Day05
    | Day06
    | Day07
    | Day08


{-|
-}
pathnames : List ( String, Route )
pathnames =
    [ ( "01-50-little-bugs-on-the-wall",  Day01 )
    , ( "02-fixing-spreadsheets", Day02 )
    , ( "03-dizzy-spiral", Day03 )
    , ( "04-validating-passphrases", Day04 )
    , ( "05-escaping-instruction-hell", Day05 )
    , ( "06-where-to-reallocate", Day06 )
    , ( "07-crazy-recursive-circus-tree.", Day07 )
    , ( "08-dont-touch-your-registers.", Day08 )
    ]


{-|
-}
parser : Parser (Route -> a) a
parser =
    pathnames
        |> List.map (\( pathname, route ) -> map route (s pathname) )
        |> oneOf


{-|
-}
getRoute : Navigation.Location -> Route
getRoute location =
    location
        |> parsePath parser
        |> Maybe.withDefault Unknown


{-|
-}
defaultRedirect : Cmd msg
defaultRedirect =
    pathnames
        |> List.head
        |> Maybe.andThen(\(pathname, _) -> Just <| Navigation.newUrl ("/" ++ pathname))
        |> Maybe.withDefault Cmd.none
