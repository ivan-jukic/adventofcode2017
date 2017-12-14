module Components.KnotHash exposing (HashModel, knotHash, hashRound, hashModel)

import Array exposing (Array)
import Char
import Bitwise
import Hex


{-|
-}
type alias HashModel =
    { lengths : List Int
    , numbers : Array Int
    , position : Int
    , skipSize : Int
    }


hashModel : HashModel
hashModel =
    { lengths = []
    , numbers = List.range 0 255 |> Array.fromList
    , position = 0
    , skipSize = 0
    }

{-|
-}
knotHash : String -> String
knotHash strInput =
    let
        asciiInput =
            ( strInput
                |> String.toList
                |> List.map (\c -> Char.toCode c)
            )
            ++ [ 17, 31, 73, 47, 23 ]
    in
    clculateHash 0 asciiInput hashModel


{-|
-}
clculateHash : Int -> List Int -> HashModel -> String
clculateHash roundCount asciiInput model =
    case roundCount < 64 of
        True ->
            { model | lengths = asciiInput }
                |> hashRound
                |> clculateHash (roundCount + 1) asciiInput

        False ->
            List.range 0 15
                |> List.foldl
                    (\i out ->
                        let
                            sliceIdx =
                                16 * i

                            addToOut =
                                model.numbers
                                    |> Array.slice sliceIdx (sliceIdx + 16)
                                    |> Array.toList
                                    |> List.foldl (\n p -> Bitwise.xor p n) 0
                                    |> Hex.toString
                                    |> (\h -> (if String.length h == 1 then "0" else "") ++ h)
                        in
                        out ++ [ addToOut ]
                    )
                    []
                |> String.join ""

{-|
-}
hashRound : HashModel -> HashModel
hashRound model =
    case List.head model.lengths of
        Just len ->
            let
                numCount =
                    Array.length model.numbers

                ( takeRight, takeStart ) =
                    case model.position + len > numCount of
                        True ->
                            ( numCount - model.position
                            , model.position + len - numCount
                            )

                        False ->
                            ( len
                            , 0
                            )

                updatedNumbers =
                    model.numbers
                        |> Array.indexedMap (,)
                        |> (\indexed ->
                                Array.append
                                    (indexed |> Array.filter (\(i, _) -> i >= model.position && i < model.position + takeRight))
                                    (indexed |> Array.filter (\(i, _) -> takeStart > 0 && i >= 0 && i < takeStart))
                            )
                        |> invertArray 0
                        |> Array.foldl (\(i, v) c -> Array.set i v c ) model.numbers
            in
            hashRound
                { lengths = List.drop 1 model.lengths
                , numbers = updatedNumbers
                , skipSize = model.skipSize + 1
                , position = (model.position + len + model.skipSize) % numCount
                }

        Nothing ->
            model


{-|
-}
invertArray : Int -> Array (Int, Int) -> Array (Int, Int)
invertArray step slice =
    let
        numCount =
            Array.length slice
    in
    case (toFloat numCount) / 2 > (toFloat step) of
        True ->
            let
                leftIdx =
                    0 + step

                rightIdx =
                    numCount - step - 1
            in
            case (slice |> Array.get leftIdx, slice |> Array.get rightIdx) of
                ( Just (il, vl), Just (ir, vr) ) ->
                    invertArray
                        (step + 1)
                        (slice
                            |> Array.set leftIdx (il, vr)
                            |> Array.set rightIdx (ir, vl)
                        )

                _ ->
                    slice

        False ->
            slice
