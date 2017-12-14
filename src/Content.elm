module Content exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Components.Menu exposing (menuView)
import Puzzles.Day01 as Day01
import Puzzles.Day02 as Day02
import Puzzles.Day03 as Day03
import Puzzles.Day04 as Day04
import Puzzles.Day05 as Day05
import Puzzles.Day06 as Day06
import Puzzles.Day07 as Day07
import Puzzles.Day08 as Day08
import Puzzles.Day09 as Day09
import Puzzles.Day10 as Day10
import Puzzles.Day11 as Day11
import Puzzles.Day12 as Day12
import Puzzles.Day13 as Day13
import Puzzles.Day14 as Day14
import Routes
import Navigation
import Task exposing (perform, succeed)


{-|
-}
type ContentModel
    = NoContent
    | Content01 Day01.Model
    | Content02 Day02.Model
    | Content03 Day03.Model
    | Content04 Day04.Model
    | Content05 Day05.Model
    | Content06 Day06.Model
    | Content07 Day07.Model
    | Content08 Day08.Model
    | Content09 Day09.Model
    | Content10 Day10.Model
    | Content11 Day11.Model
    | Content12 Day12.Model
    | Content13 Day13.Model
    | Content14 Day14.Model


{-|
-}
type alias Props p =
    { p | route : Routes.Route }


{-|
-}
type Msg
    = NoOp
    | ChangeUrl String
    | ChangeContent ContentModel (Cmd Msg)
    | Day01Msg Day01.Msg
    | Day02Msg Day02.Msg
    | Day03Msg Day03.Msg
    | Day04Msg Day04.Msg
    | Day05Msg Day05.Msg
    | Day06Msg Day06.Msg
    | Day07Msg Day07.Msg
    | Day08Msg Day08.Msg
    | Day09Msg Day09.Msg
    | Day10Msg Day10.Msg
    | Day11Msg Day11.Msg
    | Day12Msg Day12.Msg
    | Day13Msg Day13.Msg
    | Day14Msg Day14.Msg


{-|
-}
type alias Model =
    { content : ContentModel
    }


initialModel : Routes.Route -> Model
initialModel route =
    { content = NoContent
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ case model.content of
            Content14 m ->
                Sub.map Day14Msg (Day14.subscriptions m)

            _ ->
                Sub.none
        ]


{-|
-}
update : Props p -> Msg -> Model -> ( Model, Cmd Msg )
update props msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangeContent newContent subCmd ->
            ( { model | content = newContent }, subCmd )

        ChangeUrl url ->
            ( model, Navigation.newUrl url)

        _ ->
            updateDay msg model


{-|
-}
updateDay : Msg -> Model -> ( Model, Cmd Msg )
updateDay msg model =
    let
        noSubCmd contentFn u =
            ( contentFn u, Cmd.none )

        withSubCmd contentFn tagger (u, sc) =
            ( contentFn u, Cmd.map tagger sc )

        ( updated, subCmd ) =
            case ( model.content, msg ) of
                ( Content01 m, Day01Msg msg ) ->
                    Day01.update msg m |> noSubCmd Content01

                ( Content02 m, Day02Msg msg ) ->
                    Day02.update msg m |> noSubCmd Content02

                ( Content03 m, Day03Msg msg ) ->
                    Day03.update msg m |> noSubCmd Content03

                ( Content04 m, Day04Msg msg ) ->
                    Day04.update msg m |> noSubCmd Content04

                ( Content05 m, Day05Msg msg ) ->
                    Day05.update msg m |> withSubCmd Content05 Day05Msg

                ( Content06 m, Day06Msg msg ) ->
                    Day06.update msg m |> withSubCmd Content06 Day06Msg

                ( Content07 m, Day07Msg msg ) ->
                    Day07.update msg m |> withSubCmd Content07 Day07Msg

                ( Content08 m, Day08Msg msg ) ->
                    Day08.update msg m |> withSubCmd Content08 Day08Msg

                ( Content09 m, Day09Msg msg ) ->
                    Day09.update msg m |> withSubCmd Content09 Day09Msg

                ( Content10 m, Day10Msg msg ) ->
                    Day10.update msg m |> withSubCmd Content10 Day10Msg

                ( Content11 m, Day11Msg msg ) ->
                    Day11.update msg m |> withSubCmd Content11 Day11Msg

                ( Content12 m, Day12Msg msg ) ->
                    Day12.update msg m |> withSubCmd Content12 Day12Msg

                ( Content13 m, Day13Msg msg ) ->
                    Day13.update msg m |> withSubCmd Content13 Day13Msg

                ( Content14 m, Day14Msg msg ) ->
                    Day14.update msg m |> withSubCmd Content14 Day14Msg

                _ ->
                    ( model.content, Cmd.none )
    in
    ( { model | content = updated }, subCmd )



{-|
-}
view : Props p -> Model -> Html Msg
view props model =
    div [ class "root-view" ]
        [ ChangeUrl |> menuView props.route
        , div [ class "puzzle-content" ]
            [ case model.content of
                Content01 m ->
                    Day01.view m |> Html.map Day01Msg

                Content02 m ->
                    Day02.view m |> Html.map Day02Msg

                Content03 m ->
                    Day03.view m |> Html.map Day03Msg

                Content04 m ->
                    Day04.view m |> Html.map Day04Msg

                Content05 m ->
                    Day05.view m |> Html.map Day05Msg

                Content06 m ->
                    Day06.view m |> Html.map Day06Msg

                Content07 m ->
                    Day07.view m |> Html.map Day07Msg

                Content08 m ->
                    Day08.view m |> Html.map Day08Msg

                Content09 m ->
                    Day09.view m |> Html.map Day09Msg

                Content10 m ->
                    Day10.view m |> Html.map Day10Msg

                Content11 m ->
                    Day11.view m |> Html.map Day11Msg

                Content12 m ->
                    Day12.view m |> Html.map Day12Msg

                Content13 m ->
                    Day13.view m |> Html.map Day13Msg

                Content14 m ->
                    Day14.view m |> Html.map Day14Msg

                _ ->
                    text ""
            ]
        ]

{-|
-}
noContent : Msg
noContent =
    ChangeContent NoContent Cmd.none


{-|
-}
initDay01 : Msg
initDay01 =
    ChangeContent (Content01 Day01.initialModel) Cmd.none


{-|
-}
initDay02 : Msg
initDay02 =
    ChangeContent (Content02 Day02.initialModel) Cmd.none


{-|
-}
initDay03 : Msg
initDay03 =
    ChangeContent (Content03 Day03.initialModel) Cmd.none


{-|
-}
initDay04 : Msg
initDay04 =
    ChangeContent (Content04 Day04.initialModel) Cmd.none


{-|
-}
initDay05 : Msg
initDay05 =
    let
        (model, subCmd) =
            Day05.initialModel
    in
    ChangeContent (Content05 model) (Cmd.map Day05Msg subCmd)


{-|
-}
initDay06 : Msg
initDay06 =
    let
        (model, subCmd) =
            Day06.initialModel
    in
    ChangeContent (Content06 model) (Cmd.map Day06Msg subCmd)


{-|
-}
initDay07 : Msg
initDay07 =
    let
        (model, subCmd) =
            Day07.initialModel
    in
    ChangeContent (Content07 model) (Cmd.map Day07Msg subCmd)


{-|
-}
initDay08 : Msg
initDay08 =
    let
        (model, subCmd) =
            Day08.initialModel
    in
    ChangeContent (Content08 model) (Cmd.map Day08Msg subCmd)


{-|
-}
initDay09 : Msg
initDay09 =
    let
        (model, subCmd) =
            Day09.initialModel
    in
    ChangeContent (Content09 model) (Cmd.map Day09Msg subCmd)


{-|
-}
initDay10 : Msg
initDay10 =
    let
        (model, subCmd) =
            Day10.initialModel
    in
    ChangeContent (Content10 model) (Cmd.map Day10Msg subCmd)


{-|
-}
initDay11 : Msg
initDay11 =
    let
        (model, subCmd) =
            Day11.initialModel
    in
    ChangeContent (Content11 model) (Cmd.map Day11Msg subCmd)


{-|
-}
initDay12 : Msg
initDay12 =
    let
        (model, subCmd) =
            Day12.initialModel
    in
    ChangeContent (Content12 model) (Cmd.map Day12Msg subCmd)


{-|
-}
initDay13 : Msg
initDay13 =
    let
        (model, subCmd) =
            Day13.initialModel
    in
    ChangeContent (Content13 model) (Cmd.map Day13Msg subCmd)


{-|
-}
initDay14 : Msg
initDay14 =
    let
        (model, subCmd) =
            Day14.initialModel
    in
    ChangeContent (Content14 model) (Cmd.map Day14Msg subCmd)
