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
action_2 (7) = happyGoto action_45
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

action_4 _ = happyReduce_16

action_5 _ = happyReduce_18

action_6 (50) = happyShift action_43
action_6 (59) = happyShift action_44
action_6 _ = happyReduce_20

action_7 (55) = happyShift action_42
action_7 _ = happyReduce_22

action_8 (56) = happyShift action_41
action_8 _ = happyReduce_24

action_9 (53) = happyShift action_40
action_9 _ = happyReduce_26

action_10 (54) = happyShift action_39
action_10 _ = happyReduce_28

action_11 (58) = happyShift action_38
action_11 _ = happyFail

action_12 _ = happyReduce_31

action_13 _ = happyReduce_32

action_14 (48) = happyShift action_37
action_14 _ = happyFail

action_15 (64) = happyShift action_36
action_15 (30) = happyGoto action_35
action_15 _ = happyFail

action_16 (64) = happyShift action_34
action_16 _ = happyFail

action_17 (50) = happyShift action_32
action_17 (64) = happyShift action_33
action_17 _ = happyFail

action_18 _ = happyReduce_12

action_19 _ = happyReduce_13

action_20 (50) = happyShift action_31
action_20 _ = happyFail

action_21 (31) = happyShift action_14
action_21 (32) = happyShift action_15
action_21 (33) = happyShift action_16
action_21 (35) = happyShift action_17
action_21 (38) = happyShift action_18
action_21 (39) = happyShift action_19
action_21 (43) = happyShift action_20
action_21 (50) = happyShift action_21
action_21 (51) = happyShift action_30
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

action_22 (31) = happyShift action_14
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

action_23 _ = happyReduce_11

action_24 (45) = happyShift action_26
action_24 _ = happyReduce_14

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
action_26 (15) = happyGoto action_69
action_26 (18) = happyGoto action_12
action_26 (22) = happyGoto action_13
action_26 _ = happyFail

action_27 (54) = happyShift action_39
action_27 _ = happyReduce_27

action_28 _ = happyReduce_14

action_29 (51) = happyShift action_68
action_29 _ = happyFail

action_30 _ = happyReduce_10

action_31 (31) = happyShift action_14
action_31 (32) = happyShift action_15
action_31 (33) = happyShift action_16
action_31 (35) = happyShift action_17
action_31 (38) = happyShift action_18
action_31 (39) = happyShift action_19
action_31 (43) = happyShift action_20
action_31 (50) = happyShift action_21
action_31 (57) = happyShift action_22
action_31 (63) = happyShift action_23
action_31 (64) = happyShift action_24
action_31 (8) = happyGoto action_4
action_31 (9) = happyGoto action_5
action_31 (10) = happyGoto action_6
action_31 (11) = happyGoto action_7
action_31 (12) = happyGoto action_8
action_31 (13) = happyGoto action_9
action_31 (14) = happyGoto action_10
action_31 (15) = happyGoto action_67
action_31 (18) = happyGoto action_12
action_31 (22) = happyGoto action_13
action_31 _ = happyFail

action_32 (31) = happyShift action_61
action_32 (34) = happyShift action_62
action_32 (35) = happyShift action_63
action_32 (40) = happyShift action_64
action_32 (41) = happyShift action_65
action_32 (42) = happyShift action_66
action_32 (64) = happyShift action_36
action_32 (29) = happyGoto action_59
action_32 (30) = happyGoto action_60
action_32 _ = happyFail

action_33 (50) = happyShift action_58
action_33 _ = happyFail

action_34 (60) = happyShift action_57
action_34 _ = happyFail

action_35 (59) = happyShift action_56
action_35 _ = happyReduce_29

action_36 _ = happyReduce_70

action_37 (31) = happyShift action_14
action_37 (32) = happyShift action_15
action_37 (33) = happyShift action_16
action_37 (35) = happyShift action_17
action_37 (38) = happyShift action_18
action_37 (39) = happyShift action_19
action_37 (43) = happyShift action_20
action_37 (50) = happyShift action_21
action_37 (57) = happyShift action_22
action_37 (63) = happyShift action_23
action_37 (64) = happyShift action_24
action_37 (5) = happyGoto action_53
action_37 (6) = happyGoto action_54
action_37 (7) = happyGoto action_55
action_37 (8) = happyGoto action_4
action_37 (9) = happyGoto action_5
action_37 (10) = happyGoto action_6
action_37 (11) = happyGoto action_7
action_37 (12) = happyGoto action_8
action_37 (13) = happyGoto action_9
action_37 (14) = happyGoto action_10
action_37 (15) = happyGoto action_11
action_37 (18) = happyGoto action_12
action_37 (22) = happyGoto action_13
action_37 _ = happyReduce_6

action_38 _ = happyReduce_7

action_39 (31) = happyShift action_14
action_39 (38) = happyShift action_18
action_39 (39) = happyShift action_19
action_39 (50) = happyShift action_21
action_39 (63) = happyShift action_23
action_39 (64) = happyShift action_28
action_39 (8) = happyGoto action_4
action_39 (9) = happyGoto action_5
action_39 (10) = happyGoto action_6
action_39 (11) = happyGoto action_7
action_39 (12) = happyGoto action_8
action_39 (13) = happyGoto action_52
action_39 _ = happyFail

action_40 (31) = happyShift action_14
action_40 (38) = happyShift action_18
action_40 (39) = happyShift action_19
action_40 (50) = happyShift action_21
action_40 (63) = happyShift action_23
action_40 (64) = happyShift action_28
action_40 (8) = happyGoto action_4
action_40 (9) = happyGoto action_5
action_40 (10) = happyGoto action_6
action_40 (11) = happyGoto action_7
action_40 (12) = happyGoto action_51
action_40 _ = happyFail

action_41 (31) = happyShift action_14
action_41 (38) = happyShift action_18
action_41 (39) = happyShift action_19
action_41 (50) = happyShift action_21
action_41 (63) = happyShift action_23
action_41 (64) = happyShift action_28
action_41 (8) = happyGoto action_4
action_41 (9) = happyGoto action_5
action_41 (10) = happyGoto action_6
action_41 (11) = happyGoto action_50
action_41 _ = happyFail

action_42 (31) = happyShift action_14
action_42 (38) = happyShift action_18
action_42 (39) = happyShift action_19
action_42 (50) = happyShift action_21
action_42 (63) = happyShift action_23
action_42 (64) = happyShift action_28
action_42 (8) = happyGoto action_4
action_42 (9) = happyGoto action_5
action_42 (10) = happyGoto action_49
action_42 _ = happyFail

action_43 (31) = happyShift action_14
action_43 (32) = happyShift action_15
action_43 (33) = happyShift action_16
action_43 (35) = happyShift action_17
action_43 (38) = happyShift action_18
action_43 (39) = happyShift action_19
action_43 (43) = happyShift action_20
action_43 (50) = happyShift action_21
action_43 (57) = happyShift action_22
action_43 (63) = happyShift action_23
action_43 (64) = happyShift action_24
action_43 (8) = happyGoto action_4
action_43 (9) = happyGoto action_5
action_43 (10) = happyGoto action_6
action_43 (11) = happyGoto action_7
action_43 (12) = happyGoto action_8
action_43 (13) = happyGoto action_9
action_43 (14) = happyGoto action_10
action_43 (15) = happyGoto action_47
action_43 (16) = happyGoto action_48
action_43 (18) = happyGoto action_12
action_43 (22) = happyGoto action_13
action_43 _ = happyReduce_36

action_44 (64) = happyShift action_46
action_44 _ = happyFail

action_45 _ = happyReduce_3

action_46 _ = happyReduce_15

action_47 _ = happyReduce_34

action_48 (51) = happyShift action_84
action_48 (62) = happyShift action_85
action_48 _ = happyFail

action_49 (50) = happyShift action_43
action_49 (59) = happyShift action_44
action_49 _ = happyReduce_19

action_50 (55) = happyShift action_42
action_50 _ = happyReduce_21

action_51 (56) = happyShift action_41
action_51 _ = happyReduce_23

action_52 (53) = happyShift action_40
action_52 _ = happyReduce_25

action_53 (31) = happyShift action_14
action_53 (32) = happyShift action_15
action_53 (33) = happyShift action_16
action_53 (35) = happyShift action_17
action_53 (38) = happyShift action_18
action_53 (39) = happyShift action_19
action_53 (43) = happyShift action_20
action_53 (50) = happyShift action_21
action_53 (57) = happyShift action_22
action_53 (63) = happyShift action_23
action_53 (64) = happyShift action_24
action_53 (7) = happyGoto action_83
action_53 (8) = happyGoto action_4
action_53 (9) = happyGoto action_5
action_53 (10) = happyGoto action_6
action_53 (11) = happyGoto action_7
action_53 (12) = happyGoto action_8
action_53 (13) = happyGoto action_9
action_53 (14) = happyGoto action_10
action_53 (15) = happyGoto action_11
action_53 (18) = happyGoto action_12
action_53 (22) = happyGoto action_13
action_53 _ = happyFail

action_54 (49) = happyShift action_82
action_54 _ = happyFail

action_55 (49) = happyReduce_4
action_55 _ = happyReduce_2

action_56 (64) = happyShift action_81
action_56 _ = happyFail

action_57 (31) = happyShift action_61
action_57 (34) = happyShift action_62
action_57 (35) = happyShift action_63
action_57 (40) = happyShift action_64
action_57 (41) = happyShift action_65
action_57 (42) = happyShift action_66
action_57 (52) = happyShift action_80
action_57 (64) = happyShift action_36
action_57 (19) = happyGoto action_77
action_57 (20) = happyGoto action_78
action_57 (29) = happyGoto action_79
action_57 (30) = happyGoto action_60
action_57 _ = happyFail

action_58 (31) = happyShift action_61
action_58 (34) = happyShift action_62
action_58 (35) = happyShift action_63
action_58 (40) = happyShift action_64
action_58 (41) = happyShift action_65
action_58 (42) = happyShift action_66
action_58 (64) = happyShift action_36
action_58 (28) = happyGoto action_75
action_58 (29) = happyGoto action_76
action_58 (30) = happyGoto action_60
action_58 _ = happyReduce_61

action_59 (51) = happyShift action_74
action_59 _ = happyFail

action_60 (59) = happyShift action_56
action_60 _ = happyReduce_69

action_61 (48) = happyShift action_73
action_61 _ = happyFail

action_62 (48) = happyShift action_72
action_62 _ = happyFail

action_63 (50) = happyShift action_71
action_63 _ = happyFail

action_64 _ = happyReduce_62

action_65 _ = happyReduce_63

action_66 _ = happyReduce_64

action_67 (51) = happyShift action_70
action_67 _ = happyFail

action_68 _ = happyReduce_8

action_69 _ = happyReduce_30

action_70 (48) = happyShift action_96
action_70 _ = happyFail

action_71 (31) = happyShift action_61
action_71 (34) = happyShift action_62
action_71 (35) = happyShift action_63
action_71 (40) = happyShift action_64
action_71 (41) = happyShift action_65
action_71 (42) = happyShift action_66
action_71 (51) = happyShift action_95
action_71 (64) = happyShift action_36
action_71 (28) = happyGoto action_94
action_71 (29) = happyGoto action_76
action_71 (30) = happyGoto action_60
action_71 _ = happyReduce_61

action_72 (49) = happyShift action_93
action_72 _ = happyFail

action_73 (49) = happyShift action_92
action_73 _ = happyFail

action_74 (64) = happyShift action_91
action_74 _ = happyFail

action_75 (51) = happyShift action_89
action_75 (62) = happyShift action_90
action_75 _ = happyFail

action_76 _ = happyReduce_59

action_77 (52) = happyShift action_80
action_77 (20) = happyGoto action_88
action_77 _ = happyReduce_41

action_78 _ = happyReduce_42

action_79 _ = happyReduce_40

action_80 (64) = happyShift action_87
action_80 _ = happyFail

action_81 _ = happyReduce_71

action_82 _ = happyReduce_9

action_83 (49) = happyReduce_5
action_83 _ = happyReduce_3

action_84 _ = happyReduce_17

action_85 (31) = happyShift action_14
action_85 (32) = happyShift action_15
action_85 (33) = happyShift action_16
action_85 (35) = happyShift action_17
action_85 (38) = happyShift action_18
action_85 (39) = happyShift action_19
action_85 (43) = happyShift action_20
action_85 (50) = happyShift action_21
action_85 (57) = happyShift action_22
action_85 (63) = happyShift action_23
action_85 (64) = happyShift action_24
action_85 (8) = happyGoto action_4
action_85 (9) = happyGoto action_5
action_85 (10) = happyGoto action_6
action_85 (11) = happyGoto action_7
action_85 (12) = happyGoto action_8
action_85 (13) = happyGoto action_9
action_85 (14) = happyGoto action_10
action_85 (15) = happyGoto action_86
action_85 (18) = happyGoto action_12
action_85 (22) = happyGoto action_13
action_85 _ = happyFail

action_86 _ = happyReduce_35

action_87 (31) = happyShift action_61
action_87 (34) = happyShift action_62
action_87 (35) = happyShift action_63
action_87 (40) = happyShift action_64
action_87 (41) = happyShift action_65
action_87 (42) = happyShift action_66
action_87 (64) = happyShift action_36
action_87 (21) = happyGoto action_103
action_87 (29) = happyGoto action_104
action_87 (30) = happyGoto action_60
action_87 _ = happyReduce_47

action_88 _ = happyReduce_43

action_89 (61) = happyShift action_102
action_89 _ = happyFail

action_90 (31) = happyShift action_61
action_90 (34) = happyShift action_62
action_90 (35) = happyShift action_63
action_90 (40) = happyShift action_64
action_90 (41) = happyShift action_65
action_90 (42) = happyShift action_66
action_90 (64) = happyShift action_36
action_90 (29) = happyGoto action_101
action_90 (30) = happyGoto action_60
action_90 _ = happyFail

action_91 (50) = happyShift action_100
action_91 _ = happyFail

action_92 _ = happyReduce_67

action_93 _ = happyReduce_68

action_94 (51) = happyShift action_99
action_94 (62) = happyShift action_90
action_94 _ = happyFail

action_95 (61) = happyShift action_98
action_95 _ = happyFail

action_96 (31) = happyShift action_14
action_96 (32) = happyShift action_15
action_96 (33) = happyShift action_16
action_96 (35) = happyShift action_17
action_96 (38) = happyShift action_18
action_96 (39) = happyShift action_19
action_96 (43) = happyShift action_20
action_96 (50) = happyShift action_21
action_96 (57) = happyShift action_22
action_96 (63) = happyShift action_23
action_96 (64) = happyShift action_24
action_96 (5) = happyGoto action_53
action_96 (6) = happyGoto action_97
action_96 (7) = happyGoto action_55
action_96 (8) = happyGoto action_4
action_96 (9) = happyGoto action_5
action_96 (10) = happyGoto action_6
action_96 (11) = happyGoto action_7
action_96 (12) = happyGoto action_8
action_96 (13) = happyGoto action_9
action_96 (14) = happyGoto action_10
action_96 (15) = happyGoto action_11
action_96 (18) = happyGoto action_12
action_96 (22) = happyGoto action_13
action_96 _ = happyReduce_6

action_97 (49) = happyShift action_110
action_97 _ = happyFail

action_98 (31) = happyShift action_61
action_98 (34) = happyShift action_62
action_98 (35) = happyShift action_63
action_98 (40) = happyShift action_64
action_98 (41) = happyShift action_65
action_98 (42) = happyShift action_66
action_98 (64) = happyShift action_36
action_98 (29) = happyGoto action_109
action_98 (30) = happyGoto action_60
action_98 _ = happyFail

action_99 (61) = happyShift action_108
action_99 _ = happyFail

action_100 (31) = happyShift action_61
action_100 (34) = happyShift action_62
action_100 (35) = happyShift action_63
action_100 (40) = happyShift action_64
action_100 (41) = happyShift action_65
action_100 (42) = happyShift action_66
action_100 (64) = happyShift action_36
action_100 (28) = happyGoto action_107
action_100 (29) = happyGoto action_76
action_100 (30) = happyGoto action_60
action_100 _ = happyReduce_61

action_101 _ = happyReduce_60

action_102 (31) = happyShift action_61
action_102 (34) = happyShift action_62
action_102 (35) = happyShift action_63
action_102 (40) = happyShift action_64
action_102 (41) = happyShift action_65
action_102 (42) = happyShift action_66
action_102 (64) = happyShift action_36
action_102 (29) = happyGoto action_106
action_102 (30) = happyGoto action_60
action_102 _ = happyFail

action_103 (31) = happyShift action_61
action_103 (34) = happyShift action_62
action_103 (35) = happyShift action_63
action_103 (40) = happyShift action_64
action_103 (41) = happyShift action_65
action_103 (42) = happyShift action_66
action_103 (64) = happyShift action_36
action_103 (29) = happyGoto action_105
action_103 (30) = happyGoto action_60
action_103 _ = happyReduce_44

action_104 _ = happyReduce_45

action_105 _ = happyReduce_46

action_106 (58) = happyShift action_114
action_106 _ = happyFail

action_107 (51) = happyShift action_113
action_107 (62) = happyShift action_90
action_107 _ = happyFail

action_108 (31) = happyShift action_61
action_108 (34) = happyShift action_62
action_108 (35) = happyShift action_63
action_108 (40) = happyShift action_64
action_108 (41) = happyShift action_65
action_108 (42) = happyShift action_66
action_108 (64) = happyShift action_36
action_108 (29) = happyGoto action_112
action_108 (30) = happyGoto action_60
action_108 _ = happyFail

action_109 _ = happyReduce_65

action_110 (44) = happyShift action_111
action_110 _ = happyFail

action_111 (48) = happyShift action_121
action_111 _ = happyFail

action_112 _ = happyReduce_66

action_113 (61) = happyShift action_120
action_113 _ = happyFail

action_114 (50) = happyShift action_118
action_114 (64) = happyShift action_119
action_114 (23) = happyGoto action_115
action_114 (24) = happyGoto action_116
action_114 (25) = happyGoto action_117
action_114 _ = happyFail

action_115 (50) = happyShift action_118
action_115 (64) = happyShift action_119
action_115 (24) = happyGoto action_128
action_115 (25) = happyGoto action_117
action_115 _ = happyReduce_49

action_116 _ = happyReduce_50

action_117 (64) = happyShift action_127
action_117 _ = happyFail

action_118 (64) = happyShift action_126
action_118 (27) = happyGoto action_125
action_118 _ = happyFail

action_119 (50) = happyShift action_124
action_119 _ = happyFail

action_120 (31) = happyShift action_61
action_120 (34) = happyShift action_62
action_120 (35) = happyShift action_63
action_120 (40) = happyShift action_64
action_120 (41) = happyShift action_65
action_120 (42) = happyShift action_66
action_120 (64) = happyShift action_36
action_120 (29) = happyGoto action_123
action_120 (30) = happyGoto action_60
action_120 _ = happyFail

action_121 (31) = happyShift action_14
action_121 (32) = happyShift action_15
action_121 (33) = happyShift action_16
action_121 (35) = happyShift action_17
action_121 (38) = happyShift action_18
action_121 (39) = happyShift action_19
action_121 (43) = happyShift action_20
action_121 (50) = happyShift action_21
action_121 (57) = happyShift action_22
action_121 (63) = happyShift action_23
action_121 (64) = happyShift action_24
action_121 (5) = happyGoto action_53
action_121 (6) = happyGoto action_122
action_121 (7) = happyGoto action_55
action_121 (8) = happyGoto action_4
action_121 (9) = happyGoto action_5
action_121 (10) = happyGoto action_6
action_121 (11) = happyGoto action_7
action_121 (12) = happyGoto action_8
action_121 (13) = happyGoto action_9
action_121 (14) = happyGoto action_10
action_121 (15) = happyGoto action_11
action_121 (18) = happyGoto action_12
action_121 (22) = happyGoto action_13
action_121 _ = happyReduce_6

action_122 (49) = happyShift action_134
action_122 _ = happyFail

action_123 (58) = happyShift action_133
action_123 _ = happyFail

action_124 (64) = happyShift action_126
action_124 (26) = happyGoto action_131
action_124 (27) = happyGoto action_132
action_124 _ = happyReduce_57

action_125 (51) = happyShift action_130
action_125 _ = happyFail

action_126 _ = happyReduce_58

action_127 (50) = happyShift action_129
action_127 _ = happyFail

action_128 _ = happyReduce_51

action_129 (64) = happyShift action_126
action_129 (26) = happyGoto action_139
action_129 (27) = happyGoto action_132
action_129 _ = happyReduce_57

action_130 (59) = happyShift action_138
action_130 _ = happyFail

action_131 (51) = happyShift action_136
action_131 (62) = happyShift action_137
action_131 _ = happyFail

action_132 _ = happyReduce_55

action_133 (50) = happyShift action_118
action_133 (64) = happyShift action_119
action_133 (23) = happyGoto action_135
action_133 (24) = happyGoto action_116
action_133 (25) = happyGoto action_117
action_133 _ = happyFail

action_134 _ = happyReduce_33

action_135 (50) = happyShift action_118
action_135 (64) = happyShift action_119
action_135 (24) = happyGoto action_128
action_135 (25) = happyGoto action_117
action_135 _ = happyReduce_48

action_136 (45) = happyShift action_142
action_136 _ = happyFail

action_137 (64) = happyShift action_126
action_137 (27) = happyGoto action_141
action_137 _ = happyFail

action_138 _ = happyReduce_54

action_139 (51) = happyShift action_140
action_139 (62) = happyShift action_137
action_139 _ = happyFail

action_140 (45) = happyShift action_144
action_140 _ = happyFail

action_141 _ = happyReduce_56

action_142 (48) = happyShift action_143
action_142 _ = happyFail

action_143 (31) = happyShift action_14
action_143 (32) = happyShift action_15
action_143 (33) = happyShift action_16
action_143 (35) = happyShift action_17
action_143 (38) = happyShift action_18
action_143 (39) = happyShift action_19
action_143 (43) = happyShift action_20
action_143 (50) = happyShift action_21
action_143 (57) = happyShift action_22
action_143 (63) = happyShift action_23
action_143 (64) = happyShift action_24
action_143 (5) = happyGoto action_146
action_143 (7) = happyGoto action_3
action_143 (8) = happyGoto action_4
action_143 (9) = happyGoto action_5
action_143 (10) = happyGoto action_6
action_143 (11) = happyGoto action_7
action_143 (12) = happyGoto action_8
action_143 (13) = happyGoto action_9
action_143 (14) = happyGoto action_10
action_143 (15) = happyGoto action_11
action_143 (18) = happyGoto action_12
action_143 (22) = happyGoto action_13
action_143 _ = happyFail

action_144 (48) = happyShift action_145
action_144 _ = happyFail

action_145 (31) = happyShift action_14
action_145 (32) = happyShift action_15
action_145 (33) = happyShift action_16
action_145 (35) = happyShift action_17
action_145 (38) = happyShift action_18
action_145 (39) = happyShift action_19
action_145 (43) = happyShift action_20
action_145 (50) = happyShift action_21
action_145 (57) = happyShift action_22
action_145 (63) = happyShift action_23
action_145 (64) = happyShift action_24
action_145 (5) = happyGoto action_148
action_145 (7) = happyGoto action_3
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

action_146 (31) = happyShift action_14
action_146 (32) = happyShift action_15
action_146 (33) = happyShift action_16
action_146 (35) = happyShift action_17
action_146 (38) = happyShift action_18
action_146 (39) = happyShift action_19
action_146 (43) = happyShift action_20
action_146 (49) = happyShift action_147
action_146 (50) = happyShift action_21
action_146 (57) = happyShift action_22
action_146 (63) = happyShift action_23
action_146 (64) = happyShift action_24
action_146 (7) = happyGoto action_45
action_146 (8) = happyGoto action_4
action_146 (9) = happyGoto action_5
action_146 (10) = happyGoto action_6
action_146 (11) = happyGoto action_7
action_146 (12) = happyGoto action_8
action_146 (13) = happyGoto action_9
action_146 (14) = happyGoto action_10
action_146 (15) = happyGoto action_11
action_146 (18) = happyGoto action_12
action_146 (22) = happyGoto action_13
action_146 _ = happyFail

action_147 _ = happyReduce_53

action_148 (31) = happyShift action_14
action_148 (32) = happyShift action_15
action_148 (33) = happyShift action_16
action_148 (35) = happyShift action_17
action_148 (38) = happyShift action_18
action_148 (39) = happyShift action_19
action_148 (43) = happyShift action_20
action_148 (49) = happyShift action_149
action_148 (50) = happyShift action_21
action_148 (57) = happyShift action_22
action_148 (63) = happyShift action_23
action_148 (64) = happyShift action_24
action_148 (7) = happyGoto action_45
action_148 (8) = happyGoto action_4
action_148 (9) = happyGoto action_5
action_148 (10) = happyGoto action_6
action_148 (11) = happyGoto action_7
action_148 (12) = happyGoto action_8
action_148 (13) = happyGoto action_9
action_148 (14) = happyGoto action_10
action_148 (15) = happyGoto action_11
action_148 (18) = happyGoto action_12
action_148 (22) = happyGoto action_13
action_148 _ = happyFail

action_149 _ = happyReduce_52

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

happyReduce_9 = happyReduce 4 8 happyReduction_9
happyReduction_9 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_10 = happySpecReduce_2  8 happyReduction_10
happyReduction_10 _
	_
	 =  HappyAbsSyn8
		 (ExpUnit
	)

happyReduce_11 = happySpecReduce_1  8 happyReduction_11
happyReduction_11 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn8
		 (ExpNum happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  8 happyReduction_12
happyReduction_12 _
	 =  HappyAbsSyn8
		 (ExpBool True
	)

happyReduce_13 = happySpecReduce_1  8 happyReduction_13
happyReduction_13 _
	 =  HappyAbsSyn8
		 (ExpBool False
	)

happyReduce_14 = happySpecReduce_1  8 happyReduction_14
happyReduction_14 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn8
		 (ExpRef happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  9 happyReduction_15
happyReduction_15 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  9 happyReduction_16
happyReduction_16 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happyReduce 4 10 happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_1  10 happyReduction_18
happyReduction_18 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  11 happyReduction_19
happyReduction_19 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  11 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  12 happyReduction_21
happyReduction_21 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  12 happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  13 happyReduction_23
happyReduction_23 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  13 happyReduction_24
happyReduction_24 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  14 happyReduction_25
happyReduction_25 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  14 happyReduction_26
happyReduction_26 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  15 happyReduction_27
happyReduction_27 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (ExpNot happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  15 happyReduction_28
happyReduction_28 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  15 happyReduction_29
happyReduction_29 (HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (ExpImport happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  15 happyReduction_30
happyReduction_30 (HappyAbsSyn15  happy_var_3)
	_
	(HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn15
		 (ExpAssign happy_var_1 happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  15 happyReduction_31
happyReduction_31 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpTypeDec happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  15 happyReduction_32
happyReduction_32 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpFunDec happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happyReduce 11 15 happyReduction_33
happyReduction_33 (_ `HappyStk`
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

happyReduce_34 = happySpecReduce_1  16 happyReduction_34
happyReduction_34 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  16 happyReduction_35
happyReduction_35 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_0  16 happyReduction_36
happyReduction_36  =  HappyAbsSyn16
		 ([]
	)

happyReduce_37 = happySpecReduce_1  17 happyReduction_37
happyReduction_37 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  17 happyReduction_38
happyReduction_38 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_0  17 happyReduction_39
happyReduction_39  =  HappyAbsSyn17
		 ([]
	)

happyReduce_40 = happyReduce 4 18 happyReduction_40
happyReduction_40 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_41 = happyReduce 4 18 happyReduction_41
happyReduction_41 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_42 = happySpecReduce_1  19 happyReduction_42
happyReduction_42 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_2  19 happyReduction_43
happyReduction_43 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_43 _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn20
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  21 happyReduction_45
happyReduction_45 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_2  21 happyReduction_46
happyReduction_46 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_46 _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_0  21 happyReduction_47
happyReduction_47  =  HappyAbsSyn21
		 ([]
	)

happyReduce_48 = happyReduce 12 22 happyReduction_48
happyReduction_48 ((HappyAbsSyn23  happy_var_12) `HappyStk`
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

happyReduce_49 = happyReduce 9 22 happyReduction_49
happyReduction_49 ((HappyAbsSyn23  happy_var_9) `HappyStk`
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

happyReduce_50 = happySpecReduce_1  23 happyReduction_50
happyReduction_50 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_2  23 happyReduction_51
happyReduction_51 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_51 _ _  = notHappyAtAll 

happyReduce_52 = happyReduce 9 24 happyReduction_52
happyReduction_52 (_ `HappyStk`
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

happyReduce_53 = happyReduce 8 24 happyReduction_53
happyReduction_53 (_ `HappyStk`
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

happyReduce_54 = happyReduce 4 25 happyReduction_54
happyReduction_54 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_55 = happySpecReduce_1  26 happyReduction_55
happyReduction_55 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  26 happyReduction_56
happyReduction_56 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_0  26 happyReduction_57
happyReduction_57  =  HappyAbsSyn26
		 ([]
	)

happyReduce_58 = happySpecReduce_1  27 happyReduction_58
happyReduction_58 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn27
		 (PatExpVar happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  28 happyReduction_59
happyReduction_59 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1]
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  28 happyReduction_60
happyReduction_60 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_0  28 happyReduction_61
happyReduction_61  =  HappyAbsSyn28
		 ([]
	)

happyReduce_62 = happySpecReduce_1  29 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn29
		 (TyInt
	)

happyReduce_63 = happySpecReduce_1  29 happyReduction_63
happyReduction_63 _
	 =  HappyAbsSyn29
		 (TyBool
	)

happyReduce_64 = happySpecReduce_1  29 happyReduction_64
happyReduction_64 _
	 =  HappyAbsSyn29
		 (TyUnit
	)

happyReduce_65 = happyReduce 5 29 happyReduction_65
happyReduction_65 ((HappyAbsSyn29  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_66 = happyReduce 6 29 happyReduction_66
happyReduction_66 ((HappyAbsSyn29  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_67 = happySpecReduce_3  29 happyReduction_67
happyReduction_67 _
	_
	_
	 =  HappyAbsSyn29
		 (TyModule
	)

happyReduce_68 = happySpecReduce_3  29 happyReduction_68
happyReduction_68 _
	_
	_
	 =  HappyAbsSyn29
		 (TyInterface
	)

happyReduce_69 = happySpecReduce_1  29 happyReduction_69
happyReduction_69 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (TyRef happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  30 happyReduction_70
happyReduction_70 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn30
		 (Id happy_var_1
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  30 happyReduction_71
happyReduction_71 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (Path happy_var_1 happy_var_3
	)
happyReduction_71 _ _ _  = notHappyAtAll 

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

