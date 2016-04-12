{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49
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
	| HappyAbsSyn38 t38
	| HappyAbsSyn39 t39
	| HappyAbsSyn40 t40
	| HappyAbsSyn41 t41
	| HappyAbsSyn42 t42
	| HappyAbsSyn43 t43
	| HappyAbsSyn44 t44
	| HappyAbsSyn45 t45
	| HappyAbsSyn46 t46
	| HappyAbsSyn47 t47
	| HappyAbsSyn48 t48
	| HappyAbsSyn49 t49

action_0 (50) = happyShift action_14
action_0 (51) = happyShift action_15
action_0 (52) = happyShift action_16
action_0 (54) = happyShift action_17
action_0 (58) = happyShift action_18
action_0 (59) = happyShift action_19
action_0 (60) = happyShift action_20
action_0 (65) = happyShift action_21
action_0 (67) = happyShift action_22
action_0 (75) = happyShift action_23
action_0 (82) = happyShift action_24
action_0 (89) = happyShift action_25
action_0 (90) = happyShift action_26
action_0 (91) = happyShift action_27
action_0 (4) = happyGoto action_28
action_0 (5) = happyGoto action_2
action_0 (7) = happyGoto action_3
action_0 (20) = happyGoto action_4
action_0 (21) = happyGoto action_5
action_0 (22) = happyGoto action_6
action_0 (23) = happyGoto action_7
action_0 (24) = happyGoto action_8
action_0 (25) = happyGoto action_9
action_0 (26) = happyGoto action_10
action_0 (27) = happyGoto action_11
action_0 (32) = happyGoto action_12
action_0 (36) = happyGoto action_13
action_0 _ = happyFail

action_1 (50) = happyShift action_14
action_1 (51) = happyShift action_15
action_1 (52) = happyShift action_16
action_1 (54) = happyShift action_17
action_1 (58) = happyShift action_18
action_1 (59) = happyShift action_19
action_1 (60) = happyShift action_20
action_1 (65) = happyShift action_21
action_1 (67) = happyShift action_22
action_1 (75) = happyShift action_23
action_1 (82) = happyShift action_24
action_1 (89) = happyShift action_25
action_1 (90) = happyShift action_26
action_1 (91) = happyShift action_27
action_1 (5) = happyGoto action_2
action_1 (7) = happyGoto action_3
action_1 (20) = happyGoto action_4
action_1 (21) = happyGoto action_5
action_1 (22) = happyGoto action_6
action_1 (23) = happyGoto action_7
action_1 (24) = happyGoto action_8
action_1 (25) = happyGoto action_9
action_1 (26) = happyGoto action_10
action_1 (27) = happyGoto action_11
action_1 (32) = happyGoto action_12
action_1 (36) = happyGoto action_13
action_1 _ = happyFail

action_2 (50) = happyShift action_14
action_2 (51) = happyShift action_15
action_2 (52) = happyShift action_16
action_2 (54) = happyShift action_17
action_2 (58) = happyShift action_18
action_2 (59) = happyShift action_19
action_2 (60) = happyShift action_20
action_2 (65) = happyShift action_21
action_2 (67) = happyShift action_22
action_2 (75) = happyShift action_23
action_2 (82) = happyShift action_24
action_2 (89) = happyShift action_25
action_2 (90) = happyShift action_26
action_2 (91) = happyShift action_27
action_2 (7) = happyGoto action_55
action_2 (20) = happyGoto action_4
action_2 (21) = happyGoto action_5
action_2 (22) = happyGoto action_6
action_2 (23) = happyGoto action_7
action_2 (24) = happyGoto action_8
action_2 (25) = happyGoto action_9
action_2 (26) = happyGoto action_10
action_2 (27) = happyGoto action_11
action_2 (32) = happyGoto action_12
action_2 (36) = happyGoto action_13
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 _ = happyReduce_46

action_5 (73) = happyShift action_54
action_5 _ = happyReduce_48

action_6 (75) = happyShift action_52
action_6 (84) = happyShift action_53
action_6 _ = happyReduce_50

action_7 (80) = happyShift action_51
action_7 _ = happyReduce_52

action_8 (81) = happyShift action_50
action_8 _ = happyReduce_54

action_9 (78) = happyShift action_49
action_9 _ = happyReduce_56

action_10 (79) = happyShift action_48
action_10 _ = happyReduce_58

action_11 (83) = happyShift action_47
action_11 _ = happyFail

action_12 _ = happyReduce_62

action_13 _ = happyReduce_63

action_14 (73) = happyShift action_46
action_14 _ = happyFail

action_15 (90) = happyShift action_45
action_15 (49) = happyGoto action_44
action_15 _ = happyFail

action_16 (90) = happyShift action_43
action_16 _ = happyFail

action_17 (75) = happyShift action_41
action_17 (90) = happyShift action_42
action_17 _ = happyFail

action_18 (75) = happyShift action_38
action_18 (88) = happyShift action_39
action_18 (90) = happyShift action_40
action_18 (16) = happyGoto action_35
action_18 (18) = happyGoto action_36
action_18 (19) = happyGoto action_37
action_18 _ = happyFail

action_19 _ = happyReduce_41

action_20 _ = happyReduce_42

action_21 (75) = happyShift action_34
action_21 _ = happyFail

action_22 (75) = happyShift action_33
action_22 _ = happyFail

action_23 (50) = happyShift action_14
action_23 (51) = happyShift action_15
action_23 (52) = happyShift action_16
action_23 (54) = happyShift action_17
action_23 (58) = happyShift action_18
action_23 (59) = happyShift action_19
action_23 (60) = happyShift action_20
action_23 (65) = happyShift action_21
action_23 (67) = happyShift action_22
action_23 (75) = happyShift action_23
action_23 (76) = happyShift action_32
action_23 (82) = happyShift action_24
action_23 (89) = happyShift action_25
action_23 (90) = happyShift action_26
action_23 (91) = happyShift action_27
action_23 (20) = happyGoto action_4
action_23 (21) = happyGoto action_5
action_23 (22) = happyGoto action_6
action_23 (23) = happyGoto action_7
action_23 (24) = happyGoto action_8
action_23 (25) = happyGoto action_9
action_23 (26) = happyGoto action_10
action_23 (27) = happyGoto action_31
action_23 (32) = happyGoto action_12
action_23 (36) = happyGoto action_13
action_23 _ = happyFail

action_24 (50) = happyShift action_14
action_24 (59) = happyShift action_19
action_24 (60) = happyShift action_20
action_24 (75) = happyShift action_23
action_24 (89) = happyShift action_25
action_24 (90) = happyShift action_26
action_24 (91) = happyShift action_27
action_24 (20) = happyGoto action_4
action_24 (21) = happyGoto action_29
action_24 (22) = happyGoto action_6
action_24 (23) = happyGoto action_7
action_24 (24) = happyGoto action_8
action_24 (25) = happyGoto action_9
action_24 (26) = happyGoto action_30
action_24 _ = happyFail

action_25 _ = happyReduce_40

action_26 _ = happyReduce_44

action_27 _ = happyReduce_43

action_28 (92) = happyAccept
action_28 _ = happyFail

action_29 _ = happyReduce_48

action_30 (79) = happyShift action_48
action_30 _ = happyReduce_57

action_31 (76) = happyShift action_90
action_31 (87) = happyShift action_91
action_31 (8) = happyGoto action_89
action_31 _ = happyFail

action_32 _ = happyReduce_38

action_33 (50) = happyShift action_14
action_33 (51) = happyShift action_15
action_33 (52) = happyShift action_16
action_33 (54) = happyShift action_17
action_33 (58) = happyShift action_18
action_33 (59) = happyShift action_19
action_33 (60) = happyShift action_20
action_33 (65) = happyShift action_21
action_33 (67) = happyShift action_22
action_33 (75) = happyShift action_23
action_33 (82) = happyShift action_24
action_33 (89) = happyShift action_25
action_33 (90) = happyShift action_26
action_33 (91) = happyShift action_27
action_33 (20) = happyGoto action_4
action_33 (21) = happyGoto action_5
action_33 (22) = happyGoto action_6
action_33 (23) = happyGoto action_7
action_33 (24) = happyGoto action_8
action_33 (25) = happyGoto action_9
action_33 (26) = happyGoto action_10
action_33 (27) = happyGoto action_88
action_33 (32) = happyGoto action_12
action_33 (36) = happyGoto action_13
action_33 _ = happyFail

action_34 (50) = happyShift action_14
action_34 (51) = happyShift action_15
action_34 (52) = happyShift action_16
action_34 (54) = happyShift action_17
action_34 (58) = happyShift action_18
action_34 (59) = happyShift action_19
action_34 (60) = happyShift action_20
action_34 (65) = happyShift action_21
action_34 (67) = happyShift action_22
action_34 (75) = happyShift action_23
action_34 (82) = happyShift action_24
action_34 (89) = happyShift action_25
action_34 (90) = happyShift action_26
action_34 (91) = happyShift action_27
action_34 (20) = happyGoto action_4
action_34 (21) = happyGoto action_5
action_34 (22) = happyGoto action_6
action_34 (23) = happyGoto action_7
action_34 (24) = happyGoto action_8
action_34 (25) = happyGoto action_9
action_34 (26) = happyGoto action_10
action_34 (27) = happyGoto action_87
action_34 (32) = happyGoto action_12
action_34 (36) = happyGoto action_13
action_34 _ = happyFail

action_35 (69) = happyShift action_86
action_35 _ = happyFail

action_36 _ = happyReduce_28

action_37 _ = happyReduce_29

action_38 (75) = happyShift action_38
action_38 (88) = happyShift action_39
action_38 (90) = happyShift action_40
action_38 (16) = happyGoto action_85
action_38 (18) = happyGoto action_36
action_38 (19) = happyGoto action_37
action_38 _ = happyFail

action_39 _ = happyReduce_31

action_40 (75) = happyShift action_84
action_40 _ = happyReduce_30

action_41 (50) = happyShift action_75
action_41 (53) = happyShift action_76
action_41 (54) = happyShift action_77
action_41 (57) = happyShift action_78
action_41 (61) = happyShift action_79
action_41 (62) = happyShift action_80
action_41 (63) = happyShift action_81
action_41 (64) = happyShift action_82
action_41 (75) = happyShift action_83
action_41 (90) = happyShift action_45
action_41 (43) = happyGoto action_72
action_41 (44) = happyGoto action_73
action_41 (49) = happyGoto action_74
action_41 _ = happyFail

action_42 (75) = happyShift action_71
action_42 _ = happyFail

action_43 (85) = happyShift action_70
action_43 _ = happyFail

action_44 (84) = happyShift action_69
action_44 _ = happyReduce_59

action_45 _ = happyReduce_118

action_46 (50) = happyShift action_14
action_46 (51) = happyShift action_15
action_46 (52) = happyShift action_16
action_46 (54) = happyShift action_17
action_46 (58) = happyShift action_18
action_46 (59) = happyShift action_19
action_46 (60) = happyShift action_20
action_46 (65) = happyShift action_21
action_46 (67) = happyShift action_22
action_46 (75) = happyShift action_23
action_46 (82) = happyShift action_24
action_46 (89) = happyShift action_25
action_46 (90) = happyShift action_26
action_46 (91) = happyShift action_27
action_46 (5) = happyGoto action_66
action_46 (6) = happyGoto action_67
action_46 (7) = happyGoto action_68
action_46 (20) = happyGoto action_4
action_46 (21) = happyGoto action_5
action_46 (22) = happyGoto action_6
action_46 (23) = happyGoto action_7
action_46 (24) = happyGoto action_8
action_46 (25) = happyGoto action_9
action_46 (26) = happyGoto action_10
action_46 (27) = happyGoto action_11
action_46 (32) = happyGoto action_12
action_46 (36) = happyGoto action_13
action_46 _ = happyReduce_6

action_47 _ = happyReduce_7

action_48 (50) = happyShift action_14
action_48 (59) = happyShift action_19
action_48 (60) = happyShift action_20
action_48 (75) = happyShift action_23
action_48 (89) = happyShift action_25
action_48 (90) = happyShift action_26
action_48 (91) = happyShift action_27
action_48 (20) = happyGoto action_4
action_48 (21) = happyGoto action_29
action_48 (22) = happyGoto action_6
action_48 (23) = happyGoto action_7
action_48 (24) = happyGoto action_8
action_48 (25) = happyGoto action_65
action_48 _ = happyFail

action_49 (50) = happyShift action_14
action_49 (59) = happyShift action_19
action_49 (60) = happyShift action_20
action_49 (75) = happyShift action_23
action_49 (89) = happyShift action_25
action_49 (90) = happyShift action_26
action_49 (91) = happyShift action_27
action_49 (20) = happyGoto action_4
action_49 (21) = happyGoto action_29
action_49 (22) = happyGoto action_6
action_49 (23) = happyGoto action_7
action_49 (24) = happyGoto action_64
action_49 _ = happyFail

action_50 (50) = happyShift action_14
action_50 (59) = happyShift action_19
action_50 (60) = happyShift action_20
action_50 (75) = happyShift action_23
action_50 (89) = happyShift action_25
action_50 (90) = happyShift action_26
action_50 (91) = happyShift action_27
action_50 (20) = happyGoto action_4
action_50 (21) = happyGoto action_29
action_50 (22) = happyGoto action_6
action_50 (23) = happyGoto action_63
action_50 _ = happyFail

action_51 (50) = happyShift action_14
action_51 (59) = happyShift action_19
action_51 (60) = happyShift action_20
action_51 (75) = happyShift action_23
action_51 (89) = happyShift action_25
action_51 (90) = happyShift action_26
action_51 (91) = happyShift action_27
action_51 (20) = happyGoto action_4
action_51 (21) = happyGoto action_29
action_51 (22) = happyGoto action_62
action_51 _ = happyFail

action_52 (50) = happyShift action_14
action_52 (51) = happyShift action_15
action_52 (52) = happyShift action_16
action_52 (54) = happyShift action_17
action_52 (58) = happyShift action_18
action_52 (59) = happyShift action_19
action_52 (60) = happyShift action_20
action_52 (65) = happyShift action_21
action_52 (67) = happyShift action_22
action_52 (75) = happyShift action_23
action_52 (82) = happyShift action_24
action_52 (89) = happyShift action_25
action_52 (90) = happyShift action_26
action_52 (91) = happyShift action_27
action_52 (20) = happyGoto action_4
action_52 (21) = happyGoto action_5
action_52 (22) = happyGoto action_6
action_52 (23) = happyGoto action_7
action_52 (24) = happyGoto action_8
action_52 (25) = happyGoto action_9
action_52 (26) = happyGoto action_10
action_52 (27) = happyGoto action_60
action_52 (30) = happyGoto action_61
action_52 (32) = happyGoto action_12
action_52 (36) = happyGoto action_13
action_52 _ = happyReduce_71

action_53 (90) = happyShift action_59
action_53 _ = happyFail

action_54 (90) = happyShift action_58
action_54 (47) = happyGoto action_56
action_54 (48) = happyGoto action_57
action_54 _ = happyReduce_117

action_55 _ = happyReduce_3

action_56 _ = happyReduce_115

action_57 (74) = happyShift action_130
action_57 (90) = happyShift action_58
action_57 (47) = happyGoto action_129
action_57 _ = happyFail

action_58 (85) = happyShift action_128
action_58 _ = happyFail

action_59 _ = happyReduce_45

action_60 _ = happyReduce_69

action_61 (76) = happyShift action_126
action_61 (87) = happyShift action_127
action_61 _ = happyFail

action_62 (75) = happyShift action_52
action_62 (84) = happyShift action_53
action_62 _ = happyReduce_49

action_63 (80) = happyShift action_51
action_63 _ = happyReduce_51

action_64 (81) = happyShift action_50
action_64 _ = happyReduce_53

action_65 (78) = happyShift action_49
action_65 _ = happyReduce_55

action_66 (50) = happyShift action_14
action_66 (51) = happyShift action_15
action_66 (52) = happyShift action_16
action_66 (54) = happyShift action_17
action_66 (58) = happyShift action_18
action_66 (59) = happyShift action_19
action_66 (60) = happyShift action_20
action_66 (65) = happyShift action_21
action_66 (67) = happyShift action_22
action_66 (75) = happyShift action_23
action_66 (82) = happyShift action_24
action_66 (89) = happyShift action_25
action_66 (90) = happyShift action_26
action_66 (91) = happyShift action_27
action_66 (7) = happyGoto action_125
action_66 (20) = happyGoto action_4
action_66 (21) = happyGoto action_5
action_66 (22) = happyGoto action_6
action_66 (23) = happyGoto action_7
action_66 (24) = happyGoto action_8
action_66 (25) = happyGoto action_9
action_66 (26) = happyGoto action_10
action_66 (27) = happyGoto action_11
action_66 (32) = happyGoto action_12
action_66 (36) = happyGoto action_13
action_66 _ = happyFail

action_67 (74) = happyShift action_124
action_67 _ = happyFail

action_68 (74) = happyReduce_4
action_68 _ = happyReduce_2

action_69 (90) = happyShift action_123
action_69 _ = happyFail

action_70 (50) = happyShift action_75
action_70 (53) = happyShift action_76
action_70 (54) = happyShift action_77
action_70 (57) = happyShift action_78
action_70 (61) = happyShift action_79
action_70 (62) = happyShift action_80
action_70 (63) = happyShift action_81
action_70 (64) = happyShift action_82
action_70 (75) = happyShift action_83
action_70 (77) = happyShift action_122
action_70 (90) = happyShift action_45
action_70 (33) = happyGoto action_119
action_70 (34) = happyGoto action_120
action_70 (43) = happyGoto action_72
action_70 (44) = happyGoto action_121
action_70 (49) = happyGoto action_74
action_70 _ = happyFail

action_71 (50) = happyShift action_75
action_71 (53) = happyShift action_76
action_71 (54) = happyShift action_77
action_71 (57) = happyShift action_78
action_71 (61) = happyShift action_79
action_71 (62) = happyShift action_80
action_71 (63) = happyShift action_81
action_71 (64) = happyShift action_82
action_71 (75) = happyShift action_83
action_71 (90) = happyShift action_45
action_71 (41) = happyGoto action_117
action_71 (43) = happyGoto action_72
action_71 (44) = happyGoto action_118
action_71 (49) = happyGoto action_74
action_71 _ = happyReduce_95

action_72 _ = happyReduce_108

action_73 (76) = happyShift action_116
action_73 _ = happyFail

action_74 (84) = happyShift action_69
action_74 _ = happyReduce_109

action_75 (73) = happyShift action_115
action_75 _ = happyFail

action_76 (73) = happyShift action_114
action_76 _ = happyFail

action_77 (75) = happyShift action_113
action_77 _ = happyFail

action_78 (73) = happyShift action_112
action_78 _ = happyFail

action_79 _ = happyReduce_99

action_80 _ = happyReduce_100

action_81 _ = happyReduce_101

action_82 _ = happyReduce_102

action_83 (50) = happyShift action_75
action_83 (53) = happyShift action_76
action_83 (54) = happyShift action_77
action_83 (57) = happyShift action_78
action_83 (61) = happyShift action_79
action_83 (62) = happyShift action_80
action_83 (63) = happyShift action_81
action_83 (64) = happyShift action_82
action_83 (75) = happyShift action_83
action_83 (90) = happyShift action_45
action_83 (43) = happyGoto action_72
action_83 (44) = happyGoto action_111
action_83 (49) = happyGoto action_74
action_83 _ = happyFail

action_84 (59) = happyShift action_105
action_84 (60) = happyShift action_106
action_84 (75) = happyShift action_107
action_84 (88) = happyShift action_108
action_84 (89) = happyShift action_109
action_84 (90) = happyShift action_110
action_84 (9) = happyGoto action_100
action_84 (11) = happyGoto action_101
action_84 (12) = happyGoto action_102
action_84 (14) = happyGoto action_103
action_84 (15) = happyGoto action_104
action_84 _ = happyReduce_22

action_85 (87) = happyShift action_99
action_85 (17) = happyGoto action_98
action_85 _ = happyFail

action_86 (50) = happyShift action_14
action_86 (51) = happyShift action_15
action_86 (52) = happyShift action_16
action_86 (54) = happyShift action_17
action_86 (58) = happyShift action_18
action_86 (59) = happyShift action_19
action_86 (60) = happyShift action_20
action_86 (65) = happyShift action_21
action_86 (67) = happyShift action_22
action_86 (75) = happyShift action_23
action_86 (82) = happyShift action_24
action_86 (89) = happyShift action_25
action_86 (90) = happyShift action_26
action_86 (91) = happyShift action_27
action_86 (20) = happyGoto action_4
action_86 (21) = happyGoto action_5
action_86 (22) = happyGoto action_6
action_86 (23) = happyGoto action_7
action_86 (24) = happyGoto action_8
action_86 (25) = happyGoto action_9
action_86 (26) = happyGoto action_10
action_86 (27) = happyGoto action_97
action_86 (32) = happyGoto action_12
action_86 (36) = happyGoto action_13
action_86 _ = happyFail

action_87 (76) = happyShift action_96
action_87 _ = happyFail

action_88 (76) = happyShift action_95
action_88 _ = happyFail

action_89 (76) = happyShift action_93
action_89 (87) = happyShift action_94
action_89 _ = happyFail

action_90 _ = happyReduce_36

action_91 (50) = happyShift action_14
action_91 (51) = happyShift action_15
action_91 (52) = happyShift action_16
action_91 (54) = happyShift action_17
action_91 (58) = happyShift action_18
action_91 (59) = happyShift action_19
action_91 (60) = happyShift action_20
action_91 (65) = happyShift action_21
action_91 (67) = happyShift action_22
action_91 (75) = happyShift action_23
action_91 (82) = happyShift action_24
action_91 (89) = happyShift action_25
action_91 (90) = happyShift action_26
action_91 (91) = happyShift action_27
action_91 (20) = happyGoto action_4
action_91 (21) = happyGoto action_5
action_91 (22) = happyGoto action_6
action_91 (23) = happyGoto action_7
action_91 (24) = happyGoto action_8
action_91 (25) = happyGoto action_9
action_91 (26) = happyGoto action_10
action_91 (27) = happyGoto action_92
action_91 (32) = happyGoto action_12
action_91 (36) = happyGoto action_13
action_91 _ = happyFail

action_92 _ = happyReduce_8

action_93 _ = happyReduce_39

action_94 (50) = happyShift action_14
action_94 (51) = happyShift action_15
action_94 (52) = happyShift action_16
action_94 (54) = happyShift action_17
action_94 (58) = happyShift action_18
action_94 (59) = happyShift action_19
action_94 (60) = happyShift action_20
action_94 (65) = happyShift action_21
action_94 (67) = happyShift action_22
action_94 (75) = happyShift action_23
action_94 (82) = happyShift action_24
action_94 (89) = happyShift action_25
action_94 (90) = happyShift action_26
action_94 (91) = happyShift action_27
action_94 (20) = happyGoto action_4
action_94 (21) = happyGoto action_5
action_94 (22) = happyGoto action_6
action_94 (23) = happyGoto action_7
action_94 (24) = happyGoto action_8
action_94 (25) = happyGoto action_9
action_94 (26) = happyGoto action_10
action_94 (27) = happyGoto action_156
action_94 (32) = happyGoto action_12
action_94 (36) = happyGoto action_13
action_94 _ = happyFail

action_95 (73) = happyShift action_155
action_95 _ = happyFail

action_96 (73) = happyShift action_154
action_96 _ = happyFail

action_97 _ = happyReduce_60

action_98 (76) = happyShift action_152
action_98 (87) = happyShift action_153
action_98 _ = happyFail

action_99 (75) = happyShift action_38
action_99 (88) = happyShift action_39
action_99 (90) = happyShift action_40
action_99 (16) = happyGoto action_151
action_99 (18) = happyGoto action_36
action_99 (19) = happyGoto action_37
action_99 _ = happyFail

action_100 _ = happyReduce_23

action_101 _ = happyReduce_24

action_102 _ = happyReduce_25

action_103 (76) = happyShift action_149
action_103 (87) = happyShift action_150
action_103 _ = happyFail

action_104 _ = happyReduce_20

action_105 _ = happyReduce_11

action_106 _ = happyReduce_12

action_107 (59) = happyShift action_105
action_107 (60) = happyShift action_106
action_107 (75) = happyShift action_107
action_107 (88) = happyShift action_108
action_107 (89) = happyShift action_109
action_107 (90) = happyShift action_110
action_107 (9) = happyGoto action_100
action_107 (11) = happyGoto action_101
action_107 (12) = happyGoto action_102
action_107 (15) = happyGoto action_148
action_107 _ = happyFail

action_108 _ = happyReduce_27

action_109 _ = happyReduce_10

action_110 (75) = happyShift action_147
action_110 _ = happyReduce_26

action_111 (87) = happyShift action_146
action_111 (42) = happyGoto action_145
action_111 _ = happyFail

action_112 (50) = happyShift action_75
action_112 (53) = happyShift action_76
action_112 (54) = happyShift action_77
action_112 (57) = happyShift action_78
action_112 (61) = happyShift action_79
action_112 (62) = happyShift action_80
action_112 (63) = happyShift action_81
action_112 (64) = happyShift action_82
action_112 (75) = happyShift action_83
action_112 (90) = happyShift action_45
action_112 (43) = happyGoto action_72
action_112 (44) = happyGoto action_142
action_112 (45) = happyGoto action_143
action_112 (46) = happyGoto action_144
action_112 (49) = happyGoto action_74
action_112 _ = happyReduce_113

action_113 (50) = happyShift action_75
action_113 (53) = happyShift action_76
action_113 (54) = happyShift action_77
action_113 (57) = happyShift action_78
action_113 (61) = happyShift action_79
action_113 (62) = happyShift action_80
action_113 (63) = happyShift action_81
action_113 (64) = happyShift action_82
action_113 (75) = happyShift action_83
action_113 (76) = happyShift action_141
action_113 (90) = happyShift action_45
action_113 (41) = happyGoto action_140
action_113 (43) = happyGoto action_72
action_113 (44) = happyGoto action_118
action_113 (49) = happyGoto action_74
action_113 _ = happyReduce_95

action_114 (74) = happyShift action_139
action_114 _ = happyFail

action_115 (74) = happyShift action_138
action_115 _ = happyFail

action_116 (90) = happyShift action_137
action_116 _ = happyFail

action_117 (76) = happyShift action_135
action_117 (87) = happyShift action_136
action_117 _ = happyFail

action_118 _ = happyReduce_93

action_119 (77) = happyShift action_122
action_119 (34) = happyGoto action_134
action_119 _ = happyReduce_76

action_120 _ = happyReduce_77

action_121 _ = happyReduce_75

action_122 (90) = happyShift action_133
action_122 _ = happyFail

action_123 _ = happyReduce_119

action_124 _ = happyReduce_37

action_125 (74) = happyReduce_5
action_125 _ = happyReduce_3

action_126 _ = happyReduce_47

action_127 (50) = happyShift action_14
action_127 (51) = happyShift action_15
action_127 (52) = happyShift action_16
action_127 (54) = happyShift action_17
action_127 (58) = happyShift action_18
action_127 (59) = happyShift action_19
action_127 (60) = happyShift action_20
action_127 (65) = happyShift action_21
action_127 (67) = happyShift action_22
action_127 (75) = happyShift action_23
action_127 (82) = happyShift action_24
action_127 (89) = happyShift action_25
action_127 (90) = happyShift action_26
action_127 (91) = happyShift action_27
action_127 (20) = happyGoto action_4
action_127 (21) = happyGoto action_5
action_127 (22) = happyGoto action_6
action_127 (23) = happyGoto action_7
action_127 (24) = happyGoto action_8
action_127 (25) = happyGoto action_9
action_127 (26) = happyGoto action_10
action_127 (27) = happyGoto action_132
action_127 (32) = happyGoto action_12
action_127 (36) = happyGoto action_13
action_127 _ = happyFail

action_128 (50) = happyShift action_14
action_128 (51) = happyShift action_15
action_128 (52) = happyShift action_16
action_128 (54) = happyShift action_17
action_128 (58) = happyShift action_18
action_128 (59) = happyShift action_19
action_128 (60) = happyShift action_20
action_128 (65) = happyShift action_21
action_128 (67) = happyShift action_22
action_128 (75) = happyShift action_23
action_128 (82) = happyShift action_24
action_128 (89) = happyShift action_25
action_128 (90) = happyShift action_26
action_128 (91) = happyShift action_27
action_128 (20) = happyGoto action_4
action_128 (21) = happyGoto action_5
action_128 (22) = happyGoto action_6
action_128 (23) = happyGoto action_7
action_128 (24) = happyGoto action_8
action_128 (25) = happyGoto action_9
action_128 (26) = happyGoto action_10
action_128 (27) = happyGoto action_131
action_128 (32) = happyGoto action_12
action_128 (36) = happyGoto action_13
action_128 _ = happyFail

action_129 _ = happyReduce_116

action_130 _ = happyReduce_61

action_131 (83) = happyShift action_180
action_131 _ = happyFail

action_132 _ = happyReduce_70

action_133 (50) = happyShift action_75
action_133 (53) = happyShift action_76
action_133 (54) = happyShift action_77
action_133 (57) = happyShift action_78
action_133 (61) = happyShift action_79
action_133 (62) = happyShift action_80
action_133 (63) = happyShift action_81
action_133 (64) = happyShift action_82
action_133 (75) = happyShift action_83
action_133 (90) = happyShift action_45
action_133 (35) = happyGoto action_178
action_133 (43) = happyGoto action_72
action_133 (44) = happyGoto action_179
action_133 (49) = happyGoto action_74
action_133 _ = happyReduce_82

action_134 _ = happyReduce_78

action_135 (86) = happyShift action_177
action_135 _ = happyFail

action_136 (50) = happyShift action_75
action_136 (53) = happyShift action_76
action_136 (54) = happyShift action_77
action_136 (57) = happyShift action_78
action_136 (61) = happyShift action_79
action_136 (62) = happyShift action_80
action_136 (63) = happyShift action_81
action_136 (64) = happyShift action_82
action_136 (75) = happyShift action_83
action_136 (90) = happyShift action_45
action_136 (43) = happyGoto action_72
action_136 (44) = happyGoto action_176
action_136 (49) = happyGoto action_74
action_136 _ = happyFail

action_137 (75) = happyShift action_175
action_137 _ = happyFail

action_138 _ = happyReduce_105

action_139 _ = happyReduce_106

action_140 (76) = happyShift action_174
action_140 (87) = happyShift action_136
action_140 _ = happyFail

action_141 (86) = happyShift action_173
action_141 _ = happyFail

action_142 (90) = happyShift action_172
action_142 _ = happyFail

action_143 _ = happyReduce_111

action_144 (50) = happyShift action_75
action_144 (53) = happyShift action_76
action_144 (54) = happyShift action_77
action_144 (57) = happyShift action_78
action_144 (61) = happyShift action_79
action_144 (62) = happyShift action_80
action_144 (63) = happyShift action_81
action_144 (64) = happyShift action_82
action_144 (74) = happyShift action_171
action_144 (75) = happyShift action_83
action_144 (90) = happyShift action_45
action_144 (43) = happyGoto action_72
action_144 (44) = happyGoto action_142
action_144 (45) = happyGoto action_170
action_144 (49) = happyGoto action_74
action_144 _ = happyFail

action_145 (76) = happyShift action_168
action_145 (87) = happyShift action_169
action_145 _ = happyFail

action_146 (50) = happyShift action_75
action_146 (53) = happyShift action_76
action_146 (54) = happyShift action_77
action_146 (57) = happyShift action_78
action_146 (61) = happyShift action_79
action_146 (62) = happyShift action_80
action_146 (63) = happyShift action_81
action_146 (64) = happyShift action_82
action_146 (75) = happyShift action_83
action_146 (90) = happyShift action_45
action_146 (43) = happyGoto action_72
action_146 (44) = happyGoto action_167
action_146 (49) = happyGoto action_74
action_146 _ = happyFail

action_147 (59) = happyShift action_105
action_147 (60) = happyShift action_106
action_147 (75) = happyShift action_107
action_147 (88) = happyShift action_108
action_147 (89) = happyShift action_109
action_147 (90) = happyShift action_110
action_147 (9) = happyGoto action_100
action_147 (11) = happyGoto action_101
action_147 (12) = happyGoto action_102
action_147 (13) = happyGoto action_165
action_147 (15) = happyGoto action_166
action_147 _ = happyReduce_19

action_148 (87) = happyShift action_164
action_148 (10) = happyGoto action_163
action_148 _ = happyFail

action_149 _ = happyReduce_35

action_150 (59) = happyShift action_105
action_150 (60) = happyShift action_106
action_150 (75) = happyShift action_107
action_150 (88) = happyShift action_108
action_150 (89) = happyShift action_109
action_150 (90) = happyShift action_110
action_150 (9) = happyGoto action_100
action_150 (11) = happyGoto action_101
action_150 (12) = happyGoto action_102
action_150 (15) = happyGoto action_162
action_150 _ = happyFail

action_151 _ = happyReduce_32

action_152 _ = happyReduce_34

action_153 (75) = happyShift action_38
action_153 (88) = happyShift action_39
action_153 (90) = happyShift action_40
action_153 (16) = happyGoto action_161
action_153 (18) = happyGoto action_36
action_153 (19) = happyGoto action_37
action_153 _ = happyFail

action_154 (50) = happyShift action_14
action_154 (51) = happyShift action_15
action_154 (52) = happyShift action_16
action_154 (54) = happyShift action_17
action_154 (58) = happyShift action_18
action_154 (59) = happyShift action_19
action_154 (60) = happyShift action_20
action_154 (65) = happyShift action_21
action_154 (67) = happyShift action_22
action_154 (75) = happyShift action_23
action_154 (82) = happyShift action_24
action_154 (89) = happyShift action_25
action_154 (90) = happyShift action_26
action_154 (91) = happyShift action_27
action_154 (5) = happyGoto action_66
action_154 (6) = happyGoto action_160
action_154 (7) = happyGoto action_68
action_154 (20) = happyGoto action_4
action_154 (21) = happyGoto action_5
action_154 (22) = happyGoto action_6
action_154 (23) = happyGoto action_7
action_154 (24) = happyGoto action_8
action_154 (25) = happyGoto action_9
action_154 (26) = happyGoto action_10
action_154 (27) = happyGoto action_11
action_154 (32) = happyGoto action_12
action_154 (36) = happyGoto action_13
action_154 _ = happyReduce_6

action_155 (68) = happyShift action_159
action_155 (28) = happyGoto action_157
action_155 (29) = happyGoto action_158
action_155 _ = happyFail

action_156 _ = happyReduce_9

action_157 (68) = happyShift action_159
action_157 (74) = happyShift action_196
action_157 (29) = happyGoto action_195
action_157 _ = happyFail

action_158 _ = happyReduce_66

action_159 (59) = happyShift action_105
action_159 (60) = happyShift action_106
action_159 (75) = happyShift action_107
action_159 (88) = happyShift action_108
action_159 (89) = happyShift action_109
action_159 (90) = happyShift action_110
action_159 (9) = happyGoto action_100
action_159 (11) = happyGoto action_101
action_159 (12) = happyGoto action_102
action_159 (15) = happyGoto action_194
action_159 _ = happyFail

action_160 (74) = happyShift action_193
action_160 _ = happyFail

action_161 _ = happyReduce_33

action_162 _ = happyReduce_21

action_163 (76) = happyShift action_191
action_163 (87) = happyShift action_192
action_163 _ = happyFail

action_164 (59) = happyShift action_105
action_164 (60) = happyShift action_106
action_164 (75) = happyShift action_107
action_164 (88) = happyShift action_108
action_164 (89) = happyShift action_109
action_164 (90) = happyShift action_110
action_164 (9) = happyGoto action_100
action_164 (11) = happyGoto action_101
action_164 (12) = happyGoto action_102
action_164 (15) = happyGoto action_190
action_164 _ = happyFail

action_165 (59) = happyShift action_105
action_165 (60) = happyShift action_106
action_165 (75) = happyShift action_107
action_165 (76) = happyShift action_189
action_165 (88) = happyShift action_108
action_165 (89) = happyShift action_109
action_165 (90) = happyShift action_110
action_165 (9) = happyGoto action_100
action_165 (11) = happyGoto action_101
action_165 (12) = happyGoto action_102
action_165 (15) = happyGoto action_188
action_165 _ = happyFail

action_166 _ = happyReduce_17

action_167 _ = happyReduce_96

action_168 _ = happyReduce_98

action_169 (50) = happyShift action_75
action_169 (53) = happyShift action_76
action_169 (54) = happyShift action_77
action_169 (57) = happyShift action_78
action_169 (61) = happyShift action_79
action_169 (62) = happyShift action_80
action_169 (63) = happyShift action_81
action_169 (64) = happyShift action_82
action_169 (75) = happyShift action_83
action_169 (90) = happyShift action_45
action_169 (43) = happyGoto action_72
action_169 (44) = happyGoto action_187
action_169 (49) = happyGoto action_74
action_169 _ = happyFail

action_170 _ = happyReduce_112

action_171 _ = happyReduce_107

action_172 (83) = happyShift action_186
action_172 _ = happyFail

action_173 (50) = happyShift action_75
action_173 (53) = happyShift action_76
action_173 (54) = happyShift action_77
action_173 (57) = happyShift action_78
action_173 (61) = happyShift action_79
action_173 (62) = happyShift action_80
action_173 (63) = happyShift action_81
action_173 (64) = happyShift action_82
action_173 (75) = happyShift action_83
action_173 (90) = happyShift action_45
action_173 (43) = happyGoto action_72
action_173 (44) = happyGoto action_185
action_173 (49) = happyGoto action_74
action_173 _ = happyFail

action_174 (86) = happyShift action_184
action_174 _ = happyFail

action_175 (50) = happyShift action_75
action_175 (53) = happyShift action_76
action_175 (54) = happyShift action_77
action_175 (57) = happyShift action_78
action_175 (61) = happyShift action_79
action_175 (62) = happyShift action_80
action_175 (63) = happyShift action_81
action_175 (64) = happyShift action_82
action_175 (75) = happyShift action_83
action_175 (90) = happyShift action_45
action_175 (41) = happyGoto action_183
action_175 (43) = happyGoto action_72
action_175 (44) = happyGoto action_118
action_175 (49) = happyGoto action_74
action_175 _ = happyReduce_95

action_176 _ = happyReduce_94

action_177 (50) = happyShift action_75
action_177 (53) = happyShift action_76
action_177 (54) = happyShift action_77
action_177 (57) = happyShift action_78
action_177 (61) = happyShift action_79
action_177 (62) = happyShift action_80
action_177 (63) = happyShift action_81
action_177 (64) = happyShift action_82
action_177 (75) = happyShift action_83
action_177 (90) = happyShift action_45
action_177 (43) = happyGoto action_72
action_177 (44) = happyGoto action_182
action_177 (49) = happyGoto action_74
action_177 _ = happyFail

action_178 (50) = happyShift action_75
action_178 (53) = happyShift action_76
action_178 (54) = happyShift action_77
action_178 (57) = happyShift action_78
action_178 (61) = happyShift action_79
action_178 (62) = happyShift action_80
action_178 (63) = happyShift action_81
action_178 (64) = happyShift action_82
action_178 (75) = happyShift action_83
action_178 (90) = happyShift action_45
action_178 (43) = happyGoto action_72
action_178 (44) = happyGoto action_181
action_178 (49) = happyGoto action_74
action_178 _ = happyReduce_79

action_179 _ = happyReduce_80

action_180 _ = happyReduce_114

action_181 _ = happyReduce_81

action_182 (83) = happyShift action_202
action_182 _ = happyFail

action_183 (76) = happyShift action_201
action_183 (87) = happyShift action_136
action_183 _ = happyFail

action_184 (50) = happyShift action_75
action_184 (53) = happyShift action_76
action_184 (54) = happyShift action_77
action_184 (57) = happyShift action_78
action_184 (61) = happyShift action_79
action_184 (62) = happyShift action_80
action_184 (63) = happyShift action_81
action_184 (64) = happyShift action_82
action_184 (75) = happyShift action_83
action_184 (90) = happyShift action_45
action_184 (43) = happyGoto action_72
action_184 (44) = happyGoto action_200
action_184 (49) = happyGoto action_74
action_184 _ = happyFail

action_185 _ = happyReduce_103

action_186 _ = happyReduce_110

action_187 _ = happyReduce_97

action_188 _ = happyReduce_18

action_189 _ = happyReduce_16

action_190 _ = happyReduce_13

action_191 _ = happyReduce_15

action_192 (59) = happyShift action_105
action_192 (60) = happyShift action_106
action_192 (75) = happyShift action_107
action_192 (88) = happyShift action_108
action_192 (89) = happyShift action_109
action_192 (90) = happyShift action_110
action_192 (9) = happyGoto action_100
action_192 (11) = happyGoto action_101
action_192 (12) = happyGoto action_102
action_192 (15) = happyGoto action_199
action_192 _ = happyFail

action_193 (66) = happyShift action_198
action_193 _ = happyFail

action_194 (70) = happyShift action_197
action_194 _ = happyFail

action_195 _ = happyReduce_67

action_196 _ = happyReduce_65

action_197 (50) = happyShift action_14
action_197 (51) = happyShift action_15
action_197 (52) = happyShift action_16
action_197 (54) = happyShift action_17
action_197 (58) = happyShift action_18
action_197 (59) = happyShift action_19
action_197 (60) = happyShift action_20
action_197 (65) = happyShift action_21
action_197 (67) = happyShift action_22
action_197 (75) = happyShift action_23
action_197 (82) = happyShift action_24
action_197 (89) = happyShift action_25
action_197 (90) = happyShift action_26
action_197 (91) = happyShift action_27
action_197 (5) = happyGoto action_210
action_197 (7) = happyGoto action_3
action_197 (20) = happyGoto action_4
action_197 (21) = happyGoto action_5
action_197 (22) = happyGoto action_6
action_197 (23) = happyGoto action_7
action_197 (24) = happyGoto action_8
action_197 (25) = happyGoto action_9
action_197 (26) = happyGoto action_10
action_197 (27) = happyGoto action_11
action_197 (32) = happyGoto action_12
action_197 (36) = happyGoto action_13
action_197 _ = happyFail

action_198 (73) = happyShift action_209
action_198 _ = happyFail

action_199 _ = happyReduce_14

action_200 _ = happyReduce_104

action_201 (86) = happyShift action_208
action_201 _ = happyFail

action_202 (75) = happyShift action_206
action_202 (90) = happyShift action_207
action_202 (37) = happyGoto action_203
action_202 (38) = happyGoto action_204
action_202 (39) = happyGoto action_205
action_202 _ = happyFail

action_203 (75) = happyShift action_206
action_203 (90) = happyShift action_207
action_203 (38) = happyGoto action_216
action_203 (39) = happyGoto action_205
action_203 _ = happyReduce_84

action_204 _ = happyReduce_85

action_205 (90) = happyShift action_215
action_205 _ = happyFail

action_206 (59) = happyShift action_105
action_206 (60) = happyShift action_106
action_206 (75) = happyShift action_107
action_206 (88) = happyShift action_108
action_206 (89) = happyShift action_109
action_206 (90) = happyShift action_110
action_206 (9) = happyGoto action_100
action_206 (11) = happyGoto action_101
action_206 (12) = happyGoto action_102
action_206 (15) = happyGoto action_214
action_206 _ = happyFail

action_207 (75) = happyShift action_213
action_207 _ = happyFail

action_208 (50) = happyShift action_75
action_208 (53) = happyShift action_76
action_208 (54) = happyShift action_77
action_208 (57) = happyShift action_78
action_208 (61) = happyShift action_79
action_208 (62) = happyShift action_80
action_208 (63) = happyShift action_81
action_208 (64) = happyShift action_82
action_208 (75) = happyShift action_83
action_208 (90) = happyShift action_45
action_208 (43) = happyGoto action_72
action_208 (44) = happyGoto action_212
action_208 (49) = happyGoto action_74
action_208 _ = happyFail

action_209 (50) = happyShift action_14
action_209 (51) = happyShift action_15
action_209 (52) = happyShift action_16
action_209 (54) = happyShift action_17
action_209 (58) = happyShift action_18
action_209 (59) = happyShift action_19
action_209 (60) = happyShift action_20
action_209 (65) = happyShift action_21
action_209 (67) = happyShift action_22
action_209 (75) = happyShift action_23
action_209 (82) = happyShift action_24
action_209 (89) = happyShift action_25
action_209 (90) = happyShift action_26
action_209 (91) = happyShift action_27
action_209 (5) = happyGoto action_66
action_209 (6) = happyGoto action_211
action_209 (7) = happyGoto action_68
action_209 (20) = happyGoto action_4
action_209 (21) = happyGoto action_5
action_209 (22) = happyGoto action_6
action_209 (23) = happyGoto action_7
action_209 (24) = happyGoto action_8
action_209 (25) = happyGoto action_9
action_209 (26) = happyGoto action_10
action_209 (27) = happyGoto action_11
action_209 (32) = happyGoto action_12
action_209 (36) = happyGoto action_13
action_209 _ = happyReduce_6

action_210 (50) = happyShift action_14
action_210 (51) = happyShift action_15
action_210 (52) = happyShift action_16
action_210 (54) = happyShift action_17
action_210 (58) = happyShift action_18
action_210 (59) = happyShift action_19
action_210 (60) = happyShift action_20
action_210 (65) = happyShift action_21
action_210 (67) = happyShift action_22
action_210 (75) = happyShift action_23
action_210 (82) = happyShift action_24
action_210 (89) = happyShift action_25
action_210 (90) = happyShift action_26
action_210 (91) = happyShift action_27
action_210 (7) = happyGoto action_55
action_210 (20) = happyGoto action_4
action_210 (21) = happyGoto action_5
action_210 (22) = happyGoto action_6
action_210 (23) = happyGoto action_7
action_210 (24) = happyGoto action_8
action_210 (25) = happyGoto action_9
action_210 (26) = happyGoto action_10
action_210 (27) = happyGoto action_11
action_210 (32) = happyGoto action_12
action_210 (36) = happyGoto action_13
action_210 _ = happyReduce_68

action_211 (74) = happyShift action_222
action_211 _ = happyFail

action_212 (83) = happyShift action_221
action_212 _ = happyFail

action_213 (59) = happyShift action_105
action_213 (60) = happyShift action_106
action_213 (75) = happyShift action_107
action_213 (88) = happyShift action_108
action_213 (89) = happyShift action_109
action_213 (90) = happyShift action_110
action_213 (9) = happyGoto action_100
action_213 (11) = happyGoto action_101
action_213 (12) = happyGoto action_102
action_213 (15) = happyGoto action_219
action_213 (40) = happyGoto action_220
action_213 _ = happyReduce_92

action_214 (76) = happyShift action_218
action_214 _ = happyFail

action_215 (75) = happyShift action_217
action_215 _ = happyFail

action_216 _ = happyReduce_86

action_217 (59) = happyShift action_105
action_217 (60) = happyShift action_106
action_217 (75) = happyShift action_107
action_217 (88) = happyShift action_108
action_217 (89) = happyShift action_109
action_217 (90) = happyShift action_110
action_217 (9) = happyGoto action_100
action_217 (11) = happyGoto action_101
action_217 (12) = happyGoto action_102
action_217 (15) = happyGoto action_219
action_217 (40) = happyGoto action_227
action_217 _ = happyReduce_92

action_218 (84) = happyShift action_226
action_218 _ = happyFail

action_219 _ = happyReduce_90

action_220 (76) = happyShift action_224
action_220 (87) = happyShift action_225
action_220 _ = happyFail

action_221 (75) = happyShift action_206
action_221 (90) = happyShift action_207
action_221 (37) = happyGoto action_223
action_221 (38) = happyGoto action_204
action_221 (39) = happyGoto action_205
action_221 _ = happyFail

action_222 _ = happyReduce_64

action_223 (75) = happyShift action_206
action_223 (90) = happyShift action_207
action_223 (38) = happyGoto action_216
action_223 (39) = happyGoto action_205
action_223 _ = happyReduce_83

action_224 (69) = happyShift action_230
action_224 _ = happyFail

action_225 (59) = happyShift action_105
action_225 (60) = happyShift action_106
action_225 (75) = happyShift action_107
action_225 (88) = happyShift action_108
action_225 (89) = happyShift action_109
action_225 (90) = happyShift action_110
action_225 (9) = happyGoto action_100
action_225 (11) = happyGoto action_101
action_225 (12) = happyGoto action_102
action_225 (15) = happyGoto action_229
action_225 _ = happyFail

action_226 _ = happyReduce_89

action_227 (76) = happyShift action_228
action_227 (87) = happyShift action_225
action_227 _ = happyFail

action_228 (69) = happyShift action_232
action_228 _ = happyFail

action_229 _ = happyReduce_91

action_230 (73) = happyShift action_231
action_230 _ = happyFail

action_231 (50) = happyShift action_14
action_231 (51) = happyShift action_15
action_231 (52) = happyShift action_16
action_231 (54) = happyShift action_17
action_231 (58) = happyShift action_18
action_231 (59) = happyShift action_19
action_231 (60) = happyShift action_20
action_231 (65) = happyShift action_21
action_231 (67) = happyShift action_22
action_231 (75) = happyShift action_23
action_231 (82) = happyShift action_24
action_231 (89) = happyShift action_25
action_231 (90) = happyShift action_26
action_231 (91) = happyShift action_27
action_231 (5) = happyGoto action_234
action_231 (7) = happyGoto action_3
action_231 (20) = happyGoto action_4
action_231 (21) = happyGoto action_5
action_231 (22) = happyGoto action_6
action_231 (23) = happyGoto action_7
action_231 (24) = happyGoto action_8
action_231 (25) = happyGoto action_9
action_231 (26) = happyGoto action_10
action_231 (27) = happyGoto action_11
action_231 (32) = happyGoto action_12
action_231 (36) = happyGoto action_13
action_231 _ = happyFail

action_232 (73) = happyShift action_233
action_232 _ = happyFail

action_233 (50) = happyShift action_14
action_233 (51) = happyShift action_15
action_233 (52) = happyShift action_16
action_233 (54) = happyShift action_17
action_233 (58) = happyShift action_18
action_233 (59) = happyShift action_19
action_233 (60) = happyShift action_20
action_233 (65) = happyShift action_21
action_233 (67) = happyShift action_22
action_233 (75) = happyShift action_23
action_233 (82) = happyShift action_24
action_233 (89) = happyShift action_25
action_233 (90) = happyShift action_26
action_233 (91) = happyShift action_27
action_233 (5) = happyGoto action_236
action_233 (7) = happyGoto action_3
action_233 (20) = happyGoto action_4
action_233 (21) = happyGoto action_5
action_233 (22) = happyGoto action_6
action_233 (23) = happyGoto action_7
action_233 (24) = happyGoto action_8
action_233 (25) = happyGoto action_9
action_233 (26) = happyGoto action_10
action_233 (27) = happyGoto action_11
action_233 (32) = happyGoto action_12
action_233 (36) = happyGoto action_13
action_233 _ = happyFail

action_234 (50) = happyShift action_14
action_234 (51) = happyShift action_15
action_234 (52) = happyShift action_16
action_234 (54) = happyShift action_17
action_234 (58) = happyShift action_18
action_234 (59) = happyShift action_19
action_234 (60) = happyShift action_20
action_234 (65) = happyShift action_21
action_234 (67) = happyShift action_22
action_234 (74) = happyShift action_235
action_234 (75) = happyShift action_23
action_234 (82) = happyShift action_24
action_234 (89) = happyShift action_25
action_234 (90) = happyShift action_26
action_234 (91) = happyShift action_27
action_234 (7) = happyGoto action_55
action_234 (20) = happyGoto action_4
action_234 (21) = happyGoto action_5
action_234 (22) = happyGoto action_6
action_234 (23) = happyGoto action_7
action_234 (24) = happyGoto action_8
action_234 (25) = happyGoto action_9
action_234 (26) = happyGoto action_10
action_234 (27) = happyGoto action_11
action_234 (32) = happyGoto action_12
action_234 (36) = happyGoto action_13
action_234 _ = happyFail

action_235 _ = happyReduce_88

action_236 (50) = happyShift action_14
action_236 (51) = happyShift action_15
action_236 (52) = happyShift action_16
action_236 (54) = happyShift action_17
action_236 (58) = happyShift action_18
action_236 (59) = happyShift action_19
action_236 (60) = happyShift action_20
action_236 (65) = happyShift action_21
action_236 (67) = happyShift action_22
action_236 (74) = happyShift action_237
action_236 (75) = happyShift action_23
action_236 (82) = happyShift action_24
action_236 (89) = happyShift action_25
action_236 (90) = happyShift action_26
action_236 (91) = happyShift action_27
action_236 (7) = happyGoto action_55
action_236 (20) = happyGoto action_4
action_236 (21) = happyGoto action_5
action_236 (22) = happyGoto action_6
action_236 (23) = happyGoto action_7
action_236 (24) = happyGoto action_8
action_236 (25) = happyGoto action_9
action_236 (26) = happyGoto action_10
action_236 (27) = happyGoto action_11
action_236 (32) = happyGoto action_12
action_236 (36) = happyGoto action_13
action_236 _ = happyFail

action_237 _ = happyReduce_87

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
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  8 happyReduction_8
happyReduction_8 (HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn8
		 ([happy_var_2]
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  9 happyReduction_10
happyReduction_10 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn9
		 (PatExpNumLiteral happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 _
	 =  HappyAbsSyn9
		 (PatExpBoolLiteral True
	)

happyReduce_12 = happySpecReduce_1  9 happyReduction_12
happyReduction_12 _
	 =  HappyAbsSyn9
		 (PatExpBoolLiteral False
	)

happyReduce_13 = happySpecReduce_2  10 happyReduction_13
happyReduction_13 (HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn10
		 ([happy_var_2]
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  10 happyReduction_14
happyReduction_14 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 4 11 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (PatExpTuple ([happy_var_2] ++ happy_var_3)
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 4 12 happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (PatExpAdt happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_1  13 happyReduction_17
happyReduction_17 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_2  13 happyReduction_18
happyReduction_18 (HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_0  13 happyReduction_19
happyReduction_19  =  HappyAbsSyn13
		 ([]
	)

happyReduce_20 = happySpecReduce_1  14 happyReduction_20
happyReduction_20 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  14 happyReduction_21
happyReduction_21 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_0  14 happyReduction_22
happyReduction_22  =  HappyAbsSyn14
		 ([]
	)

happyReduce_23 = happySpecReduce_1  15 happyReduction_23
happyReduction_23 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  15 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  15 happyReduction_25
happyReduction_25 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  15 happyReduction_26
happyReduction_26 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn15
		 (PatExpId happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  15 happyReduction_27
happyReduction_27 _
	 =  HappyAbsSyn15
		 (PatExpWildcard
	)

happyReduce_28 = happySpecReduce_1  16 happyReduction_28
happyReduction_28 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  16 happyReduction_29
happyReduction_29 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  16 happyReduction_30
happyReduction_30 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn16
		 (PatExpId happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  16 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn16
		 (PatExpWildcard
	)

happyReduce_32 = happySpecReduce_2  17 happyReduction_32
happyReduction_32 (HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn17
		 ([happy_var_2]
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  17 happyReduction_33
happyReduction_33 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happyReduce 4 18 happyReduction_34
happyReduction_34 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (PatExpTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_35 = happyReduce 4 19 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (PatExpAdt happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_36 = happySpecReduce_3  20 happyReduction_36
happyReduction_36 _
	(HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (happy_var_2
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happyReduce 4 20 happyReduction_37
happyReduction_37 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_38 = happySpecReduce_2  20 happyReduction_38
happyReduction_38 _
	_
	 =  HappyAbsSyn20
		 (ExpUnit
	)

happyReduce_39 = happyReduce 4 20 happyReduction_39
happyReduction_39 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	(HappyAbsSyn27  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (ExpTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn20
		 (ExpNum happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn20
		 (ExpBool True
	)

happyReduce_42 = happySpecReduce_1  20 happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn20
		 (ExpBool False
	)

happyReduce_43 = happySpecReduce_1  20 happyReduction_43
happyReduction_43 (HappyTerminal (Token _ (TokenString happy_var_1)))
	 =  HappyAbsSyn20
		 (ExpString happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  20 happyReduction_44
happyReduction_44 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn20
		 (ExpRef happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  21 happyReduction_45
happyReduction_45 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  21 happyReduction_46
happyReduction_46 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happyReduce 4 22 happyReduction_47
happyReduction_47 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_48 = happySpecReduce_1  22 happyReduction_48
happyReduction_48 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  23 happyReduction_49
happyReduction_49 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  23 happyReduction_50
happyReduction_50 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  24 happyReduction_51
happyReduction_51 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  24 happyReduction_52
happyReduction_52 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  25 happyReduction_53
happyReduction_53 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn25
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  25 happyReduction_54
happyReduction_54 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  26 happyReduction_55
happyReduction_55 (HappyAbsSyn25  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  26 happyReduction_56
happyReduction_56 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_2  27 happyReduction_57
happyReduction_57 (HappyAbsSyn26  happy_var_2)
	_
	 =  HappyAbsSyn27
		 (ExpNot happy_var_2
	)
happyReduction_57 _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  27 happyReduction_58
happyReduction_58 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_2  27 happyReduction_59
happyReduction_59 (HappyAbsSyn49  happy_var_2)
	_
	 =  HappyAbsSyn27
		 (ExpImport happy_var_2
	)
happyReduction_59 _ _  = notHappyAtAll 

happyReduce_60 = happyReduce 4 27 happyReduction_60
happyReduction_60 ((HappyAbsSyn27  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpAssign happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_61 = happyReduce 4 27 happyReduction_61
happyReduction_61 (_ `HappyStk`
	(HappyAbsSyn48  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpStruct happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_62 = happySpecReduce_1  27 happyReduction_62
happyReduction_62 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn27
		 (ExpTypeDec happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  27 happyReduction_63
happyReduction_63 (HappyAbsSyn36  happy_var_1)
	 =  HappyAbsSyn27
		 (ExpFunDec happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happyReduce 11 27 happyReduction_64
happyReduction_64 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpIfElse happy_var_3 happy_var_6 happy_var_10
	) `HappyStk` happyRest

happyReduce_65 = happyReduce 7 27 happyReduction_65
happyReduction_65 (_ `HappyStk`
	(HappyAbsSyn28  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpSwitch happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_66 = happySpecReduce_1  28 happyReduction_66
happyReduction_66 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1]
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  28 happyReduction_67
happyReduction_67 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happyReduce 4 29 happyReduction_68
happyReduction_68 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (CaseClause happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_69 = happySpecReduce_1  30 happyReduction_69
happyReduction_69 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn30
		 ([happy_var_1]
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  30 happyReduction_70
happyReduction_70 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_0  30 happyReduction_71
happyReduction_71  =  HappyAbsSyn30
		 ([]
	)

happyReduce_72 = happySpecReduce_1  31 happyReduction_72
happyReduction_72 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn31
		 ([happy_var_1]
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  31 happyReduction_73
happyReduction_73 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_0  31 happyReduction_74
happyReduction_74  =  HappyAbsSyn31
		 ([]
	)

happyReduce_75 = happyReduce 4 32 happyReduction_75
happyReduction_75 ((HappyAbsSyn44  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_76 = happyReduce 4 32 happyReduction_76
happyReduction_76 ((HappyAbsSyn33  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_77 = happySpecReduce_1  33 happyReduction_77
happyReduction_77 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn33
		 ([happy_var_1]
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_2  33 happyReduction_78
happyReduction_78 (HappyAbsSyn34  happy_var_2)
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_78 _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_3  34 happyReduction_79
happyReduction_79 (HappyAbsSyn35  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn34
		 (AdtAlternative happy_var_2 0 happy_var_3
	)
happyReduction_79 _ _ _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  35 happyReduction_80
happyReduction_80 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn35
		 ([happy_var_1]
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_2  35 happyReduction_81
happyReduction_81 (HappyAbsSyn44  happy_var_2)
	(HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn35
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_81 _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_0  35 happyReduction_82
happyReduction_82  =  HappyAbsSyn35
		 ([]
	)

happyReduce_83 = happyReduce 12 36 happyReduction_83
happyReduction_83 ((HappyAbsSyn37  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn44  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn41  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn44  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn36
		 (FunDecInstFun happy_var_5 happy_var_3 (TyArrow happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_84 = happyReduce 9 36 happyReduction_84
happyReduction_84 ((HappyAbsSyn37  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn44  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn41  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn36
		 (FunDecFun happy_var_2 (TyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_85 = happySpecReduce_1  37 happyReduction_85
happyReduction_85 (HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn37
		 ([happy_var_1]
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_2  37 happyReduction_86
happyReduction_86 (HappyAbsSyn38  happy_var_2)
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn37
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_86 _ _  = notHappyAtAll 

happyReduce_87 = happyReduce 9 38 happyReduction_87
happyReduction_87 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn40  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn39  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn38
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_88 = happyReduce 8 38 happyReduction_88
happyReduction_88 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn40  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn38
		 (FunDefFun happy_var_1 happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_89 = happyReduce 4 39 happyReduction_89
happyReduction_89 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn39
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_90 = happySpecReduce_1  40 happyReduction_90
happyReduction_90 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn40
		 ([happy_var_1]
	)
happyReduction_90 _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_3  40 happyReduction_91
happyReduction_91 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn40
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_91 _ _ _  = notHappyAtAll 

happyReduce_92 = happySpecReduce_0  40 happyReduction_92
happyReduction_92  =  HappyAbsSyn40
		 ([]
	)

happyReduce_93 = happySpecReduce_1  41 happyReduction_93
happyReduction_93 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn41
		 ([happy_var_1]
	)
happyReduction_93 _  = notHappyAtAll 

happyReduce_94 = happySpecReduce_3  41 happyReduction_94
happyReduction_94 (HappyAbsSyn44  happy_var_3)
	_
	(HappyAbsSyn41  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_94 _ _ _  = notHappyAtAll 

happyReduce_95 = happySpecReduce_0  41 happyReduction_95
happyReduction_95  =  HappyAbsSyn41
		 ([]
	)

happyReduce_96 = happySpecReduce_2  42 happyReduction_96
happyReduction_96 (HappyAbsSyn44  happy_var_2)
	_
	 =  HappyAbsSyn42
		 ([happy_var_2]
	)
happyReduction_96 _ _  = notHappyAtAll 

happyReduce_97 = happySpecReduce_3  42 happyReduction_97
happyReduction_97 (HappyAbsSyn44  happy_var_3)
	_
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn42
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_97 _ _ _  = notHappyAtAll 

happyReduce_98 = happyReduce 4 43 happyReduction_98
happyReduction_98 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_3) `HappyStk`
	(HappyAbsSyn44  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn43
		 (TyTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_99 = happySpecReduce_1  44 happyReduction_99
happyReduction_99 _
	 =  HappyAbsSyn44
		 (TyInt
	)

happyReduce_100 = happySpecReduce_1  44 happyReduction_100
happyReduction_100 _
	 =  HappyAbsSyn44
		 (TyBool
	)

happyReduce_101 = happySpecReduce_1  44 happyReduction_101
happyReduction_101 _
	 =  HappyAbsSyn44
		 (TyString
	)

happyReduce_102 = happySpecReduce_1  44 happyReduction_102
happyReduction_102 _
	 =  HappyAbsSyn44
		 (TyUnit
	)

happyReduce_103 = happyReduce 5 44 happyReduction_103
happyReduction_103 ((HappyAbsSyn44  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn44
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_104 = happyReduce 6 44 happyReduction_104
happyReduction_104 ((HappyAbsSyn44  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn41  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn44
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_105 = happySpecReduce_3  44 happyReduction_105
happyReduction_105 _
	_
	_
	 =  HappyAbsSyn44
		 (TyModule
	)

happyReduce_106 = happySpecReduce_3  44 happyReduction_106
happyReduction_106 _
	_
	_
	 =  HappyAbsSyn44
		 (TyInterface
	)

happyReduce_107 = happyReduce 4 44 happyReduction_107
happyReduction_107 (_ `HappyStk`
	(HappyAbsSyn46  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn44
		 (TyStruct happy_var_3
	) `HappyStk` happyRest

happyReduce_108 = happySpecReduce_1  44 happyReduction_108
happyReduction_108 (HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn44
		 (happy_var_1
	)
happyReduction_108 _  = notHappyAtAll 

happyReduce_109 = happySpecReduce_1  44 happyReduction_109
happyReduction_109 (HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn44
		 (TyRef happy_var_1
	)
happyReduction_109 _  = notHappyAtAll 

happyReduce_110 = happySpecReduce_3  45 happyReduction_110
happyReduction_110 _
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn45
		 ((happy_var_2, happy_var_1)
	)
happyReduction_110 _ _ _  = notHappyAtAll 

happyReduce_111 = happySpecReduce_1  46 happyReduction_111
happyReduction_111 (HappyAbsSyn45  happy_var_1)
	 =  HappyAbsSyn46
		 ([happy_var_1]
	)
happyReduction_111 _  = notHappyAtAll 

happyReduce_112 = happySpecReduce_2  46 happyReduction_112
happyReduction_112 (HappyAbsSyn45  happy_var_2)
	(HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn46
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_112 _ _  = notHappyAtAll 

happyReduce_113 = happySpecReduce_0  46 happyReduction_113
happyReduction_113  =  HappyAbsSyn46
		 ([]
	)

happyReduce_114 = happyReduce 4 47 happyReduction_114
happyReduction_114 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn47
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_115 = happySpecReduce_1  48 happyReduction_115
happyReduction_115 (HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn48
		 ([happy_var_1]
	)
happyReduction_115 _  = notHappyAtAll 

happyReduce_116 = happySpecReduce_2  48 happyReduction_116
happyReduction_116 (HappyAbsSyn47  happy_var_2)
	(HappyAbsSyn48  happy_var_1)
	 =  HappyAbsSyn48
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_116 _ _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_0  48 happyReduction_117
happyReduction_117  =  HappyAbsSyn48
		 ([]
	)

happyReduce_118 = happySpecReduce_1  49 happyReduction_118
happyReduction_118 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn49
		 (Id happy_var_1
	)
happyReduction_118 _  = notHappyAtAll 

happyReduce_119 = happySpecReduce_3  49 happyReduction_119
happyReduction_119 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn49
		 (Path happy_var_1 happy_var_3
	)
happyReduction_119 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 92 92 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 50;
	Token _ TokenImport -> cont 51;
	Token _ TokenType -> cont 52;
	Token _ TokenInterface -> cont 53;
	Token _ TokenFun -> cont 54;
	Token _ TokenImp -> cont 55;
	Token _ TokenTest -> cont 56;
	Token _ TokenStruct -> cont 57;
	Token _ TokenDef -> cont 58;
	Token _ TokenTrue -> cont 59;
	Token _ TokenFalse -> cont 60;
	Token _ TokenInt -> cont 61;
	Token _ TokenBool -> cont 62;
	Token _ TokenStringTy -> cont 63;
	Token _ TokenUnit -> cont 64;
	Token _ TokenIf -> cont 65;
	Token _ TokenElse -> cont 66;
	Token _ TokenSwitch -> cont 67;
	Token _ TokenCase -> cont 68;
	Token _ TokenAssign -> cont 69;
	Token _ TokenArrow -> cont 70;
	Token _ TokenLBracket -> cont 71;
	Token _ TokenRBracket -> cont 72;
	Token _ TokenLBrace -> cont 73;
	Token _ TokenRBrace -> cont 74;
	Token _ TokenLParen -> cont 75;
	Token _ TokenRParen -> cont 76;
	Token _ TokenPipe -> cont 77;
	Token _ TokenPlus -> cont 78;
	Token _ TokenMinus -> cont 79;
	Token _ TokenStar -> cont 80;
	Token _ TokenFSlash -> cont 81;
	Token _ TokenExclamation -> cont 82;
	Token _ TokenSemi -> cont 83;
	Token _ TokenDot -> cont 84;
	Token _ TokenEq -> cont 85;
	Token _ TokenColon -> cont 86;
	Token _ TokenComma -> cont 87;
	Token _ TokenUnderscore -> cont 88;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 89;
	Token _ (TokenId happy_dollar_dollar) -> cont 90;
	Token _ (TokenString happy_dollar_dollar) -> cont 91;
	_ -> happyError' tk
	})

happyError_ 92 tk = happyError' tk
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

