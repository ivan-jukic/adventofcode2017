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
    | Day09
    | Day10
    | Day11
    | Day12
    | Day13
    | Day14
    | Day15
    | Day16
    | Day17
    | Day18
    | Day19


{-|
-}
pathnames : List ( Route, String, String )
pathnames =
    [ ( Day01, "01-50-little-bugs-on-the-wall", "Inverse Captcha" )
    , ( Day02, "02-fixing-spreadsheets", "Corruption Checksum" )
    , ( Day03, "03-dizzy-spiral", "Spiral Memory" )
    , ( Day04, "04-validating-passphrases", "High-Entropy Passphrases" )
    , ( Day05, "05-escaping-instruction-hell", "A Maze of Twisty Trampolines, All Alike" )
    , ( Day06, "06-where-to-reallocate", "Memory Reallocation" )
    , ( Day07, "07-crazy-recursive-circus-tree.", "Recursive Circus" )
    , ( Day08, "08-dont-touch-your-registers.", "I Heard You Like Registers" )
    , ( Day09, "09-cleaning-up-garbage", "Stream Processing" )
    , ( Day10, "10-knot-hash", "Knot Hash" )
    , ( Day11, "11-hex-pathfinding", "Hex Ed" )
    , ( Day12, "12-communication-is-key", "Digital Plumber" )
    , ( Day13, "13-on-the-collision-course", "Packet Scanners" )
    , ( Day14, "14-defragment-this-grid", "Disk Defragmentation" )
    , ( Day15, "15-generate-some-numbers", "Dueling Generators" )
    , ( Day16, "16-program-dance-off", "Permutation Promenade" )
    , ( Day17, "17-step-into-the-vortex", "Spinlock" )
    , ( Day18, "18-duet-in-parallel", "Duet" )
    , ( Day19, "19-lost-in-pc", "A Series of Tubes" )
    ]


{-|
-}
parser : Parser (Route -> a) a
parser =
    pathnames
        |> List.map (\( route, pathname, _ ) -> map route (s pathname) )
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
        |> Maybe.andThen(\(_, pathname, _) -> Just <| Navigation.newUrl ("/" ++ pathname))
        |> Maybe.withDefault Cmd.none
