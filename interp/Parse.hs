{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37
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
	| HappyAbsSyn31 t31
	| HappyAbsSyn32 t32
	| HappyAbsSyn33 t33
	| HappyAbsSyn34 t34
	| HappyAbsSyn35 t35
	| HappyAbsSyn36 t36
	| HappyAbsSyn37 t37

action_0 (38) = happyShift action_14
action_0 (39) = happyShift action_15
action_0 (40) = happyShift action_16
action_0 (42) = happyShift action_17
action_0 (46) = happyShift action_18
action_0 (47) = happyShift action_19
action_0 (51) = happyShift action_20
action_0 (58) = happyShift action_21
action_0 (65) = happyShift action_22
action_0 (71) = happyShift action_23
action_0 (72) = happyShift action_24
action_0 (4) = happyGoto action_25
action_0 (5) = happyGoto action_2
action_0 (7) = happyGoto action_3
action_0 (9) = happyGoto action_4
action_0 (10) = happyGoto action_5
action_0 (11) = happyGoto action_6
action_0 (12) = happyGoto action_7
action_0 (13) = happyGoto action_8
action_0 (14) = happyGoto action_9
action_0 (15) = happyGoto action_10
action_0 (16) = happyGoto action_11
action_0 (19) = happyGoto action_12
action_0 (23) = happyGoto action_13
action_0 _ = happyFail

action_1 (38) = happyShift action_14
action_1 (39) = happyShift action_15
action_1 (40) = happyShift action_16
action_1 (42) = happyShift action_17
action_1 (46) = happyShift action_18
action_1 (47) = happyShift action_19
action_1 (51) = happyShift action_20
action_1 (58) = happyShift action_21
action_1 (65) = happyShift action_22
action_1 (71) = happyShift action_23
action_1 (72) = happyShift action_24
action_1 (5) = happyGoto action_2
action_1 (7) = happyGoto action_3
action_1 (9) = happyGoto action_4
action_1 (10) = happyGoto action_5
action_1 (11) = happyGoto action_6
action_1 (12) = happyGoto action_7
action_1 (13) = happyGoto action_8
action_1 (14) = happyGoto action_9
action_1 (15) = happyGoto action_10
action_1 (16) = happyGoto action_11
action_1 (19) = happyGoto action_12
action_1 (23) = happyGoto action_13
action_1 _ = happyFail

action_2 (38) = happyShift action_14
action_2 (39) = happyShift action_15
action_2 (40) = happyShift action_16
action_2 (42) = happyShift action_17
action_2 (46) = happyShift action_18
action_2 (47) = happyShift action_19
action_2 (51) = happyShift action_20
action_2 (58) = happyShift action_21
action_2 (65) = happyShift action_22
action_2 (71) = happyShift action_23
action_2 (72) = happyShift action_24
action_2 (7) = happyGoto action_47
action_2 (9) = happyGoto action_4
action_2 (10) = happyGoto action_5
action_2 (11) = happyGoto action_6
action_2 (12) = happyGoto action_7
action_2 (13) = happyGoto action_8
action_2 (14) = happyGoto action_9
action_2 (15) = happyGoto action_10
action_2 (16) = happyGoto action_11
action_2 (19) = happyGoto action_12
action_2 (23) = happyGoto action_13
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 _ = happyReduce_19

action_5 (56) = happyShift action_46
action_5 _ = happyReduce_21

action_6 (58) = happyShift action_44
action_6 (67) = happyShift action_45
action_6 _ = happyReduce_23

action_7 (63) = happyShift action_43
action_7 _ = happyReduce_25

action_8 (64) = happyShift action_42
action_8 _ = happyReduce_27

action_9 (61) = happyShift action_41
action_9 _ = happyReduce_29

action_10 (62) = happyShift action_40
action_10 _ = happyReduce_31

action_11 (66) = happyShift action_39
action_11 _ = happyFail

action_12 _ = happyReduce_35

action_13 _ = happyReduce_36

action_14 (56) = happyShift action_38
action_14 _ = happyFail

action_15 (72) = happyShift action_37
action_15 (37) = happyGoto action_36
action_15 _ = happyFail

action_16 (72) = happyShift action_35
action_16 _ = happyFail

action_17 (58) = happyShift action_33
action_17 (72) = happyShift action_34
action_17 _ = happyFail

action_18 _ = happyReduce_15

action_19 _ = happyReduce_16

action_20 (58) = happyShift action_32
action_20 _ = happyFail

action_21 (38) = happyShift action_14
action_21 (39) = happyShift action_15
action_21 (40) = happyShift action_16
action_21 (42) = happyShift action_17
action_21 (46) = happyShift action_18
action_21 (47) = happyShift action_19
action_21 (51) = happyShift action_20
action_21 (58) = happyShift action_21
action_21 (59) = happyShift action_31
action_21 (65) = happyShift action_22
action_21 (71) = happyShift action_23
action_21 (72) = happyShift action_24
action_21 (9) = happyGoto action_4
action_21 (10) = happyGoto action_5
action_21 (11) = happyGoto action_6
action_21 (12) = happyGoto action_7
action_21 (13) = happyGoto action_8
action_21 (14) = happyGoto action_9
action_21 (15) = happyGoto action_10
action_21 (16) = happyGoto action_30
action_21 (19) = happyGoto action_12
action_21 (23) = happyGoto action_13
action_21 _ = happyFail

action_22 (38) = happyShift action_14
action_22 (46) = happyShift action_18
action_22 (47) = happyShift action_19
action_22 (58) = happyShift action_21
action_22 (71) = happyShift action_23
action_22 (72) = happyShift action_29
action_22 (9) = happyGoto action_4
action_22 (10) = happyGoto action_27
action_22 (11) = happyGoto action_6
action_22 (12) = happyGoto action_7
action_22 (13) = happyGoto action_8
action_22 (14) = happyGoto action_9
action_22 (15) = happyGoto action_28
action_22 _ = happyFail

action_23 _ = happyReduce_14

action_24 (53) = happyShift action_26
action_24 _ = happyReduce_17

action_25 (73) = happyAccept
action_25 _ = happyFail

action_26 (38) = happyShift action_14
action_26 (39) = happyShift action_15
action_26 (40) = happyShift action_16
action_26 (42) = happyShift action_17
action_26 (46) = happyShift action_18
action_26 (47) = happyShift action_19
action_26 (51) = happyShift action_20
action_26 (58) = happyShift action_21
action_26 (65) = happyShift action_22
action_26 (71) = happyShift action_23
action_26 (72) = happyShift action_24
action_26 (9) = happyGoto action_4
action_26 (10) = happyGoto action_5
action_26 (11) = happyGoto action_6
action_26 (12) = happyGoto action_7
action_26 (13) = happyGoto action_8
action_26 (14) = happyGoto action_9
action_26 (15) = happyGoto action_10
action_26 (16) = happyGoto action_79
action_26 (19) = happyGoto action_12
action_26 (23) = happyGoto action_13
action_26 _ = happyFail

action_27 _ = happyReduce_21

action_28 (62) = happyShift action_40
action_28 _ = happyReduce_30

action_29 _ = happyReduce_17

action_30 (59) = happyShift action_77
action_30 (70) = happyShift action_78
action_30 (8) = happyGoto action_76
action_30 _ = happyFail

action_31 _ = happyReduce_12

action_32 (38) = happyShift action_14
action_32 (39) = happyShift action_15
action_32 (40) = happyShift action_16
action_32 (42) = happyShift action_17
action_32 (46) = happyShift action_18
action_32 (47) = happyShift action_19
action_32 (51) = happyShift action_20
action_32 (58) = happyShift action_21
action_32 (65) = happyShift action_22
action_32 (71) = happyShift action_23
action_32 (72) = happyShift action_24
action_32 (9) = happyGoto action_4
action_32 (10) = happyGoto action_5
action_32 (11) = happyGoto action_6
action_32 (12) = happyGoto action_7
action_32 (13) = happyGoto action_8
action_32 (14) = happyGoto action_9
action_32 (15) = happyGoto action_10
action_32 (16) = happyGoto action_75
action_32 (19) = happyGoto action_12
action_32 (23) = happyGoto action_13
action_32 _ = happyFail

action_33 (38) = happyShift action_67
action_33 (41) = happyShift action_68
action_33 (42) = happyShift action_69
action_33 (45) = happyShift action_70
action_33 (48) = happyShift action_71
action_33 (49) = happyShift action_72
action_33 (50) = happyShift action_73
action_33 (58) = happyShift action_74
action_33 (72) = happyShift action_37
action_33 (31) = happyGoto action_64
action_33 (32) = happyGoto action_65
action_33 (37) = happyGoto action_66
action_33 _ = happyFail

action_34 (58) = happyShift action_63
action_34 _ = happyFail

action_35 (68) = happyShift action_62
action_35 _ = happyFail

action_36 (67) = happyShift action_61
action_36 _ = happyReduce_32

action_37 _ = happyReduce_87

action_38 (38) = happyShift action_14
action_38 (39) = happyShift action_15
action_38 (40) = happyShift action_16
action_38 (42) = happyShift action_17
action_38 (46) = happyShift action_18
action_38 (47) = happyShift action_19
action_38 (51) = happyShift action_20
action_38 (58) = happyShift action_21
action_38 (65) = happyShift action_22
action_38 (71) = happyShift action_23
action_38 (72) = happyShift action_24
action_38 (5) = happyGoto action_58
action_38 (6) = happyGoto action_59
action_38 (7) = happyGoto action_60
action_38 (9) = happyGoto action_4
action_38 (10) = happyGoto action_5
action_38 (11) = happyGoto action_6
action_38 (12) = happyGoto action_7
action_38 (13) = happyGoto action_8
action_38 (14) = happyGoto action_9
action_38 (15) = happyGoto action_10
action_38 (16) = happyGoto action_11
action_38 (19) = happyGoto action_12
action_38 (23) = happyGoto action_13
action_38 _ = happyReduce_6

action_39 _ = happyReduce_7

action_40 (38) = happyShift action_14
action_40 (46) = happyShift action_18
action_40 (47) = happyShift action_19
action_40 (58) = happyShift action_21
action_40 (71) = happyShift action_23
action_40 (72) = happyShift action_29
action_40 (9) = happyGoto action_4
action_40 (10) = happyGoto action_27
action_40 (11) = happyGoto action_6
action_40 (12) = happyGoto action_7
action_40 (13) = happyGoto action_8
action_40 (14) = happyGoto action_57
action_40 _ = happyFail

action_41 (38) = happyShift action_14
action_41 (46) = happyShift action_18
action_41 (47) = happyShift action_19
action_41 (58) = happyShift action_21
action_41 (71) = happyShift action_23
action_41 (72) = happyShift action_29
action_41 (9) = happyGoto action_4
action_41 (10) = happyGoto action_27
action_41 (11) = happyGoto action_6
action_41 (12) = happyGoto action_7
action_41 (13) = happyGoto action_56
action_41 _ = happyFail

action_42 (38) = happyShift action_14
action_42 (46) = happyShift action_18
action_42 (47) = happyShift action_19
action_42 (58) = happyShift action_21
action_42 (71) = happyShift action_23
action_42 (72) = happyShift action_29
action_42 (9) = happyGoto action_4
action_42 (10) = happyGoto action_27
action_42 (11) = happyGoto action_6
action_42 (12) = happyGoto action_55
action_42 _ = happyFail

action_43 (38) = happyShift action_14
action_43 (46) = happyShift action_18
action_43 (47) = happyShift action_19
action_43 (58) = happyShift action_21
action_43 (71) = happyShift action_23
action_43 (72) = happyShift action_29
action_43 (9) = happyGoto action_4
action_43 (10) = happyGoto action_27
action_43 (11) = happyGoto action_54
action_43 _ = happyFail

action_44 (38) = happyShift action_14
action_44 (39) = happyShift action_15
action_44 (40) = happyShift action_16
action_44 (42) = happyShift action_17
action_44 (46) = happyShift action_18
action_44 (47) = happyShift action_19
action_44 (51) = happyShift action_20
action_44 (58) = happyShift action_21
action_44 (65) = happyShift action_22
action_44 (71) = happyShift action_23
action_44 (72) = happyShift action_24
action_44 (9) = happyGoto action_4
action_44 (10) = happyGoto action_5
action_44 (11) = happyGoto action_6
action_44 (12) = happyGoto action_7
action_44 (13) = happyGoto action_8
action_44 (14) = happyGoto action_9
action_44 (15) = happyGoto action_10
action_44 (16) = happyGoto action_52
action_44 (17) = happyGoto action_53
action_44 (19) = happyGoto action_12
action_44 (23) = happyGoto action_13
action_44 _ = happyReduce_40

action_45 (72) = happyShift action_51
action_45 _ = happyFail

action_46 (72) = happyShift action_50
action_46 (35) = happyGoto action_48
action_46 (36) = happyGoto action_49
action_46 _ = happyReduce_86

action_47 _ = happyReduce_3

action_48 _ = happyReduce_84

action_49 (57) = happyShift action_103
action_49 (72) = happyShift action_50
action_49 (35) = happyGoto action_102
action_49 _ = happyFail

action_50 (68) = happyShift action_101
action_50 _ = happyFail

action_51 _ = happyReduce_18

action_52 _ = happyReduce_38

action_53 (59) = happyShift action_99
action_53 (70) = happyShift action_100
action_53 _ = happyFail

action_54 (58) = happyShift action_44
action_54 (67) = happyShift action_45
action_54 _ = happyReduce_22

action_55 (63) = happyShift action_43
action_55 _ = happyReduce_24

action_56 (64) = happyShift action_42
action_56 _ = happyReduce_26

action_57 (61) = happyShift action_41
action_57 _ = happyReduce_28

action_58 (38) = happyShift action_14
action_58 (39) = happyShift action_15
action_58 (40) = happyShift action_16
action_58 (42) = happyShift action_17
action_58 (46) = happyShift action_18
action_58 (47) = happyShift action_19
action_58 (51) = happyShift action_20
action_58 (58) = happyShift action_21
action_58 (65) = happyShift action_22
action_58 (71) = happyShift action_23
action_58 (72) = happyShift action_24
action_58 (7) = happyGoto action_98
action_58 (9) = happyGoto action_4
action_58 (10) = happyGoto action_5
action_58 (11) = happyGoto action_6
action_58 (12) = happyGoto action_7
action_58 (13) = happyGoto action_8
action_58 (14) = happyGoto action_9
action_58 (15) = happyGoto action_10
action_58 (16) = happyGoto action_11
action_58 (19) = happyGoto action_12
action_58 (23) = happyGoto action_13
action_58 _ = happyFail

action_59 (57) = happyShift action_97
action_59 _ = happyFail

action_60 (57) = happyReduce_4
action_60 _ = happyReduce_2

action_61 (72) = happyShift action_96
action_61 _ = happyFail

action_62 (38) = happyShift action_67
action_62 (41) = happyShift action_68
action_62 (42) = happyShift action_69
action_62 (45) = happyShift action_70
action_62 (48) = happyShift action_71
action_62 (49) = happyShift action_72
action_62 (50) = happyShift action_73
action_62 (58) = happyShift action_74
action_62 (60) = happyShift action_95
action_62 (72) = happyShift action_37
action_62 (20) = happyGoto action_92
action_62 (21) = happyGoto action_93
action_62 (31) = happyGoto action_64
action_62 (32) = happyGoto action_94
action_62 (37) = happyGoto action_66
action_62 _ = happyFail

action_63 (38) = happyShift action_67
action_63 (41) = happyShift action_68
action_63 (42) = happyShift action_69
action_63 (45) = happyShift action_70
action_63 (48) = happyShift action_71
action_63 (49) = happyShift action_72
action_63 (50) = happyShift action_73
action_63 (58) = happyShift action_74
action_63 (72) = happyShift action_37
action_63 (29) = happyGoto action_90
action_63 (31) = happyGoto action_64
action_63 (32) = happyGoto action_91
action_63 (37) = happyGoto action_66
action_63 _ = happyReduce_65

action_64 _ = happyReduce_77

action_65 (59) = happyShift action_89
action_65 _ = happyFail

action_66 (67) = happyShift action_61
action_66 _ = happyReduce_78

action_67 (56) = happyShift action_88
action_67 _ = happyFail

action_68 (56) = happyShift action_87
action_68 _ = happyFail

action_69 (58) = happyShift action_86
action_69 _ = happyFail

action_70 (56) = happyShift action_85
action_70 _ = happyFail

action_71 _ = happyReduce_69

action_72 _ = happyReduce_70

action_73 _ = happyReduce_71

action_74 (38) = happyShift action_67
action_74 (41) = happyShift action_68
action_74 (42) = happyShift action_69
action_74 (45) = happyShift action_70
action_74 (48) = happyShift action_71
action_74 (49) = happyShift action_72
action_74 (50) = happyShift action_73
action_74 (58) = happyShift action_74
action_74 (72) = happyShift action_37
action_74 (31) = happyGoto action_64
action_74 (32) = happyGoto action_84
action_74 (37) = happyGoto action_66
action_74 _ = happyFail

action_75 (59) = happyShift action_83
action_75 _ = happyFail

action_76 (59) = happyShift action_81
action_76 (70) = happyShift action_82
action_76 _ = happyFail

action_77 _ = happyReduce_10

action_78 (38) = happyShift action_14
action_78 (39) = happyShift action_15
action_78 (40) = happyShift action_16
action_78 (42) = happyShift action_17
action_78 (46) = happyShift action_18
action_78 (47) = happyShift action_19
action_78 (51) = happyShift action_20
action_78 (58) = happyShift action_21
action_78 (65) = happyShift action_22
action_78 (71) = happyShift action_23
action_78 (72) = happyShift action_24
action_78 (9) = happyGoto action_4
action_78 (10) = happyGoto action_5
action_78 (11) = happyGoto action_6
action_78 (12) = happyGoto action_7
action_78 (13) = happyGoto action_8
action_78 (14) = happyGoto action_9
action_78 (15) = happyGoto action_10
action_78 (16) = happyGoto action_80
action_78 (19) = happyGoto action_12
action_78 (23) = happyGoto action_13
action_78 _ = happyFail

action_79 _ = happyReduce_33

action_80 _ = happyReduce_8

action_81 _ = happyReduce_13

action_82 (38) = happyShift action_14
action_82 (39) = happyShift action_15
action_82 (40) = happyShift action_16
action_82 (42) = happyShift action_17
action_82 (46) = happyShift action_18
action_82 (47) = happyShift action_19
action_82 (51) = happyShift action_20
action_82 (58) = happyShift action_21
action_82 (65) = happyShift action_22
action_82 (71) = happyShift action_23
action_82 (72) = happyShift action_24
action_82 (9) = happyGoto action_4
action_82 (10) = happyGoto action_5
action_82 (11) = happyGoto action_6
action_82 (12) = happyGoto action_7
action_82 (13) = happyGoto action_8
action_82 (14) = happyGoto action_9
action_82 (15) = happyGoto action_10
action_82 (16) = happyGoto action_121
action_82 (19) = happyGoto action_12
action_82 (23) = happyGoto action_13
action_82 _ = happyFail

action_83 (56) = happyShift action_120
action_83 _ = happyFail

action_84 (70) = happyShift action_119
action_84 (30) = happyGoto action_118
action_84 _ = happyFail

action_85 (38) = happyShift action_67
action_85 (41) = happyShift action_68
action_85 (42) = happyShift action_69
action_85 (45) = happyShift action_70
action_85 (48) = happyShift action_71
action_85 (49) = happyShift action_72
action_85 (50) = happyShift action_73
action_85 (58) = happyShift action_74
action_85 (72) = happyShift action_37
action_85 (31) = happyGoto action_64
action_85 (32) = happyGoto action_115
action_85 (33) = happyGoto action_116
action_85 (34) = happyGoto action_117
action_85 (37) = happyGoto action_66
action_85 _ = happyReduce_82

action_86 (38) = happyShift action_67
action_86 (41) = happyShift action_68
action_86 (42) = happyShift action_69
action_86 (45) = happyShift action_70
action_86 (48) = happyShift action_71
action_86 (49) = happyShift action_72
action_86 (50) = happyShift action_73
action_86 (58) = happyShift action_74
action_86 (59) = happyShift action_114
action_86 (72) = happyShift action_37
action_86 (29) = happyGoto action_113
action_86 (31) = happyGoto action_64
action_86 (32) = happyGoto action_91
action_86 (37) = happyGoto action_66
action_86 _ = happyReduce_65

action_87 (57) = happyShift action_112
action_87 _ = happyFail

action_88 (57) = happyShift action_111
action_88 _ = happyFail

action_89 (72) = happyShift action_110
action_89 _ = happyFail

action_90 (59) = happyShift action_108
action_90 (70) = happyShift action_109
action_90 _ = happyFail

action_91 _ = happyReduce_63

action_92 (60) = happyShift action_95
action_92 (21) = happyGoto action_107
action_92 _ = happyReduce_45

action_93 _ = happyReduce_46

action_94 _ = happyReduce_44

action_95 (72) = happyShift action_106
action_95 _ = happyFail

action_96 _ = happyReduce_88

action_97 _ = happyReduce_11

action_98 (57) = happyReduce_5
action_98 _ = happyReduce_3

action_99 _ = happyReduce_20

action_100 (38) = happyShift action_14
action_100 (39) = happyShift action_15
action_100 (40) = happyShift action_16
action_100 (42) = happyShift action_17
action_100 (46) = happyShift action_18
action_100 (47) = happyShift action_19
action_100 (51) = happyShift action_20
action_100 (58) = happyShift action_21
action_100 (65) = happyShift action_22
action_100 (71) = happyShift action_23
action_100 (72) = happyShift action_24
action_100 (9) = happyGoto action_4
action_100 (10) = happyGoto action_5
action_100 (11) = happyGoto action_6
action_100 (12) = happyGoto action_7
action_100 (13) = happyGoto action_8
action_100 (14) = happyGoto action_9
action_100 (15) = happyGoto action_10
action_100 (16) = happyGoto action_105
action_100 (19) = happyGoto action_12
action_100 (23) = happyGoto action_13
action_100 _ = happyFail

action_101 (38) = happyShift action_14
action_101 (39) = happyShift action_15
action_101 (40) = happyShift action_16
action_101 (42) = happyShift action_17
action_101 (46) = happyShift action_18
action_101 (47) = happyShift action_19
action_101 (51) = happyShift action_20
action_101 (58) = happyShift action_21
action_101 (65) = happyShift action_22
action_101 (71) = happyShift action_23
action_101 (72) = happyShift action_24
action_101 (9) = happyGoto action_4
action_101 (10) = happyGoto action_5
action_101 (11) = happyGoto action_6
action_101 (12) = happyGoto action_7
action_101 (13) = happyGoto action_8
action_101 (14) = happyGoto action_9
action_101 (15) = happyGoto action_10
action_101 (16) = happyGoto action_104
action_101 (19) = happyGoto action_12
action_101 (23) = happyGoto action_13
action_101 _ = happyFail

action_102 _ = happyReduce_85

action_103 _ = happyReduce_34

action_104 (66) = happyShift action_136
action_104 _ = happyFail

action_105 _ = happyReduce_39

action_106 (38) = happyShift action_67
action_106 (41) = happyShift action_68
action_106 (42) = happyShift action_69
action_106 (45) = happyShift action_70
action_106 (48) = happyShift action_71
action_106 (49) = happyShift action_72
action_106 (50) = happyShift action_73
action_106 (58) = happyShift action_74
action_106 (72) = happyShift action_37
action_106 (22) = happyGoto action_134
action_106 (31) = happyGoto action_64
action_106 (32) = happyGoto action_135
action_106 (37) = happyGoto action_66
action_106 _ = happyReduce_51

action_107 _ = happyReduce_47

action_108 (69) = happyShift action_133
action_108 _ = happyFail

action_109 (38) = happyShift action_67
action_109 (41) = happyShift action_68
action_109 (42) = happyShift action_69
action_109 (45) = happyShift action_70
action_109 (48) = happyShift action_71
action_109 (49) = happyShift action_72
action_109 (50) = happyShift action_73
action_109 (58) = happyShift action_74
action_109 (72) = happyShift action_37
action_109 (31) = happyGoto action_64
action_109 (32) = happyGoto action_132
action_109 (37) = happyGoto action_66
action_109 _ = happyFail

action_110 (58) = happyShift action_131
action_110 _ = happyFail

action_111 _ = happyReduce_74

action_112 _ = happyReduce_75

action_113 (59) = happyShift action_130
action_113 (70) = happyShift action_109
action_113 _ = happyFail

action_114 (69) = happyShift action_129
action_114 _ = happyFail

action_115 (72) = happyShift action_128
action_115 _ = happyFail

action_116 _ = happyReduce_80

action_117 (38) = happyShift action_67
action_117 (41) = happyShift action_68
action_117 (42) = happyShift action_69
action_117 (45) = happyShift action_70
action_117 (48) = happyShift action_71
action_117 (49) = happyShift action_72
action_117 (50) = happyShift action_73
action_117 (57) = happyShift action_127
action_117 (58) = happyShift action_74
action_117 (72) = happyShift action_37
action_117 (31) = happyGoto action_64
action_117 (32) = happyGoto action_115
action_117 (33) = happyGoto action_126
action_117 (37) = happyGoto action_66
action_117 _ = happyFail

action_118 (59) = happyShift action_124
action_118 (70) = happyShift action_125
action_118 _ = happyFail

action_119 (38) = happyShift action_67
action_119 (41) = happyShift action_68
action_119 (42) = happyShift action_69
action_119 (45) = happyShift action_70
action_119 (48) = happyShift action_71
action_119 (49) = happyShift action_72
action_119 (50) = happyShift action_73
action_119 (58) = happyShift action_74
action_119 (72) = happyShift action_37
action_119 (31) = happyGoto action_64
action_119 (32) = happyGoto action_123
action_119 (37) = happyGoto action_66
action_119 _ = happyFail

action_120 (38) = happyShift action_14
action_120 (39) = happyShift action_15
action_120 (40) = happyShift action_16
action_120 (42) = happyShift action_17
action_120 (46) = happyShift action_18
action_120 (47) = happyShift action_19
action_120 (51) = happyShift action_20
action_120 (58) = happyShift action_21
action_120 (65) = happyShift action_22
action_120 (71) = happyShift action_23
action_120 (72) = happyShift action_24
action_120 (5) = happyGoto action_58
action_120 (6) = happyGoto action_122
action_120 (7) = happyGoto action_60
action_120 (9) = happyGoto action_4
action_120 (10) = happyGoto action_5
action_120 (11) = happyGoto action_6
action_120 (12) = happyGoto action_7
action_120 (13) = happyGoto action_8
action_120 (14) = happyGoto action_9
action_120 (15) = happyGoto action_10
action_120 (16) = happyGoto action_11
action_120 (19) = happyGoto action_12
action_120 (23) = happyGoto action_13
action_120 _ = happyReduce_6

action_121 _ = happyReduce_9

action_122 (57) = happyShift action_144
action_122 _ = happyFail

action_123 _ = happyReduce_66

action_124 _ = happyReduce_68

action_125 (38) = happyShift action_67
action_125 (41) = happyShift action_68
action_125 (42) = happyShift action_69
action_125 (45) = happyShift action_70
action_125 (48) = happyShift action_71
action_125 (49) = happyShift action_72
action_125 (50) = happyShift action_73
action_125 (58) = happyShift action_74
action_125 (72) = happyShift action_37
action_125 (31) = happyGoto action_64
action_125 (32) = happyGoto action_143
action_125 (37) = happyGoto action_66
action_125 _ = happyFail

action_126 _ = happyReduce_81

action_127 _ = happyReduce_76

action_128 (66) = happyShift action_142
action_128 _ = happyFail

action_129 (38) = happyShift action_67
action_129 (41) = happyShift action_68
action_129 (42) = happyShift action_69
action_129 (45) = happyShift action_70
action_129 (48) = happyShift action_71
action_129 (49) = happyShift action_72
action_129 (50) = happyShift action_73
action_129 (58) = happyShift action_74
action_129 (72) = happyShift action_37
action_129 (31) = happyGoto action_64
action_129 (32) = happyGoto action_141
action_129 (37) = happyGoto action_66
action_129 _ = happyFail

action_130 (69) = happyShift action_140
action_130 _ = happyFail

action_131 (38) = happyShift action_67
action_131 (41) = happyShift action_68
action_131 (42) = happyShift action_69
action_131 (45) = happyShift action_70
action_131 (48) = happyShift action_71
action_131 (49) = happyShift action_72
action_131 (50) = happyShift action_73
action_131 (58) = happyShift action_74
action_131 (72) = happyShift action_37
action_131 (29) = happyGoto action_139
action_131 (31) = happyGoto action_64
action_131 (32) = happyGoto action_91
action_131 (37) = happyGoto action_66
action_131 _ = happyReduce_65

action_132 _ = happyReduce_64

action_133 (38) = happyShift action_67
action_133 (41) = happyShift action_68
action_133 (42) = happyShift action_69
action_133 (45) = happyShift action_70
action_133 (48) = happyShift action_71
action_133 (49) = happyShift action_72
action_133 (50) = happyShift action_73
action_133 (58) = happyShift action_74
action_133 (72) = happyShift action_37
action_133 (31) = happyGoto action_64
action_133 (32) = happyGoto action_138
action_133 (37) = happyGoto action_66
action_133 _ = happyFail

action_134 (38) = happyShift action_67
action_134 (41) = happyShift action_68
action_134 (42) = happyShift action_69
action_134 (45) = happyShift action_70
action_134 (48) = happyShift action_71
action_134 (49) = happyShift action_72
action_134 (50) = happyShift action_73
action_134 (58) = happyShift action_74
action_134 (72) = happyShift action_37
action_134 (31) = happyGoto action_64
action_134 (32) = happyGoto action_137
action_134 (37) = happyGoto action_66
action_134 _ = happyReduce_48

action_135 _ = happyReduce_49

action_136 _ = happyReduce_83

action_137 _ = happyReduce_50

action_138 (66) = happyShift action_148
action_138 _ = happyFail

action_139 (59) = happyShift action_147
action_139 (70) = happyShift action_109
action_139 _ = happyFail

action_140 (38) = happyShift action_67
action_140 (41) = happyShift action_68
action_140 (42) = happyShift action_69
action_140 (45) = happyShift action_70
action_140 (48) = happyShift action_71
action_140 (49) = happyShift action_72
action_140 (50) = happyShift action_73
action_140 (58) = happyShift action_74
action_140 (72) = happyShift action_37
action_140 (31) = happyGoto action_64
action_140 (32) = happyGoto action_146
action_140 (37) = happyGoto action_66
action_140 _ = happyFail

action_141 _ = happyReduce_72

action_142 _ = happyReduce_79

action_143 _ = happyReduce_67

action_144 (52) = happyShift action_145
action_144 _ = happyFail

action_145 (56) = happyShift action_155
action_145 _ = happyFail

action_146 _ = happyReduce_73

action_147 (69) = happyShift action_154
action_147 _ = happyFail

action_148 (58) = happyShift action_152
action_148 (72) = happyShift action_153
action_148 (24) = happyGoto action_149
action_148 (25) = happyGoto action_150
action_148 (26) = happyGoto action_151
action_148 _ = happyFail

action_149 (58) = happyShift action_152
action_149 (72) = happyShift action_153
action_149 (25) = happyGoto action_162
action_149 (26) = happyGoto action_151
action_149 _ = happyReduce_53

action_150 _ = happyReduce_54

action_151 (72) = happyShift action_161
action_151 _ = happyFail

action_152 (72) = happyShift action_160
action_152 (28) = happyGoto action_159
action_152 _ = happyFail

action_153 (58) = happyShift action_158
action_153 _ = happyFail

action_154 (38) = happyShift action_67
action_154 (41) = happyShift action_68
action_154 (42) = happyShift action_69
action_154 (45) = happyShift action_70
action_154 (48) = happyShift action_71
action_154 (49) = happyShift action_72
action_154 (50) = happyShift action_73
action_154 (58) = happyShift action_74
action_154 (72) = happyShift action_37
action_154 (31) = happyGoto action_64
action_154 (32) = happyGoto action_157
action_154 (37) = happyGoto action_66
action_154 _ = happyFail

action_155 (38) = happyShift action_14
action_155 (39) = happyShift action_15
action_155 (40) = happyShift action_16
action_155 (42) = happyShift action_17
action_155 (46) = happyShift action_18
action_155 (47) = happyShift action_19
action_155 (51) = happyShift action_20
action_155 (58) = happyShift action_21
action_155 (65) = happyShift action_22
action_155 (71) = happyShift action_23
action_155 (72) = happyShift action_24
action_155 (5) = happyGoto action_58
action_155 (6) = happyGoto action_156
action_155 (7) = happyGoto action_60
action_155 (9) = happyGoto action_4
action_155 (10) = happyGoto action_5
action_155 (11) = happyGoto action_6
action_155 (12) = happyGoto action_7
action_155 (13) = happyGoto action_8
action_155 (14) = happyGoto action_9
action_155 (15) = happyGoto action_10
action_155 (16) = happyGoto action_11
action_155 (19) = happyGoto action_12
action_155 (23) = happyGoto action_13
action_155 _ = happyReduce_6

action_156 (57) = happyShift action_168
action_156 _ = happyFail

action_157 (66) = happyShift action_167
action_157 _ = happyFail

action_158 (72) = happyShift action_160
action_158 (27) = happyGoto action_165
action_158 (28) = happyGoto action_166
action_158 _ = happyReduce_61

action_159 (59) = happyShift action_164
action_159 _ = happyFail

action_160 _ = happyReduce_62

action_161 (58) = happyShift action_163
action_161 _ = happyFail

action_162 _ = happyReduce_55

action_163 (72) = happyShift action_160
action_163 (27) = happyGoto action_173
action_163 (28) = happyGoto action_166
action_163 _ = happyReduce_61

action_164 (67) = happyShift action_172
action_164 _ = happyFail

action_165 (59) = happyShift action_170
action_165 (70) = happyShift action_171
action_165 _ = happyFail

action_166 _ = happyReduce_59

action_167 (58) = happyShift action_152
action_167 (72) = happyShift action_153
action_167 (24) = happyGoto action_169
action_167 (25) = happyGoto action_150
action_167 (26) = happyGoto action_151
action_167 _ = happyFail

action_168 _ = happyReduce_37

action_169 (58) = happyShift action_152
action_169 (72) = happyShift action_153
action_169 (25) = happyGoto action_162
action_169 (26) = happyGoto action_151
action_169 _ = happyReduce_52

action_170 (53) = happyShift action_176
action_170 _ = happyFail

action_171 (72) = happyShift action_160
action_171 (28) = happyGoto action_175
action_171 _ = happyFail

action_172 _ = happyReduce_58

action_173 (59) = happyShift action_174
action_173 (70) = happyShift action_171
action_173 _ = happyFail

action_174 (53) = happyShift action_178
action_174 _ = happyFail

action_175 _ = happyReduce_60

action_176 (56) = happyShift action_177
action_176 _ = happyFail

action_177 (38) = happyShift action_14
action_177 (39) = happyShift action_15
action_177 (40) = happyShift action_16
action_177 (42) = happyShift action_17
action_177 (46) = happyShift action_18
action_177 (47) = happyShift action_19
action_177 (51) = happyShift action_20
action_177 (58) = happyShift action_21
action_177 (65) = happyShift action_22
action_177 (71) = happyShift action_23
action_177 (72) = happyShift action_24
action_177 (5) = happyGoto action_180
action_177 (7) = happyGoto action_3
action_177 (9) = happyGoto action_4
action_177 (10) = happyGoto action_5
action_177 (11) = happyGoto action_6
action_177 (12) = happyGoto action_7
action_177 (13) = happyGoto action_8
action_177 (14) = happyGoto action_9
action_177 (15) = happyGoto action_10
action_177 (16) = happyGoto action_11
action_177 (19) = happyGoto action_12
action_177 (23) = happyGoto action_13
action_177 _ = happyFail

action_178 (56) = happyShift action_179
action_178 _ = happyFail

action_179 (38) = happyShift action_14
action_179 (39) = happyShift action_15
action_179 (40) = happyShift action_16
action_179 (42) = happyShift action_17
action_179 (46) = happyShift action_18
action_179 (47) = happyShift action_19
action_179 (51) = happyShift action_20
action_179 (58) = happyShift action_21
action_179 (65) = happyShift action_22
action_179 (71) = happyShift action_23
action_179 (72) = happyShift action_24
action_179 (5) = happyGoto action_182
action_179 (7) = happyGoto action_3
action_179 (9) = happyGoto action_4
action_179 (10) = happyGoto action_5
action_179 (11) = happyGoto action_6
action_179 (12) = happyGoto action_7
action_179 (13) = happyGoto action_8
action_179 (14) = happyGoto action_9
action_179 (15) = happyGoto action_10
action_179 (16) = happyGoto action_11
action_179 (19) = happyGoto action_12
action_179 (23) = happyGoto action_13
action_179 _ = happyFail

action_180 (38) = happyShift action_14
action_180 (39) = happyShift action_15
action_180 (40) = happyShift action_16
action_180 (42) = happyShift action_17
action_180 (46) = happyShift action_18
action_180 (47) = happyShift action_19
action_180 (51) = happyShift action_20
action_180 (57) = happyShift action_181
action_180 (58) = happyShift action_21
action_180 (65) = happyShift action_22
action_180 (71) = happyShift action_23
action_180 (72) = happyShift action_24
action_180 (7) = happyGoto action_47
action_180 (9) = happyGoto action_4
action_180 (10) = happyGoto action_5
action_180 (11) = happyGoto action_6
action_180 (12) = happyGoto action_7
action_180 (13) = happyGoto action_8
action_180 (14) = happyGoto action_9
action_180 (15) = happyGoto action_10
action_180 (16) = happyGoto action_11
action_180 (19) = happyGoto action_12
action_180 (23) = happyGoto action_13
action_180 _ = happyFail

action_181 _ = happyReduce_57

action_182 (38) = happyShift action_14
action_182 (39) = happyShift action_15
action_182 (40) = happyShift action_16
action_182 (42) = happyShift action_17
action_182 (46) = happyShift action_18
action_182 (47) = happyShift action_19
action_182 (51) = happyShift action_20
action_182 (57) = happyShift action_183
action_182 (58) = happyShift action_21
action_182 (65) = happyShift action_22
action_182 (71) = happyShift action_23
action_182 (72) = happyShift action_24
action_182 (7) = happyGoto action_47
action_182 (9) = happyGoto action_4
action_182 (10) = happyGoto action_5
action_182 (11) = happyGoto action_6
action_182 (12) = happyGoto action_7
action_182 (13) = happyGoto action_8
action_182 (14) = happyGoto action_9
action_182 (15) = happyGoto action_10
action_182 (16) = happyGoto action_11
action_182 (19) = happyGoto action_12
action_182 (23) = happyGoto action_13
action_182 _ = happyFail

action_183 _ = happyReduce_56

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
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  8 happyReduction_8
happyReduction_8 (HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn8
		 ([happy_var_2]
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  9 happyReduction_10
happyReduction_10 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn9
		 (happy_var_2
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happyReduce 4 9 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_2  9 happyReduction_12
happyReduction_12 _
	_
	 =  HappyAbsSyn9
		 (ExpUnit
	)

happyReduce_13 = happyReduce 4 9 happyReduction_13
happyReduction_13 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (ExpTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_14 = happySpecReduce_1  9 happyReduction_14
happyReduction_14 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn9
		 (ExpNum happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  9 happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn9
		 (ExpBool True
	)

happyReduce_16 = happySpecReduce_1  9 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn9
		 (ExpBool False
	)

happyReduce_17 = happySpecReduce_1  9 happyReduction_17
happyReduction_17 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn9
		 (ExpRef happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  10 happyReduction_18
happyReduction_18 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  10 happyReduction_19
happyReduction_19 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happyReduce 4 11 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_1  11 happyReduction_21
happyReduction_21 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  12 happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  12 happyReduction_23
happyReduction_23 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  13 happyReduction_24
happyReduction_24 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  13 happyReduction_25
happyReduction_25 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  14 happyReduction_26
happyReduction_26 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  14 happyReduction_27
happyReduction_27 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  15 happyReduction_28
happyReduction_28 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  15 happyReduction_29
happyReduction_29 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_2  16 happyReduction_30
happyReduction_30 (HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (ExpNot happy_var_2
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  16 happyReduction_31
happyReduction_31 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_2  16 happyReduction_32
happyReduction_32 (HappyAbsSyn37  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (ExpImport happy_var_2
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  16 happyReduction_33
happyReduction_33 (HappyAbsSyn16  happy_var_3)
	_
	(HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn16
		 (ExpAssign happy_var_1 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happyReduce 4 16 happyReduction_34
happyReduction_34 (_ `HappyStk`
	(HappyAbsSyn36  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (ExpStruct happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_35 = happySpecReduce_1  16 happyReduction_35
happyReduction_35 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn16
		 (ExpTypeDec happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  16 happyReduction_36
happyReduction_36 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn16
		 (ExpFunDec happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happyReduce 11 16 happyReduction_37
happyReduction_37 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (ExpIfElse happy_var_3 happy_var_6 happy_var_10
	) `HappyStk` happyRest

happyReduce_38 = happySpecReduce_1  17 happyReduction_38
happyReduction_38 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  17 happyReduction_39
happyReduction_39 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_0  17 happyReduction_40
happyReduction_40  =  HappyAbsSyn17
		 ([]
	)

happyReduce_41 = happySpecReduce_1  18 happyReduction_41
happyReduction_41 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  18 happyReduction_42
happyReduction_42 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_0  18 happyReduction_43
happyReduction_43  =  HappyAbsSyn18
		 ([]
	)

happyReduce_44 = happyReduce 4 19 happyReduction_44
happyReduction_44 ((HappyAbsSyn32  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_45 = happyReduce 4 19 happyReduction_45
happyReduction_45 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_1  20 happyReduction_46
happyReduction_46 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 ([happy_var_1]
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_2  20 happyReduction_47
happyReduction_47 (HappyAbsSyn21  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_47 _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  21 happyReduction_48
happyReduction_48 (HappyAbsSyn22  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn21
		 (AdtAlternative happy_var_2 0 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn22
		 ([happy_var_1]
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_2  22 happyReduction_50
happyReduction_50 (HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_50 _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_0  22 happyReduction_51
happyReduction_51  =  HappyAbsSyn22
		 ([]
	)

happyReduce_52 = happyReduce 12 23 happyReduction_52
happyReduction_52 ((HappyAbsSyn24  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn32  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn32  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (FunDecInstFun happy_var_5 happy_var_3 (TyArrow happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_53 = happyReduce 9 23 happyReduction_53
happyReduction_53 ((HappyAbsSyn24  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn32  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (FunDecFun happy_var_2 (TyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_54 = happySpecReduce_1  24 happyReduction_54
happyReduction_54 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_2  24 happyReduction_55
happyReduction_55 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_55 _ _  = notHappyAtAll 

happyReduce_56 = happyReduce 9 25 happyReduction_56
happyReduction_56 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn26  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_57 = happyReduce 8 25 happyReduction_57
happyReduction_57 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (FunDefFun happy_var_1 happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_58 = happyReduce 4 26 happyReduction_58
happyReduction_58 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_59 = happySpecReduce_1  27 happyReduction_59
happyReduction_59 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn27
		 ([happy_var_1]
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  27 happyReduction_60
happyReduction_60 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_0  27 happyReduction_61
happyReduction_61  =  HappyAbsSyn27
		 ([]
	)

happyReduce_62 = happySpecReduce_1  28 happyReduction_62
happyReduction_62 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn28
		 (PatExpVar happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  29 happyReduction_63
happyReduction_63 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn29
		 ([happy_var_1]
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  29 happyReduction_64
happyReduction_64 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_0  29 happyReduction_65
happyReduction_65  =  HappyAbsSyn29
		 ([]
	)

happyReduce_66 = happySpecReduce_2  30 happyReduction_66
happyReduction_66 (HappyAbsSyn32  happy_var_2)
	_
	 =  HappyAbsSyn30
		 ([happy_var_2]
	)
happyReduction_66 _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  30 happyReduction_67
happyReduction_67 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happyReduce 4 31 happyReduction_68
happyReduction_68 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	(HappyAbsSyn32  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn31
		 (TyTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_69 = happySpecReduce_1  32 happyReduction_69
happyReduction_69 _
	 =  HappyAbsSyn32
		 (TyInt
	)

happyReduce_70 = happySpecReduce_1  32 happyReduction_70
happyReduction_70 _
	 =  HappyAbsSyn32
		 (TyBool
	)

happyReduce_71 = happySpecReduce_1  32 happyReduction_71
happyReduction_71 _
	 =  HappyAbsSyn32
		 (TyUnit
	)

happyReduce_72 = happyReduce 5 32 happyReduction_72
happyReduction_72 ((HappyAbsSyn32  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_73 = happyReduce 6 32 happyReduction_73
happyReduction_73 ((HappyAbsSyn32  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_74 = happySpecReduce_3  32 happyReduction_74
happyReduction_74 _
	_
	_
	 =  HappyAbsSyn32
		 (TyModule
	)

happyReduce_75 = happySpecReduce_3  32 happyReduction_75
happyReduction_75 _
	_
	_
	 =  HappyAbsSyn32
		 (TyInterface
	)

happyReduce_76 = happyReduce 4 32 happyReduction_76
happyReduction_76 (_ `HappyStk`
	(HappyAbsSyn34  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (TyStruct happy_var_3
	) `HappyStk` happyRest

happyReduce_77 = happySpecReduce_1  32 happyReduction_77
happyReduction_77 (HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  32 happyReduction_78
happyReduction_78 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn32
		 (TyRef happy_var_1
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  33 happyReduction_79
happyReduction_79 _
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	(HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn33
		 ((happy_var_2, happy_var_1)
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  34 happyReduction_80
happyReduction_80 (HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn34
		 ([happy_var_1]
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_2  34 happyReduction_81
happyReduction_81 (HappyAbsSyn33  happy_var_2)
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn34
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_81 _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_0  34 happyReduction_82
happyReduction_82  =  HappyAbsSyn34
		 ([]
	)

happyReduce_83 = happyReduce 4 35 happyReduction_83
happyReduction_83 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn35
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_84 = happySpecReduce_1  36 happyReduction_84
happyReduction_84 (HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn36
		 ([happy_var_1]
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_2  36 happyReduction_85
happyReduction_85 (HappyAbsSyn35  happy_var_2)
	(HappyAbsSyn36  happy_var_1)
	 =  HappyAbsSyn36
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_85 _ _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_0  36 happyReduction_86
happyReduction_86  =  HappyAbsSyn36
		 ([]
	)

happyReduce_87 = happySpecReduce_1  37 happyReduction_87
happyReduction_87 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn37
		 (Id happy_var_1
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_3  37 happyReduction_88
happyReduction_88 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn37
		 (Path happy_var_1 happy_var_3
	)
happyReduction_88 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 73 73 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 38;
	Token _ TokenImport -> cont 39;
	Token _ TokenType -> cont 40;
	Token _ TokenInterface -> cont 41;
	Token _ TokenFun -> cont 42;
	Token _ TokenImp -> cont 43;
	Token _ TokenTest -> cont 44;
	Token _ TokenStruct -> cont 45;
	Token _ TokenTrue -> cont 46;
	Token _ TokenFalse -> cont 47;
	Token _ TokenInt -> cont 48;
	Token _ TokenBool -> cont 49;
	Token _ TokenUnit -> cont 50;
	Token _ TokenIf -> cont 51;
	Token _ TokenElse -> cont 52;
	Token _ TokenAssign -> cont 53;
	Token _ TokenLBracket -> cont 54;
	Token _ TokenRBracket -> cont 55;
	Token _ TokenLBrace -> cont 56;
	Token _ TokenRBrace -> cont 57;
	Token _ TokenLParen -> cont 58;
	Token _ TokenRParen -> cont 59;
	Token _ TokenPipe -> cont 60;
	Token _ TokenPlus -> cont 61;
	Token _ TokenMinus -> cont 62;
	Token _ TokenStar -> cont 63;
	Token _ TokenFSlash -> cont 64;
	Token _ TokenExclamation -> cont 65;
	Token _ TokenSemi -> cont 66;
	Token _ TokenDot -> cont 67;
	Token _ TokenEq -> cont 68;
	Token _ TokenColon -> cont 69;
	Token _ TokenComma -> cont 70;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 71;
	Token _ (TokenId happy_dollar_dollar) -> cont 72;
	_ -> happyError' tk
	})

happyError_ 73 tk = happyError' tk
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

