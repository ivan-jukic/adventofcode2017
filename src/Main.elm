module Main exposing (..)

import Html exposing (..)
import Content
import Navigation
import Routes exposing (Route(..))
import Task exposing (perform, succeed)


{-|
-}
type Msg
    = NoOp
    | UrlChange Navigation.Location
    | ContentMsg Content.Msg


{-|
-}
type alias Model =
    { route : Routes.Route
    , content : Content.Model
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( route, subCmd ) =
            processRoute location
    in
    ( { route = route
      , content = Content.initialModel route
      }
    , case route /= Routes.Unknown of
        True ->
            subCmd

        False ->
            Routes.defaultRedirect
    )


{-|
-}
main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }


{-|
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChange location ->
            let
                ( newRoute, subCmd ) =
                    processRoute location
            in
            ( { model | route = newRoute }, subCmd )

        ContentMsg msg ->
            let
                props =
                    { route = model.route
                    }

                ( updatedContent, subCmd ) =
                    model.content |> Content.update props msg
            in
            ( { model | content = updatedContent }
            , Cmd.map ContentMsg subCmd
            )


{-|
-}
view : Model -> Html Msg
view model =
    let
        props =
            { route = model.route
            }
    in
    model.content
        |> Content.view props
        |> Html.map ContentMsg


{-|
-}
contentAction : Content.Msg -> Cmd Msg
contentAction msg =
    perform (\_ -> ContentMsg msg) (succeed ())


{-|
-}
processRoute : Navigation.Location -> ( Routes.Route, Cmd Msg)
processRoute location =
    let
        newRoute =
            Routes.getRoute location

        subCmd =
            contentAction <|
                case newRoute of
                    Day01 ->
                        Content.initDay01
                    
                    Day02 ->
                        Content.initDay02
                    
                    Day03 ->
                        Content.initDay03
                    
                    Day04 ->
                        Content.initDay04
                    
                    Day05 ->
                        Content.initDay05

                    Day06 ->
                        Content.initDay06

                    Day07 ->
                        Content.initDay07

                    Day08 ->
                        Content.initDay08

                    Day09 ->
                        Content.initDay09

                    Day10 ->
                        Content.initDay10

                    Day11 ->
                        Content.initDay11

                    Day12 ->
                        Content.initDay12

                    Day13 ->
                        Content.initDay13

                    _ ->
                        Content.noContent
    in
    ( newRoute, subCmd )
