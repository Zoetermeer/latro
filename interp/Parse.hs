{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22
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

action_0 (23) = happyShift action_7
action_0 (24) = happyShift action_8
action_0 (25) = happyShift action_9
action_0 (27) = happyShift action_10
action_0 (30) = happyShift action_11
action_0 (31) = happyShift action_12
action_0 (40) = happyShift action_13
action_0 (47) = happyShift action_14
action_0 (53) = happyShift action_15
action_0 (54) = happyShift action_16
action_0 (4) = happyGoto action_17
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (10) = happyGoto action_5
action_0 (14) = happyGoto action_6
action_0 _ = happyReduce_4

action_1 (23) = happyShift action_7
action_1 (24) = happyShift action_8
action_1 (25) = happyShift action_9
action_1 (27) = happyShift action_10
action_1 (30) = happyShift action_11
action_1 (31) = happyShift action_12
action_1 (40) = happyShift action_13
action_1 (47) = happyShift action_14
action_1 (53) = happyShift action_15
action_1 (54) = happyShift action_16
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (10) = happyGoto action_5
action_1 (14) = happyGoto action_6
action_1 _ = happyFail

action_2 (23) = happyShift action_7
action_2 (24) = happyShift action_8
action_2 (25) = happyShift action_9
action_2 (27) = happyShift action_10
action_2 (30) = happyShift action_11
action_2 (31) = happyShift action_12
action_2 (40) = happyShift action_13
action_2 (47) = happyShift action_14
action_2 (53) = happyShift action_15
action_2 (54) = happyShift action_16
action_2 (6) = happyGoto action_34
action_2 (7) = happyGoto action_4
action_2 (10) = happyGoto action_5
action_2 (14) = happyGoto action_6
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 (40) = happyShift action_27
action_4 (43) = happyShift action_28
action_4 (44) = happyShift action_29
action_4 (45) = happyShift action_30
action_4 (46) = happyShift action_31
action_4 (48) = happyShift action_32
action_4 (49) = happyShift action_33
action_4 _ = happyFail

action_5 _ = happyReduce_16

action_6 _ = happyReduce_17

action_7 (38) = happyShift action_26
action_7 _ = happyFail

action_8 (54) = happyShift action_25
action_8 (22) = happyGoto action_24
action_8 _ = happyFail

action_9 (54) = happyShift action_23
action_9 _ = happyFail

action_10 (40) = happyShift action_21
action_10 (54) = happyShift action_22
action_10 _ = happyFail

action_11 _ = happyReduce_20

action_12 _ = happyReduce_21

action_13 (23) = happyShift action_7
action_13 (24) = happyShift action_8
action_13 (25) = happyShift action_9
action_13 (27) = happyShift action_10
action_13 (30) = happyShift action_11
action_13 (31) = happyShift action_12
action_13 (40) = happyShift action_13
action_13 (47) = happyShift action_14
action_13 (53) = happyShift action_15
action_13 (54) = happyShift action_16
action_13 (7) = happyGoto action_20
action_13 (10) = happyGoto action_5
action_13 (14) = happyGoto action_6
action_13 _ = happyFail

action_14 (23) = happyShift action_7
action_14 (24) = happyShift action_8
action_14 (25) = happyShift action_9
action_14 (27) = happyShift action_10
action_14 (30) = happyShift action_11
action_14 (31) = happyShift action_12
action_14 (40) = happyShift action_13
action_14 (47) = happyShift action_14
action_14 (53) = happyShift action_15
action_14 (54) = happyShift action_16
action_14 (7) = happyGoto action_19
action_14 (10) = happyGoto action_5
action_14 (14) = happyGoto action_6
action_14 _ = happyFail

action_15 _ = happyReduce_19

action_16 (35) = happyShift action_18
action_16 _ = happyReduce_22

action_17 (55) = happyAccept
action_17 _ = happyFail

action_18 (23) = happyShift action_7
action_18 (24) = happyShift action_8
action_18 (25) = happyShift action_9
action_18 (27) = happyShift action_10
action_18 (30) = happyShift action_11
action_18 (31) = happyShift action_12
action_18 (40) = happyShift action_13
action_18 (47) = happyShift action_14
action_18 (53) = happyShift action_15
action_18 (54) = happyShift action_16
action_18 (7) = happyGoto action_55
action_18 (10) = happyGoto action_5
action_18 (14) = happyGoto action_6
action_18 _ = happyFail

action_19 (40) = happyShift action_27
action_19 (43) = happyShift action_28
action_19 (44) = happyShift action_29
action_19 (45) = happyShift action_30
action_19 (46) = happyShift action_31
action_19 (49) = happyShift action_33
action_19 _ = happyReduce_13

action_20 (40) = happyShift action_27
action_20 (41) = happyShift action_54
action_20 (43) = happyShift action_28
action_20 (44) = happyShift action_29
action_20 (45) = happyShift action_30
action_20 (46) = happyShift action_31
action_20 (49) = happyShift action_33
action_20 _ = happyFail

action_21 (23) = happyShift action_48
action_21 (26) = happyShift action_49
action_21 (27) = happyShift action_50
action_21 (32) = happyShift action_51
action_21 (33) = happyShift action_52
action_21 (34) = happyShift action_53
action_21 (54) = happyShift action_25
action_21 (21) = happyGoto action_46
action_21 (22) = happyGoto action_47
action_21 _ = happyFail

action_22 (40) = happyShift action_45
action_22 _ = happyFail

action_23 (50) = happyShift action_44
action_23 _ = happyFail

action_24 (49) = happyShift action_43
action_24 _ = happyReduce_14

action_25 _ = happyReduce_58

action_26 (23) = happyShift action_7
action_26 (24) = happyShift action_8
action_26 (25) = happyShift action_9
action_26 (27) = happyShift action_10
action_26 (30) = happyShift action_11
action_26 (31) = happyShift action_12
action_26 (40) = happyShift action_13
action_26 (47) = happyShift action_14
action_26 (53) = happyShift action_15
action_26 (54) = happyShift action_16
action_26 (5) = happyGoto action_42
action_26 (6) = happyGoto action_3
action_26 (7) = happyGoto action_4
action_26 (10) = happyGoto action_5
action_26 (14) = happyGoto action_6
action_26 _ = happyReduce_4

action_27 (23) = happyShift action_7
action_27 (24) = happyShift action_8
action_27 (25) = happyShift action_9
action_27 (27) = happyShift action_10
action_27 (30) = happyShift action_11
action_27 (31) = happyShift action_12
action_27 (40) = happyShift action_13
action_27 (47) = happyShift action_14
action_27 (53) = happyShift action_15
action_27 (54) = happyShift action_16
action_27 (7) = happyGoto action_40
action_27 (8) = happyGoto action_41
action_27 (10) = happyGoto action_5
action_27 (14) = happyGoto action_6
action_27 _ = happyReduce_25

action_28 (23) = happyShift action_7
action_28 (24) = happyShift action_8
action_28 (25) = happyShift action_9
action_28 (27) = happyShift action_10
action_28 (30) = happyShift action_11
action_28 (31) = happyShift action_12
action_28 (40) = happyShift action_13
action_28 (47) = happyShift action_14
action_28 (53) = happyShift action_15
action_28 (54) = happyShift action_16
action_28 (7) = happyGoto action_39
action_28 (10) = happyGoto action_5
action_28 (14) = happyGoto action_6
action_28 _ = happyFail

action_29 (23) = happyShift action_7
action_29 (24) = happyShift action_8
action_29 (25) = happyShift action_9
action_29 (27) = happyShift action_10
action_29 (30) = happyShift action_11
action_29 (31) = happyShift action_12
action_29 (40) = happyShift action_13
action_29 (47) = happyShift action_14
action_29 (53) = happyShift action_15
action_29 (54) = happyShift action_16
action_29 (7) = happyGoto action_38
action_29 (10) = happyGoto action_5
action_29 (14) = happyGoto action_6
action_29 _ = happyFail

action_30 (23) = happyShift action_7
action_30 (24) = happyShift action_8
action_30 (25) = happyShift action_9
action_30 (27) = happyShift action_10
action_30 (30) = happyShift action_11
action_30 (31) = happyShift action_12
action_30 (40) = happyShift action_13
action_30 (47) = happyShift action_14
action_30 (53) = happyShift action_15
action_30 (54) = happyShift action_16
action_30 (7) = happyGoto action_37
action_30 (10) = happyGoto action_5
action_30 (14) = happyGoto action_6
action_30 _ = happyFail

action_31 (23) = happyShift action_7
action_31 (24) = happyShift action_8
action_31 (25) = happyShift action_9
action_31 (27) = happyShift action_10
action_31 (30) = happyShift action_11
action_31 (31) = happyShift action_12
action_31 (40) = happyShift action_13
action_31 (47) = happyShift action_14
action_31 (53) = happyShift action_15
action_31 (54) = happyShift action_16
action_31 (7) = happyGoto action_36
action_31 (10) = happyGoto action_5
action_31 (14) = happyGoto action_6
action_31 _ = happyFail

action_32 _ = happyReduce_5

action_33 (54) = happyShift action_35
action_33 _ = happyFail

action_34 _ = happyReduce_3

action_35 _ = happyReduce_10

action_36 (40) = happyShift action_27
action_36 (43) = happyShift action_28
action_36 (44) = happyShift action_29
action_36 (45) = happyShift action_30
action_36 (46) = happyShift action_31
action_36 (49) = happyShift action_33
action_36 _ = happyReduce_8

action_37 (40) = happyShift action_27
action_37 (43) = happyShift action_28
action_37 (44) = happyShift action_29
action_37 (45) = happyShift action_30
action_37 (46) = happyShift action_31
action_37 (49) = happyShift action_33
action_37 _ = happyReduce_9

action_38 (40) = happyShift action_27
action_38 (43) = happyShift action_28
action_38 (44) = happyShift action_29
action_38 (45) = happyShift action_30
action_38 (46) = happyShift action_31
action_38 (49) = happyShift action_33
action_38 _ = happyReduce_7

action_39 (40) = happyShift action_27
action_39 (43) = happyShift action_28
action_39 (44) = happyShift action_29
action_39 (45) = happyShift action_30
action_39 (46) = happyShift action_31
action_39 (49) = happyShift action_33
action_39 _ = happyReduce_6

action_40 (40) = happyShift action_27
action_40 (43) = happyShift action_28
action_40 (44) = happyShift action_29
action_40 (45) = happyShift action_30
action_40 (46) = happyShift action_31
action_40 (49) = happyShift action_33
action_40 _ = happyReduce_23

action_41 (41) = happyShift action_68
action_41 (52) = happyShift action_69
action_41 _ = happyFail

action_42 (23) = happyShift action_7
action_42 (24) = happyShift action_8
action_42 (25) = happyShift action_9
action_42 (27) = happyShift action_10
action_42 (30) = happyShift action_11
action_42 (31) = happyShift action_12
action_42 (39) = happyShift action_67
action_42 (40) = happyShift action_13
action_42 (47) = happyShift action_14
action_42 (53) = happyShift action_15
action_42 (54) = happyShift action_16
action_42 (6) = happyGoto action_34
action_42 (7) = happyGoto action_4
action_42 (10) = happyGoto action_5
action_42 (14) = happyGoto action_6
action_42 _ = happyFail

action_43 (54) = happyShift action_66
action_43 _ = happyFail

action_44 (23) = happyShift action_48
action_44 (26) = happyShift action_49
action_44 (27) = happyShift action_50
action_44 (32) = happyShift action_51
action_44 (33) = happyShift action_52
action_44 (34) = happyShift action_53
action_44 (42) = happyShift action_65
action_44 (54) = happyShift action_25
action_44 (11) = happyGoto action_62
action_44 (12) = happyGoto action_63
action_44 (21) = happyGoto action_64
action_44 (22) = happyGoto action_47
action_44 _ = happyFail

action_45 (23) = happyShift action_48
action_45 (26) = happyShift action_49
action_45 (27) = happyShift action_50
action_45 (32) = happyShift action_51
action_45 (33) = happyShift action_52
action_45 (34) = happyShift action_53
action_45 (54) = happyShift action_25
action_45 (20) = happyGoto action_60
action_45 (21) = happyGoto action_61
action_45 (22) = happyGoto action_47
action_45 _ = happyReduce_50

action_46 (41) = happyShift action_59
action_46 _ = happyFail

action_47 (49) = happyShift action_43
action_47 _ = happyReduce_57

action_48 (38) = happyShift action_58
action_48 _ = happyFail

action_49 (38) = happyShift action_57
action_49 _ = happyFail

action_50 (40) = happyShift action_56
action_50 _ = happyFail

action_51 _ = happyReduce_51

action_52 _ = happyReduce_52

action_53 _ = happyReduce_53

action_54 _ = happyReduce_12

action_55 (40) = happyShift action_27
action_55 (43) = happyShift action_28
action_55 (44) = happyShift action_29
action_55 (45) = happyShift action_30
action_55 (46) = happyShift action_31
action_55 (49) = happyShift action_33
action_55 _ = happyReduce_15

action_56 (23) = happyShift action_48
action_56 (26) = happyShift action_49
action_56 (27) = happyShift action_50
action_56 (32) = happyShift action_51
action_56 (33) = happyShift action_52
action_56 (34) = happyShift action_53
action_56 (54) = happyShift action_25
action_56 (20) = happyGoto action_78
action_56 (21) = happyGoto action_61
action_56 (22) = happyGoto action_47
action_56 _ = happyReduce_50

action_57 (39) = happyShift action_77
action_57 _ = happyFail

action_58 (39) = happyShift action_76
action_58 _ = happyFail

action_59 (54) = happyShift action_75
action_59 _ = happyFail

action_60 (41) = happyShift action_73
action_60 (52) = happyShift action_74
action_60 _ = happyFail

action_61 _ = happyReduce_48

action_62 (42) = happyShift action_65
action_62 (12) = happyGoto action_72
action_62 _ = happyReduce_30

action_63 _ = happyReduce_31

action_64 _ = happyReduce_29

action_65 (54) = happyShift action_71
action_65 _ = happyFail

action_66 _ = happyReduce_59

action_67 _ = happyReduce_18

action_68 _ = happyReduce_11

action_69 (23) = happyShift action_7
action_69 (24) = happyShift action_8
action_69 (25) = happyShift action_9
action_69 (27) = happyShift action_10
action_69 (30) = happyShift action_11
action_69 (31) = happyShift action_12
action_69 (40) = happyShift action_13
action_69 (47) = happyShift action_14
action_69 (53) = happyShift action_15
action_69 (54) = happyShift action_16
action_69 (7) = happyGoto action_70
action_69 (10) = happyGoto action_5
action_69 (14) = happyGoto action_6
action_69 _ = happyFail

action_70 (40) = happyShift action_27
action_70 (43) = happyShift action_28
action_70 (44) = happyShift action_29
action_70 (45) = happyShift action_30
action_70 (46) = happyShift action_31
action_70 (49) = happyShift action_33
action_70 _ = happyReduce_24

action_71 (23) = happyShift action_48
action_71 (26) = happyShift action_49
action_71 (27) = happyShift action_50
action_71 (32) = happyShift action_51
action_71 (33) = happyShift action_52
action_71 (34) = happyShift action_53
action_71 (54) = happyShift action_25
action_71 (13) = happyGoto action_83
action_71 (21) = happyGoto action_84
action_71 (22) = happyGoto action_47
action_71 _ = happyReduce_36

action_72 _ = happyReduce_32

action_73 (51) = happyShift action_82
action_73 _ = happyFail

action_74 (23) = happyShift action_48
action_74 (26) = happyShift action_49
action_74 (27) = happyShift action_50
action_74 (32) = happyShift action_51
action_74 (33) = happyShift action_52
action_74 (34) = happyShift action_53
action_74 (54) = happyShift action_25
action_74 (21) = happyGoto action_81
action_74 (22) = happyGoto action_47
action_74 _ = happyFail

action_75 (40) = happyShift action_80
action_75 _ = happyFail

action_76 _ = happyReduce_55

action_77 _ = happyReduce_56

action_78 (41) = happyShift action_79
action_78 (52) = happyShift action_74
action_78 _ = happyFail

action_79 (51) = happyShift action_88
action_79 _ = happyFail

action_80 (23) = happyShift action_48
action_80 (26) = happyShift action_49
action_80 (27) = happyShift action_50
action_80 (32) = happyShift action_51
action_80 (33) = happyShift action_52
action_80 (34) = happyShift action_53
action_80 (54) = happyShift action_25
action_80 (20) = happyGoto action_87
action_80 (21) = happyGoto action_61
action_80 (22) = happyGoto action_47
action_80 _ = happyReduce_50

action_81 _ = happyReduce_49

action_82 (23) = happyShift action_48
action_82 (26) = happyShift action_49
action_82 (27) = happyShift action_50
action_82 (32) = happyShift action_51
action_82 (33) = happyShift action_52
action_82 (34) = happyShift action_53
action_82 (54) = happyShift action_25
action_82 (21) = happyGoto action_86
action_82 (22) = happyGoto action_47
action_82 _ = happyFail

action_83 (23) = happyShift action_48
action_83 (26) = happyShift action_49
action_83 (27) = happyShift action_50
action_83 (32) = happyShift action_51
action_83 (33) = happyShift action_52
action_83 (34) = happyShift action_53
action_83 (54) = happyShift action_25
action_83 (21) = happyGoto action_85
action_83 (22) = happyGoto action_47
action_83 _ = happyReduce_33

action_84 _ = happyReduce_34

action_85 _ = happyReduce_35

action_86 (48) = happyShift action_91
action_86 _ = happyFail

action_87 (41) = happyShift action_90
action_87 (52) = happyShift action_74
action_87 _ = happyFail

action_88 (23) = happyShift action_48
action_88 (26) = happyShift action_49
action_88 (27) = happyShift action_50
action_88 (32) = happyShift action_51
action_88 (33) = happyShift action_52
action_88 (34) = happyShift action_53
action_88 (54) = happyShift action_25
action_88 (21) = happyGoto action_89
action_88 (22) = happyGoto action_47
action_88 _ = happyFail

action_89 _ = happyReduce_54

action_90 (51) = happyShift action_97
action_90 _ = happyFail

action_91 (40) = happyShift action_95
action_91 (54) = happyShift action_96
action_91 (15) = happyGoto action_92
action_91 (16) = happyGoto action_93
action_91 (17) = happyGoto action_94
action_91 _ = happyFail

action_92 (40) = happyShift action_95
action_92 (54) = happyShift action_96
action_92 (16) = happyGoto action_103
action_92 (17) = happyGoto action_94
action_92 _ = happyReduce_38

action_93 _ = happyReduce_39

action_94 (54) = happyShift action_102
action_94 _ = happyFail

action_95 (54) = happyShift action_101
action_95 (19) = happyGoto action_100
action_95 _ = happyFail

action_96 (40) = happyShift action_99
action_96 _ = happyFail

action_97 (23) = happyShift action_48
action_97 (26) = happyShift action_49
action_97 (27) = happyShift action_50
action_97 (32) = happyShift action_51
action_97 (33) = happyShift action_52
action_97 (34) = happyShift action_53
action_97 (54) = happyShift action_25
action_97 (21) = happyGoto action_98
action_97 (22) = happyGoto action_47
action_97 _ = happyFail

action_98 (48) = happyShift action_108
action_98 _ = happyFail

action_99 (54) = happyShift action_101
action_99 (18) = happyGoto action_106
action_99 (19) = happyGoto action_107
action_99 _ = happyReduce_46

action_100 (41) = happyShift action_105
action_100 _ = happyFail

action_101 _ = happyReduce_47

action_102 (40) = happyShift action_104
action_102 _ = happyFail

action_103 _ = happyReduce_40

action_104 (54) = happyShift action_101
action_104 (18) = happyGoto action_113
action_104 (19) = happyGoto action_107
action_104 _ = happyReduce_46

action_105 (49) = happyShift action_112
action_105 _ = happyFail

action_106 (41) = happyShift action_110
action_106 (52) = happyShift action_111
action_106 _ = happyFail

action_107 _ = happyReduce_44

action_108 (40) = happyShift action_95
action_108 (54) = happyShift action_96
action_108 (15) = happyGoto action_109
action_108 (16) = happyGoto action_93
action_108 (17) = happyGoto action_94
action_108 _ = happyFail

action_109 (40) = happyShift action_95
action_109 (54) = happyShift action_96
action_109 (16) = happyGoto action_103
action_109 (17) = happyGoto action_94
action_109 _ = happyReduce_37

action_110 (35) = happyShift action_116
action_110 _ = happyFail

action_111 (54) = happyShift action_101
action_111 (19) = happyGoto action_115
action_111 _ = happyFail

action_112 _ = happyReduce_43

action_113 (41) = happyShift action_114
action_113 (52) = happyShift action_111
action_113 _ = happyFail

action_114 (35) = happyShift action_118
action_114 _ = happyFail

action_115 _ = happyReduce_45

action_116 (38) = happyShift action_117
action_116 _ = happyFail

action_117 (23) = happyShift action_7
action_117 (24) = happyShift action_8
action_117 (25) = happyShift action_9
action_117 (27) = happyShift action_10
action_117 (30) = happyShift action_11
action_117 (31) = happyShift action_12
action_117 (40) = happyShift action_13
action_117 (47) = happyShift action_14
action_117 (53) = happyShift action_15
action_117 (54) = happyShift action_16
action_117 (5) = happyGoto action_120
action_117 (6) = happyGoto action_3
action_117 (7) = happyGoto action_4
action_117 (10) = happyGoto action_5
action_117 (14) = happyGoto action_6
action_117 _ = happyReduce_4

action_118 (38) = happyShift action_119
action_118 _ = happyFail

action_119 (23) = happyShift action_7
action_119 (24) = happyShift action_8
action_119 (25) = happyShift action_9
action_119 (27) = happyShift action_10
action_119 (30) = happyShift action_11
action_119 (31) = happyShift action_12
action_119 (40) = happyShift action_13
action_119 (47) = happyShift action_14
action_119 (53) = happyShift action_15
action_119 (54) = happyShift action_16
action_119 (5) = happyGoto action_122
action_119 (6) = happyGoto action_3
action_119 (7) = happyGoto action_4
action_119 (10) = happyGoto action_5
action_119 (14) = happyGoto action_6
action_119 _ = happyReduce_4

action_120 (23) = happyShift action_7
action_120 (24) = happyShift action_8
action_120 (25) = happyShift action_9
action_120 (27) = happyShift action_10
action_120 (30) = happyShift action_11
action_120 (31) = happyShift action_12
action_120 (39) = happyShift action_121
action_120 (40) = happyShift action_13
action_120 (47) = happyShift action_14
action_120 (53) = happyShift action_15
action_120 (54) = happyShift action_16
action_120 (6) = happyGoto action_34
action_120 (7) = happyGoto action_4
action_120 (10) = happyGoto action_5
action_120 (14) = happyGoto action_6
action_120 _ = happyFail

action_121 _ = happyReduce_42

action_122 (23) = happyShift action_7
action_122 (24) = happyShift action_8
action_122 (25) = happyShift action_9
action_122 (27) = happyShift action_10
action_122 (30) = happyShift action_11
action_122 (31) = happyShift action_12
action_122 (39) = happyShift action_123
action_122 (40) = happyShift action_13
action_122 (47) = happyShift action_14
action_122 (53) = happyShift action_15
action_122 (54) = happyShift action_16
action_122 (6) = happyGoto action_34
action_122 (7) = happyGoto action_4
action_122 (10) = happyGoto action_5
action_122 (14) = happyGoto action_6
action_122 _ = happyFail

action_123 _ = happyReduce_41

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (CompUnit happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_0  5 happyReduction_4
happyReduction_4  =  HappyAbsSyn5
		 ([]
	)

happyReduce_5 = happySpecReduce_2  6 happyReduction_5
happyReduction_5 _
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  7 happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  7 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  7 happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  7 happyReduction_9
happyReduction_9 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  7 happyReduction_10
happyReduction_10 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happyReduce 4 7 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_3  7 happyReduction_12
happyReduction_12 _
	(HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (happy_var_2
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  7 happyReduction_13
happyReduction_13 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (ExpNot happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  7 happyReduction_14
happyReduction_14 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (ExpImport happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  7 happyReduction_15
happyReduction_15 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn7
		 (ExpAssign happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  7 happyReduction_16
happyReduction_16 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpTypeDec happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  7 happyReduction_17
happyReduction_17 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpFunDec happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happyReduce 4 7 happyReduction_18
happyReduction_18 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_19 = happySpecReduce_1  7 happyReduction_19
happyReduction_19 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn7
		 (ExpNum happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  7 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn7
		 (ExpBool True
	)

happyReduce_21 = happySpecReduce_1  7 happyReduction_21
happyReduction_21 _
	 =  HappyAbsSyn7
		 (ExpBool False
	)

happyReduce_22 = happySpecReduce_1  7 happyReduction_22
happyReduction_22 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn7
		 (ExpRef happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  8 happyReduction_23
happyReduction_23 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  8 happyReduction_24
happyReduction_24 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_0  8 happyReduction_25
happyReduction_25  =  HappyAbsSyn8
		 ([]
	)

happyReduce_26 = happySpecReduce_1  9 happyReduction_26
happyReduction_26 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  9 happyReduction_27
happyReduction_27 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_0  9 happyReduction_28
happyReduction_28  =  HappyAbsSyn9
		 ([]
	)

happyReduce_29 = happyReduce 4 10 happyReduction_29
happyReduction_29 ((HappyAbsSyn21  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_30 = happyReduce 4 10 happyReduction_30
happyReduction_30 ((HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_31 = happySpecReduce_1  11 happyReduction_31
happyReduction_31 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 ([happy_var_1]
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_2  11 happyReduction_32
happyReduction_32 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  12 happyReduction_33
happyReduction_33 (HappyAbsSyn13  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn12
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  13 happyReduction_34
happyReduction_34 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_2  13 happyReduction_35
happyReduction_35 (HappyAbsSyn21  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_35 _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_0  13 happyReduction_36
happyReduction_36  =  HappyAbsSyn13
		 ([]
	)

happyReduce_37 = happyReduce 12 14 happyReduction_37
happyReduction_37 ((HappyAbsSyn15  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (FunDecInstFun happy_var_5 (TyInstArrow happy_var_3 happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_38 = happyReduce 9 14 happyReduction_38
happyReduction_38 ((HappyAbsSyn15  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (FunDecFun happy_var_2 (TyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_39 = happySpecReduce_1  15 happyReduction_39
happyReduction_39 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 ([happy_var_1]
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_2  15 happyReduction_40
happyReduction_40 (HappyAbsSyn16  happy_var_2)
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_40 _ _  = notHappyAtAll 

happyReduce_41 = happyReduce 9 16 happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn18  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_42 = happyReduce 8 16 happyReduction_42
happyReduction_42 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn18  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn16
		 (FunDefFun happy_var_1 happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_43 = happyReduce 4 17 happyReduction_43
happyReduction_43 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_44 = happySpecReduce_1  18 happyReduction_44
happyReduction_44 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  18 happyReduction_45
happyReduction_45 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  18 happyReduction_46
happyReduction_46  =  HappyAbsSyn18
		 ([]
	)

happyReduce_47 = happySpecReduce_1  19 happyReduction_47
happyReduction_47 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn19
		 (PatExpVar happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  20 happyReduction_48
happyReduction_48 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 ([happy_var_1]
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  20 happyReduction_49
happyReduction_49 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_0  20 happyReduction_50
happyReduction_50  =  HappyAbsSyn20
		 ([]
	)

happyReduce_51 = happySpecReduce_1  21 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn21
		 (TyInt
	)

happyReduce_52 = happySpecReduce_1  21 happyReduction_52
happyReduction_52 _
	 =  HappyAbsSyn21
		 (TyBool
	)

happyReduce_53 = happySpecReduce_1  21 happyReduction_53
happyReduction_53 _
	 =  HappyAbsSyn21
		 (TyUnit
	)

happyReduce_54 = happyReduce 6 21 happyReduction_54
happyReduction_54 ((HappyAbsSyn21  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_55 = happySpecReduce_3  21 happyReduction_55
happyReduction_55 _
	_
	_
	 =  HappyAbsSyn21
		 (TyModule
	)

happyReduce_56 = happySpecReduce_3  21 happyReduction_56
happyReduction_56 _
	_
	_
	 =  HappyAbsSyn21
		 (TyInterface
	)

happyReduce_57 = happySpecReduce_1  21 happyReduction_57
happyReduction_57 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn21
		 (TyRef happy_var_1
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  22 happyReduction_58
happyReduction_58 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn22
		 (Id happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  22 happyReduction_59
happyReduction_59 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (Path happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 55 55 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 23;
	Token _ TokenImport -> cont 24;
	Token _ TokenType -> cont 25;
	Token _ TokenInterface -> cont 26;
	Token _ TokenFun -> cont 27;
	Token _ TokenImp -> cont 28;
	Token _ TokenTest -> cont 29;
	Token _ TokenTrue -> cont 30;
	Token _ TokenFalse -> cont 31;
	Token _ TokenInt -> cont 32;
	Token _ TokenBool -> cont 33;
	Token _ TokenUnit -> cont 34;
	Token _ TokenAssign -> cont 35;
	Token _ TokenLBracket -> cont 36;
	Token _ TokenRBracket -> cont 37;
	Token _ TokenLBrace -> cont 38;
	Token _ TokenRBrace -> cont 39;
	Token _ TokenLParen -> cont 40;
	Token _ TokenRParen -> cont 41;
	Token _ TokenPipe -> cont 42;
	Token _ TokenPlus -> cont 43;
	Token _ TokenMinus -> cont 44;
	Token _ TokenStar -> cont 45;
	Token _ TokenFSlash -> cont 46;
	Token _ TokenExclamation -> cont 47;
	Token _ TokenSemi -> cont 48;
	Token _ TokenDot -> cont 49;
	Token _ TokenEq -> cont 50;
	Token _ TokenColon -> cont 51;
	Token _ TokenComma -> cont 52;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 53;
	Token _ (TokenId happy_dollar_dollar) -> cont 54;
	_ -> happyError' tk
	})

happyError_ 55 tk = happyError' tk
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

parseExp :: FilePath -> String -> Either String CompUnit
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

