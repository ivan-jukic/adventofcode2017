module Utils exposing (..)

import Task exposing (perform, succeed)


{-|
-}
fireAction : msg -> Cmd msg
fireAction tagger =
    perform (\_ -> tagger) (succeed ())


{-|
-}
toNum : String -> Int
toNum num =
    num |> String.toInt |> Result.withDefault 0


{-|
-}
toMaybeString : Maybe Int -> Maybe String
toMaybeString num =
    num |> Maybe.andThen (toString >> Just)

