import Html exposing (..)
import PuzzleView exposing (puzzleView, partData)
import Task exposing (perform, succeed)
import Array exposing (Array)

{-| part 2 solution in js

let step = 0;
let current = 0;
let instructions =
    //"0 3 0 1 -3"
    "2 1 2 -2 -2 1 1 2 -2 0 -3 -9 0 0 2 -12 -1 -12 0 -16 -14 -14 -3 -9 -11 0 -23 -21 2 -4 -28 -27 -4 -19 -9 -8 -25 -27 -1 -29 -13 0 -29 -29 -35 2 -3 2 -2 -46 -18 1 -47 -6 -27 -47 -43 -40 -25 -37 -4 -31 1 -6 -2 -38 -1 -66 -33 -48 -47 -9 -58 -7 -57 -35 -61 -11 0 -76 0 -80 -77 -72 -5 -47 -38 -16 -28 -47 -19 -42 -15 -88 -34 -50 -12 -54 -63 -95 -1 -66 -48 -14 -34 -72 -63 -101 -102 -107 -37 -75 -28 -23 -14 -61 -108 -71 -113 -96 -26 -28 -92 -64 -47 -74 -9 -113 -126 -61 -36 -40 -26 -73 -7 -99 -3 -15 -127 -104 -89 -67 -81 -8 -63 -109 -57 -81 -101 -57 -94 -78 -82 -9 -118 -34 -93 -147 -41 0 -44 -57 -11 -22 -86 -6 -55 -47 -49 -124 -139 -144 -7 -23 -128 -97 -27 -151 -104 -94 -177 -165 -136 -167 -53 -15 -8 -72 2 -4 -44 -15 -177 -188 -142 -71 -161 -81 -169 -150 -144 -193 -143 -185 -33 -21 -198 -97 -55 -50 -183 -94 -77 -138 -195 -146 -4 -193 -132 -88 -93 -67 -100 -162 -107 -17 -108 -213 -123 -49 -191 -180 -73 -182 -125 -176 -65 -189 -131 -18 -145 -197 -136 -53 -60 -209 -67 -244 -163 -246 -153 -16 -231 -68 -165 -42 -3 -9 -178 -250 -37 -128 -99 -145 -234 -167 -123 -222 -101 -46 -52 -129 -155 -85 -122 -228 -150 -237 -173 -29 -24 -175 -229 -106 -236 -234 -246 -90 -105 -274 -211 -94 -285 -201 -92 -204 -215 -115 -213 -218 -2 -122 -176 -2 -35 -143 2 -190 -216 -38 -247 -309 -18 -119 -198 -275 -91 -151 -195 -299 -192 -25 -162 -37 -70 -30 -42 -249 -156 -319 -317 -264 -19 -47 -38 -235 -184 -25 -43 -127 -168 -138 -35 -24 -257 -30 -259 -22 -69 -80 0 -212 -41 -20 -90 -196 -169 -47 -238 -320 -132 -348 -301 -242 -353 -63 -51 -33 -270 -196 -334 -160 -63 -177 -42 -30 -216 -219 -155 -146 -192 -113 -368 -349 -330 -33 -4 -302 -119 -387 -336 2 -201 -344 1 -6 -339 -311 -79 -55 -67 -118 -257 -215 -141 -40 -117 -28 -345 -312 -60 -57 -43 -193 -134 -144 -28 -11 -138 -48 -167 -76 -99 -51 -283 -174 -159 -72 -55 -155 -343 -226 -195 -364 -39 -368 -117 -256 -42 -172 -236 -231 -133 -36 -442 -178 -101 -213 -142 -266 -305 -95 -341 -227 -217 -162 -1 -168 -384 -424 2 -394 -96 -458 -258 -232 0 -283 -393 -211 0 -466 -431 -455 -430 -459 0 -235 -96 -371 -479 -117 -39 -291 -220 -403 -325 -433 -189 -275 -58 -109 -191 -175 -416 -61 -269 -411 -330 -497 -487 -393 -417 -275 -157 -208 -196 -330 -427 -361 -304 -385 -16 -175 -250 -101 -256 -186 -369 -328 -322 -190 -135 -71 -455 -303 -287 -95 -55 -446 -489 -329 -410 -372 -36 -7 -407 -455 -347 -160 -376 -515 -414 -433 -107 -508 -156 -111 -81 -382 -203 -3 -109 -163 -61 -313 -516 -277 -306 -166 -286 -437 -100 -117 -556 -248 -326 -550 -424 -21 -524 -27 -69 -244 -303 -124 -299 -434 -364 -543 -233 -189 -279 -159 -49 -112 -291 -173 -143 -482 -202 -446 -226 -439 -496 -568 -171 -376 -80 -189 -495 -67 -22 -470 -330 -329 -259 -30 -201 -591 -543 -33 -591 -3 -493 -614 -579 -283 -251 -518 -230 -408 -87 -438 -551 -521 -424 0 -552 -87 -311 -570 -250 -552 -316 -239 -628 -508 -142 -56 -288 -38 -567 -477 -195 -337 -23 -78 -237 -569 -533 -345 -220 -16 -223 -565 -488 -152 -517 -448 -563 -73 -153 -275 -186 -308 -576 -64 -293 -118 -138 -422 -645 -302 -193 -171 -190 -218 -330 -96 -454 -343 -399 -327 -484 -379 -362 -484 -477 -490 -243 -551 -649 -418 -54 -137 -355 -624 -18 -294 -333 -425 -540 -322 -77 -201 -550 -318 -571 -396 -616 -626 -404 -105 -661 -538 -398 -690 -353 -445 -523 -72 -1 -502 -711 -274 -81 -272 -644 -598 -593 -716 -355 -620 -550 -427 -647 -723 -275 -500 -49 -4 -575 -268 -336 -674 -742 -285 -672 -622 -591 -421 -574 -167 -38 -314 -597 -255 -277 -651 -571 -153 -292 -5 -101 -348 -48 -119 -448 -685 -389 -471 -646 -285 -239 -249 -465 -198 -43 -522 -19 -82 -240 -521 -136 -586 -195 -446 -587 -58 -263 -550 -449 -220 -39 -691 -386 -199 -96 -144 -151 -593 -237 -414 -238 -377 -280 -638 -729 -235 -603 -214 -245 -714 -323 -297 -558 -416 -388 -271 -622 -62 -726 -242 -550 -277 -709 -62 -266 -632 -411 -327 -574 -183 -467 -332 -804 -693 -809 -240 -496 -380 -749 -466 -738 -761 -832 -398 -105 -675 -772 -136 -4 -46 -58 -836 -688 -722 -466 -346 -117 -183 -330 -794 -101 -253 -2 -519 -113 -115 -439 -118 -398 -326 -409 -723 -719 -354 -200 -647 -520 -29 -130 -564 -880 -823 -309 -352 -822 -326 -302 -452 -281 -467 -316 -115 -623 -625 -142 -262 -382 -85 -743 -340 -50 -270 -118 -683 -218 -595 -217 -371 -397 -443 -755 -909 -378 -843 -644 -303 -642 -798 -90 -562 2 -733 -792 -235 -536 -132 -481 -386 -795 -167 -145 -725 -403 -533 -761 -599 -732 -719 -250 -239 -626 -318 -135 -756 -308 -287 -130 -277 -265 -709 -252 -679 -126 -794 -6 -194 -715 -703 -373 -481 -928 -710 -155 -431 -780 -658 -897 -947 -55 -271 -927 -554 -165 -763 -895 -329 -132 -293 -134 -524 -824 -277 -187 -849 -193 -167 -175 -125 -489 -36 -960 -931 -533 -9 -599 -589 -795 -418 -679 -793 -592 -24 -100 -664 -382 -524 -549 -124 -899 -583 -470 -897 -309 -886 -291 -971 -123 -122 -841 -218 -62 -434 -113 -138 -358 -569 -182 -839 -621 -596 -977 -297 -590 -738 -503 -334 -756 -245 -505 -107 -376 -958 -937 -986 -942 -589 -541 -612 -932 -314 -114 -213 -922 -31 -380 -152 -512 -521 -34 -613 -759 -781 -256 -297 -155 -853 -169 -842 -567 -533 -709 -19 -517 -542 -376 -149 -934 -496 -782 -469 -320 -219 -902 -155 -971 -1074"
        .split(/\s+/g)
        .map(n => parseInt(n));

const nextStep = () => {
    const instruction = instructions[current];

    instructions[current] = instruction + (instruction >= 3 ? -1 : 1);
    current = current + instruction;
    step++;

    if (current >= 0 && current < instructions.length) {
        return true;
    } else {
        console.log("Total steps: ", step);
        return false;
    }
};

while(nextStep());

-}


main : Program Never Model Msg
main = 
    Html.program
        { init = ( init, perform (\_ -> NoOp) (succeed ()) )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
        

-- MODEL

type alias Model = 
    { jumps1 : Int
    , jumps2 : Int
    , current : Int
    , instructions : Array Int
    , busy : Bool
    }


init : Model
init =
    { jumps1 = 0
    , jumps2 = 0
    , current = 0
    , instructions = getInput
    , busy = False
    }


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- UPDATE

type Msg = NoOp | StartPart1 | StartPart2 | NextInstruction Bool

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        StartPart1 ->
            case model.busy of
                False ->
                    ( { init | jumps2 = model.jumps2, busy = True }, nextInstruction False )

                True ->
                    ( model, Cmd.none )
        
        StartPart2 ->
            case model.busy of
                False ->
                    ( { init  | jumps1 = model.jumps1, busy = True }, nextInstruction True )

                True ->
                    ( model, Cmd.none )

        NextInstruction isPart2 ->
            let
                idx =
                    model.current
            in
            case Array.get model.current model.instructions of
                Just instruction ->
                    let
                        nextIdx =
                            idx + instruction

                        newInstruction =
                            case isPart2 && instruction >= 3 of
                                True ->
                                    instruction - 1

                                False ->
                                    instruction + 1
                    in
                    ( { model
                        | jumps1 = if not isPart2 then model.jumps1 + 1 else model.jumps1
                        , jumps2 = if isPart2 then model.jumps2 + 1 else model.jumps2
                        , current = nextIdx
                        , instructions = model.instructions |> Array.set idx newInstruction
                        }
                    , nextInstruction isPart2
                    )

                Nothing ->
                    ( { model | busy = False }, Cmd.none )


{-|
-}
nextInstruction : Bool -> Cmd Msg
nextInstruction isPart2 =
    perform (\_ -> NextInstruction isPart2 ) (succeed ()) 


-- VIEW

view : Model -> Html Msg
view model =
    puzzleView
        "05 A Maze of Twisty Trampolines, All Alike"
        [ { partData
            | label = "1) Number Of Jumps"
            , desc = "Solution for first part of the puzzle: "
            , button = Just StartPart1
            , buttonLabel = Just "Start! (solution 388611)"
            , solution = if model.jumps1 > 0 then model.jumps1 |> toString |> Just else Nothing
            }
        , { partData
            | label = "2) Puzzle Part"
            , desc = "Solution for second part of the puzzle: "            
            , button = Just StartPart2
            , buttonLabel = Just "Start (solution 27763113)"
            , solution = if model.jumps2 > 0 then model.jumps2 |> toString |> Just else Nothing
            }
        ]


calculate : Int
calculate =
    0


-- INPUT

getInput : Array Int
getInput =
    input |> String.split " " |> List.map (\n -> n |> String.toInt |> Result.withDefault 0) |> Array.fromList


input : String
input =
    --"0 3 0 1 -3"
    "2 1 2 -2 -2 1 1 2 -2 0 -3 -9 0 0 2 -12 -1 -12 0 -16 -14 -14 -3 -9 -11 0 -23 -21 2 -4 -28 -27 -4 -19 -9 -8 -25 -27 -1 -29 -13 0 -29 -29 -35 2 -3 2 -2 -46 -18 1 -47 -6 -27 -47 -43 -40 -25 -37 -4 -31 1 -6 -2 -38 -1 -66 -33 -48 -47 -9 -58 -7 -57 -35 -61 -11 0 -76 0 -80 -77 -72 -5 -47 -38 -16 -28 -47 -19 -42 -15 -88 -34 -50 -12 -54 -63 -95 -1 -66 -48 -14 -34 -72 -63 -101 -102 -107 -37 -75 -28 -23 -14 -61 -108 -71 -113 -96 -26 -28 -92 -64 -47 -74 -9 -113 -126 -61 -36 -40 -26 -73 -7 -99 -3 -15 -127 -104 -89 -67 -81 -8 -63 -109 -57 -81 -101 -57 -94 -78 -82 -9 -118 -34 -93 -147 -41 0 -44 -57 -11 -22 -86 -6 -55 -47 -49 -124 -139 -144 -7 -23 -128 -97 -27 -151 -104 -94 -177 -165 -136 -167 -53 -15 -8 -72 2 -4 -44 -15 -177 -188 -142 -71 -161 -81 -169 -150 -144 -193 -143 -185 -33 -21 -198 -97 -55 -50 -183 -94 -77 -138 -195 -146 -4 -193 -132 -88 -93 -67 -100 -162 -107 -17 -108 -213 -123 -49 -191 -180 -73 -182 -125 -176 -65 -189 -131 -18 -145 -197 -136 -53 -60 -209 -67 -244 -163 -246 -153 -16 -231 -68 -165 -42 -3 -9 -178 -250 -37 -128 -99 -145 -234 -167 -123 -222 -101 -46 -52 -129 -155 -85 -122 -228 -150 -237 -173 -29 -24 -175 -229 -106 -236 -234 -246 -90 -105 -274 -211 -94 -285 -201 -92 -204 -215 -115 -213 -218 -2 -122 -176 -2 -35 -143 2 -190 -216 -38 -247 -309 -18 -119 -198 -275 -91 -151 -195 -299 -192 -25 -162 -37 -70 -30 -42 -249 -156 -319 -317 -264 -19 -47 -38 -235 -184 -25 -43 -127 -168 -138 -35 -24 -257 -30 -259 -22 -69 -80 0 -212 -41 -20 -90 -196 -169 -47 -238 -320 -132 -348 -301 -242 -353 -63 -51 -33 -270 -196 -334 -160 -63 -177 -42 -30 -216 -219 -155 -146 -192 -113 -368 -349 -330 -33 -4 -302 -119 -387 -336 2 -201 -344 1 -6 -339 -311 -79 -55 -67 -118 -257 -215 -141 -40 -117 -28 -345 -312 -60 -57 -43 -193 -134 -144 -28 -11 -138 -48 -167 -76 -99 -51 -283 -174 -159 -72 -55 -155 -343 -226 -195 -364 -39 -368 -117 -256 -42 -172 -236 -231 -133 -36 -442 -178 -101 -213 -142 -266 -305 -95 -341 -227 -217 -162 -1 -168 -384 -424 2 -394 -96 -458 -258 -232 0 -283 -393 -211 0 -466 -431 -455 -430 -459 0 -235 -96 -371 -479 -117 -39 -291 -220 -403 -325 -433 -189 -275 -58 -109 -191 -175 -416 -61 -269 -411 -330 -497 -487 -393 -417 -275 -157 -208 -196 -330 -427 -361 -304 -385 -16 -175 -250 -101 -256 -186 -369 -328 -322 -190 -135 -71 -455 -303 -287 -95 -55 -446 -489 -329 -410 -372 -36 -7 -407 -455 -347 -160 -376 -515 -414 -433 -107 -508 -156 -111 -81 -382 -203 -3 -109 -163 -61 -313 -516 -277 -306 -166 -286 -437 -100 -117 -556 -248 -326 -550 -424 -21 -524 -27 -69 -244 -303 -124 -299 -434 -364 -543 -233 -189 -279 -159 -49 -112 -291 -173 -143 -482 -202 -446 -226 -439 -496 -568 -171 -376 -80 -189 -495 -67 -22 -470 -330 -329 -259 -30 -201 -591 -543 -33 -591 -3 -493 -614 -579 -283 -251 -518 -230 -408 -87 -438 -551 -521 -424 0 -552 -87 -311 -570 -250 -552 -316 -239 -628 -508 -142 -56 -288 -38 -567 -477 -195 -337 -23 -78 -237 -569 -533 -345 -220 -16 -223 -565 -488 -152 -517 -448 -563 -73 -153 -275 -186 -308 -576 -64 -293 -118 -138 -422 -645 -302 -193 -171 -190 -218 -330 -96 -454 -343 -399 -327 -484 -379 -362 -484 -477 -490 -243 -551 -649 -418 -54 -137 -355 -624 -18 -294 -333 -425 -540 -322 -77 -201 -550 -318 -571 -396 -616 -626 -404 -105 -661 -538 -398 -690 -353 -445 -523 -72 -1 -502 -711 -274 -81 -272 -644 -598 -593 -716 -355 -620 -550 -427 -647 -723 -275 -500 -49 -4 -575 -268 -336 -674 -742 -285 -672 -622 -591 -421 -574 -167 -38 -314 -597 -255 -277 -651 -571 -153 -292 -5 -101 -348 -48 -119 -448 -685 -389 -471 -646 -285 -239 -249 -465 -198 -43 -522 -19 -82 -240 -521 -136 -586 -195 -446 -587 -58 -263 -550 -449 -220 -39 -691 -386 -199 -96 -144 -151 -593 -237 -414 -238 -377 -280 -638 -729 -235 -603 -214 -245 -714 -323 -297 -558 -416 -388 -271 -622 -62 -726 -242 -550 -277 -709 -62 -266 -632 -411 -327 -574 -183 -467 -332 -804 -693 -809 -240 -496 -380 -749 -466 -738 -761 -832 -398 -105 -675 -772 -136 -4 -46 -58 -836 -688 -722 -466 -346 -117 -183 -330 -794 -101 -253 -2 -519 -113 -115 -439 -118 -398 -326 -409 -723 -719 -354 -200 -647 -520 -29 -130 -564 -880 -823 -309 -352 -822 -326 -302 -452 -281 -467 -316 -115 -623 -625 -142 -262 -382 -85 -743 -340 -50 -270 -118 -683 -218 -595 -217 -371 -397 -443 -755 -909 -378 -843 -644 -303 -642 -798 -90 -562 2 -733 -792 -235 -536 -132 -481 -386 -795 -167 -145 -725 -403 -533 -761 -599 -732 -719 -250 -239 -626 -318 -135 -756 -308 -287 -130 -277 -265 -709 -252 -679 -126 -794 -6 -194 -715 -703 -373 -481 -928 -710 -155 -431 -780 -658 -897 -947 -55 -271 -927 -554 -165 -763 -895 -329 -132 -293 -134 -524 -824 -277 -187 -849 -193 -167 -175 -125 -489 -36 -960 -931 -533 -9 -599 -589 -795 -418 -679 -793 -592 -24 -100 -664 -382 -524 -549 -124 -899 -583 -470 -897 -309 -886 -291 -971 -123 -122 -841 -218 -62 -434 -113 -138 -358 -569 -182 -839 -621 -596 -977 -297 -590 -738 -503 -334 -756 -245 -505 -107 -376 -958 -937 -986 -942 -589 -541 -612 -932 -314 -114 -213 -922 -31 -380 -152 -512 -521 -34 -613 -759 -781 -256 -297 -155 -853 -169 -842 -567 -533 -709 -19 -517 -542 -376 -149 -934 -496 -782 -469 -320 -219 -902 -155 -971 -1074"