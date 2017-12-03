import Html exposing (..)
import PuzzleView exposing (puzzleView)

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
        "Task title"
        ( "Solution for the first part:", toString calculate )
        ( "Solution for the second part:", toString calculate )


calculate : Int
calculate =
    0
