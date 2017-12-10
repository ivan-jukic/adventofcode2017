module Puzzles.Day08 exposing (..)

import Components.View exposing (puzzleView, partData)
import Html exposing (..)
import Html.Attributes exposing (class)
import Regex exposing (..)
import Dict exposing (Dict)
import Task exposing (perform, succeed)


{-|
-}
type alias Registers =
    Dict String Int


{-|
-}
type Msg
    = NoOp
    | RunInstructions


{-|
-}
type alias Model = 
    { registers : Registers
    , instructions : List (Registers -> Registers)
    , partOne : Maybe Int
    , partTwo : Maybe Int
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { registers = Dict.empty
      , instructions = getInstructions
      , partOne = Nothing
      , partTwo = Nothing
      }
    , perform (\_ -> RunInstructions) (succeed ())
    )


{-|
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RunInstructions ->
            let
                ( newRegisters, highestVal ) =
                    runInstructions model.instructions 0 model.registers

                endHighestVal =
                    newRegisters |> Dict.values |> List.maximum
            in
            ( { model
                | registers = newRegisters
                , partOne = endHighestVal
                , partTwo = Just highestVal
                }
            , Cmd.none
            )


{-|
-}
runInstructions : List (Registers -> Registers) -> Int -> Registers -> (Registers, Int)
runInstructions ins highestVal reg =
    case List.head ins of
        Just insFn ->
            let
                newReg =
                    insFn reg

                newHighestVal =
                    newReg |> Dict.values |> List.maximum |> Maybe.withDefault 0
            in
            newReg
                |> runInstructions
                    (ins |> List.drop 1)
                    (if newHighestVal > highestVal then newHighestVal else highestVal)

        Nothing ->
            (reg, highestVal)


{-|
-}
view : Model -> Html Msg
view model =
    div [ class "solution solution-8" ]
        [ puzzleView
            "08 I Heard You Like Registers"
            [ { partData
                | label = "1) Max value "
                , desc = "Max value in registers after instruction exec: "
                , solution = model.partOne |> Maybe.andThen (\v -> toString v |> Just)
                }
            , { partData
                | label = "2) Max value ever held"
                , desc = "Max value ever held by a register: "
                , solution = model.partTwo |> Maybe.andThen (\v -> toString v |> Just)
                }
            ]
        ]


{-|
-}
instructionFn : String -> String -> Int -> String -> String -> Int -> Registers -> Registers
instructionFn reg1 op change reg2 cond condVal registers =
    let
        condSatisfied =
            registers
                |> Dict.get reg2
                |> Maybe.withDefault 0
                |> (\regVal ->
                        case cond of
                            ">"  -> regVal > condVal
                            "<"  -> regVal < condVal
                            ">=" -> regVal >= condVal
                            "<=" -> regVal <= condVal
                            "==" -> regVal == condVal
                            "!=" -> regVal /= condVal
                            _    -> False
                    )
    in
    case condSatisfied of
        True ->
            registers
                |> Dict.update reg1
                    (\val -> Just <| (Maybe.withDefault 0 val) + (if op == "dec" then -1 else 1) * change)

        False ->
            registers

{-|
-}
getInstructions : List (Registers -> Registers)
getInstructions =
    input
        |> String.trim
        |> String.lines
        |> List.foldl
            (\instructionStr instructions ->
                instructions ++
                    ( instructionStr
                        |> String.trim
                        |> find All (regex "^([a-z]+)\\s+(inc|dec)\\s+(-?[0-9]+)\\s+if\\s+([a-z]+)\\s+(>|<|>=|==|<=|!=)\\s+(-?[0-9]+)$")
                        |> List.head
                        |> Maybe.andThen
                            (\m ->
                                case m.submatches of
                                    (Just reg1)::(Just op)::(Just change)::(Just reg2)::(Just cond)::(Just condVal)::[] ->
                                        let
                                            (changeNum, condValNum) =
                                                ( change |> String.toInt |> Result.withDefault 0
                                                , condVal |> String.toInt |> Result.withDefault 0
                                                )
                                        in
                                        Just <| [ instructionFn reg1 op changeNum reg2 cond condValNum ]

                                    _ ->
                                        Nothing
                            )
                        |> Maybe.withDefault []
                    )
            )
            []


{-|
-}
input : String
input =
{-- }
    """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10"""
--}
{--}
    """o inc 394 if tcy >= -3
s inc -204 if s <= -5
keq inc -34 if keq > -6
ip inc 762 if ip == 4
zr inc -644 if ip >= 6
myk dec 894 if yq == -10
pc dec -990 if keq > -44
hwk inc 106 if qfz == -5
o inc 406 if qfz != -3
ljs dec 34 if myk == 0
n inc 579 if n != -6
sd dec -645 if pc <= 992
ow inc 154 if bio == 0
ige dec 108 if ip >= -9
py dec 799 if vt == 0
qfz dec -943 if tcy <= -9
hwk inc 569 if o == 800
tcy inc 90 if gij < 3
qpa inc -15 if ip < 1
keq inc -2 if u == 0
qpa inc -132 if keq <= -38
hwk inc -87 if zr == 7
ige dec 759 if g >= 9
cy inc -232 if scy > -8
hwk dec 539 if vt >= -7
d inc 517 if d <= 8
keq inc -65 if d < 509
sd dec -585 if vt >= -1
zr dec 970 if vt < 6
yq dec -670 if n == 579
qpa inc -839 if sd != 1226
s dec -633 if hwk > 26
sd inc -310 if g > 6
ljs inc 764 if o != 790
yq dec -785 if tcy >= 83
qfz inc 136 if ljs == 721
myk inc -699 if n == 579
qpa dec -16 if ow > 146
ow dec -257 if ige >= -112
d inc 675 if d != 517
gij dec 294 if bio >= 1
bio dec -937 if vt < 9
myk dec -630 if ige < -105
qpa inc -630 if bio > 930
ip dec -280 if ljs >= 738
hwk inc 532 if myk <= -61
sd inc -71 if pc >= 987
zr inc -753 if ip == -10
bio inc 716 if scy >= -3
u dec -59 if ljs >= 721
tcy dec -872 if py <= -803
si dec -480 if py != -799
cy dec -99 if gij <= 7
bio inc 804 if d <= 508
cy inc 489 if si > 0
o inc -910 if si <= 9
pc dec 393 if s <= 633
zr inc -580 if zr != -967
ige inc -824 if qfz >= -7
d dec -138 if o >= -116
ige inc -16 if scy < 2
s dec -29 if ip != 6
py inc -172 if bio <= 1657
keq inc 648 if tcy != 89
cy dec 324 if n > 575
ljs inc 624 if myk <= -61
n inc -643 if qpa == -1468
py dec -637 if g != -2
zr dec -174 if myk == -74
hwk dec 746 if scy >= -4
myk dec 775 if pc < 602
ljs inc -490 if s < 670
vt dec 173 if yq >= 1453
bio inc -106 if bio <= 1661
ljs inc 654 if qfz <= 6
gij dec -932 if d == 655
ige inc 146 if ljs == 1518
py dec 294 if myk > -850
zr inc 370 if n > -68
pc inc 463 if ige != -802
sd inc -300 if d != 645
ip dec -523 if hwk < -178
sd inc -652 if vt > -164
yq dec -493 if d < 663
ljs inc -612 if o < -110
myk inc -211 if bio <= 1544
gij dec -630 if pc < 598
ige inc -45 if ow <= 403
keq dec -658 if cy == -457
py dec -171 if gij <= 1565
hwk inc -159 if ljs < 1521
sd inc 475 if qfz >= 4
myk inc 516 if ow >= 411
hwk dec -812 if u < 53
d inc 544 if ige >= -805
cy inc -594 if ow >= 414
zr inc -98 if tcy < 85
cy dec -242 if sd == 859
bio dec 177 if ljs == 1518
myk inc -485 if ow < 420
s dec 451 if myk < -810
qfz dec 865 if yq > 1954
zr dec -430 if cy != -211
yq dec -640 if py < -451
qfz inc -886 if ljs == 1518
gij inc -636 if keq > 1267
bio inc 932 if ow >= 411
qpa inc -638 if sd != 859
qfz dec -726 if n != -61
tcy dec 303 if yq <= 2579
vt inc -915 if keq <= 1275
n inc -653 if zr > -747
ow inc -583 if keq <= 1277
scy inc 522 if pc > 596
gij inc -186 if n <= -56
sd dec 908 if qpa < -1472
o dec -157 if si < 3
g inc -239 if si < -9
ige inc -454 if hwk < -333
qfz inc 992 if qpa >= -1470
py dec -876 if sd > 852
py inc 983 if scy >= 513
vt inc -633 if yq <= 2592
o dec -167 if pc < 599
yq inc -784 if ip < 529
bio dec -179 if cy <= -209
keq dec -213 if keq <= 1278
s inc 845 if u >= 56
vt dec -890 if n <= -60
ow dec 479 if myk > -815
gij dec 93 if pc > 591
qfz dec 976 if pc == 597
myk dec -402 if pc > 588
cy dec -248 if s != 1054
n dec -519 if ljs == 1518
ow inc 323 if o < 224
ow dec 386 if ljs > 1509
scy inc 175 if ow != -715
tcy inc -344 if ip > 525
o inc 200 if si <= 4
ip dec 942 if bio > 2477
keq dec 983 if sd < 864
o inc 776 if o < 420
vt inc 284 if ljs > 1510
qfz inc 272 if myk > -407
tcy dec 276 if myk != -411
si inc -634 if keq == 500
gij inc -767 if g == 0
o inc 857 if o > 1189
yq inc -490 if cy != 27
vt inc -646 if qfz != -153
n dec 388 if n >= 447
yq dec -734 if pc > 603
ljs inc 382 if vt <= -1187
si dec 933 if bio > 2477
qpa dec -572 if ip == -419
scy inc -520 if keq == 500
g inc 133 if ljs <= 1908
ow dec -77 if ige >= -1264
si dec 984 if yq >= 1305
n dec 53 if pc == 597
zr inc -682 if tcy >= 89
g inc -839 if n > 16
keq inc 975 if qfz <= -145
hwk inc -592 if u >= 51
s inc -786 if gij != -113
keq dec -805 if n < 16
ige dec 854 if hwk < -940
yq inc 656 if ow <= -643
qfz inc -577 if pc <= 590
d dec -85 if d < 1208
keq inc 546 if cy == 33
bio dec 23 if ip == -419
si inc 205 if cy < 37
ige dec 979 if sd >= 855
o dec -482 if vt > -1198
cy dec -72 if gij <= -112
yq inc 276 if hwk > -930
zr inc 994 if qfz > -153
hwk inc 843 if py >= 1412
ige inc 468 if hwk >= -940
sd inc 477 if myk < -406
vt inc 557 if gij >= -124
tcy inc 949 if ljs == 1900
qpa dec 321 if g < 136
scy inc 502 if pc < 603
ljs inc -339 if cy <= 95
gij dec -963 if ljs < 1902
myk inc 1000 if bio >= 2449
sd dec 317 if gij != 849
qfz dec 148 if sd > 1027
g dec -786 if s <= 279
py dec -451 if ip != -422
ljs inc -756 if gij != 837
d inc 459 if ljs > 1140
hwk inc -371 if u > 58
u inc 765 if qfz < -141
ljs inc -69 if yq != 1324
ip inc -347 if o <= 2530
gij inc -56 if cy < 108
zr inc 988 if qpa <= -1216
o dec -671 if zr < 552
n inc -680 if qfz < -136
ow dec -709 if sd < 1027
ip inc -73 if si <= -2352
hwk dec 673 if gij <= 796
s inc 806 if py != 1856
zr dec -792 if g >= 910
si dec 325 if gij > 787
u dec -950 if ow == 73
yq dec 821 if sd <= 1025
g dec -160 if myk == 589
ljs inc -870 if gij >= 795
ow inc -309 if o == 3200
s dec -472 if s == 1076
ip dec 510 if keq < 1852
sd dec -599 if vt != -629
ige dec -147 if g > 1076
sd dec 602 if hwk == -1979
keq dec 215 if ip <= -1286
cy dec -290 if tcy >= 1038
pc inc 816 if g == 1079
cy inc 171 if bio != 2467
ip inc 104 if d >= 1734
scy inc -577 if qfz > -146
n inc 209 if cy != 558
qfz dec 130 if yq < 501
ow dec 740 if ip <= -1165
d dec -857 if vt > -639
pc inc -981 if bio < 2460
zr dec -979 if ow == -972
n inc -167 if ljs == 1071
ljs inc -315 if vt >= -636
vt dec -276 if gij > 779
g dec 778 if ip >= -1178
sd inc -976 if tcy >= 1040
d inc -517 if n > -467
ljs dec 359 if ow <= -976
gij inc -811 if u >= 820
ljs dec -768 if scy != 102
u dec -584 if zr < 1333
qfz dec 588 if qfz > -268
zr inc -775 if ow < -972
myk dec -693 if vt >= -367
cy inc 937 if s > 1549
hwk dec -686 if u >= 821
tcy dec -868 if qfz != -276
qpa inc 97 if scy > 111
gij inc 296 if pc != 432
cy dec -559 if o != 3199
g dec 59 if ip < -1166
keq inc -262 if zr != 563
o dec 823 if py >= 1844
ljs dec -253 if g < 243
ow inc -351 if tcy != 1914
myk dec -684 if d <= 2092
zr dec -175 if qpa == -1221
s inc -96 if scy <= 92
o inc 492 if keq <= 1589
tcy inc 563 if n > -464
ljs inc 764 if s < 1553
qpa inc -475 if qfz > -278
hwk dec -474 if myk >= 1957
o dec -709 if vt >= -364
ip dec -372 if bio == 2458
ip dec 361 if qfz != -272
tcy inc 986 if sd < 1019
ow dec 405 if hwk >= -809
n inc 894 if ow != -1336
g dec 648 if cy != 1116
si inc -49 if gij == -24
ip dec -787 if myk <= 1974
ljs dec 449 if scy <= 111
ow dec 940 if qpa != -1698
pc dec 788 if qfz > -277
u inc -955 if bio <= 2465
sd dec 113 if pc < -352
n dec 827 if ow <= -2260
tcy inc 298 if myk < 1973
g inc -615 if ige > -1630
ige inc 561 if o != 3578
scy dec -853 if myk > 1962
ige dec -248 if scy == 955
ip dec -961 if ige <= -1372
gij dec 441 if bio >= 2456
cy inc -631 if o == 3578
o dec -801 if gij == -465
zr dec -313 if scy <= 946
s dec -959 if yq == 493
s inc 77 if g > -1023
sd inc -160 if yq >= 485
yq dec -274 if pc != -357
d dec -882 if ige >= -1379
vt dec 311 if o != 4383
ip inc 732 if n < -384
ljs inc 742 if py < 1854
yq dec 707 if s < 2588
si inc -970 if cy != 486
cy inc 867 if scy >= 961
ow inc -880 if myk != 1972
pc inc -36 if ige <= -1369
g dec 308 if qpa > -1698
ljs dec -900 if gij >= -474
qpa inc 87 if hwk != -817
zr inc -763 if py == 1853
g dec 990 if myk <= 1975
tcy dec -579 if vt < -672
keq dec -565 if pc >= -399
u inc 381 if pc < -384
o dec -195 if bio > 2456
myk dec -39 if yq != 60
qpa dec 416 if bio == 2458
u inc 351 if keq < 2150
s inc 854 if vt >= -668
d dec 502 if myk < 1976
scy inc 372 if qpa >= -2023
hwk inc 362 if g == -2319
keq dec -972 if n != -390
pc inc 415 if tcy <= 3759
n inc 37 if sd > 737
n inc -617 if py != 1860
yq dec -446 if yq <= 62
ow inc -865 if pc == 23
n inc -157 if ljs == 2619
qfz inc 885 if keq != 2147
ige dec 106 if d <= 2460
sd dec 409 if d < 2469
ige dec 219 if d >= 2454
g dec -861 if qpa > -2029
cy dec 216 if ljs == 2611
ljs dec -993 if qpa < -2027
qfz inc 777 if d < 2467
ljs inc 348 if d != 2470
o dec -187 if bio > 2455
gij inc -778 if d == 2463
ige inc 798 if ip != 1321
n dec 160 if tcy < 3762
ip dec 431 if o > 4758
keq inc 889 if ip <= 890
si inc -272 if zr <= -192
zr inc -289 if sd != 344
si inc 843 if o == 4761
ige inc -940 if ip >= 887
pc inc -189 if keq < 3045
o inc -658 if yq >= 501
n dec -886 if keq >= 3045
tcy inc -3 if o > 4095
ow dec -639 if n < -1125
n dec 81 if ip < 891
qpa dec -430 if qfz <= 1394
cy inc 602 if bio >= 2457
qpa inc -579 if hwk >= -448
qfz inc 559 if g > -1460
u inc -902 if yq <= 507
py dec 556 if s > 2578
ige dec 439 if bio != 2467
hwk inc 327 if scy <= 1330
d dec -634 if o > 4103
myk dec 919 if qfz < 1957
tcy inc 680 if keq < 3050
qpa dec 628 if cy == 880
zr dec 112 if u <= -650
o dec -214 if si <= -2788
keq inc 132 if bio > 2451
myk inc 229 if qpa != -2219
keq inc 651 if n != -1203
si inc -655 if qfz != 1942
py inc -726 if zr < -595
scy inc -565 if py >= 567
qfz dec -219 if vt >= -661
py dec -405 if u > -656
ip dec 668 if g != -1454
sd inc -496 if py == 976
zr dec 315 if s != 2590
o dec -355 if myk >= 1047
cy dec -575 if keq <= 3831
o dec 589 if qfz != 1947
sd dec 487 if scy != 768
qfz inc -742 if n == -1211
n inc -81 if n > -1220
pc dec -747 if bio >= 2454
pc inc 814 if qpa == -2219
myk inc -874 if sd < -642
myk inc 375 if bio <= 2450
u inc -7 if ip <= 229
scy dec 677 if cy >= 1455
keq dec 746 if zr != -917
yq inc 594 if hwk >= -121
qpa inc -511 if bio != 2456
tcy dec 24 if zr < -919
o inc 10 if vt >= -679
ow dec -995 if yq != 506
py dec -144 if tcy >= 4425
g dec 501 if si > -3457
sd inc 911 if scy > 82
gij inc 545 if keq == 3080
gij inc 498 if vt <= -671
yq inc 728 if ip >= 227
si inc -751 if u > -669
keq dec 819 if d > 2453
ow inc -863 if pc == 1395
bio inc 651 if hwk < -134
s inc -818 if gij != -200
scy dec -26 if vt >= -675
ow dec -279 if d > 2454
n dec -451 if pc <= 1403
myk dec -113 if ljs != 2967
myk inc 14 if ip <= 210
bio inc 473 if hwk < -126
sd dec -907 if pc > 1392
qfz dec 21 if sd <= 1170
s inc 612 if vt != -664
qpa inc -734 if o != 4686
zr dec -487 if cy > 1453
myk dec -733 if sd > 1176
tcy inc -873 if ip >= 220
tcy inc -28 if vt <= -670
scy dec -793 if qpa <= -3465
u inc 301 if qfz >= 1180
d inc 515 if g > -1950
scy dec -335 if g > -1965
hwk inc 563 if scy == 446
bio dec -980 if py > 1112
yq dec 504 if o <= 4683
keq dec 458 if scy > 443
o inc -840 if sd > 1159
pc inc 922 if g <= -1957
si dec -305 if ljs < 2960
si inc 576 if ip > 212
pc inc 167 if n == -841
u dec 354 if d < 2470
py dec -167 if qpa > -3469
bio inc -599 if bio < 3912
u dec -783 if s >= 3190
hwk inc -838 if gij != -210
ow dec 803 if keq >= 1803
ow inc -592 if qpa > -3463
gij dec 475 if d == 2463
g dec -344 if u <= 69
si inc -575 if yq != -7
ige inc 247 if py != 1296
scy inc -847 if g >= -1966
zr inc 405 if yq > -5
si dec -102 if zr > -25
ow dec -630 if ip <= 221
o inc 563 if si <= -3788
qfz inc 722 if myk != 285
gij inc 461 if ow > -4139
bio inc -605 if cy < 1461
ige inc -235 if scy > -404
zr dec -637 if n != -840
n dec 847 if gij < -211
keq dec -165 if keq != 1806
o inc -27 if ige >= -2166
d dec -751 if n <= -1681
o dec -847 if scy < -395
hwk inc 526 if n < -1681
ow dec -197 if o > 5234
o dec 730 if py != 1285
ljs inc 300 if o < 4503
vt dec -530 if u > 66
n dec 862 if zr >= 615
si inc 804 if py <= 1289
myk dec -87 if n == -2550
pc inc -633 if vt >= -141
scy inc -392 if myk == 373
scy dec 444 if scy != -793
tcy inc 806 if zr < 624
vt inc 957 if ip <= 212
zr inc -380 if keq == 1968
n inc 519 if ow <= -4124
bio inc 738 if d != 3219
hwk inc -599 if yq == 2
ip dec -795 if ige < -2155
s inc -205 if myk == 373
zr dec 36 if keq <= 1970
pc dec -69 if ige == -2160
hwk dec 239 if tcy != 4333
ige dec 197 if s <= 3000
u dec 564 if tcy != 4326
u dec -109 if zr != 197
py inc 61 if vt >= -147
s dec -736 if tcy != 4330
u inc 385 if n != -2030
keq dec 98 if s > 3726
bio dec 467 if d == 3214
si dec 616 if ljs <= 3259
scy inc -799 if o == 4495
myk inc -364 if u < 8
qfz inc -180 if s != 3718
py dec 954 if gij == -214
qfz inc -608 if o >= 4487
ige dec -214 if ow < -4130
py dec 31 if qpa > -3471
d dec -625 if d <= 3210
ljs dec -407 if cy < 1460
n dec -218 if py >= 355
vt dec 577 if py == 363
hwk dec 406 if cy != 1464
g inc -243 if bio != 2968
keq inc -322 if vt > -727
tcy inc -159 if bio < 2970
qfz dec 208 if ljs > 3661
u inc 130 if u != -2
si dec 283 if g == -2202
hwk inc -489 if n <= -1812
u inc -895 if gij < -219
vt dec -375 if ljs < 3668
pc dec 325 if o == 4495
qpa dec 655 if yq == 2
ow inc 433 if sd <= 1172
ip inc 932 if ige != -2145
qpa inc 256 if g == -2202
ige inc -839 if qfz <= 916
o inc 108 if yq <= 9
myk dec 49 if ige >= -2983
d dec -825 if keq < 1556
hwk dec 756 if ige >= -2989
tcy dec 17 if u == 131
keq dec -841 if u >= 129
scy inc -926 if si > -3897
bio inc 880 if d > 4035
sd inc -230 if qpa <= -3861
si dec 782 if n <= -1808
myk inc 998 if vt != -337
hwk inc -363 if ljs < 3670
qpa dec 349 if keq == 2389
ip dec 17 if s <= 3736
u dec -985 if ige != -2984
zr dec 470 if hwk == -2731
ige dec -767 if py <= 368
yq dec 766 if keq >= 2385
ige dec 790 if yq == -758
cy inc 712 if ip > 1939
qfz inc 379 if ljs != 3666
py inc -287 if ljs == 3666
cy inc 148 if gij > -220
cy dec -389 if ip >= 1925
s dec 405 if g == -2202
ljs dec -95 if vt != -353
sd dec -511 if qfz <= 912
ljs dec -997 if gij < -204
scy dec -731 if ow != -3698
yq inc -383 if bio >= 3853
myk inc -272 if tcy >= 4321
py inc -162 if scy <= -2514
g dec -975 if keq <= 2392
bio dec -327 if n >= -1816
u inc -309 if d == 4039
scy inc -593 if cy > 1988
bio dec 737 if cy >= 1990
o inc 978 if o == 4603
ow inc -788 if bio <= 3448
qfz inc 568 if qpa != -4212
gij dec 637 if cy <= 1998
cy dec -603 if n == -1821
ljs inc 642 if ip > 1925
qpa inc 159 if ljs <= 5404
ip inc 987 if cy == 1992
d dec -499 if ige > -2225
n inc -267 if gij != -857
u dec 396 if cy >= 1987
hwk inc -131 if vt < -335
tcy dec 878 if gij != -841
cy dec -269 if d >= 4530
sd dec 706 if si >= -4670
n dec 239 if pc <= 1594
sd dec 318 if zr >= -274
ow dec 897 if s <= 3330
zr inc -891 if si >= -4661
u dec 119 if gij != -853
keq dec 427 if ige == -2215
ige dec 185 if pc < 1596
n inc 200 if py >= -90
scy inc 289 if u == 292
scy dec -570 if ige < -2390
myk dec 676 if qpa == -4053
yq dec 232 if sd < 434
ljs dec 685 if yq != -1379
n dec -747 if ow >= -5389
bio dec 900 if ige < -2398
hwk inc 106 if qfz != 906
o inc -687 if u < 294
sd inc 905 if sd > 430
yq inc -405 if qpa == -4053
u inc 871 if gij > -850
pc dec -145 if hwk > -2760
sd dec -673 if u >= 284
si dec 407 if qpa > -4055
ip dec 491 if s < 3329
bio inc 90 if ige != -2404
g dec 429 if ljs > 5398
qpa inc -965 if o >= 4888
s dec 419 if myk > 279
cy inc 309 if scy != -2261
u inc -585 if pc <= 1740
myk inc 933 if ow >= -5382
bio dec -959 if keq <= 1966
zr inc -68 if d == 4538
gij dec 418 if n <= -1127
cy dec -537 if scy > -2260
n dec -912 if scy <= -2251
yq inc -880 if ow < -5382
u dec -593 if yq <= -2663
u dec -628 if qfz >= 907
hwk dec -978 if keq == 1962
py dec 286 if o > 4903
o dec 626 if vt >= -349
vt dec 244 if si >= -5079
g inc -282 if ip <= 2428
zr dec 729 if py >= -86
pc dec 626 if vt >= -594
myk inc -630 if u == 928
bio inc -318 if ige <= -2393
hwk dec -636 if bio <= 3272
gij inc 4 if tcy != 3437
d inc -633 if keq != 1954
cy dec -845 if qfz > 909
bio dec -701 if zr < -1060
bio dec 33 if bio <= 3985
gij dec -770 if scy == -2252
o inc -301 if yq > -2673
s inc -11 if s != 2903
ip inc -527 if yq > -2674
d dec -700 if scy < -2245
o dec 157 if yq <= -2655
g dec -914 if cy < 3962
ige inc -380 if s < 2908
qpa inc -37 if hwk != -1784
pc inc 300 if keq == 1955
s dec 259 if s < 2907
yq inc 415 if cy < 3956
d inc -713 if vt < -584
si inc -257 if ip < 1902
n dec 573 if ljs > 5398
n dec -227 if py == -84
cy dec -469 if zr <= -1062
qfz inc -210 if ige != -2779
myk dec -63 if ip < 1894
keq inc 573 if gij <= -486
tcy dec 552 if keq < 2528
s inc 340 if qpa == -5055
zr inc 258 if qfz == 700
keq dec 528 if scy >= -2256
g dec 876 if g < -1021
si dec -939 if si < -5340
cy dec 200 if py > -80
qfz inc -714 if o <= 3814
g inc -497 if yq > -2253
bio dec -953 if ow > -5384
g dec 215 if ljs < 5396
yq dec 24 if ip > 1906
n inc 371 if scy <= -2248
o dec 264 if s < 2987
s dec -428 if gij > -502
ige dec 629 if yq <= -2242
gij inc -461 if g <= -2393
d dec -217 if u > 926
cy dec -781 if u != 926
hwk dec 929 if tcy < 3450
u dec 835 if ip >= 1897
tcy dec 753 if u < 99
ow inc 592 if py >= -91
ip dec -141 if pc != 1114
tcy inc -295 if zr == -808
o inc -627 if d == 4109
cy inc 469 if bio != 4905
vt inc -913 if vt != -587
sd dec 242 if zr > -809
qfz dec -166 if g > -2407
s dec 375 if yq >= -2253
scy inc -741 if qpa != -5051
myk dec 358 if g >= -2406
myk dec 873 if u != 90
hwk dec -387 if qpa == -5061
ow dec -360 if n < -431
py inc -907 if yq < -2239
pc dec -403 if myk >= -1576
sd inc -788 if si > -5328
qfz inc -95 if qfz > 158
s inc -25 if si != -5337
tcy inc -216 if qpa < -5054
ow dec -542 if bio > 4899
tcy dec 425 if hwk > -2707
tcy inc -543 if ljs < 5404
sd dec -200 if py < -989
zr dec 421 if u <= 91
d dec -522 if ljs != 5394
cy inc -533 if ljs >= 5398
vt inc -761 if py != -1001
bio inc -888 if ige > -3419
hwk inc -757 if gij == -956
yq dec 982 if ip >= 1892
scy dec 498 if myk != -1588
sd dec -884 if o < 2922
si dec 630 if qpa < -5047
bio dec -509 if gij == -947
vt dec 811 if pc >= 1113
yq inc 973 if ow <= -4257
s inc 564 if zr != -805
qpa dec 40 if ow > -4259
tcy dec -628 if u >= 93
qfz inc -951 if qpa != -5105
si dec 314 if py >= -994
n dec 41 if scy >= -3497
hwk inc -338 if pc > 1112
cy inc -982 if g < -2387
ow dec -651 if cy <= 4163
sd inc 463 if g >= -2405
yq dec -669 if qpa <= -5090
zr inc -237 if ljs > 5393
pc inc 594 if zr != -1047
bio inc -336 if keq <= 2001
py inc 303 if s < 3586
tcy dec 239 if gij != -965
tcy dec -514 if g > -2407
cy dec 362 if scy > -3493
ige dec 194 if o > 2917
cy inc 547 if u != 91
n inc 925 if si <= -6269
ow dec -786 if py <= -687
s inc 759 if zr != -1047
py dec 844 if yq == -2562
cy inc 640 if keq <= 2011
zr inc 13 if d < 4634
d dec -439 if o >= 2915
u dec 616 if n >= 456
myk dec -754 if tcy > 2541
sd dec 166 if vt == -2153
bio inc -776 if vt >= -2161
ljs dec -616 if myk >= -1583
zr inc 612 if ow < -2813
vt dec 735 if ip >= 1896
yq dec -856 if ige >= -3602
zr dec 927 if py >= -1535
u dec -416 if myk == -1579
py dec -76 if sd < 2412
myk dec -48 if ip >= 1905
qfz dec 95 if o > 2912
vt dec 810 if d != 5070
qfz inc 89 if qfz > -896
qfz dec -527 if scy > -3500
bio inc -851 if keq > 2005
u inc -43 if pc != 1704
u dec -143 if scy != -3487
gij dec 947 if sd >= 2411
g dec 202 if ow <= -2810
tcy dec 438 if bio != 2384
n inc -784 if sd <= 2400
ljs dec -64 if ip > 1893
yq inc 951 if keq >= 2004
bio dec -37 if vt == -2894
ige dec -280 if o > 2917
qpa dec -373 if ige == -3323
qpa dec 697 if yq > -1617
scy dec -430 if s < 4329
zr inc -253 if g == -2599
keq dec 339 if vt <= -2893
g dec 703 if ljs <= 6078
hwk dec -571 if vt == -2894
ige dec -954 if o <= 2928
keq dec 568 if o > 2914
ljs inc -645 if scy >= -3498
keq dec -827 if ljs != 5434
cy dec 784 if g == -2599
gij dec -47 if qpa == -5428
hwk inc -260 if myk == -1579
qpa dec -586 if g > -2608
o dec -581 if hwk > -3486
qpa inc -86 if o == 2919
gij dec -946 if zr < -2210
u dec 212 if ow == -2812
ow dec 268 if qpa < -4915
qpa inc 867 if hwk <= -3487
py dec -844 if hwk == -3491
g inc 35 if ow != -3078
gij dec -783 if vt <= -2885
u dec 57 if tcy >= 2097
pc dec -465 if tcy >= 2103
zr dec -262 if vt > -2904
hwk inc 153 if myk < -1571
si dec 295 if tcy >= 2092
u inc -59 if u < -270
sd dec 18 if gij != 769
gij inc -803 if bio < 2417
cy inc 523 if myk < -1579
vt dec -929 if ip < 1909
s dec -584 if ow < -3079
hwk dec -717 if keq < 1931
gij inc -114 if sd != 2386
qfz inc -478 if tcy != 2092
sd inc -322 if cy < 4198
ige dec 271 if tcy >= 2106
myk inc -298 if g != -2564
zr dec 711 if pc >= 1707
si dec -542 if sd < 2074
vt dec 819 if scy <= -3493
qfz inc 700 if ip >= 1891
g inc 134 if sd < 2067
qfz inc -572 if pc > 1703
ow dec -770 if keq <= 1931
o inc -63 if bio != 2422
hwk inc 797 if py < -612
qpa dec 679 if si >= -6031
qfz inc 46 if bio == 2422
g dec 182 if g < -2423
vt inc 488 if o != 2926
o dec -900 if cy > 4193
zr inc -625 if d > 5070
scy inc -64 if scy >= -3481
s inc 958 if tcy >= 2091
n inc -824 if myk != -1586
n dec -601 if u > -338
qfz inc 503 if s <= 5878
hwk inc 445 if d >= 5074
ow dec -123 if tcy != 2099
s inc -160 if hwk >= -1831
ige inc -959 if pc == 1708
s dec 526 if d > 5062
si inc -250 if pc > 1714
scy dec -40 if n >= 233
ow dec 909 if py == -614
ow inc 147 if u <= -333
sd inc -748 if pc > 1717
qpa dec 303 if cy >= 4190
qfz dec -347 if cy < 4206
vt inc 575 if scy < -3458
ow inc -59 if cy < 4201
ow dec -701 if ip <= 1896
qpa inc -666 if ige < -3318
g dec -595 if ige == -3328
sd dec 968 if u < -333
d dec -135 if u > -334
zr inc 501 if ljs != 5438
qpa inc 126 if qfz >= 264
ip dec 334 if keq > 1926
si inc 979 if ljs >= 5427
ip dec -474 if vt > -1485
vt dec -262 if pc <= 1710
u dec -960 if ige == -3328
scy inc -621 if ow < -3125
zr inc -256 if cy > 4189
u inc -133 if sd == 1096
si inc -53 if pc < 1706
vt dec 695 if keq <= 1928
zr inc 373 if hwk > -1833
qpa dec -198 if ow >= -3139
cy dec 636 if s != 5181
ip inc -732 if sd <= 1105
tcy inc -756 if tcy <= 2091
zr dec 503 if py <= -618
yq inc 451 if ip > 1298
gij dec 391 if zr < -2033
ow dec -258 if tcy <= 2106
yq inc 957 if g != -2022
gij dec 639 if u < 502
sd dec 253 if vt < -1908
tcy inc -882 if cy < 3570
s dec 556 if gij != -256
cy dec -820 if keq == 1927
py inc 885 if d < 5078
ige dec -207 if qpa != -5376
scy dec -417 if py == 271
g inc 45 if u >= 484
o dec -198 if o <= 3824
d dec -978 if pc >= 1705
scy dec -770 if ip != 1310
hwk dec -35 if hwk > -1826
pc dec 470 if si > -5047
n dec -141 if u > 483
ow inc 244 if scy == -2885
pc dec 538 if d <= 6055
sd inc 289 if ow >= -2638
keq inc -931 if ip != 1317
py inc 746 if py != 278
qfz dec -957 if si == -5051
yq dec -374 if cy < 4377
vt dec -749 if ljs >= 5426
n inc 922 if bio != 2422
scy dec 758 if s <= 4644
qfz inc -739 if s <= 4635
si inc 653 if s >= 4634
d inc 297 if ow == -2629
vt inc 963 if zr != -2033
g inc 977 if si <= -4393
myk dec -141 if qfz == 486
s dec 68 if d == 6345
zr inc 882 if s <= 4564
cy inc -492 if pc == 1170
myk dec -492 if ow <= -2633
s dec -186 if cy <= 3893
tcy inc -947 if hwk == -1789
pc dec 455 if s > 4745
gij dec 601 if n <= 370
scy inc -688 if hwk < -1797
scy inc 768 if qfz < 491
myk inc -187 if qfz != 490
g dec -732 if ow != -2629
cy dec 355 if qfz != 480
ip inc 901 if cy == 3534
qfz dec 460 if yq != -203
py dec 366 if d <= 6349
qpa inc 474 if d > 6343
keq dec -768 if tcy == 270
gij inc 876 if ljs >= 5427
tcy inc 617 if bio > 2419
sd inc -649 if ljs != 5441
ow dec -20 if gij < 627
qfz dec 436 if vt <= -198
pc dec -752 if d <= 6337
ip dec 928 if scy < -2867
qpa inc 780 if d > 6344
bio inc 963 if n == 379
ige inc 93 if gij != 620
ige inc -185 if scy == -2875
py inc -650 if qpa >= -4129
ip dec -895 if gij < 621
s dec -539 if ip != 2180
py dec 71 if qpa >= -4127
bio dec 229 if gij != 619
yq dec 56 if vt > -205
qfz dec -389 if sd != 485
s dec -85 if cy < 3540
ip inc 386 if yq < -253
gij dec 571 if qpa != -4119
ip inc -645 if bio == 3380
qpa inc -822 if qpa < -4118
ljs inc -43 if myk == -1625
bio inc -462 if tcy == 887
myk inc -717 if vt > -200
scy dec 228 if myk != -2348
myk dec -518 if myk <= -2336
d inc -593 if si < -4397
ip inc -912 if ige < -3428
si inc -320 if vt <= -196
n dec 997 if ige != -3420
ip inc -801 if ip > 2557
pc dec -526 if hwk < -1781
ige dec -279 if ip <= 1762
ow dec -488 if qfz >= 436
scy inc 408 if qfz != 443
gij inc -992 if scy <= -2691
pc inc 238 if ige != -3143
g inc 760 if scy >= -2697
s dec -57 if hwk <= -1783
si dec 368 if ip == 1760
qfz dec 760 if vt >= -205
myk dec 254 if u == 491
sd inc -466 if myk <= -1818
cy dec -64 if qfz != -331
vt dec -632 if qpa == -4944
gij inc 382 if zr == -2042
py inc 585 if zr <= -2050
n dec 612 if d < 5760
o inc 673 if py <= -62
u inc 986 if py <= -61
ip dec 128 if gij == -954
u inc -173 if ige <= -3140
ip inc 358 if scy <= -2687
o inc 114 if py > -67
hwk dec -413 if n <= -233
scy dec 979 if s == 5434
myk inc -190 if py <= -62
u dec 884 if hwk != -1376
sd inc -711 if zr > -2038
pc inc -292 if o <= 4690
d inc -490 if d < 5749
py dec 812 if ljs <= 5397
keq dec -74 if qfz >= -324
qfz dec 820 if ige >= -3149
ow dec 629 if d >= 5746
scy dec 481 if qfz != -1144
gij dec 272 if ip == 2118
keq inc -957 if scy == -4161
ljs dec -974 if hwk == -1376
gij dec 848 if sd < 20
o inc -718 if scy >= -4160
s dec 807 if g <= -244
zr inc -12 if sd != 23
ip dec 332 if sd >= 19
sd inc -237 if ljs >= 6370
o dec 105 if ow == -2750
u inc -466 if qpa > -4950
cy inc -11 if keq >= 1846
gij dec 576 if scy > -4159
py inc -470 if u == 834
qfz inc 812 if vt != 434
yq inc -447 if bio <= 2927
qpa inc 983 if bio != 2926
g dec -396 if py != -882
qfz dec -504 if vt < 437
d inc 202 if ip > 2121
ip dec -112 if n < -230
hwk inc -295 if keq <= 1845
hwk dec -244 if d == 5752
tcy inc 905 if n != -235
ljs dec 901 if yq >= -710
keq dec -871 if sd <= 20
u inc -900 if s == 5434
pc dec 916 if vt <= 426"""
--}