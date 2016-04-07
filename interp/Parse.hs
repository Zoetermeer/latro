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
action_0 (48) = happyShift action_20
action_0 (55) = happyShift action_21
action_0 (61) = happyShift action_22
action_0 (62) = happyShift action_23
action_0 (4) = happyGoto action_24
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
action_1 (48) = happyShift action_20
action_1 (55) = happyShift action_21
action_1 (61) = happyShift action_22
action_1 (62) = happyShift action_23
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
action_2 (48) = happyShift action_20
action_2 (55) = happyShift action_21
action_2 (61) = happyShift action_22
action_2 (62) = happyShift action_23
action_2 (7) = happyGoto action_42
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

action_6 (48) = happyShift action_40
action_6 (57) = happyShift action_41
action_6 _ = happyReduce_18

action_7 (53) = happyShift action_39
action_7 _ = happyReduce_20

action_8 (54) = happyShift action_38
action_8 _ = happyReduce_22

action_9 (51) = happyShift action_37
action_9 _ = happyReduce_24

action_10 (52) = happyShift action_36
action_10 _ = happyReduce_26

action_11 (56) = happyShift action_35
action_11 _ = happyFail

action_12 _ = happyReduce_29

action_13 _ = happyReduce_30

action_14 (46) = happyShift action_34
action_14 _ = happyFail

action_15 (62) = happyShift action_33
action_15 (30) = happyGoto action_32
action_15 _ = happyFail

action_16 (62) = happyShift action_31
action_16 _ = happyFail

action_17 (48) = happyShift action_29
action_17 (62) = happyShift action_30
action_17 _ = happyFail

action_18 _ = happyReduce_10

action_19 _ = happyReduce_11

action_20 (31) = happyShift action_14
action_20 (32) = happyShift action_15
action_20 (33) = happyShift action_16
action_20 (35) = happyShift action_17
action_20 (38) = happyShift action_18
action_20 (39) = happyShift action_19
action_20 (48) = happyShift action_20
action_20 (55) = happyShift action_21
action_20 (61) = happyShift action_22
action_20 (62) = happyShift action_23
action_20 (8) = happyGoto action_4
action_20 (9) = happyGoto action_5
action_20 (10) = happyGoto action_6
action_20 (11) = happyGoto action_7
action_20 (12) = happyGoto action_8
action_20 (13) = happyGoto action_9
action_20 (14) = happyGoto action_10
action_20 (15) = happyGoto action_28
action_20 (18) = happyGoto action_12
action_20 (22) = happyGoto action_13
action_20 _ = happyFail

action_21 (38) = happyShift action_18
action_21 (39) = happyShift action_19
action_21 (48) = happyShift action_20
action_21 (61) = happyShift action_22
action_21 (62) = happyShift action_27
action_21 (8) = happyGoto action_4
action_21 (9) = happyGoto action_5
action_21 (10) = happyGoto action_6
action_21 (11) = happyGoto action_7
action_21 (12) = happyGoto action_8
action_21 (13) = happyGoto action_9
action_21 (14) = happyGoto action_26
action_21 _ = happyFail

action_22 _ = happyReduce_9

action_23 (43) = happyShift action_25
action_23 _ = happyReduce_12

action_24 (63) = happyAccept
action_24 _ = happyFail

action_25 (31) = happyShift action_14
action_25 (32) = happyShift action_15
action_25 (33) = happyShift action_16
action_25 (35) = happyShift action_17
action_25 (38) = happyShift action_18
action_25 (39) = happyShift action_19
action_25 (48) = happyShift action_20
action_25 (55) = happyShift action_21
action_25 (61) = happyShift action_22
action_25 (62) = happyShift action_23
action_25 (8) = happyGoto action_4
action_25 (9) = happyGoto action_5
action_25 (10) = happyGoto action_6
action_25 (11) = happyGoto action_7
action_25 (12) = happyGoto action_8
action_25 (13) = happyGoto action_9
action_25 (14) = happyGoto action_10
action_25 (15) = happyGoto action_65
action_25 (18) = happyGoto action_12
action_25 (22) = happyGoto action_13
action_25 _ = happyFail

action_26 (52) = happyShift action_36
action_26 _ = happyReduce_25

action_27 _ = happyReduce_12

action_28 (49) = happyShift action_64
action_28 _ = happyFail

action_29 (31) = happyShift action_58
action_29 (34) = happyShift action_59
action_29 (35) = happyShift action_60
action_29 (40) = happyShift action_61
action_29 (41) = happyShift action_62
action_29 (42) = happyShift action_63
action_29 (62) = happyShift action_33
action_29 (29) = happyGoto action_56
action_29 (30) = happyGoto action_57
action_29 _ = happyFail

action_30 (48) = happyShift action_55
action_30 _ = happyFail

action_31 (58) = happyShift action_54
action_31 _ = happyFail

action_32 (57) = happyShift action_53
action_32 _ = happyReduce_27

action_33 _ = happyReduce_68

action_34 (31) = happyShift action_14
action_34 (32) = happyShift action_15
action_34 (33) = happyShift action_16
action_34 (35) = happyShift action_17
action_34 (38) = happyShift action_18
action_34 (39) = happyShift action_19
action_34 (48) = happyShift action_20
action_34 (55) = happyShift action_21
action_34 (61) = happyShift action_22
action_34 (62) = happyShift action_23
action_34 (5) = happyGoto action_50
action_34 (6) = happyGoto action_51
action_34 (7) = happyGoto action_52
action_34 (8) = happyGoto action_4
action_34 (9) = happyGoto action_5
action_34 (10) = happyGoto action_6
action_34 (11) = happyGoto action_7
action_34 (12) = happyGoto action_8
action_34 (13) = happyGoto action_9
action_34 (14) = happyGoto action_10
action_34 (15) = happyGoto action_11
action_34 (18) = happyGoto action_12
action_34 (22) = happyGoto action_13
action_34 _ = happyReduce_6

action_35 _ = happyReduce_7

action_36 (38) = happyShift action_18
action_36 (39) = happyShift action_19
action_36 (48) = happyShift action_20
action_36 (61) = happyShift action_22
action_36 (62) = happyShift action_27
action_36 (8) = happyGoto action_4
action_36 (9) = happyGoto action_5
action_36 (10) = happyGoto action_6
action_36 (11) = happyGoto action_7
action_36 (12) = happyGoto action_8
action_36 (13) = happyGoto action_49
action_36 _ = happyFail

action_37 (38) = happyShift action_18
action_37 (39) = happyShift action_19
action_37 (48) = happyShift action_20
action_37 (61) = happyShift action_22
action_37 (62) = happyShift action_27
action_37 (8) = happyGoto action_4
action_37 (9) = happyGoto action_5
action_37 (10) = happyGoto action_6
action_37 (11) = happyGoto action_7
action_37 (12) = happyGoto action_48
action_37 _ = happyFail

action_38 (38) = happyShift action_18
action_38 (39) = happyShift action_19
action_38 (48) = happyShift action_20
action_38 (61) = happyShift action_22
action_38 (62) = happyShift action_27
action_38 (8) = happyGoto action_4
action_38 (9) = happyGoto action_5
action_38 (10) = happyGoto action_6
action_38 (11) = happyGoto action_47
action_38 _ = happyFail

action_39 (38) = happyShift action_18
action_39 (39) = happyShift action_19
action_39 (48) = happyShift action_20
action_39 (61) = happyShift action_22
action_39 (62) = happyShift action_27
action_39 (8) = happyGoto action_4
action_39 (9) = happyGoto action_5
action_39 (10) = happyGoto action_46
action_39 _ = happyFail

action_40 (31) = happyShift action_14
action_40 (32) = happyShift action_15
action_40 (33) = happyShift action_16
action_40 (35) = happyShift action_17
action_40 (38) = happyShift action_18
action_40 (39) = happyShift action_19
action_40 (48) = happyShift action_20
action_40 (55) = happyShift action_21
action_40 (61) = happyShift action_22
action_40 (62) = happyShift action_23
action_40 (8) = happyGoto action_4
action_40 (9) = happyGoto action_5
action_40 (10) = happyGoto action_6
action_40 (11) = happyGoto action_7
action_40 (12) = happyGoto action_8
action_40 (13) = happyGoto action_9
action_40 (14) = happyGoto action_10
action_40 (15) = happyGoto action_44
action_40 (16) = happyGoto action_45
action_40 (18) = happyGoto action_12
action_40 (22) = happyGoto action_13
action_40 _ = happyReduce_34

action_41 (62) = happyShift action_43
action_41 _ = happyFail

action_42 _ = happyReduce_3

action_43 _ = happyReduce_13

action_44 _ = happyReduce_32

action_45 (49) = happyShift action_79
action_45 (60) = happyShift action_80
action_45 _ = happyFail

action_46 (48) = happyShift action_40
action_46 (57) = happyShift action_41
action_46 _ = happyReduce_17

action_47 (53) = happyShift action_39
action_47 _ = happyReduce_19

action_48 (54) = happyShift action_38
action_48 _ = happyReduce_21

action_49 (51) = happyShift action_37
action_49 _ = happyReduce_23

action_50 (31) = happyShift action_14
action_50 (32) = happyShift action_15
action_50 (33) = happyShift action_16
action_50 (35) = happyShift action_17
action_50 (38) = happyShift action_18
action_50 (39) = happyShift action_19
action_50 (48) = happyShift action_20
action_50 (55) = happyShift action_21
action_50 (61) = happyShift action_22
action_50 (62) = happyShift action_23
action_50 (7) = happyGoto action_78
action_50 (8) = happyGoto action_4
action_50 (9) = happyGoto action_5
action_50 (10) = happyGoto action_6
action_50 (11) = happyGoto action_7
action_50 (12) = happyGoto action_8
action_50 (13) = happyGoto action_9
action_50 (14) = happyGoto action_10
action_50 (15) = happyGoto action_11
action_50 (18) = happyGoto action_12
action_50 (22) = happyGoto action_13
action_50 _ = happyFail

action_51 (47) = happyShift action_77
action_51 _ = happyFail

action_52 (47) = happyReduce_4
action_52 _ = happyReduce_2

action_53 (62) = happyShift action_76
action_53 _ = happyFail

action_54 (31) = happyShift action_58
action_54 (34) = happyShift action_59
action_54 (35) = happyShift action_60
action_54 (40) = happyShift action_61
action_54 (41) = happyShift action_62
action_54 (42) = happyShift action_63
action_54 (50) = happyShift action_75
action_54 (62) = happyShift action_33
action_54 (19) = happyGoto action_72
action_54 (20) = happyGoto action_73
action_54 (29) = happyGoto action_74
action_54 (30) = happyGoto action_57
action_54 _ = happyFail

action_55 (31) = happyShift action_58
action_55 (34) = happyShift action_59
action_55 (35) = happyShift action_60
action_55 (40) = happyShift action_61
action_55 (41) = happyShift action_62
action_55 (42) = happyShift action_63
action_55 (62) = happyShift action_33
action_55 (28) = happyGoto action_70
action_55 (29) = happyGoto action_71
action_55 (30) = happyGoto action_57
action_55 _ = happyReduce_59

action_56 (49) = happyShift action_69
action_56 _ = happyFail

action_57 (57) = happyShift action_53
action_57 _ = happyReduce_67

action_58 (46) = happyShift action_68
action_58 _ = happyFail

action_59 (46) = happyShift action_67
action_59 _ = happyFail

action_60 (48) = happyShift action_66
action_60 _ = happyFail

action_61 _ = happyReduce_60

action_62 _ = happyReduce_61

action_63 _ = happyReduce_62

action_64 _ = happyReduce_8

action_65 _ = happyReduce_28

action_66 (31) = happyShift action_58
action_66 (34) = happyShift action_59
action_66 (35) = happyShift action_60
action_66 (40) = happyShift action_61
action_66 (41) = happyShift action_62
action_66 (42) = happyShift action_63
action_66 (49) = happyShift action_90
action_66 (62) = happyShift action_33
action_66 (28) = happyGoto action_89
action_66 (29) = happyGoto action_71
action_66 (30) = happyGoto action_57
action_66 _ = happyReduce_59

action_67 (47) = happyShift action_88
action_67 _ = happyFail

action_68 (47) = happyShift action_87
action_68 _ = happyFail

action_69 (62) = happyShift action_86
action_69 _ = happyFail

action_70 (49) = happyShift action_84
action_70 (60) = happyShift action_85
action_70 _ = happyFail

action_71 _ = happyReduce_57

action_72 (50) = happyShift action_75
action_72 (20) = happyGoto action_83
action_72 _ = happyReduce_39

action_73 _ = happyReduce_40

action_74 _ = happyReduce_38

action_75 (62) = happyShift action_82
action_75 _ = happyFail

action_76 _ = happyReduce_69

action_77 _ = happyReduce_31

action_78 (47) = happyReduce_5
action_78 _ = happyReduce_3

action_79 _ = happyReduce_15

action_80 (31) = happyShift action_14
action_80 (32) = happyShift action_15
action_80 (33) = happyShift action_16
action_80 (35) = happyShift action_17
action_80 (38) = happyShift action_18
action_80 (39) = happyShift action_19
action_80 (48) = happyShift action_20
action_80 (55) = happyShift action_21
action_80 (61) = happyShift action_22
action_80 (62) = happyShift action_23
action_80 (8) = happyGoto action_4
action_80 (9) = happyGoto action_5
action_80 (10) = happyGoto action_6
action_80 (11) = happyGoto action_7
action_80 (12) = happyGoto action_8
action_80 (13) = happyGoto action_9
action_80 (14) = happyGoto action_10
action_80 (15) = happyGoto action_81
action_80 (18) = happyGoto action_12
action_80 (22) = happyGoto action_13
action_80 _ = happyFail

action_81 _ = happyReduce_33

action_82 (31) = happyShift action_58
action_82 (34) = happyShift action_59
action_82 (35) = happyShift action_60
action_82 (40) = happyShift action_61
action_82 (41) = happyShift action_62
action_82 (42) = happyShift action_63
action_82 (62) = happyShift action_33
action_82 (21) = happyGoto action_96
action_82 (29) = happyGoto action_97
action_82 (30) = happyGoto action_57
action_82 _ = happyReduce_45

action_83 _ = happyReduce_41

action_84 (59) = happyShift action_95
action_84 _ = happyFail

action_85 (31) = happyShift action_58
action_85 (34) = happyShift action_59
action_85 (35) = happyShift action_60
action_85 (40) = happyShift action_61
action_85 (41) = happyShift action_62
action_85 (42) = happyShift action_63
action_85 (62) = happyShift action_33
action_85 (29) = happyGoto action_94
action_85 (30) = happyGoto action_57
action_85 _ = happyFail

action_86 (48) = happyShift action_93
action_86 _ = happyFail

action_87 _ = happyReduce_65

action_88 _ = happyReduce_66

action_89 (49) = happyShift action_92
action_89 (60) = happyShift action_85
action_89 _ = happyFail

action_90 (59) = happyShift action_91
action_90 _ = happyFail

action_91 (31) = happyShift action_58
action_91 (34) = happyShift action_59
action_91 (35) = happyShift action_60
action_91 (40) = happyShift action_61
action_91 (41) = happyShift action_62
action_91 (42) = happyShift action_63
action_91 (62) = happyShift action_33
action_91 (29) = happyGoto action_102
action_91 (30) = happyGoto action_57
action_91 _ = happyFail

action_92 (59) = happyShift action_101
action_92 _ = happyFail

action_93 (31) = happyShift action_58
action_93 (34) = happyShift action_59
action_93 (35) = happyShift action_60
action_93 (40) = happyShift action_61
action_93 (41) = happyShift action_62
action_93 (42) = happyShift action_63
action_93 (62) = happyShift action_33
action_93 (28) = happyGoto action_100
action_93 (29) = happyGoto action_71
action_93 (30) = happyGoto action_57
action_93 _ = happyReduce_59

action_94 _ = happyReduce_58

action_95 (31) = happyShift action_58
action_95 (34) = happyShift action_59
action_95 (35) = happyShift action_60
action_95 (40) = happyShift action_61
action_95 (41) = happyShift action_62
action_95 (42) = happyShift action_63
action_95 (62) = happyShift action_33
action_95 (29) = happyGoto action_99
action_95 (30) = happyGoto action_57
action_95 _ = happyFail

action_96 (31) = happyShift action_58
action_96 (34) = happyShift action_59
action_96 (35) = happyShift action_60
action_96 (40) = happyShift action_61
action_96 (41) = happyShift action_62
action_96 (42) = happyShift action_63
action_96 (62) = happyShift action_33
action_96 (29) = happyGoto action_98
action_96 (30) = happyGoto action_57
action_96 _ = happyReduce_42

action_97 _ = happyReduce_43

action_98 _ = happyReduce_44

action_99 (56) = happyShift action_105
action_99 _ = happyFail

action_100 (49) = happyShift action_104
action_100 (60) = happyShift action_85
action_100 _ = happyFail

action_101 (31) = happyShift action_58
action_101 (34) = happyShift action_59
action_101 (35) = happyShift action_60
action_101 (40) = happyShift action_61
action_101 (41) = happyShift action_62
action_101 (42) = happyShift action_63
action_101 (62) = happyShift action_33
action_101 (29) = happyGoto action_103
action_101 (30) = happyGoto action_57
action_101 _ = happyFail

action_102 _ = happyReduce_63

action_103 _ = happyReduce_64

action_104 (59) = happyShift action_111
action_104 _ = happyFail

action_105 (48) = happyShift action_109
action_105 (62) = happyShift action_110
action_105 (23) = happyGoto action_106
action_105 (24) = happyGoto action_107
action_105 (25) = happyGoto action_108
action_105 _ = happyFail

action_106 (48) = happyShift action_109
action_106 (62) = happyShift action_110
action_106 (24) = happyGoto action_117
action_106 (25) = happyGoto action_108
action_106 _ = happyReduce_47

action_107 _ = happyReduce_48

action_108 (62) = happyShift action_116
action_108 _ = happyFail

action_109 (62) = happyShift action_115
action_109 (27) = happyGoto action_114
action_109 _ = happyFail

action_110 (48) = happyShift action_113
action_110 _ = happyFail

action_111 (31) = happyShift action_58
action_111 (34) = happyShift action_59
action_111 (35) = happyShift action_60
action_111 (40) = happyShift action_61
action_111 (41) = happyShift action_62
action_111 (42) = happyShift action_63
action_111 (62) = happyShift action_33
action_111 (29) = happyGoto action_112
action_111 (30) = happyGoto action_57
action_111 _ = happyFail

action_112 (56) = happyShift action_122
action_112 _ = happyFail

action_113 (62) = happyShift action_115
action_113 (26) = happyGoto action_120
action_113 (27) = happyGoto action_121
action_113 _ = happyReduce_55

action_114 (49) = happyShift action_119
action_114 _ = happyFail

action_115 _ = happyReduce_56

action_116 (48) = happyShift action_118
action_116 _ = happyFail

action_117 _ = happyReduce_49

action_118 (62) = happyShift action_115
action_118 (26) = happyGoto action_127
action_118 (27) = happyGoto action_121
action_118 _ = happyReduce_55

action_119 (57) = happyShift action_126
action_119 _ = happyFail

action_120 (49) = happyShift action_124
action_120 (60) = happyShift action_125
action_120 _ = happyFail

action_121 _ = happyReduce_53

action_122 (48) = happyShift action_109
action_122 (62) = happyShift action_110
action_122 (23) = happyGoto action_123
action_122 (24) = happyGoto action_107
action_122 (25) = happyGoto action_108
action_122 _ = happyFail

action_123 (48) = happyShift action_109
action_123 (62) = happyShift action_110
action_123 (24) = happyGoto action_117
action_123 (25) = happyGoto action_108
action_123 _ = happyReduce_46

action_124 (43) = happyShift action_130
action_124 _ = happyFail

action_125 (62) = happyShift action_115
action_125 (27) = happyGoto action_129
action_125 _ = happyFail

action_126 _ = happyReduce_52

action_127 (49) = happyShift action_128
action_127 (60) = happyShift action_125
action_127 _ = happyFail

action_128 (43) = happyShift action_132
action_128 _ = happyFail

action_129 _ = happyReduce_54

action_130 (46) = happyShift action_131
action_130 _ = happyFail

action_131 (31) = happyShift action_14
action_131 (32) = happyShift action_15
action_131 (33) = happyShift action_16
action_131 (35) = happyShift action_17
action_131 (38) = happyShift action_18
action_131 (39) = happyShift action_19
action_131 (48) = happyShift action_20
action_131 (55) = happyShift action_21
action_131 (61) = happyShift action_22
action_131 (62) = happyShift action_23
action_131 (5) = happyGoto action_134
action_131 (7) = happyGoto action_3
action_131 (8) = happyGoto action_4
action_131 (9) = happyGoto action_5
action_131 (10) = happyGoto action_6
action_131 (11) = happyGoto action_7
action_131 (12) = happyGoto action_8
action_131 (13) = happyGoto action_9
action_131 (14) = happyGoto action_10
action_131 (15) = happyGoto action_11
action_131 (18) = happyGoto action_12
action_131 (22) = happyGoto action_13
action_131 _ = happyFail

action_132 (46) = happyShift action_133
action_132 _ = happyFail

action_133 (31) = happyShift action_14
action_133 (32) = happyShift action_15
action_133 (33) = happyShift action_16
action_133 (35) = happyShift action_17
action_133 (38) = happyShift action_18
action_133 (39) = happyShift action_19
action_133 (48) = happyShift action_20
action_133 (55) = happyShift action_21
action_133 (61) = happyShift action_22
action_133 (62) = happyShift action_23
action_133 (5) = happyGoto action_136
action_133 (7) = happyGoto action_3
action_133 (8) = happyGoto action_4
action_133 (9) = happyGoto action_5
action_133 (10) = happyGoto action_6
action_133 (11) = happyGoto action_7
action_133 (12) = happyGoto action_8
action_133 (13) = happyGoto action_9
action_133 (14) = happyGoto action_10
action_133 (15) = happyGoto action_11
action_133 (18) = happyGoto action_12
action_133 (22) = happyGoto action_13
action_133 _ = happyFail

action_134 (31) = happyShift action_14
action_134 (32) = happyShift action_15
action_134 (33) = happyShift action_16
action_134 (35) = happyShift action_17
action_134 (38) = happyShift action_18
action_134 (39) = happyShift action_19
action_134 (47) = happyShift action_135
action_134 (48) = happyShift action_20
action_134 (55) = happyShift action_21
action_134 (61) = happyShift action_22
action_134 (62) = happyShift action_23
action_134 (7) = happyGoto action_42
action_134 (8) = happyGoto action_4
action_134 (9) = happyGoto action_5
action_134 (10) = happyGoto action_6
action_134 (11) = happyGoto action_7
action_134 (12) = happyGoto action_8
action_134 (13) = happyGoto action_9
action_134 (14) = happyGoto action_10
action_134 (15) = happyGoto action_11
action_134 (18) = happyGoto action_12
action_134 (22) = happyGoto action_13
action_134 _ = happyFail

action_135 _ = happyReduce_51

action_136 (31) = happyShift action_14
action_136 (32) = happyShift action_15
action_136 (33) = happyShift action_16
action_136 (35) = happyShift action_17
action_136 (38) = happyShift action_18
action_136 (39) = happyShift action_19
action_136 (47) = happyShift action_137
action_136 (48) = happyShift action_20
action_136 (55) = happyShift action_21
action_136 (61) = happyShift action_22
action_136 (62) = happyShift action_23
action_136 (7) = happyGoto action_42
action_136 (8) = happyGoto action_4
action_136 (9) = happyGoto action_5
action_136 (10) = happyGoto action_6
action_136 (11) = happyGoto action_7
action_136 (12) = happyGoto action_8
action_136 (13) = happyGoto action_9
action_136 (14) = happyGoto action_10
action_136 (15) = happyGoto action_11
action_136 (18) = happyGoto action_12
action_136 (22) = happyGoto action_13
action_136 _ = happyFail

action_137 _ = happyReduce_50

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

happyReduce_32 = happySpecReduce_1  16 happyReduction_32
happyReduction_32 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  16 happyReduction_33
happyReduction_33 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_0  16 happyReduction_34
happyReduction_34  =  HappyAbsSyn16
		 ([]
	)

happyReduce_35 = happySpecReduce_1  17 happyReduction_35
happyReduction_35 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  17 happyReduction_36
happyReduction_36 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_0  17 happyReduction_37
happyReduction_37  =  HappyAbsSyn17
		 ([]
	)

happyReduce_38 = happyReduce 4 18 happyReduction_38
happyReduction_38 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 4 18 happyReduction_39
happyReduction_39 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_40 = happySpecReduce_1  19 happyReduction_40
happyReduction_40 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_2  19 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_41 _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  20 happyReduction_42
happyReduction_42 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn20
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  21 happyReduction_43
happyReduction_43 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_2  21 happyReduction_44
happyReduction_44 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_0  21 happyReduction_45
happyReduction_45  =  HappyAbsSyn21
		 ([]
	)

happyReduce_46 = happyReduce 12 22 happyReduction_46
happyReduction_46 ((HappyAbsSyn23  happy_var_12) `HappyStk`
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

happyReduce_47 = happyReduce 9 22 happyReduction_47
happyReduction_47 ((HappyAbsSyn23  happy_var_9) `HappyStk`
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

happyReduce_48 = happySpecReduce_1  23 happyReduction_48
happyReduction_48 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_2  23 happyReduction_49
happyReduction_49 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_49 _ _  = notHappyAtAll 

happyReduce_50 = happyReduce 9 24 happyReduction_50
happyReduction_50 (_ `HappyStk`
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

happyReduce_51 = happyReduce 8 24 happyReduction_51
happyReduction_51 (_ `HappyStk`
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

happyReduce_52 = happyReduce 4 25 happyReduction_52
happyReduction_52 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_53 = happySpecReduce_1  26 happyReduction_53
happyReduction_53 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  26 happyReduction_54
happyReduction_54 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_0  26 happyReduction_55
happyReduction_55  =  HappyAbsSyn26
		 ([]
	)

happyReduce_56 = happySpecReduce_1  27 happyReduction_56
happyReduction_56 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn27
		 (PatExpVar happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  28 happyReduction_57
happyReduction_57 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1]
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  28 happyReduction_58
happyReduction_58 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_0  28 happyReduction_59
happyReduction_59  =  HappyAbsSyn28
		 ([]
	)

happyReduce_60 = happySpecReduce_1  29 happyReduction_60
happyReduction_60 _
	 =  HappyAbsSyn29
		 (TyInt
	)

happyReduce_61 = happySpecReduce_1  29 happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn29
		 (TyBool
	)

happyReduce_62 = happySpecReduce_1  29 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn29
		 (TyUnit
	)

happyReduce_63 = happyReduce 5 29 happyReduction_63
happyReduction_63 ((HappyAbsSyn29  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_64 = happyReduce 6 29 happyReduction_64
happyReduction_64 ((HappyAbsSyn29  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_65 = happySpecReduce_3  29 happyReduction_65
happyReduction_65 _
	_
	_
	 =  HappyAbsSyn29
		 (TyModule
	)

happyReduce_66 = happySpecReduce_3  29 happyReduction_66
happyReduction_66 _
	_
	_
	 =  HappyAbsSyn29
		 (TyInterface
	)

happyReduce_67 = happySpecReduce_1  29 happyReduction_67
happyReduction_67 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (TyRef happy_var_1
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  30 happyReduction_68
happyReduction_68 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn30
		 (Id happy_var_1
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  30 happyReduction_69
happyReduction_69 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (Path happy_var_1 happy_var_3
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 63 63 tk (HappyState action) sts stk;
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
	Token _ TokenAssign -> cont 43;
	Token _ TokenLBracket -> cont 44;
	Token _ TokenRBracket -> cont 45;
	Token _ TokenLBrace -> cont 46;
	Token _ TokenRBrace -> cont 47;
	Token _ TokenLParen -> cont 48;
	Token _ TokenRParen -> cont 49;
	Token _ TokenPipe -> cont 50;
	Token _ TokenPlus -> cont 51;
	Token _ TokenMinus -> cont 52;
	Token _ TokenStar -> cont 53;
	Token _ TokenFSlash -> cont 54;
	Token _ TokenExclamation -> cont 55;
	Token _ TokenSemi -> cont 56;
	Token _ TokenDot -> cont 57;
	Token _ TokenEq -> cont 58;
	Token _ TokenColon -> cont 59;
	Token _ TokenComma -> cont 60;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 61;
	Token _ (TokenId happy_dollar_dollar) -> cont 62;
	_ -> happyError' tk
	})

happyError_ 63 tk = happyError' tk
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

