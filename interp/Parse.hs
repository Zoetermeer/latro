{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21
	| HappyAbsSyn22 t22
	| HappyAbsSyn23 t23
	| HappyAbsSyn24 t24
	| HappyAbsSyn25 t25
	| HappyAbsSyn26 t26
	| HappyAbsSyn27 t27
	| HappyAbsSyn28 t28
	| HappyAbsSyn29 t29
	| HappyAbsSyn30 t30

action_0 (31) = happyShift action_14
action_0 (32) = happyShift action_15
action_0 (33) = happyShift action_16
action_0 (35) = happyShift action_17
action_0 (38) = happyShift action_18
action_0 (39) = happyShift action_19
action_0 (43) = happyShift action_20
action_0 (50) = happyShift action_21
action_0 (57) = happyShift action_22
action_0 (63) = happyShift action_23
action_0 (64) = happyShift action_24
action_0 (4) = happyGoto action_25
action_0 (5) = happyGoto action_2
action_0 (7) = happyGoto action_3
action_0 (8) = happyGoto action_4
action_0 (9) = happyGoto action_5
action_0 (10) = happyGoto action_6
action_0 (11) = happyGoto action_7
action_0 (12) = happyGoto action_8
action_0 (13) = happyGoto action_9
action_0 (14) = happyGoto action_10
action_0 (15) = happyGoto action_11
action_0 (18) = happyGoto action_12
action_0 (22) = happyGoto action_13
action_0 _ = happyFail

action_1 (31) = happyShift action_14
action_1 (32) = happyShift action_15
action_1 (33) = happyShift action_16
action_1 (35) = happyShift action_17
action_1 (38) = happyShift action_18
action_1 (39) = happyShift action_19
action_1 (43) = happyShift action_20
action_1 (50) = happyShift action_21
action_1 (57) = happyShift action_22
action_1 (63) = happyShift action_23
action_1 (64) = happyShift action_24
action_1 (5) = happyGoto action_2
action_1 (7) = happyGoto action_3
action_1 (8) = happyGoto action_4
action_1 (9) = happyGoto action_5
action_1 (10) = happyGoto action_6
action_1 (11) = happyGoto action_7
action_1 (12) = happyGoto action_8
action_1 (13) = happyGoto action_9
action_1 (14) = happyGoto action_10
action_1 (15) = happyGoto action_11
action_1 (18) = happyGoto action_12
action_1 (22) = happyGoto action_13
action_1 _ = happyFail

action_2 (31) = happyShift action_14
action_2 (32) = happyShift action_15
action_2 (33) = happyShift action_16
action_2 (35) = happyShift action_17
action_2 (38) = happyShift action_18
action_2 (39) = happyShift action_19
action_2 (43) = happyShift action_20
action_2 (50) = happyShift action_21
action_2 (57) = happyShift action_22
action_2 (63) = happyShift action_23
action_2 (64) = happyShift action_24
action_2 (7) = happyGoto action_44
action_2 (8) = happyGoto action_4
action_2 (9) = happyGoto action_5
action_2 (10) = happyGoto action_6
action_2 (11) = happyGoto action_7
action_2 (12) = happyGoto action_8
action_2 (13) = happyGoto action_9
action_2 (14) = happyGoto action_10
action_2 (15) = happyGoto action_11
action_2 (18) = happyGoto action_12
action_2 (22) = happyGoto action_13
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 _ = happyReduce_14

action_5 _ = happyReduce_16

action_6 (50) = happyShift action_42
action_6 (59) = happyShift action_43
action_6 _ = happyReduce_18

action_7 (55) = happyShift action_41
action_7 _ = happyReduce_20

action_8 (56) = happyShift action_40
action_8 _ = happyReduce_22

action_9 (53) = happyShift action_39
action_9 _ = happyReduce_24

action_10 (54) = happyShift action_38
action_10 _ = happyReduce_26

action_11 (58) = happyShift action_37
action_11 _ = happyFail

action_12 _ = happyReduce_29

action_13 _ = happyReduce_30

action_14 (48) = happyShift action_36
action_14 _ = happyFail

action_15 (64) = happyShift action_35
action_15 (30) = happyGoto action_34
action_15 _ = happyFail

action_16 (64) = happyShift action_33
action_16 _ = happyFail

action_17 (50) = happyShift action_31
action_17 (64) = happyShift action_32
action_17 _ = happyFail

action_18 _ = happyReduce_10

action_19 _ = happyReduce_11

action_20 (50) = happyShift action_30
action_20 _ = happyFail

action_21 (31) = happyShift action_14
action_21 (32) = happyShift action_15
action_21 (33) = happyShift action_16
action_21 (35) = happyShift action_17
action_21 (38) = happyShift action_18
action_21 (39) = happyShift action_19
action_21 (43) = happyShift action_20
action_21 (50) = happyShift action_21
action_21 (57) = happyShift action_22
action_21 (63) = happyShift action_23
action_21 (64) = happyShift action_24
action_21 (8) = happyGoto action_4
action_21 (9) = happyGoto action_5
action_21 (10) = happyGoto action_6
action_21 (11) = happyGoto action_7
action_21 (12) = happyGoto action_8
action_21 (13) = happyGoto action_9
action_21 (14) = happyGoto action_10
action_21 (15) = happyGoto action_29
action_21 (18) = happyGoto action_12
action_21 (22) = happyGoto action_13
action_21 _ = happyFail

action_22 (38) = happyShift action_18
action_22 (39) = happyShift action_19
action_22 (50) = happyShift action_21
action_22 (63) = happyShift action_23
action_22 (64) = happyShift action_28
action_22 (8) = happyGoto action_4
action_22 (9) = happyGoto action_5
action_22 (10) = happyGoto action_6
action_22 (11) = happyGoto action_7
action_22 (12) = happyGoto action_8
action_22 (13) = happyGoto action_9
action_22 (14) = happyGoto action_27
action_22 _ = happyFail

action_23 _ = happyReduce_9

action_24 (45) = happyShift action_26
action_24 _ = happyReduce_12

action_25 (65) = happyAccept
action_25 _ = happyFail

action_26 (31) = happyShift action_14
action_26 (32) = happyShift action_15
action_26 (33) = happyShift action_16
action_26 (35) = happyShift action_17
action_26 (38) = happyShift action_18
action_26 (39) = happyShift action_19
action_26 (43) = happyShift action_20
action_26 (50) = happyShift action_21
action_26 (57) = happyShift action_22
action_26 (63) = happyShift action_23
action_26 (64) = happyShift action_24
action_26 (8) = happyGoto action_4
action_26 (9) = happyGoto action_5
action_26 (10) = happyGoto action_6
action_26 (11) = happyGoto action_7
action_26 (12) = happyGoto action_8
action_26 (13) = happyGoto action_9
action_26 (14) = happyGoto action_10
action_26 (15) = happyGoto action_68
action_26 (18) = happyGoto action_12
action_26 (22) = happyGoto action_13
action_26 _ = happyFail

action_27 (54) = happyShift action_38
action_27 _ = happyReduce_25

action_28 _ = happyReduce_12

action_29 (51) = happyShift action_67
action_29 _ = happyFail

action_30 (31) = happyShift action_14
action_30 (32) = happyShift action_15
action_30 (33) = happyShift action_16
action_30 (35) = happyShift action_17
action_30 (38) = happyShift action_18
action_30 (39) = happyShift action_19
action_30 (43) = happyShift action_20
action_30 (50) = happyShift action_21
action_30 (57) = happyShift action_22
action_30 (63) = happyShift action_23
action_30 (64) = happyShift action_24
action_30 (8) = happyGoto action_4
action_30 (9) = happyGoto action_5
action_30 (10) = happyGoto action_6
action_30 (11) = happyGoto action_7
action_30 (12) = happyGoto action_8
action_30 (13) = happyGoto action_9
action_30 (14) = happyGoto action_10
action_30 (15) = happyGoto action_66
action_30 (18) = happyGoto action_12
action_30 (22) = happyGoto action_13
action_30 _ = happyFail

action_31 (31) = happyShift action_60
action_31 (34) = happyShift action_61
action_31 (35) = happyShift action_62
action_31 (40) = happyShift action_63
action_31 (41) = happyShift action_64
action_31 (42) = happyShift action_65
action_31 (64) = happyShift action_35
action_31 (29) = happyGoto action_58
action_31 (30) = happyGoto action_59
action_31 _ = happyFail

action_32 (50) = happyShift action_57
action_32 _ = happyFail

action_33 (60) = happyShift action_56
action_33 _ = happyFail

action_34 (59) = happyShift action_55
action_34 _ = happyReduce_27

action_35 _ = happyReduce_69

action_36 (31) = happyShift action_14
action_36 (32) = happyShift action_15
action_36 (33) = happyShift action_16
action_36 (35) = happyShift action_17
action_36 (38) = happyShift action_18
action_36 (39) = happyShift action_19
action_36 (43) = happyShift action_20
action_36 (50) = happyShift action_21
action_36 (57) = happyShift action_22
action_36 (63) = happyShift action_23
action_36 (64) = happyShift action_24
action_36 (5) = happyGoto action_52
action_36 (6) = happyGoto action_53
action_36 (7) = happyGoto action_54
action_36 (8) = happyGoto action_4
action_36 (9) = happyGoto action_5
action_36 (10) = happyGoto action_6
action_36 (11) = happyGoto action_7
action_36 (12) = happyGoto action_8
action_36 (13) = happyGoto action_9
action_36 (14) = happyGoto action_10
action_36 (15) = happyGoto action_11
action_36 (18) = happyGoto action_12
action_36 (22) = happyGoto action_13
action_36 _ = happyReduce_6

action_37 _ = happyReduce_7

action_38 (38) = happyShift action_18
action_38 (39) = happyShift action_19
action_38 (50) = happyShift action_21
action_38 (63) = happyShift action_23
action_38 (64) = happyShift action_28
action_38 (8) = happyGoto action_4
action_38 (9) = happyGoto action_5
action_38 (10) = happyGoto action_6
action_38 (11) = happyGoto action_7
action_38 (12) = happyGoto action_8
action_38 (13) = happyGoto action_51
action_38 _ = happyFail

action_39 (38) = happyShift action_18
action_39 (39) = happyShift action_19
action_39 (50) = happyShift action_21
action_39 (63) = happyShift action_23
action_39 (64) = happyShift action_28
action_39 (8) = happyGoto action_4
action_39 (9) = happyGoto action_5
action_39 (10) = happyGoto action_6
action_39 (11) = happyGoto action_7
action_39 (12) = happyGoto action_50
action_39 _ = happyFail

action_40 (38) = happyShift action_18
action_40 (39) = happyShift action_19
action_40 (50) = happyShift action_21
action_40 (63) = happyShift action_23
action_40 (64) = happyShift action_28
action_40 (8) = happyGoto action_4
action_40 (9) = happyGoto action_5
action_40 (10) = happyGoto action_6
action_40 (11) = happyGoto action_49
action_40 _ = happyFail

action_41 (38) = happyShift action_18
action_41 (39) = happyShift action_19
action_41 (50) = happyShift action_21
action_41 (63) = happyShift action_23
action_41 (64) = happyShift action_28
action_41 (8) = happyGoto action_4
action_41 (9) = happyGoto action_5
action_41 (10) = happyGoto action_48
action_41 _ = happyFail

action_42 (31) = happyShift action_14
action_42 (32) = happyShift action_15
action_42 (33) = happyShift action_16
action_42 (35) = happyShift action_17
action_42 (38) = happyShift action_18
action_42 (39) = happyShift action_19
action_42 (43) = happyShift action_20
action_42 (50) = happyShift action_21
action_42 (57) = happyShift action_22
action_42 (63) = happyShift action_23
action_42 (64) = happyShift action_24
action_42 (8) = happyGoto action_4
action_42 (9) = happyGoto action_5
action_42 (10) = happyGoto action_6
action_42 (11) = happyGoto action_7
action_42 (12) = happyGoto action_8
action_42 (13) = happyGoto action_9
action_42 (14) = happyGoto action_10
action_42 (15) = happyGoto action_46
action_42 (16) = happyGoto action_47
action_42 (18) = happyGoto action_12
action_42 (22) = happyGoto action_13
action_42 _ = happyReduce_35

action_43 (64) = happyShift action_45
action_43 _ = happyFail

action_44 _ = happyReduce_3

action_45 _ = happyReduce_13

action_46 _ = happyReduce_33

action_47 (51) = happyShift action_83
action_47 (62) = happyShift action_84
action_47 _ = happyFail

action_48 (50) = happyShift action_42
action_48 (59) = happyShift action_43
action_48 _ = happyReduce_17

action_49 (55) = happyShift action_41
action_49 _ = happyReduce_19

action_50 (56) = happyShift action_40
action_50 _ = happyReduce_21

action_51 (53) = happyShift action_39
action_51 _ = happyReduce_23

action_52 (31) = happyShift action_14
action_52 (32) = happyShift action_15
action_52 (33) = happyShift action_16
action_52 (35) = happyShift action_17
action_52 (38) = happyShift action_18
action_52 (39) = happyShift action_19
action_52 (43) = happyShift action_20
action_52 (50) = happyShift action_21
action_52 (57) = happyShift action_22
action_52 (63) = happyShift action_23
action_52 (64) = happyShift action_24
action_52 (7) = happyGoto action_82
action_52 (8) = happyGoto action_4
action_52 (9) = happyGoto action_5
action_52 (10) = happyGoto action_6
action_52 (11) = happyGoto action_7
action_52 (12) = happyGoto action_8
action_52 (13) = happyGoto action_9
action_52 (14) = happyGoto action_10
action_52 (15) = happyGoto action_11
action_52 (18) = happyGoto action_12
action_52 (22) = happyGoto action_13
action_52 _ = happyFail

action_53 (49) = happyShift action_81
action_53 _ = happyFail

action_54 (49) = happyReduce_4
action_54 _ = happyReduce_2

action_55 (64) = happyShift action_80
action_55 _ = happyFail

action_56 (31) = happyShift action_60
action_56 (34) = happyShift action_61
action_56 (35) = happyShift action_62
action_56 (40) = happyShift action_63
action_56 (41) = happyShift action_64
action_56 (42) = happyShift action_65
action_56 (52) = happyShift action_79
action_56 (64) = happyShift action_35
action_56 (19) = happyGoto action_76
action_56 (20) = happyGoto action_77
action_56 (29) = happyGoto action_78
action_56 (30) = happyGoto action_59
action_56 _ = happyFail

action_57 (31) = happyShift action_60
action_57 (34) = happyShift action_61
action_57 (35) = happyShift action_62
action_57 (40) = happyShift action_63
action_57 (41) = happyShift action_64
action_57 (42) = happyShift action_65
action_57 (64) = happyShift action_35
action_57 (28) = happyGoto action_74
action_57 (29) = happyGoto action_75
action_57 (30) = happyGoto action_59
action_57 _ = happyReduce_60

action_58 (51) = happyShift action_73
action_58 _ = happyFail

action_59 (59) = happyShift action_55
action_59 _ = happyReduce_68

action_60 (48) = happyShift action_72
action_60 _ = happyFail

action_61 (48) = happyShift action_71
action_61 _ = happyFail

action_62 (50) = happyShift action_70
action_62 _ = happyFail

action_63 _ = happyReduce_61

action_64 _ = happyReduce_62

action_65 _ = happyReduce_63

action_66 (51) = happyShift action_69
action_66 _ = happyFail

action_67 _ = happyReduce_8

action_68 _ = happyReduce_28

action_69 (48) = happyShift action_95
action_69 _ = happyFail

action_70 (31) = happyShift action_60
action_70 (34) = happyShift action_61
action_70 (35) = happyShift action_62
action_70 (40) = happyShift action_63
action_70 (41) = happyShift action_64
action_70 (42) = happyShift action_65
action_70 (51) = happyShift action_94
action_70 (64) = happyShift action_35
action_70 (28) = happyGoto action_93
action_70 (29) = happyGoto action_75
action_70 (30) = happyGoto action_59
action_70 _ = happyReduce_60

action_71 (49) = happyShift action_92
action_71 _ = happyFail

action_72 (49) = happyShift action_91
action_72 _ = happyFail

action_73 (64) = happyShift action_90
action_73 _ = happyFail

action_74 (51) = happyShift action_88
action_74 (62) = happyShift action_89
action_74 _ = happyFail

action_75 _ = happyReduce_58

action_76 (52) = happyShift action_79
action_76 (20) = happyGoto action_87
action_76 _ = happyReduce_40

action_77 _ = happyReduce_41

action_78 _ = happyReduce_39

action_79 (64) = happyShift action_86
action_79 _ = happyFail

action_80 _ = happyReduce_70

action_81 _ = happyReduce_31

action_82 (49) = happyReduce_5
action_82 _ = happyReduce_3

action_83 _ = happyReduce_15

action_84 (31) = happyShift action_14
action_84 (32) = happyShift action_15
action_84 (33) = happyShift action_16
action_84 (35) = happyShift action_17
action_84 (38) = happyShift action_18
action_84 (39) = happyShift action_19
action_84 (43) = happyShift action_20
action_84 (50) = happyShift action_21
action_84 (57) = happyShift action_22
action_84 (63) = happyShift action_23
action_84 (64) = happyShift action_24
action_84 (8) = happyGoto action_4
action_84 (9) = happyGoto action_5
action_84 (10) = happyGoto action_6
action_84 (11) = happyGoto action_7
action_84 (12) = happyGoto action_8
action_84 (13) = happyGoto action_9
action_84 (14) = happyGoto action_10
action_84 (15) = happyGoto action_85
action_84 (18) = happyGoto action_12
action_84 (22) = happyGoto action_13
action_84 _ = happyFail

action_85 _ = happyReduce_34

action_86 (31) = happyShift action_60
action_86 (34) = happyShift action_61
action_86 (35) = happyShift action_62
action_86 (40) = happyShift action_63
action_86 (41) = happyShift action_64
action_86 (42) = happyShift action_65
action_86 (64) = happyShift action_35
action_86 (21) = happyGoto action_102
action_86 (29) = happyGoto action_103
action_86 (30) = happyGoto action_59
action_86 _ = happyReduce_46

action_87 _ = happyReduce_42

action_88 (61) = happyShift action_101
action_88 _ = happyFail

action_89 (31) = happyShift action_60
action_89 (34) = happyShift action_61
action_89 (35) = happyShift action_62
action_89 (40) = happyShift action_63
action_89 (41) = happyShift action_64
action_89 (42) = happyShift action_65
action_89 (64) = happyShift action_35
action_89 (29) = happyGoto action_100
action_89 (30) = happyGoto action_59
action_89 _ = happyFail

action_90 (50) = happyShift action_99
action_90 _ = happyFail

action_91 _ = happyReduce_66

action_92 _ = happyReduce_67

action_93 (51) = happyShift action_98
action_93 (62) = happyShift action_89
action_93 _ = happyFail

action_94 (61) = happyShift action_97
action_94 _ = happyFail

action_95 (31) = happyShift action_14
action_95 (32) = happyShift action_15
action_95 (33) = happyShift action_16
action_95 (35) = happyShift action_17
action_95 (38) = happyShift action_18
action_95 (39) = happyShift action_19
action_95 (43) = happyShift action_20
action_95 (50) = happyShift action_21
action_95 (57) = happyShift action_22
action_95 (63) = happyShift action_23
action_95 (64) = happyShift action_24
action_95 (5) = happyGoto action_52
action_95 (6) = happyGoto action_96
action_95 (7) = happyGoto action_54
action_95 (8) = happyGoto action_4
action_95 (9) = happyGoto action_5
action_95 (10) = happyGoto action_6
action_95 (11) = happyGoto action_7
action_95 (12) = happyGoto action_8
action_95 (13) = happyGoto action_9
action_95 (14) = happyGoto action_10
action_95 (15) = happyGoto action_11
action_95 (18) = happyGoto action_12
action_95 (22) = happyGoto action_13
action_95 _ = happyReduce_6

action_96 (49) = happyShift action_109
action_96 _ = happyFail

action_97 (31) = happyShift action_60
action_97 (34) = happyShift action_61
action_97 (35) = happyShift action_62
action_97 (40) = happyShift action_63
action_97 (41) = happyShift action_64
action_97 (42) = happyShift action_65
action_97 (64) = happyShift action_35
action_97 (29) = happyGoto action_108
action_97 (30) = happyGoto action_59
action_97 _ = happyFail

action_98 (61) = happyShift action_107
action_98 _ = happyFail

action_99 (31) = happyShift action_60
action_99 (34) = happyShift action_61
action_99 (35) = happyShift action_62
action_99 (40) = happyShift action_63
action_99 (41) = happyShift action_64
action_99 (42) = happyShift action_65
action_99 (64) = happyShift action_35
action_99 (28) = happyGoto action_106
action_99 (29) = happyGoto action_75
action_99 (30) = happyGoto action_59
action_99 _ = happyReduce_60

action_100 _ = happyReduce_59

action_101 (31) = happyShift action_60
action_101 (34) = happyShift action_61
action_101 (35) = happyShift action_62
action_101 (40) = happyShift action_63
action_101 (41) = happyShift action_64
action_101 (42) = happyShift action_65
action_101 (64) = happyShift action_35
action_101 (29) = happyGoto action_105
action_101 (30) = happyGoto action_59
action_101 _ = happyFail

action_102 (31) = happyShift action_60
action_102 (34) = happyShift action_61
action_102 (35) = happyShift action_62
action_102 (40) = happyShift action_63
action_102 (41) = happyShift action_64
action_102 (42) = happyShift action_65
action_102 (64) = happyShift action_35
action_102 (29) = happyGoto action_104
action_102 (30) = happyGoto action_59
action_102 _ = happyReduce_43

action_103 _ = happyReduce_44

action_104 _ = happyReduce_45

action_105 (58) = happyShift action_113
action_105 _ = happyFail

action_106 (51) = happyShift action_112
action_106 (62) = happyShift action_89
action_106 _ = happyFail

action_107 (31) = happyShift action_60
action_107 (34) = happyShift action_61
action_107 (35) = happyShift action_62
action_107 (40) = happyShift action_63
action_107 (41) = happyShift action_64
action_107 (42) = happyShift action_65
action_107 (64) = happyShift action_35
action_107 (29) = happyGoto action_111
action_107 (30) = happyGoto action_59
action_107 _ = happyFail

action_108 _ = happyReduce_64

action_109 (44) = happyShift action_110
action_109 _ = happyFail

action_110 (48) = happyShift action_120
action_110 _ = happyFail

action_111 _ = happyReduce_65

action_112 (61) = happyShift action_119
action_112 _ = happyFail

action_113 (50) = happyShift action_117
action_113 (64) = happyShift action_118
action_113 (23) = happyGoto action_114
action_113 (24) = happyGoto action_115
action_113 (25) = happyGoto action_116
action_113 _ = happyFail

action_114 (50) = happyShift action_117
action_114 (64) = happyShift action_118
action_114 (24) = happyGoto action_127
action_114 (25) = happyGoto action_116
action_114 _ = happyReduce_48

action_115 _ = happyReduce_49

action_116 (64) = happyShift action_126
action_116 _ = happyFail

action_117 (64) = happyShift action_125
action_117 (27) = happyGoto action_124
action_117 _ = happyFail

action_118 (50) = happyShift action_123
action_118 _ = happyFail

action_119 (31) = happyShift action_60
action_119 (34) = happyShift action_61
action_119 (35) = happyShift action_62
action_119 (40) = happyShift action_63
action_119 (41) = happyShift action_64
action_119 (42) = happyShift action_65
action_119 (64) = happyShift action_35
action_119 (29) = happyGoto action_122
action_119 (30) = happyGoto action_59
action_119 _ = happyFail

action_120 (31) = happyShift action_14
action_120 (32) = happyShift action_15
action_120 (33) = happyShift action_16
action_120 (35) = happyShift action_17
action_120 (38) = happyShift action_18
action_120 (39) = happyShift action_19
action_120 (43) = happyShift action_20
action_120 (50) = happyShift action_21
action_120 (57) = happyShift action_22
action_120 (63) = happyShift action_23
action_120 (64) = happyShift action_24
action_120 (5) = happyGoto action_52
action_120 (6) = happyGoto action_121
action_120 (7) = happyGoto action_54
action_120 (8) = happyGoto action_4
action_120 (9) = happyGoto action_5
action_120 (10) = happyGoto action_6
action_120 (11) = happyGoto action_7
action_120 (12) = happyGoto action_8
action_120 (13) = happyGoto action_9
action_120 (14) = happyGoto action_10
action_120 (15) = happyGoto action_11
action_120 (18) = happyGoto action_12
action_120 (22) = happyGoto action_13
action_120 _ = happyReduce_6

action_121 (49) = happyShift action_133
action_121 _ = happyFail

action_122 (58) = happyShift action_132
action_122 _ = happyFail

action_123 (64) = happyShift action_125
action_123 (26) = happyGoto action_130
action_123 (27) = happyGoto action_131
action_123 _ = happyReduce_56

action_124 (51) = happyShift action_129
action_124 _ = happyFail

action_125 _ = happyReduce_57

action_126 (50) = happyShift action_128
action_126 _ = happyFail

action_127 _ = happyReduce_50

action_128 (64) = happyShift action_125
action_128 (26) = happyGoto action_138
action_128 (27) = happyGoto action_131
action_128 _ = happyReduce_56

action_129 (59) = happyShift action_137
action_129 _ = happyFail

action_130 (51) = happyShift action_135
action_130 (62) = happyShift action_136
action_130 _ = happyFail

action_131 _ = happyReduce_54

action_132 (50) = happyShift action_117
action_132 (64) = happyShift action_118
action_132 (23) = happyGoto action_134
action_132 (24) = happyGoto action_115
action_132 (25) = happyGoto action_116
action_132 _ = happyFail

action_133 _ = happyReduce_32

action_134 (50) = happyShift action_117
action_134 (64) = happyShift action_118
action_134 (24) = happyGoto action_127
action_134 (25) = happyGoto action_116
action_134 _ = happyReduce_47

action_135 (45) = happyShift action_141
action_135 _ = happyFail

action_136 (64) = happyShift action_125
action_136 (27) = happyGoto action_140
action_136 _ = happyFail

action_137 _ = happyReduce_53

action_138 (51) = happyShift action_139
action_138 (62) = happyShift action_136
action_138 _ = happyFail

action_139 (45) = happyShift action_143
action_139 _ = happyFail

action_140 _ = happyReduce_55

action_141 (48) = happyShift action_142
action_141 _ = happyFail

action_142 (31) = happyShift action_14
action_142 (32) = happyShift action_15
action_142 (33) = happyShift action_16
action_142 (35) = happyShift action_17
action_142 (38) = happyShift action_18
action_142 (39) = happyShift action_19
action_142 (43) = happyShift action_20
action_142 (50) = happyShift action_21
action_142 (57) = happyShift action_22
action_142 (63) = happyShift action_23
action_142 (64) = happyShift action_24
action_142 (5) = happyGoto action_145
action_142 (7) = happyGoto action_3
action_142 (8) = happyGoto action_4
action_142 (9) = happyGoto action_5
action_142 (10) = happyGoto action_6
action_142 (11) = happyGoto action_7
action_142 (12) = happyGoto action_8
action_142 (13) = happyGoto action_9
action_142 (14) = happyGoto action_10
action_142 (15) = happyGoto action_11
action_142 (18) = happyGoto action_12
action_142 (22) = happyGoto action_13
action_142 _ = happyFail

action_143 (48) = happyShift action_144
action_143 _ = happyFail

action_144 (31) = happyShift action_14
action_144 (32) = happyShift action_15
action_144 (33) = happyShift action_16
action_144 (35) = happyShift action_17
action_144 (38) = happyShift action_18
action_144 (39) = happyShift action_19
action_144 (43) = happyShift action_20
action_144 (50) = happyShift action_21
action_144 (57) = happyShift action_22
action_144 (63) = happyShift action_23
action_144 (64) = happyShift action_24
action_144 (5) = happyGoto action_147
action_144 (7) = happyGoto action_3
action_144 (8) = happyGoto action_4
action_144 (9) = happyGoto action_5
action_144 (10) = happyGoto action_6
action_144 (11) = happyGoto action_7
action_144 (12) = happyGoto action_8
action_144 (13) = happyGoto action_9
action_144 (14) = happyGoto action_10
action_144 (15) = happyGoto action_11
action_144 (18) = happyGoto action_12
action_144 (22) = happyGoto action_13
action_144 _ = happyFail

action_145 (31) = happyShift action_14
action_145 (32) = happyShift action_15
action_145 (33) = happyShift action_16
action_145 (35) = happyShift action_17
action_145 (38) = happyShift action_18
action_145 (39) = happyShift action_19
action_145 (43) = happyShift action_20
action_145 (49) = happyShift action_146
action_145 (50) = happyShift action_21
action_145 (57) = happyShift action_22
action_145 (63) = happyShift action_23
action_145 (64) = happyShift action_24
action_145 (7) = happyGoto action_44
action_145 (8) = happyGoto action_4
action_145 (9) = happyGoto action_5
action_145 (10) = happyGoto action_6
action_145 (11) = happyGoto action_7
action_145 (12) = happyGoto action_8
action_145 (13) = happyGoto action_9
action_145 (14) = happyGoto action_10
action_145 (15) = happyGoto action_11
action_145 (18) = happyGoto action_12
action_145 (22) = happyGoto action_13
action_145 _ = happyFail

action_146 _ = happyReduce_52

action_147 (31) = happyShift action_14
action_147 (32) = happyShift action_15
action_147 (33) = happyShift action_16
action_147 (35) = happyShift action_17
action_147 (38) = happyShift action_18
action_147 (39) = happyShift action_19
action_147 (43) = happyShift action_20
action_147 (49) = happyShift action_148
action_147 (50) = happyShift action_21
action_147 (57) = happyShift action_22
action_147 (63) = happyShift action_23
action_147 (64) = happyShift action_24
action_147 (7) = happyGoto action_44
action_147 (8) = happyGoto action_4
action_147 (9) = happyGoto action_5
action_147 (10) = happyGoto action_6
action_147 (11) = happyGoto action_7
action_147 (12) = happyGoto action_8
action_147 (13) = happyGoto action_9
action_147 (14) = happyGoto action_10
action_147 (15) = happyGoto action_11
action_147 (18) = happyGoto action_12
action_147 (22) = happyGoto action_13
action_147 _ = happyFail

action_148 _ = happyReduce_51

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (CompUnit happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  6 happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_0  6 happyReduction_6
happyReduction_6  =  HappyAbsSyn6
		 ([]
	)

happyReduce_7 = happySpecReduce_2  7 happyReduction_7
happyReduction_7 _
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  8 happyReduction_8
happyReduction_8 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn8
		 (happy_var_2
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  8 happyReduction_9
happyReduction_9 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn8
		 (ExpNum happy_var_1
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 _
	 =  HappyAbsSyn8
		 (ExpBool True
	)

happyReduce_11 = happySpecReduce_1  8 happyReduction_11
happyReduction_11 _
	 =  HappyAbsSyn8
		 (ExpBool False
	)

happyReduce_12 = happySpecReduce_1  8 happyReduction_12
happyReduction_12 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn8
		 (ExpRef happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  9 happyReduction_13
happyReduction_13 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  9 happyReduction_14
happyReduction_14 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happyReduce 4 10 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_1  10 happyReduction_16
happyReduction_16 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  11 happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  11 happyReduction_18
happyReduction_18 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  12 happyReduction_19
happyReduction_19 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  12 happyReduction_20
happyReduction_20 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  13 happyReduction_21
happyReduction_21 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  13 happyReduction_22
happyReduction_22 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  14 happyReduction_23
happyReduction_23 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  14 happyReduction_24
happyReduction_24 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_2  15 happyReduction_25
happyReduction_25 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (ExpNot happy_var_2
	)
happyReduction_25 _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  15 happyReduction_26
happyReduction_26 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  15 happyReduction_27
happyReduction_27 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (ExpImport happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  15 happyReduction_28
happyReduction_28 (HappyAbsSyn15  happy_var_3)
	_
	(HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn15
		 (ExpAssign happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  15 happyReduction_29
happyReduction_29 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpTypeDec happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  15 happyReduction_30
happyReduction_30 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpFunDec happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happyReduce 4 15 happyReduction_31
happyReduction_31 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_32 = happyReduce 11 15 happyReduction_32
happyReduction_32 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (ExpIfElse happy_var_3 happy_var_6 happy_var_10
	) `HappyStk` happyRest

happyReduce_33 = happySpecReduce_1  16 happyReduction_33
happyReduction_33 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  16 happyReduction_34
happyReduction_34 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_0  16 happyReduction_35
happyReduction_35  =  HappyAbsSyn16
		 ([]
	)

happyReduce_36 = happySpecReduce_1  17 happyReduction_36
happyReduction_36 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  17 happyReduction_37
happyReduction_37 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_0  17 happyReduction_38
happyReduction_38  =  HappyAbsSyn17
		 ([]
	)

happyReduce_39 = happyReduce 4 18 happyReduction_39
happyReduction_39 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_40 = happyReduce 4 18 happyReduction_40
happyReduction_40 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_1  19 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_2  19 happyReduction_42
happyReduction_42 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_42 _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  20 happyReduction_43
happyReduction_43 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn20
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_2  21 happyReduction_45
happyReduction_45 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_45 _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  21 happyReduction_46
happyReduction_46  =  HappyAbsSyn21
		 ([]
	)

happyReduce_47 = happyReduce 12 22 happyReduction_47
happyReduction_47 ((HappyAbsSyn23  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (FunDecInstFun happy_var_5 happy_var_3 (TyArrow happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_48 = happyReduce 9 22 happyReduction_48
happyReduction_48 ((HappyAbsSyn23  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (FunDecFun happy_var_2 (TyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_49 = happySpecReduce_1  23 happyReduction_49
happyReduction_49 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_2  23 happyReduction_50
happyReduction_50 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_50 _ _  = notHappyAtAll 

happyReduce_51 = happyReduce 9 24 happyReduction_51
happyReduction_51 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_52 = happyReduce 8 24 happyReduction_52
happyReduction_52 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (FunDefFun happy_var_1 happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_53 = happyReduce 4 25 happyReduction_53
happyReduction_53 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_54 = happySpecReduce_1  26 happyReduction_54
happyReduction_54 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  26 happyReduction_55
happyReduction_55 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_0  26 happyReduction_56
happyReduction_56  =  HappyAbsSyn26
		 ([]
	)

happyReduce_57 = happySpecReduce_1  27 happyReduction_57
happyReduction_57 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn27
		 (PatExpVar happy_var_1
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  28 happyReduction_58
happyReduction_58 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1]
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  28 happyReduction_59
happyReduction_59 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_0  28 happyReduction_60
happyReduction_60  =  HappyAbsSyn28
		 ([]
	)

happyReduce_61 = happySpecReduce_1  29 happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn29
		 (TyInt
	)

happyReduce_62 = happySpecReduce_1  29 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn29
		 (TyBool
	)

happyReduce_63 = happySpecReduce_1  29 happyReduction_63
happyReduction_63 _
	 =  HappyAbsSyn29
		 (TyUnit
	)

happyReduce_64 = happyReduce 5 29 happyReduction_64
happyReduction_64 ((HappyAbsSyn29  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_65 = happyReduce 6 29 happyReduction_65
happyReduction_65 ((HappyAbsSyn29  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_66 = happySpecReduce_3  29 happyReduction_66
happyReduction_66 _
	_
	_
	 =  HappyAbsSyn29
		 (TyModule
	)

happyReduce_67 = happySpecReduce_3  29 happyReduction_67
happyReduction_67 _
	_
	_
	 =  HappyAbsSyn29
		 (TyInterface
	)

happyReduce_68 = happySpecReduce_1  29 happyReduction_68
happyReduction_68 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (TyRef happy_var_1
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  30 happyReduction_69
happyReduction_69 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn30
		 (Id happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  30 happyReduction_70
happyReduction_70 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (Path happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 65 65 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 31;
	Token _ TokenImport -> cont 32;
	Token _ TokenType -> cont 33;
	Token _ TokenInterface -> cont 34;
	Token _ TokenFun -> cont 35;
	Token _ TokenImp -> cont 36;
	Token _ TokenTest -> cont 37;
	Token _ TokenTrue -> cont 38;
	Token _ TokenFalse -> cont 39;
	Token _ TokenInt -> cont 40;
	Token _ TokenBool -> cont 41;
	Token _ TokenUnit -> cont 42;
	Token _ TokenIf -> cont 43;
	Token _ TokenElse -> cont 44;
	Token _ TokenAssign -> cont 45;
	Token _ TokenLBracket -> cont 46;
	Token _ TokenRBracket -> cont 47;
	Token _ TokenLBrace -> cont 48;
	Token _ TokenRBrace -> cont 49;
	Token _ TokenLParen -> cont 50;
	Token _ TokenRParen -> cont 51;
	Token _ TokenPipe -> cont 52;
	Token _ TokenPlus -> cont 53;
	Token _ TokenMinus -> cont 54;
	Token _ TokenStar -> cont 55;
	Token _ TokenFSlash -> cont 56;
	Token _ TokenExclamation -> cont 57;
	Token _ TokenSemi -> cont 58;
	Token _ TokenDot -> cont 59;
	Token _ TokenEq -> cont 60;
	Token _ TokenColon -> cont 61;
	Token _ TokenComma -> cont 62;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 63;
	Token _ (TokenId happy_dollar_dollar) -> cont 64;
	_ -> happyError' tk
	})

happyError_ 65 tk = happyError' tk
happyError_ _ tk = happyError' tk

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (>>=)
happyReturn :: () => a -> Alex a
happyReturn = (return)
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => (Token) -> Alex a
happyError' tk = happyError tk

parse = happySomeParser where
  happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

happyError :: Token -> Alex a
happyError (Token p t) =
  alexError' p ("parse error at token '" ++ unlex t ++ "'")

parseExp :: FilePath -> String -> Either String (CompUnit RawId)
parseExp = runAlex' parse
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

























infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action



-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

