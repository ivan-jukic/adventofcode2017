import Html exposing (..)
import PuzzleView exposing (puzzleView, partData)


main: Program Never Model Msg
main = 
    Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = 
    {}

model : Model
model =
    {}


-- UPDATE

type Msg = NoOp

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


-- VIEW

view : Model -> Html Msg
view model =
    puzzleView
        "03 Spiraling memory"
        [ { partData
            | label = "1) First part"
            , desc = "Number of steps is: "
            , solution = Just <| toString <| calculateSteps
            }
        , { partData
            | label = "2) Second part"
            , desc = "First number larger than " ++ (toString input) ++ " is: "
            , solution = Just <| toString <| calculateFirstLargerNum
            }
        ]


calculateSteps : Int
calculateSteps =
    let
        nextCircle n maxPrev =
            let
                circleMin =
                    maxPrev + 1

                circleMax =
                    maxPrev + 8 * n
            in
            case circleMax >= input of
                True ->
                    (n, circleMin, circleMax)

                False ->
                    nextCircle (n + 1) circleMax

        ( inputCircle, circleMin, circleMax ) =
            nextCircle 1 1

        (x, y) =
            getCoords inputCircle (input - circleMin)
    in
    (abs x) + (abs y)


calculateFirstLargerNum : Int
calculateFirstLargerNum =
    let
        generateList n current list =
            let
                (x, y) =
                    getCoords n current

                findItems =
                    [ ( x - 1, y - 1 )
                    , ( x, y - 1 )
                    , ( x + 1, y - 1 )
                    , ( x + 1, y )
                    , ( x + 1, y + 1 )
                    , ( x, y + 1 )
                    , ( x - 1, y + 1 )
                    , ( x - 1, y )
                    ]

                total =
                    list |> List.foldl (\(v, (x, y)) c -> if List.member (x, y) findItems then c + v else c) 0
                
                -- _ = Debug.log "total and list " ( total, list |> List.map (\(v, coord) -> v))
            in
            case total > input of
                True ->
                    total
                
                False ->
                    let
                        maxCurrent =
                            n * 8

                        newCurrent =
                            current + 1

                        ( nextN, nextC ) =
                            case newCurrent == maxCurrent of
                                True ->
                                    ( n + 1, 0 )

                                False ->
                                    ( n, newCurrent )
                    in
                    ( list ++ [ ( total, (x, y) ) ] )
                        |> generateList nextN nextC
    in
    [ (1, (0, 0)) ]
        |> generateList 1 0


{-|
-}
getCoords : Int -> Int -> (Int, Int)
getCoords n current =
    let
        double =
            n * 2

        nSide =
            n * 2 + 1
    in
    if current >= 0 && current < double then
        ( n, -n + current + 1 )
    
    else if ( current >= double && current < 2 * double ) then
        ( n - (current - nSide + 2), n)

    else if ( current >= 2 * double && current < 3 * double ) then
        ( -n, n - (current % (2 * double)) - 1 )

    else
        ( -n + ( current % ( 3 * double ) ) + 1, -n )


{-|
-}
input : Int
input =
    347991
