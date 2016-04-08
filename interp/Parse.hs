{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34
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

action_0 (35) = happyShift action_14
action_0 (36) = happyShift action_15
action_0 (37) = happyShift action_16
action_0 (39) = happyShift action_17
action_0 (43) = happyShift action_18
action_0 (44) = happyShift action_19
action_0 (48) = happyShift action_20
action_0 (55) = happyShift action_21
action_0 (62) = happyShift action_22
action_0 (68) = happyShift action_23
action_0 (69) = happyShift action_24
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

action_1 (35) = happyShift action_14
action_1 (36) = happyShift action_15
action_1 (37) = happyShift action_16
action_1 (39) = happyShift action_17
action_1 (43) = happyShift action_18
action_1 (44) = happyShift action_19
action_1 (48) = happyShift action_20
action_1 (55) = happyShift action_21
action_1 (62) = happyShift action_22
action_1 (68) = happyShift action_23
action_1 (69) = happyShift action_24
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

action_2 (35) = happyShift action_14
action_2 (36) = happyShift action_15
action_2 (37) = happyShift action_16
action_2 (39) = happyShift action_17
action_2 (43) = happyShift action_18
action_2 (44) = happyShift action_19
action_2 (48) = happyShift action_20
action_2 (55) = happyShift action_21
action_2 (62) = happyShift action_22
action_2 (68) = happyShift action_23
action_2 (69) = happyShift action_24
action_2 (7) = happyGoto action_47
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

action_5 (53) = happyShift action_46
action_5 _ = happyReduce_18

action_6 (55) = happyShift action_44
action_6 (64) = happyShift action_45
action_6 _ = happyReduce_20

action_7 (60) = happyShift action_43
action_7 _ = happyReduce_22

action_8 (61) = happyShift action_42
action_8 _ = happyReduce_24

action_9 (58) = happyShift action_41
action_9 _ = happyReduce_26

action_10 (59) = happyShift action_40
action_10 _ = happyReduce_28

action_11 (63) = happyShift action_39
action_11 _ = happyFail

action_12 _ = happyReduce_32

action_13 _ = happyReduce_33

action_14 (53) = happyShift action_38
action_14 _ = happyFail

action_15 (69) = happyShift action_37
action_15 (34) = happyGoto action_36
action_15 _ = happyFail

action_16 (69) = happyShift action_35
action_16 _ = happyFail

action_17 (55) = happyShift action_33
action_17 (69) = happyShift action_34
action_17 _ = happyFail

action_18 _ = happyReduce_12

action_19 _ = happyReduce_13

action_20 (55) = happyShift action_32
action_20 _ = happyFail

action_21 (35) = happyShift action_14
action_21 (36) = happyShift action_15
action_21 (37) = happyShift action_16
action_21 (39) = happyShift action_17
action_21 (43) = happyShift action_18
action_21 (44) = happyShift action_19
action_21 (48) = happyShift action_20
action_21 (55) = happyShift action_21
action_21 (56) = happyShift action_31
action_21 (62) = happyShift action_22
action_21 (68) = happyShift action_23
action_21 (69) = happyShift action_24
action_21 (8) = happyGoto action_4
action_21 (9) = happyGoto action_5
action_21 (10) = happyGoto action_6
action_21 (11) = happyGoto action_7
action_21 (12) = happyGoto action_8
action_21 (13) = happyGoto action_9
action_21 (14) = happyGoto action_10
action_21 (15) = happyGoto action_30
action_21 (18) = happyGoto action_12
action_21 (22) = happyGoto action_13
action_21 _ = happyFail

action_22 (35) = happyShift action_14
action_22 (43) = happyShift action_18
action_22 (44) = happyShift action_19
action_22 (55) = happyShift action_21
action_22 (68) = happyShift action_23
action_22 (69) = happyShift action_29
action_22 (8) = happyGoto action_4
action_22 (9) = happyGoto action_27
action_22 (10) = happyGoto action_6
action_22 (11) = happyGoto action_7
action_22 (12) = happyGoto action_8
action_22 (13) = happyGoto action_9
action_22 (14) = happyGoto action_28
action_22 _ = happyFail

action_23 _ = happyReduce_11

action_24 (50) = happyShift action_26
action_24 _ = happyReduce_14

action_25 (70) = happyAccept
action_25 _ = happyFail

action_26 (35) = happyShift action_14
action_26 (36) = happyShift action_15
action_26 (37) = happyShift action_16
action_26 (39) = happyShift action_17
action_26 (43) = happyShift action_18
action_26 (44) = happyShift action_19
action_26 (48) = happyShift action_20
action_26 (55) = happyShift action_21
action_26 (62) = happyShift action_22
action_26 (68) = happyShift action_23
action_26 (69) = happyShift action_24
action_26 (8) = happyGoto action_4
action_26 (9) = happyGoto action_5
action_26 (10) = happyGoto action_6
action_26 (11) = happyGoto action_7
action_26 (12) = happyGoto action_8
action_26 (13) = happyGoto action_9
action_26 (14) = happyGoto action_10
action_26 (15) = happyGoto action_75
action_26 (18) = happyGoto action_12
action_26 (22) = happyGoto action_13
action_26 _ = happyFail

action_27 _ = happyReduce_18

action_28 (59) = happyShift action_40
action_28 _ = happyReduce_27

action_29 _ = happyReduce_14

action_30 (56) = happyShift action_74
action_30 _ = happyFail

action_31 _ = happyReduce_10

action_32 (35) = happyShift action_14
action_32 (36) = happyShift action_15
action_32 (37) = happyShift action_16
action_32 (39) = happyShift action_17
action_32 (43) = happyShift action_18
action_32 (44) = happyShift action_19
action_32 (48) = happyShift action_20
action_32 (55) = happyShift action_21
action_32 (62) = happyShift action_22
action_32 (68) = happyShift action_23
action_32 (69) = happyShift action_24
action_32 (8) = happyGoto action_4
action_32 (9) = happyGoto action_5
action_32 (10) = happyGoto action_6
action_32 (11) = happyGoto action_7
action_32 (12) = happyGoto action_8
action_32 (13) = happyGoto action_9
action_32 (14) = happyGoto action_10
action_32 (15) = happyGoto action_73
action_32 (18) = happyGoto action_12
action_32 (22) = happyGoto action_13
action_32 _ = happyFail

action_33 (35) = happyShift action_66
action_33 (38) = happyShift action_67
action_33 (39) = happyShift action_68
action_33 (42) = happyShift action_69
action_33 (45) = happyShift action_70
action_33 (46) = happyShift action_71
action_33 (47) = happyShift action_72
action_33 (69) = happyShift action_37
action_33 (29) = happyGoto action_64
action_33 (34) = happyGoto action_65
action_33 _ = happyFail

action_34 (55) = happyShift action_63
action_34 _ = happyFail

action_35 (65) = happyShift action_62
action_35 _ = happyFail

action_36 (64) = happyShift action_61
action_36 _ = happyReduce_29

action_37 _ = happyReduce_80

action_38 (35) = happyShift action_14
action_38 (36) = happyShift action_15
action_38 (37) = happyShift action_16
action_38 (39) = happyShift action_17
action_38 (43) = happyShift action_18
action_38 (44) = happyShift action_19
action_38 (48) = happyShift action_20
action_38 (55) = happyShift action_21
action_38 (62) = happyShift action_22
action_38 (68) = happyShift action_23
action_38 (69) = happyShift action_24
action_38 (5) = happyGoto action_58
action_38 (6) = happyGoto action_59
action_38 (7) = happyGoto action_60
action_38 (8) = happyGoto action_4
action_38 (9) = happyGoto action_5
action_38 (10) = happyGoto action_6
action_38 (11) = happyGoto action_7
action_38 (12) = happyGoto action_8
action_38 (13) = happyGoto action_9
action_38 (14) = happyGoto action_10
action_38 (15) = happyGoto action_11
action_38 (18) = happyGoto action_12
action_38 (22) = happyGoto action_13
action_38 _ = happyReduce_6

action_39 _ = happyReduce_7

action_40 (35) = happyShift action_14
action_40 (43) = happyShift action_18
action_40 (44) = happyShift action_19
action_40 (55) = happyShift action_21
action_40 (68) = happyShift action_23
action_40 (69) = happyShift action_29
action_40 (8) = happyGoto action_4
action_40 (9) = happyGoto action_27
action_40 (10) = happyGoto action_6
action_40 (11) = happyGoto action_7
action_40 (12) = happyGoto action_8
action_40 (13) = happyGoto action_57
action_40 _ = happyFail

action_41 (35) = happyShift action_14
action_41 (43) = happyShift action_18
action_41 (44) = happyShift action_19
action_41 (55) = happyShift action_21
action_41 (68) = happyShift action_23
action_41 (69) = happyShift action_29
action_41 (8) = happyGoto action_4
action_41 (9) = happyGoto action_27
action_41 (10) = happyGoto action_6
action_41 (11) = happyGoto action_7
action_41 (12) = happyGoto action_56
action_41 _ = happyFail

action_42 (35) = happyShift action_14
action_42 (43) = happyShift action_18
action_42 (44) = happyShift action_19
action_42 (55) = happyShift action_21
action_42 (68) = happyShift action_23
action_42 (69) = happyShift action_29
action_42 (8) = happyGoto action_4
action_42 (9) = happyGoto action_27
action_42 (10) = happyGoto action_6
action_42 (11) = happyGoto action_55
action_42 _ = happyFail

action_43 (35) = happyShift action_14
action_43 (43) = happyShift action_18
action_43 (44) = happyShift action_19
action_43 (55) = happyShift action_21
action_43 (68) = happyShift action_23
action_43 (69) = happyShift action_29
action_43 (8) = happyGoto action_4
action_43 (9) = happyGoto action_27
action_43 (10) = happyGoto action_54
action_43 _ = happyFail

action_44 (35) = happyShift action_14
action_44 (36) = happyShift action_15
action_44 (37) = happyShift action_16
action_44 (39) = happyShift action_17
action_44 (43) = happyShift action_18
action_44 (44) = happyShift action_19
action_44 (48) = happyShift action_20
action_44 (55) = happyShift action_21
action_44 (62) = happyShift action_22
action_44 (68) = happyShift action_23
action_44 (69) = happyShift action_24
action_44 (8) = happyGoto action_4
action_44 (9) = happyGoto action_5
action_44 (10) = happyGoto action_6
action_44 (11) = happyGoto action_7
action_44 (12) = happyGoto action_8
action_44 (13) = happyGoto action_9
action_44 (14) = happyGoto action_10
action_44 (15) = happyGoto action_52
action_44 (16) = happyGoto action_53
action_44 (18) = happyGoto action_12
action_44 (22) = happyGoto action_13
action_44 _ = happyReduce_37

action_45 (69) = happyShift action_51
action_45 _ = happyFail

action_46 (69) = happyShift action_50
action_46 (32) = happyGoto action_48
action_46 (33) = happyGoto action_49
action_46 _ = happyReduce_79

action_47 _ = happyReduce_3

action_48 _ = happyReduce_77

action_49 (54) = happyShift action_95
action_49 (69) = happyShift action_50
action_49 (32) = happyGoto action_94
action_49 _ = happyFail

action_50 (65) = happyShift action_93
action_50 _ = happyFail

action_51 _ = happyReduce_15

action_52 _ = happyReduce_35

action_53 (56) = happyShift action_91
action_53 (67) = happyShift action_92
action_53 _ = happyFail

action_54 (55) = happyShift action_44
action_54 (64) = happyShift action_45
action_54 _ = happyReduce_19

action_55 (60) = happyShift action_43
action_55 _ = happyReduce_21

action_56 (61) = happyShift action_42
action_56 _ = happyReduce_23

action_57 (58) = happyShift action_41
action_57 _ = happyReduce_25

action_58 (35) = happyShift action_14
action_58 (36) = happyShift action_15
action_58 (37) = happyShift action_16
action_58 (39) = happyShift action_17
action_58 (43) = happyShift action_18
action_58 (44) = happyShift action_19
action_58 (48) = happyShift action_20
action_58 (55) = happyShift action_21
action_58 (62) = happyShift action_22
action_58 (68) = happyShift action_23
action_58 (69) = happyShift action_24
action_58 (7) = happyGoto action_90
action_58 (8) = happyGoto action_4
action_58 (9) = happyGoto action_5
action_58 (10) = happyGoto action_6
action_58 (11) = happyGoto action_7
action_58 (12) = happyGoto action_8
action_58 (13) = happyGoto action_9
action_58 (14) = happyGoto action_10
action_58 (15) = happyGoto action_11
action_58 (18) = happyGoto action_12
action_58 (22) = happyGoto action_13
action_58 _ = happyFail

action_59 (54) = happyShift action_89
action_59 _ = happyFail

action_60 (54) = happyReduce_4
action_60 _ = happyReduce_2

action_61 (69) = happyShift action_88
action_61 _ = happyFail

action_62 (35) = happyShift action_66
action_62 (38) = happyShift action_67
action_62 (39) = happyShift action_68
action_62 (42) = happyShift action_69
action_62 (45) = happyShift action_70
action_62 (46) = happyShift action_71
action_62 (47) = happyShift action_72
action_62 (57) = happyShift action_87
action_62 (69) = happyShift action_37
action_62 (19) = happyGoto action_84
action_62 (20) = happyGoto action_85
action_62 (29) = happyGoto action_86
action_62 (34) = happyGoto action_65
action_62 _ = happyFail

action_63 (35) = happyShift action_66
action_63 (38) = happyShift action_67
action_63 (39) = happyShift action_68
action_63 (42) = happyShift action_69
action_63 (45) = happyShift action_70
action_63 (46) = happyShift action_71
action_63 (47) = happyShift action_72
action_63 (69) = happyShift action_37
action_63 (28) = happyGoto action_82
action_63 (29) = happyGoto action_83
action_63 (34) = happyGoto action_65
action_63 _ = happyReduce_62

action_64 (56) = happyShift action_81
action_64 _ = happyFail

action_65 (64) = happyShift action_61
action_65 _ = happyReduce_71

action_66 (53) = happyShift action_80
action_66 _ = happyFail

action_67 (53) = happyShift action_79
action_67 _ = happyFail

action_68 (55) = happyShift action_78
action_68 _ = happyFail

action_69 (53) = happyShift action_77
action_69 _ = happyFail

action_70 _ = happyReduce_63

action_71 _ = happyReduce_64

action_72 _ = happyReduce_65

action_73 (56) = happyShift action_76
action_73 _ = happyFail

action_74 _ = happyReduce_8

action_75 _ = happyReduce_30

action_76 (53) = happyShift action_110
action_76 _ = happyFail

action_77 (35) = happyShift action_66
action_77 (38) = happyShift action_67
action_77 (39) = happyShift action_68
action_77 (42) = happyShift action_69
action_77 (45) = happyShift action_70
action_77 (46) = happyShift action_71
action_77 (47) = happyShift action_72
action_77 (69) = happyShift action_37
action_77 (29) = happyGoto action_107
action_77 (30) = happyGoto action_108
action_77 (31) = happyGoto action_109
action_77 (34) = happyGoto action_65
action_77 _ = happyReduce_75

action_78 (35) = happyShift action_66
action_78 (38) = happyShift action_67
action_78 (39) = happyShift action_68
action_78 (42) = happyShift action_69
action_78 (45) = happyShift action_70
action_78 (46) = happyShift action_71
action_78 (47) = happyShift action_72
action_78 (56) = happyShift action_106
action_78 (69) = happyShift action_37
action_78 (28) = happyGoto action_105
action_78 (29) = happyGoto action_83
action_78 (34) = happyGoto action_65
action_78 _ = happyReduce_62

action_79 (54) = happyShift action_104
action_79 _ = happyFail

action_80 (54) = happyShift action_103
action_80 _ = happyFail

action_81 (69) = happyShift action_102
action_81 _ = happyFail

action_82 (56) = happyShift action_100
action_82 (67) = happyShift action_101
action_82 _ = happyFail

action_83 _ = happyReduce_60

action_84 (57) = happyShift action_87
action_84 (20) = happyGoto action_99
action_84 _ = happyReduce_42

action_85 _ = happyReduce_43

action_86 _ = happyReduce_41

action_87 (69) = happyShift action_98
action_87 _ = happyFail

action_88 _ = happyReduce_81

action_89 _ = happyReduce_9

action_90 (54) = happyReduce_5
action_90 _ = happyReduce_3

action_91 _ = happyReduce_17

action_92 (35) = happyShift action_14
action_92 (36) = happyShift action_15
action_92 (37) = happyShift action_16
action_92 (39) = happyShift action_17
action_92 (43) = happyShift action_18
action_92 (44) = happyShift action_19
action_92 (48) = happyShift action_20
action_92 (55) = happyShift action_21
action_92 (62) = happyShift action_22
action_92 (68) = happyShift action_23
action_92 (69) = happyShift action_24
action_92 (8) = happyGoto action_4
action_92 (9) = happyGoto action_5
action_92 (10) = happyGoto action_6
action_92 (11) = happyGoto action_7
action_92 (12) = happyGoto action_8
action_92 (13) = happyGoto action_9
action_92 (14) = happyGoto action_10
action_92 (15) = happyGoto action_97
action_92 (18) = happyGoto action_12
action_92 (22) = happyGoto action_13
action_92 _ = happyFail

action_93 (35) = happyShift action_14
action_93 (36) = happyShift action_15
action_93 (37) = happyShift action_16
action_93 (39) = happyShift action_17
action_93 (43) = happyShift action_18
action_93 (44) = happyShift action_19
action_93 (48) = happyShift action_20
action_93 (55) = happyShift action_21
action_93 (62) = happyShift action_22
action_93 (68) = happyShift action_23
action_93 (69) = happyShift action_24
action_93 (8) = happyGoto action_4
action_93 (9) = happyGoto action_5
action_93 (10) = happyGoto action_6
action_93 (11) = happyGoto action_7
action_93 (12) = happyGoto action_8
action_93 (13) = happyGoto action_9
action_93 (14) = happyGoto action_10
action_93 (15) = happyGoto action_96
action_93 (18) = happyGoto action_12
action_93 (22) = happyGoto action_13
action_93 _ = happyFail

action_94 _ = happyReduce_78

action_95 _ = happyReduce_31

action_96 (63) = happyShift action_122
action_96 _ = happyFail

action_97 _ = happyReduce_36

action_98 (35) = happyShift action_66
action_98 (38) = happyShift action_67
action_98 (39) = happyShift action_68
action_98 (42) = happyShift action_69
action_98 (45) = happyShift action_70
action_98 (46) = happyShift action_71
action_98 (47) = happyShift action_72
action_98 (69) = happyShift action_37
action_98 (21) = happyGoto action_120
action_98 (29) = happyGoto action_121
action_98 (34) = happyGoto action_65
action_98 _ = happyReduce_48

action_99 _ = happyReduce_44

action_100 (66) = happyShift action_119
action_100 _ = happyFail

action_101 (35) = happyShift action_66
action_101 (38) = happyShift action_67
action_101 (39) = happyShift action_68
action_101 (42) = happyShift action_69
action_101 (45) = happyShift action_70
action_101 (46) = happyShift action_71
action_101 (47) = happyShift action_72
action_101 (69) = happyShift action_37
action_101 (29) = happyGoto action_118
action_101 (34) = happyGoto action_65
action_101 _ = happyFail

action_102 (55) = happyShift action_117
action_102 _ = happyFail

action_103 _ = happyReduce_68

action_104 _ = happyReduce_69

action_105 (56) = happyShift action_116
action_105 (67) = happyShift action_101
action_105 _ = happyFail

action_106 (66) = happyShift action_115
action_106 _ = happyFail

action_107 (69) = happyShift action_114
action_107 _ = happyFail

action_108 _ = happyReduce_73

action_109 (35) = happyShift action_66
action_109 (38) = happyShift action_67
action_109 (39) = happyShift action_68
action_109 (42) = happyShift action_69
action_109 (45) = happyShift action_70
action_109 (46) = happyShift action_71
action_109 (47) = happyShift action_72
action_109 (54) = happyShift action_113
action_109 (69) = happyShift action_37
action_109 (29) = happyGoto action_107
action_109 (30) = happyGoto action_112
action_109 (34) = happyGoto action_65
action_109 _ = happyFail

action_110 (35) = happyShift action_14
action_110 (36) = happyShift action_15
action_110 (37) = happyShift action_16
action_110 (39) = happyShift action_17
action_110 (43) = happyShift action_18
action_110 (44) = happyShift action_19
action_110 (48) = happyShift action_20
action_110 (55) = happyShift action_21
action_110 (62) = happyShift action_22
action_110 (68) = happyShift action_23
action_110 (69) = happyShift action_24
action_110 (5) = happyGoto action_58
action_110 (6) = happyGoto action_111
action_110 (7) = happyGoto action_60
action_110 (8) = happyGoto action_4
action_110 (9) = happyGoto action_5
action_110 (10) = happyGoto action_6
action_110 (11) = happyGoto action_7
action_110 (12) = happyGoto action_8
action_110 (13) = happyGoto action_9
action_110 (14) = happyGoto action_10
action_110 (15) = happyGoto action_11
action_110 (18) = happyGoto action_12
action_110 (22) = happyGoto action_13
action_110 _ = happyReduce_6

action_111 (54) = happyShift action_129
action_111 _ = happyFail

action_112 _ = happyReduce_74

action_113 _ = happyReduce_70

action_114 (63) = happyShift action_128
action_114 _ = happyFail

action_115 (35) = happyShift action_66
action_115 (38) = happyShift action_67
action_115 (39) = happyShift action_68
action_115 (42) = happyShift action_69
action_115 (45) = happyShift action_70
action_115 (46) = happyShift action_71
action_115 (47) = happyShift action_72
action_115 (69) = happyShift action_37
action_115 (29) = happyGoto action_127
action_115 (34) = happyGoto action_65
action_115 _ = happyFail

action_116 (66) = happyShift action_126
action_116 _ = happyFail

action_117 (35) = happyShift action_66
action_117 (38) = happyShift action_67
action_117 (39) = happyShift action_68
action_117 (42) = happyShift action_69
action_117 (45) = happyShift action_70
action_117 (46) = happyShift action_71
action_117 (47) = happyShift action_72
action_117 (69) = happyShift action_37
action_117 (28) = happyGoto action_125
action_117 (29) = happyGoto action_83
action_117 (34) = happyGoto action_65
action_117 _ = happyReduce_62

action_118 _ = happyReduce_61

action_119 (35) = happyShift action_66
action_119 (38) = happyShift action_67
action_119 (39) = happyShift action_68
action_119 (42) = happyShift action_69
action_119 (45) = happyShift action_70
action_119 (46) = happyShift action_71
action_119 (47) = happyShift action_72
action_119 (69) = happyShift action_37
action_119 (29) = happyGoto action_124
action_119 (34) = happyGoto action_65
action_119 _ = happyFail

action_120 (35) = happyShift action_66
action_120 (38) = happyShift action_67
action_120 (39) = happyShift action_68
action_120 (42) = happyShift action_69
action_120 (45) = happyShift action_70
action_120 (46) = happyShift action_71
action_120 (47) = happyShift action_72
action_120 (69) = happyShift action_37
action_120 (29) = happyGoto action_123
action_120 (34) = happyGoto action_65
action_120 _ = happyReduce_45

action_121 _ = happyReduce_46

action_122 _ = happyReduce_76

action_123 _ = happyReduce_47

action_124 (63) = happyShift action_133
action_124 _ = happyFail

action_125 (56) = happyShift action_132
action_125 (67) = happyShift action_101
action_125 _ = happyFail

action_126 (35) = happyShift action_66
action_126 (38) = happyShift action_67
action_126 (39) = happyShift action_68
action_126 (42) = happyShift action_69
action_126 (45) = happyShift action_70
action_126 (46) = happyShift action_71
action_126 (47) = happyShift action_72
action_126 (69) = happyShift action_37
action_126 (29) = happyGoto action_131
action_126 (34) = happyGoto action_65
action_126 _ = happyFail

action_127 _ = happyReduce_66

action_128 _ = happyReduce_72

action_129 (49) = happyShift action_130
action_129 _ = happyFail

action_130 (53) = happyShift action_140
action_130 _ = happyFail

action_131 _ = happyReduce_67

action_132 (66) = happyShift action_139
action_132 _ = happyFail

action_133 (55) = happyShift action_137
action_133 (69) = happyShift action_138
action_133 (23) = happyGoto action_134
action_133 (24) = happyGoto action_135
action_133 (25) = happyGoto action_136
action_133 _ = happyFail

action_134 (55) = happyShift action_137
action_134 (69) = happyShift action_138
action_134 (24) = happyGoto action_147
action_134 (25) = happyGoto action_136
action_134 _ = happyReduce_50

action_135 _ = happyReduce_51

action_136 (69) = happyShift action_146
action_136 _ = happyFail

action_137 (69) = happyShift action_145
action_137 (27) = happyGoto action_144
action_137 _ = happyFail

action_138 (55) = happyShift action_143
action_138 _ = happyFail

action_139 (35) = happyShift action_66
action_139 (38) = happyShift action_67
action_139 (39) = happyShift action_68
action_139 (42) = happyShift action_69
action_139 (45) = happyShift action_70
action_139 (46) = happyShift action_71
action_139 (47) = happyShift action_72
action_139 (69) = happyShift action_37
action_139 (29) = happyGoto action_142
action_139 (34) = happyGoto action_65
action_139 _ = happyFail

action_140 (35) = happyShift action_14
action_140 (36) = happyShift action_15
action_140 (37) = happyShift action_16
action_140 (39) = happyShift action_17
action_140 (43) = happyShift action_18
action_140 (44) = happyShift action_19
action_140 (48) = happyShift action_20
action_140 (55) = happyShift action_21
action_140 (62) = happyShift action_22
action_140 (68) = happyShift action_23
action_140 (69) = happyShift action_24
action_140 (5) = happyGoto action_58
action_140 (6) = happyGoto action_141
action_140 (7) = happyGoto action_60
action_140 (8) = happyGoto action_4
action_140 (9) = happyGoto action_5
action_140 (10) = happyGoto action_6
action_140 (11) = happyGoto action_7
action_140 (12) = happyGoto action_8
action_140 (13) = happyGoto action_9
action_140 (14) = happyGoto action_10
action_140 (15) = happyGoto action_11
action_140 (18) = happyGoto action_12
action_140 (22) = happyGoto action_13
action_140 _ = happyReduce_6

action_141 (54) = happyShift action_153
action_141 _ = happyFail

action_142 (63) = happyShift action_152
action_142 _ = happyFail

action_143 (69) = happyShift action_145
action_143 (26) = happyGoto action_150
action_143 (27) = happyGoto action_151
action_143 _ = happyReduce_58

action_144 (56) = happyShift action_149
action_144 _ = happyFail

action_145 _ = happyReduce_59

action_146 (55) = happyShift action_148
action_146 _ = happyFail

action_147 _ = happyReduce_52

action_148 (69) = happyShift action_145
action_148 (26) = happyGoto action_158
action_148 (27) = happyGoto action_151
action_148 _ = happyReduce_58

action_149 (64) = happyShift action_157
action_149 _ = happyFail

action_150 (56) = happyShift action_155
action_150 (67) = happyShift action_156
action_150 _ = happyFail

action_151 _ = happyReduce_56

action_152 (55) = happyShift action_137
action_152 (69) = happyShift action_138
action_152 (23) = happyGoto action_154
action_152 (24) = happyGoto action_135
action_152 (25) = happyGoto action_136
action_152 _ = happyFail

action_153 _ = happyReduce_34

action_154 (55) = happyShift action_137
action_154 (69) = happyShift action_138
action_154 (24) = happyGoto action_147
action_154 (25) = happyGoto action_136
action_154 _ = happyReduce_49

action_155 (50) = happyShift action_161
action_155 _ = happyFail

action_156 (69) = happyShift action_145
action_156 (27) = happyGoto action_160
action_156 _ = happyFail

action_157 _ = happyReduce_55

action_158 (56) = happyShift action_159
action_158 (67) = happyShift action_156
action_158 _ = happyFail

action_159 (50) = happyShift action_163
action_159 _ = happyFail

action_160 _ = happyReduce_57

action_161 (53) = happyShift action_162
action_161 _ = happyFail

action_162 (35) = happyShift action_14
action_162 (36) = happyShift action_15
action_162 (37) = happyShift action_16
action_162 (39) = happyShift action_17
action_162 (43) = happyShift action_18
action_162 (44) = happyShift action_19
action_162 (48) = happyShift action_20
action_162 (55) = happyShift action_21
action_162 (62) = happyShift action_22
action_162 (68) = happyShift action_23
action_162 (69) = happyShift action_24
action_162 (5) = happyGoto action_165
action_162 (7) = happyGoto action_3
action_162 (8) = happyGoto action_4
action_162 (9) = happyGoto action_5
action_162 (10) = happyGoto action_6
action_162 (11) = happyGoto action_7
action_162 (12) = happyGoto action_8
action_162 (13) = happyGoto action_9
action_162 (14) = happyGoto action_10
action_162 (15) = happyGoto action_11
action_162 (18) = happyGoto action_12
action_162 (22) = happyGoto action_13
action_162 _ = happyFail

action_163 (53) = happyShift action_164
action_163 _ = happyFail

action_164 (35) = happyShift action_14
action_164 (36) = happyShift action_15
action_164 (37) = happyShift action_16
action_164 (39) = happyShift action_17
action_164 (43) = happyShift action_18
action_164 (44) = happyShift action_19
action_164 (48) = happyShift action_20
action_164 (55) = happyShift action_21
action_164 (62) = happyShift action_22
action_164 (68) = happyShift action_23
action_164 (69) = happyShift action_24
action_164 (5) = happyGoto action_167
action_164 (7) = happyGoto action_3
action_164 (8) = happyGoto action_4
action_164 (9) = happyGoto action_5
action_164 (10) = happyGoto action_6
action_164 (11) = happyGoto action_7
action_164 (12) = happyGoto action_8
action_164 (13) = happyGoto action_9
action_164 (14) = happyGoto action_10
action_164 (15) = happyGoto action_11
action_164 (18) = happyGoto action_12
action_164 (22) = happyGoto action_13
action_164 _ = happyFail

action_165 (35) = happyShift action_14
action_165 (36) = happyShift action_15
action_165 (37) = happyShift action_16
action_165 (39) = happyShift action_17
action_165 (43) = happyShift action_18
action_165 (44) = happyShift action_19
action_165 (48) = happyShift action_20
action_165 (54) = happyShift action_166
action_165 (55) = happyShift action_21
action_165 (62) = happyShift action_22
action_165 (68) = happyShift action_23
action_165 (69) = happyShift action_24
action_165 (7) = happyGoto action_47
action_165 (8) = happyGoto action_4
action_165 (9) = happyGoto action_5
action_165 (10) = happyGoto action_6
action_165 (11) = happyGoto action_7
action_165 (12) = happyGoto action_8
action_165 (13) = happyGoto action_9
action_165 (14) = happyGoto action_10
action_165 (15) = happyGoto action_11
action_165 (18) = happyGoto action_12
action_165 (22) = happyGoto action_13
action_165 _ = happyFail

action_166 _ = happyReduce_54

action_167 (35) = happyShift action_14
action_167 (36) = happyShift action_15
action_167 (37) = happyShift action_16
action_167 (39) = happyShift action_17
action_167 (43) = happyShift action_18
action_167 (44) = happyShift action_19
action_167 (48) = happyShift action_20
action_167 (54) = happyShift action_168
action_167 (55) = happyShift action_21
action_167 (62) = happyShift action_22
action_167 (68) = happyShift action_23
action_167 (69) = happyShift action_24
action_167 (7) = happyGoto action_47
action_167 (8) = happyGoto action_4
action_167 (9) = happyGoto action_5
action_167 (10) = happyGoto action_6
action_167 (11) = happyGoto action_7
action_167 (12) = happyGoto action_8
action_167 (13) = happyGoto action_9
action_167 (14) = happyGoto action_10
action_167 (15) = happyGoto action_11
action_167 (18) = happyGoto action_12
action_167 (22) = happyGoto action_13
action_167 _ = happyFail

action_168 _ = happyReduce_53

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
happyReduction_29 (HappyAbsSyn34  happy_var_2)
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

happyReduce_31 = happyReduce 4 15 happyReduction_31
happyReduction_31 (_ `HappyStk`
	(HappyAbsSyn33  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (ExpStruct happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_1  15 happyReduction_32
happyReduction_32 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpTypeDec happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  15 happyReduction_33
happyReduction_33 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpFunDec happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happyReduce 11 15 happyReduction_34
happyReduction_34 (_ `HappyStk`
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

happyReduce_35 = happySpecReduce_1  16 happyReduction_35
happyReduction_35 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  16 happyReduction_36
happyReduction_36 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_0  16 happyReduction_37
happyReduction_37  =  HappyAbsSyn16
		 ([]
	)

happyReduce_38 = happySpecReduce_1  17 happyReduction_38
happyReduction_38 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn17
		 ([happy_var_1]
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  17 happyReduction_39
happyReduction_39 (HappyTerminal (Token _ (TokenId happy_var_3)))
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

happyReduce_41 = happyReduce 4 18 happyReduction_41
happyReduction_41 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_42 = happyReduce 4 18 happyReduction_42
happyReduction_42 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_43 = happySpecReduce_1  19 happyReduction_43
happyReduction_43 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_2  19 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn20
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  21 happyReduction_46
happyReduction_46 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_2  21 happyReduction_47
happyReduction_47 (HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_47 _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_0  21 happyReduction_48
happyReduction_48  =  HappyAbsSyn21
		 ([]
	)

happyReduce_49 = happyReduce 12 22 happyReduction_49
happyReduction_49 ((HappyAbsSyn23  happy_var_12) `HappyStk`
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

happyReduce_50 = happyReduce 9 22 happyReduction_50
happyReduction_50 ((HappyAbsSyn23  happy_var_9) `HappyStk`
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

happyReduce_51 = happySpecReduce_1  23 happyReduction_51
happyReduction_51 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_2  23 happyReduction_52
happyReduction_52 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_52 _ _  = notHappyAtAll 

happyReduce_53 = happyReduce 9 24 happyReduction_53
happyReduction_53 (_ `HappyStk`
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

happyReduce_54 = happyReduce 8 24 happyReduction_54
happyReduction_54 (_ `HappyStk`
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

happyReduce_55 = happyReduce 4 25 happyReduction_55
happyReduction_55 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_1  26 happyReduction_56
happyReduction_56 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  26 happyReduction_57
happyReduction_57 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_0  26 happyReduction_58
happyReduction_58  =  HappyAbsSyn26
		 ([]
	)

happyReduce_59 = happySpecReduce_1  27 happyReduction_59
happyReduction_59 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn27
		 (PatExpVar happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  28 happyReduction_60
happyReduction_60 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 ([happy_var_1]
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  28 happyReduction_61
happyReduction_61 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_0  28 happyReduction_62
happyReduction_62  =  HappyAbsSyn28
		 ([]
	)

happyReduce_63 = happySpecReduce_1  29 happyReduction_63
happyReduction_63 _
	 =  HappyAbsSyn29
		 (TyInt
	)

happyReduce_64 = happySpecReduce_1  29 happyReduction_64
happyReduction_64 _
	 =  HappyAbsSyn29
		 (TyBool
	)

happyReduce_65 = happySpecReduce_1  29 happyReduction_65
happyReduction_65 _
	 =  HappyAbsSyn29
		 (TyUnit
	)

happyReduce_66 = happyReduce 5 29 happyReduction_66
happyReduction_66 ((HappyAbsSyn29  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_67 = happyReduce 6 29 happyReduction_67
happyReduction_67 ((HappyAbsSyn29  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_68 = happySpecReduce_3  29 happyReduction_68
happyReduction_68 _
	_
	_
	 =  HappyAbsSyn29
		 (TyModule
	)

happyReduce_69 = happySpecReduce_3  29 happyReduction_69
happyReduction_69 _
	_
	_
	 =  HappyAbsSyn29
		 (TyInterface
	)

happyReduce_70 = happyReduce 4 29 happyReduction_70
happyReduction_70 (_ `HappyStk`
	(HappyAbsSyn31  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (TyStruct happy_var_3
	) `HappyStk` happyRest

happyReduce_71 = happySpecReduce_1  29 happyReduction_71
happyReduction_71 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn29
		 (TyRef happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  30 happyReduction_72
happyReduction_72 _
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn30
		 ((happy_var_2, happy_var_1)
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  31 happyReduction_73
happyReduction_73 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn31
		 ([happy_var_1]
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_2  31 happyReduction_74
happyReduction_74 (HappyAbsSyn30  happy_var_2)
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_74 _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_0  31 happyReduction_75
happyReduction_75  =  HappyAbsSyn31
		 ([]
	)

happyReduce_76 = happyReduce 4 32 happyReduction_76
happyReduction_76 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_77 = happySpecReduce_1  33 happyReduction_77
happyReduction_77 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn33
		 ([happy_var_1]
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_2  33 happyReduction_78
happyReduction_78 (HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_78 _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_0  33 happyReduction_79
happyReduction_79  =  HappyAbsSyn33
		 ([]
	)

happyReduce_80 = happySpecReduce_1  34 happyReduction_80
happyReduction_80 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn34
		 (Id happy_var_1
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  34 happyReduction_81
happyReduction_81 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn34
		 (Path happy_var_1 happy_var_3
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 70 70 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 35;
	Token _ TokenImport -> cont 36;
	Token _ TokenType -> cont 37;
	Token _ TokenInterface -> cont 38;
	Token _ TokenFun -> cont 39;
	Token _ TokenImp -> cont 40;
	Token _ TokenTest -> cont 41;
	Token _ TokenStruct -> cont 42;
	Token _ TokenTrue -> cont 43;
	Token _ TokenFalse -> cont 44;
	Token _ TokenInt -> cont 45;
	Token _ TokenBool -> cont 46;
	Token _ TokenUnit -> cont 47;
	Token _ TokenIf -> cont 48;
	Token _ TokenElse -> cont 49;
	Token _ TokenAssign -> cont 50;
	Token _ TokenLBracket -> cont 51;
	Token _ TokenRBracket -> cont 52;
	Token _ TokenLBrace -> cont 53;
	Token _ TokenRBrace -> cont 54;
	Token _ TokenLParen -> cont 55;
	Token _ TokenRParen -> cont 56;
	Token _ TokenPipe -> cont 57;
	Token _ TokenPlus -> cont 58;
	Token _ TokenMinus -> cont 59;
	Token _ TokenStar -> cont 60;
	Token _ TokenFSlash -> cont 61;
	Token _ TokenExclamation -> cont 62;
	Token _ TokenSemi -> cont 63;
	Token _ TokenDot -> cont 64;
	Token _ TokenEq -> cont 65;
	Token _ TokenColon -> cont 66;
	Token _ TokenComma -> cont 67;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 68;
	Token _ (TokenId happy_dollar_dollar) -> cont 69;
	_ -> happyError' tk
	})

happyError_ 70 tk = happyError' tk
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

