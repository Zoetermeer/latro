{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51
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
	| HappyAbsSyn50 t50
	| HappyAbsSyn51 t51

action_0 (52) = happyShift action_16
action_0 (53) = happyShift action_17
action_0 (54) = happyShift action_18
action_0 (56) = happyShift action_19
action_0 (60) = happyShift action_20
action_0 (61) = happyShift action_21
action_0 (62) = happyShift action_22
action_0 (67) = happyShift action_23
action_0 (69) = happyShift action_24
action_0 (74) = happyShift action_25
action_0 (78) = happyShift action_26
action_0 (85) = happyShift action_27
action_0 (92) = happyShift action_28
action_0 (93) = happyShift action_29
action_0 (94) = happyShift action_30
action_0 (4) = happyGoto action_31
action_0 (5) = happyGoto action_2
action_0 (7) = happyGoto action_3
action_0 (19) = happyGoto action_4
action_0 (21) = happyGoto action_5
action_0 (22) = happyGoto action_6
action_0 (23) = happyGoto action_7
action_0 (24) = happyGoto action_8
action_0 (25) = happyGoto action_9
action_0 (26) = happyGoto action_10
action_0 (27) = happyGoto action_11
action_0 (28) = happyGoto action_12
action_0 (29) = happyGoto action_13
action_0 (34) = happyGoto action_14
action_0 (38) = happyGoto action_15
action_0 _ = happyFail

action_1 (52) = happyShift action_16
action_1 (53) = happyShift action_17
action_1 (54) = happyShift action_18
action_1 (56) = happyShift action_19
action_1 (60) = happyShift action_20
action_1 (61) = happyShift action_21
action_1 (62) = happyShift action_22
action_1 (67) = happyShift action_23
action_1 (69) = happyShift action_24
action_1 (74) = happyShift action_25
action_1 (78) = happyShift action_26
action_1 (85) = happyShift action_27
action_1 (92) = happyShift action_28
action_1 (93) = happyShift action_29
action_1 (94) = happyShift action_30
action_1 (5) = happyGoto action_2
action_1 (7) = happyGoto action_3
action_1 (19) = happyGoto action_4
action_1 (21) = happyGoto action_5
action_1 (22) = happyGoto action_6
action_1 (23) = happyGoto action_7
action_1 (24) = happyGoto action_8
action_1 (25) = happyGoto action_9
action_1 (26) = happyGoto action_10
action_1 (27) = happyGoto action_11
action_1 (28) = happyGoto action_12
action_1 (29) = happyGoto action_13
action_1 (34) = happyGoto action_14
action_1 (38) = happyGoto action_15
action_1 _ = happyFail

action_2 (52) = happyShift action_16
action_2 (53) = happyShift action_17
action_2 (54) = happyShift action_18
action_2 (56) = happyShift action_19
action_2 (60) = happyShift action_20
action_2 (61) = happyShift action_21
action_2 (62) = happyShift action_22
action_2 (67) = happyShift action_23
action_2 (69) = happyShift action_24
action_2 (74) = happyShift action_25
action_2 (78) = happyShift action_26
action_2 (85) = happyShift action_27
action_2 (92) = happyShift action_28
action_2 (93) = happyShift action_29
action_2 (94) = happyShift action_30
action_2 (7) = happyGoto action_69
action_2 (19) = happyGoto action_4
action_2 (21) = happyGoto action_5
action_2 (22) = happyGoto action_6
action_2 (23) = happyGoto action_7
action_2 (24) = happyGoto action_8
action_2 (25) = happyGoto action_9
action_2 (26) = happyGoto action_10
action_2 (27) = happyGoto action_11
action_2 (28) = happyGoto action_12
action_2 (29) = happyGoto action_13
action_2 (34) = happyGoto action_14
action_2 (38) = happyGoto action_15
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 _ = happyReduce_44

action_5 _ = happyReduce_52

action_6 (76) = happyShift action_68
action_6 _ = happyReduce_54

action_7 (78) = happyShift action_66
action_7 (87) = happyShift action_67
action_7 _ = happyReduce_56

action_8 (83) = happyShift action_65
action_8 _ = happyReduce_58

action_9 (84) = happyShift action_64
action_9 _ = happyReduce_60

action_10 (81) = happyShift action_63
action_10 _ = happyReduce_62

action_11 (73) = happyShift action_61
action_11 (82) = happyShift action_62
action_11 _ = happyReduce_64

action_12 _ = happyReduce_66

action_13 (86) = happyShift action_60
action_13 _ = happyFail

action_14 _ = happyReduce_70

action_15 _ = happyReduce_71

action_16 (76) = happyShift action_59
action_16 _ = happyFail

action_17 (93) = happyShift action_58
action_17 (51) = happyGoto action_57
action_17 _ = happyFail

action_18 (93) = happyShift action_56
action_18 _ = happyFail

action_19 (78) = happyShift action_54
action_19 (93) = happyShift action_55
action_19 _ = happyFail

action_20 (61) = happyShift action_47
action_20 (62) = happyShift action_48
action_20 (74) = happyShift action_49
action_20 (78) = happyShift action_50
action_20 (91) = happyShift action_51
action_20 (92) = happyShift action_52
action_20 (93) = happyShift action_53
action_20 (9) = happyGoto action_41
action_20 (11) = happyGoto action_42
action_20 (12) = happyGoto action_43
action_20 (15) = happyGoto action_44
action_20 (16) = happyGoto action_45
action_20 (17) = happyGoto action_46
action_20 _ = happyFail

action_21 _ = happyReduce_47

action_22 _ = happyReduce_48

action_23 (78) = happyShift action_40
action_23 _ = happyFail

action_24 (78) = happyShift action_39
action_24 _ = happyFail

action_25 (52) = happyShift action_16
action_25 (53) = happyShift action_17
action_25 (54) = happyShift action_18
action_25 (56) = happyShift action_19
action_25 (60) = happyShift action_20
action_25 (61) = happyShift action_21
action_25 (62) = happyShift action_22
action_25 (67) = happyShift action_23
action_25 (69) = happyShift action_24
action_25 (74) = happyShift action_25
action_25 (78) = happyShift action_26
action_25 (85) = happyShift action_27
action_25 (92) = happyShift action_28
action_25 (93) = happyShift action_29
action_25 (94) = happyShift action_30
action_25 (18) = happyGoto action_37
action_25 (19) = happyGoto action_4
action_25 (21) = happyGoto action_5
action_25 (22) = happyGoto action_6
action_25 (23) = happyGoto action_7
action_25 (24) = happyGoto action_8
action_25 (25) = happyGoto action_9
action_25 (26) = happyGoto action_10
action_25 (27) = happyGoto action_11
action_25 (28) = happyGoto action_12
action_25 (29) = happyGoto action_38
action_25 (34) = happyGoto action_14
action_25 (38) = happyGoto action_15
action_25 _ = happyReduce_35

action_26 (52) = happyShift action_16
action_26 (53) = happyShift action_17
action_26 (54) = happyShift action_18
action_26 (56) = happyShift action_19
action_26 (60) = happyShift action_20
action_26 (61) = happyShift action_21
action_26 (62) = happyShift action_22
action_26 (67) = happyShift action_23
action_26 (69) = happyShift action_24
action_26 (74) = happyShift action_25
action_26 (78) = happyShift action_26
action_26 (79) = happyShift action_36
action_26 (85) = happyShift action_27
action_26 (92) = happyShift action_28
action_26 (93) = happyShift action_29
action_26 (94) = happyShift action_30
action_26 (19) = happyGoto action_4
action_26 (21) = happyGoto action_5
action_26 (22) = happyGoto action_6
action_26 (23) = happyGoto action_7
action_26 (24) = happyGoto action_8
action_26 (25) = happyGoto action_9
action_26 (26) = happyGoto action_10
action_26 (27) = happyGoto action_11
action_26 (28) = happyGoto action_12
action_26 (29) = happyGoto action_35
action_26 (34) = happyGoto action_14
action_26 (38) = happyGoto action_15
action_26 _ = happyFail

action_27 (52) = happyShift action_16
action_27 (56) = happyShift action_34
action_27 (61) = happyShift action_21
action_27 (62) = happyShift action_22
action_27 (74) = happyShift action_25
action_27 (78) = happyShift action_26
action_27 (92) = happyShift action_28
action_27 (93) = happyShift action_29
action_27 (94) = happyShift action_30
action_27 (19) = happyGoto action_4
action_27 (21) = happyGoto action_5
action_27 (22) = happyGoto action_32
action_27 (23) = happyGoto action_7
action_27 (24) = happyGoto action_8
action_27 (25) = happyGoto action_9
action_27 (26) = happyGoto action_10
action_27 (27) = happyGoto action_11
action_27 (28) = happyGoto action_33
action_27 _ = happyFail

action_28 _ = happyReduce_46

action_29 _ = happyReduce_50

action_30 _ = happyReduce_49

action_31 (95) = happyAccept
action_31 _ = happyFail

action_32 _ = happyReduce_54

action_33 _ = happyReduce_65

action_34 (78) = happyShift action_114
action_34 _ = happyFail

action_35 (79) = happyShift action_112
action_35 (90) = happyShift action_113
action_35 (8) = happyGoto action_111
action_35 _ = happyFail

action_36 _ = happyReduce_42

action_37 (75) = happyShift action_109
action_37 (90) = happyShift action_110
action_37 _ = happyFail

action_38 _ = happyReduce_33

action_39 (52) = happyShift action_16
action_39 (53) = happyShift action_17
action_39 (54) = happyShift action_18
action_39 (56) = happyShift action_19
action_39 (60) = happyShift action_20
action_39 (61) = happyShift action_21
action_39 (62) = happyShift action_22
action_39 (67) = happyShift action_23
action_39 (69) = happyShift action_24
action_39 (74) = happyShift action_25
action_39 (78) = happyShift action_26
action_39 (85) = happyShift action_27
action_39 (92) = happyShift action_28
action_39 (93) = happyShift action_29
action_39 (94) = happyShift action_30
action_39 (19) = happyGoto action_4
action_39 (21) = happyGoto action_5
action_39 (22) = happyGoto action_6
action_39 (23) = happyGoto action_7
action_39 (24) = happyGoto action_8
action_39 (25) = happyGoto action_9
action_39 (26) = happyGoto action_10
action_39 (27) = happyGoto action_11
action_39 (28) = happyGoto action_12
action_39 (29) = happyGoto action_108
action_39 (34) = happyGoto action_14
action_39 (38) = happyGoto action_15
action_39 _ = happyFail

action_40 (52) = happyShift action_16
action_40 (53) = happyShift action_17
action_40 (54) = happyShift action_18
action_40 (56) = happyShift action_19
action_40 (60) = happyShift action_20
action_40 (61) = happyShift action_21
action_40 (62) = happyShift action_22
action_40 (67) = happyShift action_23
action_40 (69) = happyShift action_24
action_40 (74) = happyShift action_25
action_40 (78) = happyShift action_26
action_40 (85) = happyShift action_27
action_40 (92) = happyShift action_28
action_40 (93) = happyShift action_29
action_40 (94) = happyShift action_30
action_40 (19) = happyGoto action_4
action_40 (21) = happyGoto action_5
action_40 (22) = happyGoto action_6
action_40 (23) = happyGoto action_7
action_40 (24) = happyGoto action_8
action_40 (25) = happyGoto action_9
action_40 (26) = happyGoto action_10
action_40 (27) = happyGoto action_11
action_40 (28) = happyGoto action_12
action_40 (29) = happyGoto action_107
action_40 (34) = happyGoto action_14
action_40 (38) = happyGoto action_15
action_40 _ = happyFail

action_41 _ = happyReduce_24

action_42 _ = happyReduce_25

action_43 _ = happyReduce_26

action_44 (73) = happyShift action_106
action_44 _ = happyReduce_31

action_45 _ = happyReduce_32

action_46 (71) = happyShift action_105
action_46 _ = happyFail

action_47 _ = happyReduce_11

action_48 _ = happyReduce_12

action_49 (61) = happyShift action_47
action_49 (62) = happyShift action_48
action_49 (74) = happyShift action_49
action_49 (78) = happyShift action_50
action_49 (91) = happyShift action_51
action_49 (92) = happyShift action_52
action_49 (93) = happyShift action_53
action_49 (9) = happyGoto action_41
action_49 (11) = happyGoto action_42
action_49 (12) = happyGoto action_43
action_49 (13) = happyGoto action_103
action_49 (15) = happyGoto action_44
action_49 (16) = happyGoto action_45
action_49 (17) = happyGoto action_104
action_49 _ = happyReduce_19

action_50 (61) = happyShift action_47
action_50 (62) = happyShift action_48
action_50 (74) = happyShift action_49
action_50 (78) = happyShift action_50
action_50 (91) = happyShift action_51
action_50 (92) = happyShift action_52
action_50 (93) = happyShift action_53
action_50 (9) = happyGoto action_41
action_50 (11) = happyGoto action_42
action_50 (12) = happyGoto action_43
action_50 (15) = happyGoto action_44
action_50 (16) = happyGoto action_45
action_50 (17) = happyGoto action_102
action_50 _ = happyFail

action_51 _ = happyReduce_28

action_52 _ = happyReduce_10

action_53 (78) = happyShift action_101
action_53 _ = happyReduce_27

action_54 (52) = happyShift action_91
action_54 (55) = happyShift action_92
action_54 (56) = happyShift action_93
action_54 (59) = happyShift action_94
action_54 (63) = happyShift action_95
action_54 (64) = happyShift action_96
action_54 (65) = happyShift action_97
action_54 (66) = happyShift action_98
action_54 (78) = happyShift action_99
action_54 (93) = happyShift action_100
action_54 (20) = happyGoto action_87
action_54 (45) = happyGoto action_88
action_54 (46) = happyGoto action_89
action_54 (51) = happyGoto action_90
action_54 _ = happyReduce_39

action_55 (78) = happyShift action_86
action_55 _ = happyFail

action_56 (88) = happyShift action_85
action_56 _ = happyFail

action_57 (87) = happyShift action_84
action_57 _ = happyReduce_67

action_58 _ = happyReduce_127

action_59 (52) = happyShift action_16
action_59 (53) = happyShift action_17
action_59 (54) = happyShift action_18
action_59 (56) = happyShift action_19
action_59 (60) = happyShift action_20
action_59 (61) = happyShift action_21
action_59 (62) = happyShift action_22
action_59 (67) = happyShift action_23
action_59 (69) = happyShift action_24
action_59 (74) = happyShift action_25
action_59 (78) = happyShift action_26
action_59 (85) = happyShift action_27
action_59 (92) = happyShift action_28
action_59 (93) = happyShift action_29
action_59 (94) = happyShift action_30
action_59 (5) = happyGoto action_81
action_59 (6) = happyGoto action_82
action_59 (7) = happyGoto action_83
action_59 (19) = happyGoto action_4
action_59 (21) = happyGoto action_5
action_59 (22) = happyGoto action_6
action_59 (23) = happyGoto action_7
action_59 (24) = happyGoto action_8
action_59 (25) = happyGoto action_9
action_59 (26) = happyGoto action_10
action_59 (27) = happyGoto action_11
action_59 (28) = happyGoto action_12
action_59 (29) = happyGoto action_13
action_59 (34) = happyGoto action_14
action_59 (38) = happyGoto action_15
action_59 _ = happyReduce_6

action_60 _ = happyReduce_7

action_61 (52) = happyShift action_16
action_61 (56) = happyShift action_34
action_61 (61) = happyShift action_21
action_61 (62) = happyShift action_22
action_61 (74) = happyShift action_25
action_61 (78) = happyShift action_26
action_61 (92) = happyShift action_28
action_61 (93) = happyShift action_29
action_61 (94) = happyShift action_30
action_61 (19) = happyGoto action_4
action_61 (21) = happyGoto action_5
action_61 (22) = happyGoto action_32
action_61 (23) = happyGoto action_7
action_61 (24) = happyGoto action_8
action_61 (25) = happyGoto action_9
action_61 (26) = happyGoto action_10
action_61 (27) = happyGoto action_11
action_61 (28) = happyGoto action_80
action_61 _ = happyFail

action_62 (52) = happyShift action_16
action_62 (56) = happyShift action_34
action_62 (61) = happyShift action_21
action_62 (62) = happyShift action_22
action_62 (74) = happyShift action_25
action_62 (78) = happyShift action_26
action_62 (92) = happyShift action_28
action_62 (93) = happyShift action_29
action_62 (94) = happyShift action_30
action_62 (19) = happyGoto action_4
action_62 (21) = happyGoto action_5
action_62 (22) = happyGoto action_32
action_62 (23) = happyGoto action_7
action_62 (24) = happyGoto action_8
action_62 (25) = happyGoto action_9
action_62 (26) = happyGoto action_79
action_62 _ = happyFail

action_63 (52) = happyShift action_16
action_63 (56) = happyShift action_34
action_63 (61) = happyShift action_21
action_63 (62) = happyShift action_22
action_63 (74) = happyShift action_25
action_63 (78) = happyShift action_26
action_63 (92) = happyShift action_28
action_63 (93) = happyShift action_29
action_63 (94) = happyShift action_30
action_63 (19) = happyGoto action_4
action_63 (21) = happyGoto action_5
action_63 (22) = happyGoto action_32
action_63 (23) = happyGoto action_7
action_63 (24) = happyGoto action_8
action_63 (25) = happyGoto action_78
action_63 _ = happyFail

action_64 (52) = happyShift action_16
action_64 (56) = happyShift action_34
action_64 (61) = happyShift action_21
action_64 (62) = happyShift action_22
action_64 (74) = happyShift action_25
action_64 (78) = happyShift action_26
action_64 (92) = happyShift action_28
action_64 (93) = happyShift action_29
action_64 (94) = happyShift action_30
action_64 (19) = happyGoto action_4
action_64 (21) = happyGoto action_5
action_64 (22) = happyGoto action_32
action_64 (23) = happyGoto action_7
action_64 (24) = happyGoto action_77
action_64 _ = happyFail

action_65 (52) = happyShift action_16
action_65 (56) = happyShift action_34
action_65 (61) = happyShift action_21
action_65 (62) = happyShift action_22
action_65 (74) = happyShift action_25
action_65 (78) = happyShift action_26
action_65 (92) = happyShift action_28
action_65 (93) = happyShift action_29
action_65 (94) = happyShift action_30
action_65 (19) = happyGoto action_4
action_65 (21) = happyGoto action_5
action_65 (22) = happyGoto action_32
action_65 (23) = happyGoto action_76
action_65 _ = happyFail

action_66 (52) = happyShift action_16
action_66 (53) = happyShift action_17
action_66 (54) = happyShift action_18
action_66 (56) = happyShift action_19
action_66 (60) = happyShift action_20
action_66 (61) = happyShift action_21
action_66 (62) = happyShift action_22
action_66 (67) = happyShift action_23
action_66 (69) = happyShift action_24
action_66 (74) = happyShift action_25
action_66 (78) = happyShift action_26
action_66 (85) = happyShift action_27
action_66 (92) = happyShift action_28
action_66 (93) = happyShift action_29
action_66 (94) = happyShift action_30
action_66 (19) = happyGoto action_4
action_66 (21) = happyGoto action_5
action_66 (22) = happyGoto action_6
action_66 (23) = happyGoto action_7
action_66 (24) = happyGoto action_8
action_66 (25) = happyGoto action_9
action_66 (26) = happyGoto action_10
action_66 (27) = happyGoto action_11
action_66 (28) = happyGoto action_12
action_66 (29) = happyGoto action_74
action_66 (32) = happyGoto action_75
action_66 (34) = happyGoto action_14
action_66 (38) = happyGoto action_15
action_66 _ = happyReduce_79

action_67 (93) = happyShift action_73
action_67 _ = happyFail

action_68 (93) = happyShift action_72
action_68 (49) = happyGoto action_70
action_68 (50) = happyGoto action_71
action_68 _ = happyReduce_126

action_69 _ = happyReduce_3

action_70 _ = happyReduce_124

action_71 (77) = happyShift action_152
action_71 (93) = happyShift action_72
action_71 (49) = happyGoto action_151
action_71 _ = happyFail

action_72 (88) = happyShift action_150
action_72 _ = happyFail

action_73 _ = happyReduce_51

action_74 _ = happyReduce_77

action_75 (79) = happyShift action_148
action_75 (90) = happyShift action_149
action_75 _ = happyFail

action_76 (78) = happyShift action_66
action_76 (87) = happyShift action_67
action_76 _ = happyReduce_55

action_77 (83) = happyShift action_65
action_77 _ = happyReduce_57

action_78 (84) = happyShift action_64
action_78 _ = happyReduce_59

action_79 (81) = happyShift action_63
action_79 _ = happyReduce_61

action_80 _ = happyReduce_63

action_81 (52) = happyShift action_16
action_81 (53) = happyShift action_17
action_81 (54) = happyShift action_18
action_81 (56) = happyShift action_19
action_81 (60) = happyShift action_20
action_81 (61) = happyShift action_21
action_81 (62) = happyShift action_22
action_81 (67) = happyShift action_23
action_81 (69) = happyShift action_24
action_81 (74) = happyShift action_25
action_81 (78) = happyShift action_26
action_81 (85) = happyShift action_27
action_81 (92) = happyShift action_28
action_81 (93) = happyShift action_29
action_81 (94) = happyShift action_30
action_81 (7) = happyGoto action_147
action_81 (19) = happyGoto action_4
action_81 (21) = happyGoto action_5
action_81 (22) = happyGoto action_6
action_81 (23) = happyGoto action_7
action_81 (24) = happyGoto action_8
action_81 (25) = happyGoto action_9
action_81 (26) = happyGoto action_10
action_81 (27) = happyGoto action_11
action_81 (28) = happyGoto action_12
action_81 (29) = happyGoto action_13
action_81 (34) = happyGoto action_14
action_81 (38) = happyGoto action_15
action_81 _ = happyFail

action_82 (77) = happyShift action_146
action_82 _ = happyFail

action_83 (77) = happyReduce_4
action_83 _ = happyReduce_2

action_84 (93) = happyShift action_145
action_84 _ = happyFail

action_85 (52) = happyShift action_91
action_85 (55) = happyShift action_92
action_85 (56) = happyShift action_93
action_85 (59) = happyShift action_94
action_85 (63) = happyShift action_95
action_85 (64) = happyShift action_96
action_85 (65) = happyShift action_97
action_85 (66) = happyShift action_98
action_85 (78) = happyShift action_99
action_85 (80) = happyShift action_144
action_85 (93) = happyShift action_58
action_85 (35) = happyGoto action_141
action_85 (36) = happyGoto action_142
action_85 (45) = happyGoto action_88
action_85 (46) = happyGoto action_143
action_85 (51) = happyGoto action_90
action_85 _ = happyFail

action_86 (52) = happyShift action_91
action_86 (55) = happyShift action_92
action_86 (56) = happyShift action_93
action_86 (59) = happyShift action_94
action_86 (63) = happyShift action_95
action_86 (64) = happyShift action_96
action_86 (65) = happyShift action_97
action_86 (66) = happyShift action_98
action_86 (78) = happyShift action_99
action_86 (93) = happyShift action_58
action_86 (43) = happyGoto action_139
action_86 (45) = happyGoto action_88
action_86 (46) = happyGoto action_140
action_86 (51) = happyGoto action_90
action_86 _ = happyReduce_103

action_87 (79) = happyShift action_137
action_87 (90) = happyShift action_138
action_87 _ = happyFail

action_88 _ = happyReduce_116

action_89 (74) = happyShift action_135
action_89 (79) = happyShift action_136
action_89 _ = happyFail

action_90 (87) = happyShift action_84
action_90 _ = happyReduce_117

action_91 (76) = happyShift action_134
action_91 _ = happyFail

action_92 (76) = happyShift action_133
action_92 _ = happyFail

action_93 (78) = happyShift action_132
action_93 _ = happyFail

action_94 (76) = happyShift action_131
action_94 _ = happyFail

action_95 _ = happyReduce_107

action_96 _ = happyReduce_108

action_97 _ = happyReduce_109

action_98 _ = happyReduce_110

action_99 (52) = happyShift action_91
action_99 (55) = happyShift action_92
action_99 (56) = happyShift action_93
action_99 (59) = happyShift action_94
action_99 (63) = happyShift action_95
action_99 (64) = happyShift action_96
action_99 (65) = happyShift action_97
action_99 (66) = happyShift action_98
action_99 (78) = happyShift action_99
action_99 (93) = happyShift action_58
action_99 (45) = happyGoto action_88
action_99 (46) = happyGoto action_130
action_99 (51) = happyGoto action_90
action_99 _ = happyFail

action_100 (79) = happyReduce_127
action_100 (90) = happyReduce_37
action_100 _ = happyReduce_127

action_101 (61) = happyShift action_47
action_101 (62) = happyShift action_48
action_101 (74) = happyShift action_49
action_101 (78) = happyShift action_50
action_101 (91) = happyShift action_51
action_101 (92) = happyShift action_52
action_101 (93) = happyShift action_53
action_101 (9) = happyGoto action_41
action_101 (11) = happyGoto action_42
action_101 (12) = happyGoto action_43
action_101 (13) = happyGoto action_129
action_101 (15) = happyGoto action_44
action_101 (16) = happyGoto action_45
action_101 (17) = happyGoto action_104
action_101 _ = happyReduce_19

action_102 (79) = happyShift action_127
action_102 (90) = happyShift action_128
action_102 (10) = happyGoto action_126
action_102 _ = happyFail

action_103 (75) = happyShift action_124
action_103 (90) = happyShift action_125
action_103 _ = happyFail

action_104 _ = happyReduce_17

action_105 (52) = happyShift action_16
action_105 (53) = happyShift action_17
action_105 (54) = happyShift action_18
action_105 (56) = happyShift action_19
action_105 (60) = happyShift action_20
action_105 (61) = happyShift action_21
action_105 (62) = happyShift action_22
action_105 (67) = happyShift action_23
action_105 (69) = happyShift action_24
action_105 (74) = happyShift action_25
action_105 (78) = happyShift action_26
action_105 (85) = happyShift action_27
action_105 (92) = happyShift action_28
action_105 (93) = happyShift action_29
action_105 (94) = happyShift action_30
action_105 (19) = happyGoto action_4
action_105 (21) = happyGoto action_5
action_105 (22) = happyGoto action_6
action_105 (23) = happyGoto action_7
action_105 (24) = happyGoto action_8
action_105 (25) = happyGoto action_9
action_105 (26) = happyGoto action_10
action_105 (27) = happyGoto action_11
action_105 (28) = happyGoto action_12
action_105 (29) = happyGoto action_123
action_105 (34) = happyGoto action_14
action_105 (38) = happyGoto action_15
action_105 _ = happyFail

action_106 (61) = happyShift action_47
action_106 (62) = happyShift action_48
action_106 (74) = happyShift action_49
action_106 (78) = happyShift action_50
action_106 (91) = happyShift action_51
action_106 (92) = happyShift action_52
action_106 (93) = happyShift action_53
action_106 (9) = happyGoto action_41
action_106 (11) = happyGoto action_42
action_106 (12) = happyGoto action_43
action_106 (15) = happyGoto action_44
action_106 (16) = happyGoto action_122
action_106 _ = happyFail

action_107 (79) = happyShift action_121
action_107 _ = happyFail

action_108 (79) = happyShift action_120
action_108 _ = happyFail

action_109 _ = happyReduce_36

action_110 (52) = happyShift action_16
action_110 (53) = happyShift action_17
action_110 (54) = happyShift action_18
action_110 (56) = happyShift action_19
action_110 (60) = happyShift action_20
action_110 (61) = happyShift action_21
action_110 (62) = happyShift action_22
action_110 (67) = happyShift action_23
action_110 (69) = happyShift action_24
action_110 (74) = happyShift action_25
action_110 (78) = happyShift action_26
action_110 (85) = happyShift action_27
action_110 (92) = happyShift action_28
action_110 (93) = happyShift action_29
action_110 (94) = happyShift action_30
action_110 (19) = happyGoto action_4
action_110 (21) = happyGoto action_5
action_110 (22) = happyGoto action_6
action_110 (23) = happyGoto action_7
action_110 (24) = happyGoto action_8
action_110 (25) = happyGoto action_9
action_110 (26) = happyGoto action_10
action_110 (27) = happyGoto action_11
action_110 (28) = happyGoto action_12
action_110 (29) = happyGoto action_119
action_110 (34) = happyGoto action_14
action_110 (38) = happyGoto action_15
action_110 _ = happyFail

action_111 (79) = happyShift action_117
action_111 (90) = happyShift action_118
action_111 _ = happyFail

action_112 _ = happyReduce_40

action_113 (52) = happyShift action_16
action_113 (53) = happyShift action_17
action_113 (54) = happyShift action_18
action_113 (56) = happyShift action_19
action_113 (60) = happyShift action_20
action_113 (61) = happyShift action_21
action_113 (62) = happyShift action_22
action_113 (67) = happyShift action_23
action_113 (69) = happyShift action_24
action_113 (74) = happyShift action_25
action_113 (78) = happyShift action_26
action_113 (85) = happyShift action_27
action_113 (92) = happyShift action_28
action_113 (93) = happyShift action_29
action_113 (94) = happyShift action_30
action_113 (19) = happyGoto action_4
action_113 (21) = happyGoto action_5
action_113 (22) = happyGoto action_6
action_113 (23) = happyGoto action_7
action_113 (24) = happyGoto action_8
action_113 (25) = happyGoto action_9
action_113 (26) = happyGoto action_10
action_113 (27) = happyGoto action_11
action_113 (28) = happyGoto action_12
action_113 (29) = happyGoto action_116
action_113 (34) = happyGoto action_14
action_113 (38) = happyGoto action_15
action_113 _ = happyFail

action_114 (93) = happyShift action_115
action_114 (20) = happyGoto action_87
action_114 _ = happyReduce_39

action_115 _ = happyReduce_37

action_116 _ = happyReduce_8

action_117 _ = happyReduce_43

action_118 (52) = happyShift action_16
action_118 (53) = happyShift action_17
action_118 (54) = happyShift action_18
action_118 (56) = happyShift action_19
action_118 (60) = happyShift action_20
action_118 (61) = happyShift action_21
action_118 (62) = happyShift action_22
action_118 (67) = happyShift action_23
action_118 (69) = happyShift action_24
action_118 (74) = happyShift action_25
action_118 (78) = happyShift action_26
action_118 (85) = happyShift action_27
action_118 (92) = happyShift action_28
action_118 (93) = happyShift action_29
action_118 (94) = happyShift action_30
action_118 (19) = happyGoto action_4
action_118 (21) = happyGoto action_5
action_118 (22) = happyGoto action_6
action_118 (23) = happyGoto action_7
action_118 (24) = happyGoto action_8
action_118 (25) = happyGoto action_9
action_118 (26) = happyGoto action_10
action_118 (27) = happyGoto action_11
action_118 (28) = happyGoto action_12
action_118 (29) = happyGoto action_179
action_118 (34) = happyGoto action_14
action_118 (38) = happyGoto action_15
action_118 _ = happyFail

action_119 _ = happyReduce_34

action_120 (76) = happyShift action_178
action_120 _ = happyFail

action_121 (76) = happyShift action_177
action_121 _ = happyFail

action_122 _ = happyReduce_29

action_123 _ = happyReduce_68

action_124 _ = happyReduce_30

action_125 (61) = happyShift action_47
action_125 (62) = happyShift action_48
action_125 (74) = happyShift action_49
action_125 (78) = happyShift action_50
action_125 (91) = happyShift action_51
action_125 (92) = happyShift action_52
action_125 (93) = happyShift action_53
action_125 (9) = happyGoto action_41
action_125 (11) = happyGoto action_42
action_125 (12) = happyGoto action_43
action_125 (15) = happyGoto action_44
action_125 (16) = happyGoto action_45
action_125 (17) = happyGoto action_176
action_125 _ = happyFail

action_126 (79) = happyShift action_174
action_126 (90) = happyShift action_175
action_126 _ = happyFail

action_127 _ = happyReduce_23

action_128 (61) = happyShift action_47
action_128 (62) = happyShift action_48
action_128 (74) = happyShift action_49
action_128 (78) = happyShift action_50
action_128 (91) = happyShift action_51
action_128 (92) = happyShift action_52
action_128 (93) = happyShift action_53
action_128 (9) = happyGoto action_41
action_128 (11) = happyGoto action_42
action_128 (12) = happyGoto action_43
action_128 (15) = happyGoto action_44
action_128 (16) = happyGoto action_45
action_128 (17) = happyGoto action_173
action_128 _ = happyFail

action_129 (79) = happyShift action_172
action_129 (90) = happyShift action_125
action_129 _ = happyFail

action_130 (74) = happyShift action_135
action_130 (90) = happyShift action_171
action_130 (44) = happyGoto action_170
action_130 _ = happyFail

action_131 (52) = happyShift action_91
action_131 (55) = happyShift action_92
action_131 (56) = happyShift action_93
action_131 (59) = happyShift action_94
action_131 (63) = happyShift action_95
action_131 (64) = happyShift action_96
action_131 (65) = happyShift action_97
action_131 (66) = happyShift action_98
action_131 (78) = happyShift action_99
action_131 (93) = happyShift action_58
action_131 (45) = happyGoto action_88
action_131 (46) = happyGoto action_167
action_131 (47) = happyGoto action_168
action_131 (48) = happyGoto action_169
action_131 (51) = happyGoto action_90
action_131 _ = happyReduce_122

action_132 (52) = happyShift action_91
action_132 (55) = happyShift action_92
action_132 (56) = happyShift action_93
action_132 (59) = happyShift action_94
action_132 (63) = happyShift action_95
action_132 (64) = happyShift action_96
action_132 (65) = happyShift action_97
action_132 (66) = happyShift action_98
action_132 (78) = happyShift action_99
action_132 (79) = happyShift action_166
action_132 (93) = happyShift action_58
action_132 (43) = happyGoto action_165
action_132 (45) = happyGoto action_88
action_132 (46) = happyGoto action_140
action_132 (51) = happyGoto action_90
action_132 _ = happyReduce_103

action_133 (77) = happyShift action_164
action_133 _ = happyFail

action_134 (77) = happyShift action_163
action_134 _ = happyFail

action_135 (75) = happyShift action_162
action_135 _ = happyFail

action_136 (93) = happyShift action_161
action_136 _ = happyFail

action_137 (76) = happyShift action_160
action_137 _ = happyFail

action_138 (93) = happyShift action_159
action_138 _ = happyFail

action_139 (79) = happyShift action_157
action_139 (90) = happyShift action_158
action_139 _ = happyFail

action_140 (74) = happyShift action_135
action_140 _ = happyReduce_101

action_141 (80) = happyShift action_144
action_141 (36) = happyGoto action_156
action_141 _ = happyReduce_84

action_142 _ = happyReduce_85

action_143 (74) = happyShift action_135
action_143 _ = happyReduce_83

action_144 (93) = happyShift action_155
action_144 _ = happyFail

action_145 _ = happyReduce_128

action_146 _ = happyReduce_41

action_147 (77) = happyReduce_5
action_147 _ = happyReduce_3

action_148 _ = happyReduce_53

action_149 (52) = happyShift action_16
action_149 (53) = happyShift action_17
action_149 (54) = happyShift action_18
action_149 (56) = happyShift action_19
action_149 (60) = happyShift action_20
action_149 (61) = happyShift action_21
action_149 (62) = happyShift action_22
action_149 (67) = happyShift action_23
action_149 (69) = happyShift action_24
action_149 (74) = happyShift action_25
action_149 (78) = happyShift action_26
action_149 (85) = happyShift action_27
action_149 (92) = happyShift action_28
action_149 (93) = happyShift action_29
action_149 (94) = happyShift action_30
action_149 (19) = happyGoto action_4
action_149 (21) = happyGoto action_5
action_149 (22) = happyGoto action_6
action_149 (23) = happyGoto action_7
action_149 (24) = happyGoto action_8
action_149 (25) = happyGoto action_9
action_149 (26) = happyGoto action_10
action_149 (27) = happyGoto action_11
action_149 (28) = happyGoto action_12
action_149 (29) = happyGoto action_154
action_149 (34) = happyGoto action_14
action_149 (38) = happyGoto action_15
action_149 _ = happyFail

action_150 (52) = happyShift action_16
action_150 (53) = happyShift action_17
action_150 (54) = happyShift action_18
action_150 (56) = happyShift action_19
action_150 (60) = happyShift action_20
action_150 (61) = happyShift action_21
action_150 (62) = happyShift action_22
action_150 (67) = happyShift action_23
action_150 (69) = happyShift action_24
action_150 (74) = happyShift action_25
action_150 (78) = happyShift action_26
action_150 (85) = happyShift action_27
action_150 (92) = happyShift action_28
action_150 (93) = happyShift action_29
action_150 (94) = happyShift action_30
action_150 (19) = happyGoto action_4
action_150 (21) = happyGoto action_5
action_150 (22) = happyGoto action_6
action_150 (23) = happyGoto action_7
action_150 (24) = happyGoto action_8
action_150 (25) = happyGoto action_9
action_150 (26) = happyGoto action_10
action_150 (27) = happyGoto action_11
action_150 (28) = happyGoto action_12
action_150 (29) = happyGoto action_153
action_150 (34) = happyGoto action_14
action_150 (38) = happyGoto action_15
action_150 _ = happyFail

action_151 _ = happyReduce_125

action_152 _ = happyReduce_69

action_153 (86) = happyShift action_199
action_153 _ = happyFail

action_154 _ = happyReduce_78

action_155 (52) = happyShift action_91
action_155 (55) = happyShift action_92
action_155 (56) = happyShift action_93
action_155 (59) = happyShift action_94
action_155 (63) = happyShift action_95
action_155 (64) = happyShift action_96
action_155 (65) = happyShift action_97
action_155 (66) = happyShift action_98
action_155 (78) = happyShift action_99
action_155 (93) = happyShift action_58
action_155 (37) = happyGoto action_197
action_155 (45) = happyGoto action_88
action_155 (46) = happyGoto action_198
action_155 (51) = happyGoto action_90
action_155 _ = happyReduce_90

action_156 _ = happyReduce_86

action_157 (89) = happyShift action_196
action_157 _ = happyFail

action_158 (52) = happyShift action_91
action_158 (55) = happyShift action_92
action_158 (56) = happyShift action_93
action_158 (59) = happyShift action_94
action_158 (63) = happyShift action_95
action_158 (64) = happyShift action_96
action_158 (65) = happyShift action_97
action_158 (66) = happyShift action_98
action_158 (78) = happyShift action_99
action_158 (93) = happyShift action_58
action_158 (45) = happyGoto action_88
action_158 (46) = happyGoto action_195
action_158 (51) = happyGoto action_90
action_158 _ = happyFail

action_159 _ = happyReduce_38

action_160 (52) = happyShift action_16
action_160 (53) = happyShift action_17
action_160 (54) = happyShift action_18
action_160 (56) = happyShift action_19
action_160 (60) = happyShift action_20
action_160 (61) = happyShift action_21
action_160 (62) = happyShift action_22
action_160 (67) = happyShift action_23
action_160 (69) = happyShift action_24
action_160 (74) = happyShift action_25
action_160 (78) = happyShift action_26
action_160 (85) = happyShift action_27
action_160 (92) = happyShift action_28
action_160 (93) = happyShift action_29
action_160 (94) = happyShift action_30
action_160 (5) = happyGoto action_81
action_160 (6) = happyGoto action_194
action_160 (7) = happyGoto action_83
action_160 (19) = happyGoto action_4
action_160 (21) = happyGoto action_5
action_160 (22) = happyGoto action_6
action_160 (23) = happyGoto action_7
action_160 (24) = happyGoto action_8
action_160 (25) = happyGoto action_9
action_160 (26) = happyGoto action_10
action_160 (27) = happyGoto action_11
action_160 (28) = happyGoto action_12
action_160 (29) = happyGoto action_13
action_160 (34) = happyGoto action_14
action_160 (38) = happyGoto action_15
action_160 _ = happyReduce_6

action_161 (78) = happyShift action_193
action_161 _ = happyFail

action_162 _ = happyReduce_118

action_163 _ = happyReduce_113

action_164 _ = happyReduce_114

action_165 (79) = happyShift action_192
action_165 (90) = happyShift action_158
action_165 _ = happyFail

action_166 (89) = happyShift action_191
action_166 _ = happyFail

action_167 (74) = happyShift action_135
action_167 (93) = happyShift action_190
action_167 _ = happyFail

action_168 _ = happyReduce_120

action_169 (52) = happyShift action_91
action_169 (55) = happyShift action_92
action_169 (56) = happyShift action_93
action_169 (59) = happyShift action_94
action_169 (63) = happyShift action_95
action_169 (64) = happyShift action_96
action_169 (65) = happyShift action_97
action_169 (66) = happyShift action_98
action_169 (77) = happyShift action_189
action_169 (78) = happyShift action_99
action_169 (93) = happyShift action_58
action_169 (45) = happyGoto action_88
action_169 (46) = happyGoto action_167
action_169 (47) = happyGoto action_188
action_169 (51) = happyGoto action_90
action_169 _ = happyFail

action_170 (79) = happyShift action_186
action_170 (90) = happyShift action_187
action_170 _ = happyFail

action_171 (52) = happyShift action_91
action_171 (55) = happyShift action_92
action_171 (56) = happyShift action_93
action_171 (59) = happyShift action_94
action_171 (63) = happyShift action_95
action_171 (64) = happyShift action_96
action_171 (65) = happyShift action_97
action_171 (66) = happyShift action_98
action_171 (78) = happyShift action_99
action_171 (93) = happyShift action_58
action_171 (45) = happyGoto action_88
action_171 (46) = happyGoto action_185
action_171 (51) = happyGoto action_90
action_171 _ = happyFail

action_172 _ = happyReduce_16

action_173 _ = happyReduce_13

action_174 _ = happyReduce_15

action_175 (61) = happyShift action_47
action_175 (62) = happyShift action_48
action_175 (74) = happyShift action_49
action_175 (78) = happyShift action_50
action_175 (91) = happyShift action_51
action_175 (92) = happyShift action_52
action_175 (93) = happyShift action_53
action_175 (9) = happyGoto action_41
action_175 (11) = happyGoto action_42
action_175 (12) = happyGoto action_43
action_175 (15) = happyGoto action_44
action_175 (16) = happyGoto action_45
action_175 (17) = happyGoto action_184
action_175 _ = happyFail

action_176 _ = happyReduce_18

action_177 (52) = happyShift action_16
action_177 (53) = happyShift action_17
action_177 (54) = happyShift action_18
action_177 (56) = happyShift action_19
action_177 (60) = happyShift action_20
action_177 (61) = happyShift action_21
action_177 (62) = happyShift action_22
action_177 (67) = happyShift action_23
action_177 (69) = happyShift action_24
action_177 (74) = happyShift action_25
action_177 (78) = happyShift action_26
action_177 (85) = happyShift action_27
action_177 (92) = happyShift action_28
action_177 (93) = happyShift action_29
action_177 (94) = happyShift action_30
action_177 (5) = happyGoto action_81
action_177 (6) = happyGoto action_183
action_177 (7) = happyGoto action_83
action_177 (19) = happyGoto action_4
action_177 (21) = happyGoto action_5
action_177 (22) = happyGoto action_6
action_177 (23) = happyGoto action_7
action_177 (24) = happyGoto action_8
action_177 (25) = happyGoto action_9
action_177 (26) = happyGoto action_10
action_177 (27) = happyGoto action_11
action_177 (28) = happyGoto action_12
action_177 (29) = happyGoto action_13
action_177 (34) = happyGoto action_14
action_177 (38) = happyGoto action_15
action_177 _ = happyReduce_6

action_178 (70) = happyShift action_182
action_178 (30) = happyGoto action_180
action_178 (31) = happyGoto action_181
action_178 _ = happyFail

action_179 _ = happyReduce_9

action_180 (70) = happyShift action_182
action_180 (77) = happyShift action_211
action_180 (31) = happyGoto action_210
action_180 _ = happyFail

action_181 _ = happyReduce_74

action_182 (61) = happyShift action_47
action_182 (62) = happyShift action_48
action_182 (74) = happyShift action_49
action_182 (78) = happyShift action_50
action_182 (91) = happyShift action_51
action_182 (92) = happyShift action_52
action_182 (93) = happyShift action_53
action_182 (9) = happyGoto action_41
action_182 (11) = happyGoto action_42
action_182 (12) = happyGoto action_43
action_182 (15) = happyGoto action_44
action_182 (16) = happyGoto action_45
action_182 (17) = happyGoto action_209
action_182 _ = happyFail

action_183 (77) = happyShift action_208
action_183 _ = happyFail

action_184 _ = happyReduce_14

action_185 (74) = happyShift action_135
action_185 _ = happyReduce_104

action_186 _ = happyReduce_106

action_187 (52) = happyShift action_91
action_187 (55) = happyShift action_92
action_187 (56) = happyShift action_93
action_187 (59) = happyShift action_94
action_187 (63) = happyShift action_95
action_187 (64) = happyShift action_96
action_187 (65) = happyShift action_97
action_187 (66) = happyShift action_98
action_187 (78) = happyShift action_99
action_187 (93) = happyShift action_58
action_187 (45) = happyGoto action_88
action_187 (46) = happyGoto action_207
action_187 (51) = happyGoto action_90
action_187 _ = happyFail

action_188 _ = happyReduce_121

action_189 _ = happyReduce_115

action_190 (86) = happyShift action_206
action_190 _ = happyFail

action_191 (52) = happyShift action_91
action_191 (55) = happyShift action_92
action_191 (56) = happyShift action_93
action_191 (59) = happyShift action_94
action_191 (63) = happyShift action_95
action_191 (64) = happyShift action_96
action_191 (65) = happyShift action_97
action_191 (66) = happyShift action_98
action_191 (78) = happyShift action_99
action_191 (93) = happyShift action_58
action_191 (45) = happyGoto action_88
action_191 (46) = happyGoto action_205
action_191 (51) = happyGoto action_90
action_191 _ = happyFail

action_192 (89) = happyShift action_204
action_192 _ = happyFail

action_193 (52) = happyShift action_91
action_193 (55) = happyShift action_92
action_193 (56) = happyShift action_93
action_193 (59) = happyShift action_94
action_193 (63) = happyShift action_95
action_193 (64) = happyShift action_96
action_193 (65) = happyShift action_97
action_193 (66) = happyShift action_98
action_193 (78) = happyShift action_99
action_193 (93) = happyShift action_58
action_193 (43) = happyGoto action_203
action_193 (45) = happyGoto action_88
action_193 (46) = happyGoto action_140
action_193 (51) = happyGoto action_90
action_193 _ = happyReduce_103

action_194 (77) = happyShift action_202
action_194 _ = happyFail

action_195 (74) = happyShift action_135
action_195 _ = happyReduce_102

action_196 (52) = happyShift action_91
action_196 (55) = happyShift action_92
action_196 (56) = happyShift action_93
action_196 (59) = happyShift action_94
action_196 (63) = happyShift action_95
action_196 (64) = happyShift action_96
action_196 (65) = happyShift action_97
action_196 (66) = happyShift action_98
action_196 (78) = happyShift action_99
action_196 (93) = happyShift action_58
action_196 (45) = happyGoto action_88
action_196 (46) = happyGoto action_201
action_196 (51) = happyGoto action_90
action_196 _ = happyFail

action_197 (52) = happyShift action_91
action_197 (55) = happyShift action_92
action_197 (56) = happyShift action_93
action_197 (59) = happyShift action_94
action_197 (63) = happyShift action_95
action_197 (64) = happyShift action_96
action_197 (65) = happyShift action_97
action_197 (66) = happyShift action_98
action_197 (78) = happyShift action_99
action_197 (93) = happyShift action_58
action_197 (45) = happyGoto action_88
action_197 (46) = happyGoto action_200
action_197 (51) = happyGoto action_90
action_197 _ = happyReduce_87

action_198 (74) = happyShift action_135
action_198 _ = happyReduce_88

action_199 _ = happyReduce_123

action_200 (74) = happyShift action_135
action_200 _ = happyReduce_89

action_201 (74) = happyShift action_135
action_201 (86) = happyShift action_216
action_201 _ = happyFail

action_202 _ = happyReduce_45

action_203 (79) = happyShift action_215
action_203 (90) = happyShift action_158
action_203 _ = happyFail

action_204 (52) = happyShift action_91
action_204 (55) = happyShift action_92
action_204 (56) = happyShift action_93
action_204 (59) = happyShift action_94
action_204 (63) = happyShift action_95
action_204 (64) = happyShift action_96
action_204 (65) = happyShift action_97
action_204 (66) = happyShift action_98
action_204 (78) = happyShift action_99
action_204 (93) = happyShift action_58
action_204 (45) = happyGoto action_88
action_204 (46) = happyGoto action_214
action_204 (51) = happyGoto action_90
action_204 _ = happyFail

action_205 (74) = happyShift action_135
action_205 _ = happyReduce_111

action_206 _ = happyReduce_119

action_207 (74) = happyShift action_135
action_207 _ = happyReduce_105

action_208 (68) = happyShift action_213
action_208 _ = happyFail

action_209 (72) = happyShift action_212
action_209 _ = happyFail

action_210 _ = happyReduce_75

action_211 _ = happyReduce_73

action_212 (52) = happyShift action_16
action_212 (53) = happyShift action_17
action_212 (54) = happyShift action_18
action_212 (56) = happyShift action_19
action_212 (60) = happyShift action_20
action_212 (61) = happyShift action_21
action_212 (62) = happyShift action_22
action_212 (67) = happyShift action_23
action_212 (69) = happyShift action_24
action_212 (74) = happyShift action_25
action_212 (78) = happyShift action_26
action_212 (85) = happyShift action_27
action_212 (92) = happyShift action_28
action_212 (93) = happyShift action_29
action_212 (94) = happyShift action_30
action_212 (5) = happyGoto action_224
action_212 (7) = happyGoto action_3
action_212 (19) = happyGoto action_4
action_212 (21) = happyGoto action_5
action_212 (22) = happyGoto action_6
action_212 (23) = happyGoto action_7
action_212 (24) = happyGoto action_8
action_212 (25) = happyGoto action_9
action_212 (26) = happyGoto action_10
action_212 (27) = happyGoto action_11
action_212 (28) = happyGoto action_12
action_212 (29) = happyGoto action_13
action_212 (34) = happyGoto action_14
action_212 (38) = happyGoto action_15
action_212 _ = happyFail

action_213 (76) = happyShift action_223
action_213 _ = happyFail

action_214 (74) = happyShift action_135
action_214 _ = happyReduce_112

action_215 (89) = happyShift action_222
action_215 _ = happyFail

action_216 (78) = happyShift action_220
action_216 (93) = happyShift action_221
action_216 (39) = happyGoto action_217
action_216 (40) = happyGoto action_218
action_216 (41) = happyGoto action_219
action_216 _ = happyFail

action_217 (78) = happyShift action_220
action_217 (93) = happyShift action_221
action_217 (40) = happyGoto action_230
action_217 (41) = happyGoto action_219
action_217 _ = happyReduce_92

action_218 _ = happyReduce_93

action_219 (93) = happyShift action_229
action_219 _ = happyFail

action_220 (61) = happyShift action_47
action_220 (62) = happyShift action_48
action_220 (74) = happyShift action_49
action_220 (78) = happyShift action_50
action_220 (91) = happyShift action_51
action_220 (92) = happyShift action_52
action_220 (93) = happyShift action_53
action_220 (9) = happyGoto action_41
action_220 (11) = happyGoto action_42
action_220 (12) = happyGoto action_43
action_220 (15) = happyGoto action_44
action_220 (16) = happyGoto action_45
action_220 (17) = happyGoto action_228
action_220 _ = happyFail

action_221 (78) = happyShift action_227
action_221 _ = happyFail

action_222 (52) = happyShift action_91
action_222 (55) = happyShift action_92
action_222 (56) = happyShift action_93
action_222 (59) = happyShift action_94
action_222 (63) = happyShift action_95
action_222 (64) = happyShift action_96
action_222 (65) = happyShift action_97
action_222 (66) = happyShift action_98
action_222 (78) = happyShift action_99
action_222 (93) = happyShift action_58
action_222 (45) = happyGoto action_88
action_222 (46) = happyGoto action_226
action_222 (51) = happyGoto action_90
action_222 _ = happyFail

action_223 (52) = happyShift action_16
action_223 (53) = happyShift action_17
action_223 (54) = happyShift action_18
action_223 (56) = happyShift action_19
action_223 (60) = happyShift action_20
action_223 (61) = happyShift action_21
action_223 (62) = happyShift action_22
action_223 (67) = happyShift action_23
action_223 (69) = happyShift action_24
action_223 (74) = happyShift action_25
action_223 (78) = happyShift action_26
action_223 (85) = happyShift action_27
action_223 (92) = happyShift action_28
action_223 (93) = happyShift action_29
action_223 (94) = happyShift action_30
action_223 (5) = happyGoto action_81
action_223 (6) = happyGoto action_225
action_223 (7) = happyGoto action_83
action_223 (19) = happyGoto action_4
action_223 (21) = happyGoto action_5
action_223 (22) = happyGoto action_6
action_223 (23) = happyGoto action_7
action_223 (24) = happyGoto action_8
action_223 (25) = happyGoto action_9
action_223 (26) = happyGoto action_10
action_223 (27) = happyGoto action_11
action_223 (28) = happyGoto action_12
action_223 (29) = happyGoto action_13
action_223 (34) = happyGoto action_14
action_223 (38) = happyGoto action_15
action_223 _ = happyReduce_6

action_224 (52) = happyShift action_16
action_224 (53) = happyShift action_17
action_224 (54) = happyShift action_18
action_224 (56) = happyShift action_19
action_224 (60) = happyShift action_20
action_224 (61) = happyShift action_21
action_224 (62) = happyShift action_22
action_224 (67) = happyShift action_23
action_224 (69) = happyShift action_24
action_224 (74) = happyShift action_25
action_224 (78) = happyShift action_26
action_224 (85) = happyShift action_27
action_224 (92) = happyShift action_28
action_224 (93) = happyShift action_29
action_224 (94) = happyShift action_30
action_224 (7) = happyGoto action_69
action_224 (19) = happyGoto action_4
action_224 (21) = happyGoto action_5
action_224 (22) = happyGoto action_6
action_224 (23) = happyGoto action_7
action_224 (24) = happyGoto action_8
action_224 (25) = happyGoto action_9
action_224 (26) = happyGoto action_10
action_224 (27) = happyGoto action_11
action_224 (28) = happyGoto action_12
action_224 (29) = happyGoto action_13
action_224 (34) = happyGoto action_14
action_224 (38) = happyGoto action_15
action_224 _ = happyReduce_76

action_225 (77) = happyShift action_236
action_225 _ = happyFail

action_226 (74) = happyShift action_135
action_226 (86) = happyShift action_235
action_226 _ = happyFail

action_227 (61) = happyShift action_47
action_227 (62) = happyShift action_48
action_227 (74) = happyShift action_49
action_227 (78) = happyShift action_50
action_227 (91) = happyShift action_51
action_227 (92) = happyShift action_52
action_227 (93) = happyShift action_53
action_227 (9) = happyGoto action_41
action_227 (11) = happyGoto action_42
action_227 (12) = happyGoto action_43
action_227 (15) = happyGoto action_44
action_227 (16) = happyGoto action_45
action_227 (17) = happyGoto action_233
action_227 (42) = happyGoto action_234
action_227 _ = happyReduce_100

action_228 (79) = happyShift action_232
action_228 _ = happyFail

action_229 (78) = happyShift action_231
action_229 _ = happyFail

action_230 _ = happyReduce_94

action_231 (61) = happyShift action_47
action_231 (62) = happyShift action_48
action_231 (74) = happyShift action_49
action_231 (78) = happyShift action_50
action_231 (91) = happyShift action_51
action_231 (92) = happyShift action_52
action_231 (93) = happyShift action_53
action_231 (9) = happyGoto action_41
action_231 (11) = happyGoto action_42
action_231 (12) = happyGoto action_43
action_231 (15) = happyGoto action_44
action_231 (16) = happyGoto action_45
action_231 (17) = happyGoto action_233
action_231 (42) = happyGoto action_241
action_231 _ = happyReduce_100

action_232 (87) = happyShift action_240
action_232 _ = happyFail

action_233 _ = happyReduce_98

action_234 (79) = happyShift action_238
action_234 (90) = happyShift action_239
action_234 _ = happyFail

action_235 (78) = happyShift action_220
action_235 (93) = happyShift action_221
action_235 (39) = happyGoto action_237
action_235 (40) = happyGoto action_218
action_235 (41) = happyGoto action_219
action_235 _ = happyFail

action_236 _ = happyReduce_72

action_237 (78) = happyShift action_220
action_237 (93) = happyShift action_221
action_237 (40) = happyGoto action_230
action_237 (41) = happyGoto action_219
action_237 _ = happyReduce_91

action_238 (71) = happyShift action_244
action_238 _ = happyFail

action_239 (61) = happyShift action_47
action_239 (62) = happyShift action_48
action_239 (74) = happyShift action_49
action_239 (78) = happyShift action_50
action_239 (91) = happyShift action_51
action_239 (92) = happyShift action_52
action_239 (93) = happyShift action_53
action_239 (9) = happyGoto action_41
action_239 (11) = happyGoto action_42
action_239 (12) = happyGoto action_43
action_239 (15) = happyGoto action_44
action_239 (16) = happyGoto action_45
action_239 (17) = happyGoto action_243
action_239 _ = happyFail

action_240 _ = happyReduce_97

action_241 (79) = happyShift action_242
action_241 (90) = happyShift action_239
action_241 _ = happyFail

action_242 (71) = happyShift action_246
action_242 _ = happyFail

action_243 _ = happyReduce_99

action_244 (76) = happyShift action_245
action_244 _ = happyFail

action_245 (52) = happyShift action_16
action_245 (53) = happyShift action_17
action_245 (54) = happyShift action_18
action_245 (56) = happyShift action_19
action_245 (60) = happyShift action_20
action_245 (61) = happyShift action_21
action_245 (62) = happyShift action_22
action_245 (67) = happyShift action_23
action_245 (69) = happyShift action_24
action_245 (74) = happyShift action_25
action_245 (78) = happyShift action_26
action_245 (85) = happyShift action_27
action_245 (92) = happyShift action_28
action_245 (93) = happyShift action_29
action_245 (94) = happyShift action_30
action_245 (5) = happyGoto action_248
action_245 (7) = happyGoto action_3
action_245 (19) = happyGoto action_4
action_245 (21) = happyGoto action_5
action_245 (22) = happyGoto action_6
action_245 (23) = happyGoto action_7
action_245 (24) = happyGoto action_8
action_245 (25) = happyGoto action_9
action_245 (26) = happyGoto action_10
action_245 (27) = happyGoto action_11
action_245 (28) = happyGoto action_12
action_245 (29) = happyGoto action_13
action_245 (34) = happyGoto action_14
action_245 (38) = happyGoto action_15
action_245 _ = happyFail

action_246 (76) = happyShift action_247
action_246 _ = happyFail

action_247 (52) = happyShift action_16
action_247 (53) = happyShift action_17
action_247 (54) = happyShift action_18
action_247 (56) = happyShift action_19
action_247 (60) = happyShift action_20
action_247 (61) = happyShift action_21
action_247 (62) = happyShift action_22
action_247 (67) = happyShift action_23
action_247 (69) = happyShift action_24
action_247 (74) = happyShift action_25
action_247 (78) = happyShift action_26
action_247 (85) = happyShift action_27
action_247 (92) = happyShift action_28
action_247 (93) = happyShift action_29
action_247 (94) = happyShift action_30
action_247 (5) = happyGoto action_250
action_247 (7) = happyGoto action_3
action_247 (19) = happyGoto action_4
action_247 (21) = happyGoto action_5
action_247 (22) = happyGoto action_6
action_247 (23) = happyGoto action_7
action_247 (24) = happyGoto action_8
action_247 (25) = happyGoto action_9
action_247 (26) = happyGoto action_10
action_247 (27) = happyGoto action_11
action_247 (28) = happyGoto action_12
action_247 (29) = happyGoto action_13
action_247 (34) = happyGoto action_14
action_247 (38) = happyGoto action_15
action_247 _ = happyFail

action_248 (52) = happyShift action_16
action_248 (53) = happyShift action_17
action_248 (54) = happyShift action_18
action_248 (56) = happyShift action_19
action_248 (60) = happyShift action_20
action_248 (61) = happyShift action_21
action_248 (62) = happyShift action_22
action_248 (67) = happyShift action_23
action_248 (69) = happyShift action_24
action_248 (74) = happyShift action_25
action_248 (77) = happyShift action_249
action_248 (78) = happyShift action_26
action_248 (85) = happyShift action_27
action_248 (92) = happyShift action_28
action_248 (93) = happyShift action_29
action_248 (94) = happyShift action_30
action_248 (7) = happyGoto action_69
action_248 (19) = happyGoto action_4
action_248 (21) = happyGoto action_5
action_248 (22) = happyGoto action_6
action_248 (23) = happyGoto action_7
action_248 (24) = happyGoto action_8
action_248 (25) = happyGoto action_9
action_248 (26) = happyGoto action_10
action_248 (27) = happyGoto action_11
action_248 (28) = happyGoto action_12
action_248 (29) = happyGoto action_13
action_248 (34) = happyGoto action_14
action_248 (38) = happyGoto action_15
action_248 _ = happyFail

action_249 _ = happyReduce_96

action_250 (52) = happyShift action_16
action_250 (53) = happyShift action_17
action_250 (54) = happyShift action_18
action_250 (56) = happyShift action_19
action_250 (60) = happyShift action_20
action_250 (61) = happyShift action_21
action_250 (62) = happyShift action_22
action_250 (67) = happyShift action_23
action_250 (69) = happyShift action_24
action_250 (74) = happyShift action_25
action_250 (77) = happyShift action_251
action_250 (78) = happyShift action_26
action_250 (85) = happyShift action_27
action_250 (92) = happyShift action_28
action_250 (93) = happyShift action_29
action_250 (94) = happyShift action_30
action_250 (7) = happyGoto action_69
action_250 (19) = happyGoto action_4
action_250 (21) = happyGoto action_5
action_250 (22) = happyGoto action_6
action_250 (23) = happyGoto action_7
action_250 (24) = happyGoto action_8
action_250 (25) = happyGoto action_9
action_250 (26) = happyGoto action_10
action_250 (27) = happyGoto action_11
action_250 (28) = happyGoto action_12
action_250 (29) = happyGoto action_13
action_250 (34) = happyGoto action_14
action_250 (38) = happyGoto action_15
action_250 _ = happyFail

action_251 _ = happyReduce_95

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
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  8 happyReduction_8
happyReduction_8 (HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn8
		 ([happy_var_2]
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyAbsSyn29  happy_var_3)
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
happyReduction_13 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn10
		 ([happy_var_2]
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  10 happyReduction_14
happyReduction_14 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 4 11 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
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
happyReduction_17 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  13 happyReduction_18
happyReduction_18 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_0  13 happyReduction_19
happyReduction_19  =  HappyAbsSyn13
		 ([]
	)

happyReduce_20 = happySpecReduce_1  14 happyReduction_20
happyReduction_20 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  14 happyReduction_21
happyReduction_21 (HappyAbsSyn17  happy_var_3)
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

happyReduce_23 = happySpecReduce_3  15 happyReduction_23
happyReduction_23 _
	(HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (happy_var_2
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  15 happyReduction_24
happyReduction_24 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  15 happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  15 happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  15 happyReduction_27
happyReduction_27 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn15
		 (PatExpId happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  15 happyReduction_28
happyReduction_28 _
	 =  HappyAbsSyn15
		 (PatExpWildcard
	)

happyReduce_29 = happySpecReduce_3  16 happyReduction_29
happyReduction_29 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 (PatExpListCons happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  16 happyReduction_30
happyReduction_30 _
	(HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (PatExpList happy_var_2
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  16 happyReduction_31
happyReduction_31 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  18 happyReduction_33
happyReduction_33 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  18 happyReduction_34
happyReduction_34 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_0  18 happyReduction_35
happyReduction_35  =  HappyAbsSyn18
		 ([]
	)

happyReduce_36 = happySpecReduce_3  19 happyReduction_36
happyReduction_36 _
	(HappyAbsSyn18  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (ExpList happy_var_2
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn20
		 ([happy_var_1]
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  20 happyReduction_38
happyReduction_38 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_0  20 happyReduction_39
happyReduction_39  =  HappyAbsSyn20
		 ([]
	)

happyReduce_40 = happySpecReduce_3  21 happyReduction_40
happyReduction_40 _
	(HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (happy_var_2
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happyReduce 4 21 happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_42 = happySpecReduce_2  21 happyReduction_42
happyReduction_42 _
	_
	 =  HappyAbsSyn21
		 (ExpUnit
	)

happyReduce_43 = happyReduce 4 21 happyReduction_43
happyReduction_43 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	(HappyAbsSyn29  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (ExpTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happyReduce 7 21 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (ExpFun happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_1  21 happyReduction_46
happyReduction_46 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn21
		 (ExpNum happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  21 happyReduction_47
happyReduction_47 _
	 =  HappyAbsSyn21
		 (ExpBool True
	)

happyReduce_48 = happySpecReduce_1  21 happyReduction_48
happyReduction_48 _
	 =  HappyAbsSyn21
		 (ExpBool False
	)

happyReduce_49 = happySpecReduce_1  21 happyReduction_49
happyReduction_49 (HappyTerminal (Token _ (TokenString happy_var_1)))
	 =  HappyAbsSyn21
		 (ExpString happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  21 happyReduction_50
happyReduction_50 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn21
		 (ExpRef happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  22 happyReduction_51
happyReduction_51 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn22
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  22 happyReduction_52
happyReduction_52 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happyReduce 4 23 happyReduction_53
happyReduction_53 (_ `HappyStk`
	(HappyAbsSyn32  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_54 = happySpecReduce_1  23 happyReduction_54
happyReduction_54 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  24 happyReduction_55
happyReduction_55 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  24 happyReduction_56
happyReduction_56 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  25 happyReduction_57
happyReduction_57 (HappyAbsSyn24  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn25
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  25 happyReduction_58
happyReduction_58 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  26 happyReduction_59
happyReduction_59 (HappyAbsSyn25  happy_var_3)
	_
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn26
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  26 happyReduction_60
happyReduction_60 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  27 happyReduction_61
happyReduction_61 (HappyAbsSyn26  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  27 happyReduction_62
happyReduction_62 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  28 happyReduction_63
happyReduction_63 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn28
		 (ExpCons happy_var_1 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  28 happyReduction_64
happyReduction_64 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  29 happyReduction_65
happyReduction_65 (HappyAbsSyn28  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (ExpNot happy_var_2
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  29 happyReduction_66
happyReduction_66 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_1
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_2  29 happyReduction_67
happyReduction_67 (HappyAbsSyn51  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (ExpImport happy_var_2
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happyReduce 4 29 happyReduction_68
happyReduction_68 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (ExpAssign happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_69 = happyReduce 4 29 happyReduction_69
happyReduction_69 (_ `HappyStk`
	(HappyAbsSyn50  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (ExpStruct happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_70 = happySpecReduce_1  29 happyReduction_70
happyReduction_70 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn29
		 (ExpTypeDec happy_var_1
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  29 happyReduction_71
happyReduction_71 (HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn29
		 (ExpFunDec happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happyReduce 11 29 happyReduction_72
happyReduction_72 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (ExpIfElse happy_var_3 happy_var_6 happy_var_10
	) `HappyStk` happyRest

happyReduce_73 = happyReduce 7 29 happyReduction_73
happyReduction_73 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (ExpSwitch happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_74 = happySpecReduce_1  30 happyReduction_74
happyReduction_74 (HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn30
		 ([happy_var_1]
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_2  30 happyReduction_75
happyReduction_75 (HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_75 _ _  = notHappyAtAll 

happyReduce_76 = happyReduce 4 31 happyReduction_76
happyReduction_76 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn31
		 (CaseClause happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_77 = happySpecReduce_1  32 happyReduction_77
happyReduction_77 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn32
		 ([happy_var_1]
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  32 happyReduction_78
happyReduction_78 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_0  32 happyReduction_79
happyReduction_79  =  HappyAbsSyn32
		 ([]
	)

happyReduce_80 = happySpecReduce_1  33 happyReduction_80
happyReduction_80 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn33
		 ([happy_var_1]
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  33 happyReduction_81
happyReduction_81 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_0  33 happyReduction_82
happyReduction_82  =  HappyAbsSyn33
		 ([]
	)

happyReduce_83 = happyReduce 4 34 happyReduction_83
happyReduction_83 ((HappyAbsSyn46  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn34
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_84 = happyReduce 4 34 happyReduction_84
happyReduction_84 ((HappyAbsSyn35  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn34
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_85 = happySpecReduce_1  35 happyReduction_85
happyReduction_85 (HappyAbsSyn36  happy_var_1)
	 =  HappyAbsSyn35
		 ([happy_var_1]
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_2  35 happyReduction_86
happyReduction_86 (HappyAbsSyn36  happy_var_2)
	(HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn35
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_86 _ _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_3  36 happyReduction_87
happyReduction_87 (HappyAbsSyn37  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn36
		 (AdtAlternative happy_var_2 0 happy_var_3
	)
happyReduction_87 _ _ _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_1  37 happyReduction_88
happyReduction_88 (HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn37
		 ([happy_var_1]
	)
happyReduction_88 _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_2  37 happyReduction_89
happyReduction_89 (HappyAbsSyn46  happy_var_2)
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn37
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_89 _ _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_0  37 happyReduction_90
happyReduction_90  =  HappyAbsSyn37
		 ([]
	)

happyReduce_91 = happyReduce 12 38 happyReduction_91
happyReduction_91 ((HappyAbsSyn39  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn46  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn43  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn46  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn38
		 (FunDecInstFun happy_var_5 happy_var_3 (TyArrow happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_92 = happyReduce 9 38 happyReduction_92
happyReduction_92 ((HappyAbsSyn39  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn46  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn43  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn38
		 (FunDecFun happy_var_2 (TyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_93 = happySpecReduce_1  39 happyReduction_93
happyReduction_93 (HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn39
		 ([happy_var_1]
	)
happyReduction_93 _  = notHappyAtAll 

happyReduce_94 = happySpecReduce_2  39 happyReduction_94
happyReduction_94 (HappyAbsSyn40  happy_var_2)
	(HappyAbsSyn39  happy_var_1)
	 =  HappyAbsSyn39
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_94 _ _  = notHappyAtAll 

happyReduce_95 = happyReduce 9 40 happyReduction_95
happyReduction_95 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn41  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn40
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_96 = happyReduce 8 40 happyReduction_96
happyReduction_96 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn40
		 (FunDefFun happy_var_1 happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_97 = happyReduce 4 41 happyReduction_97
happyReduction_97 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn41
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_98 = happySpecReduce_1  42 happyReduction_98
happyReduction_98 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn42
		 ([happy_var_1]
	)
happyReduction_98 _  = notHappyAtAll 

happyReduce_99 = happySpecReduce_3  42 happyReduction_99
happyReduction_99 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn42
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_99 _ _ _  = notHappyAtAll 

happyReduce_100 = happySpecReduce_0  42 happyReduction_100
happyReduction_100  =  HappyAbsSyn42
		 ([]
	)

happyReduce_101 = happySpecReduce_1  43 happyReduction_101
happyReduction_101 (HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn43
		 ([happy_var_1]
	)
happyReduction_101 _  = notHappyAtAll 

happyReduce_102 = happySpecReduce_3  43 happyReduction_102
happyReduction_102 (HappyAbsSyn46  happy_var_3)
	_
	(HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn43
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_102 _ _ _  = notHappyAtAll 

happyReduce_103 = happySpecReduce_0  43 happyReduction_103
happyReduction_103  =  HappyAbsSyn43
		 ([]
	)

happyReduce_104 = happySpecReduce_2  44 happyReduction_104
happyReduction_104 (HappyAbsSyn46  happy_var_2)
	_
	 =  HappyAbsSyn44
		 ([happy_var_2]
	)
happyReduction_104 _ _  = notHappyAtAll 

happyReduce_105 = happySpecReduce_3  44 happyReduction_105
happyReduction_105 (HappyAbsSyn46  happy_var_3)
	_
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn44
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_105 _ _ _  = notHappyAtAll 

happyReduce_106 = happyReduce 4 45 happyReduction_106
happyReduction_106 (_ `HappyStk`
	(HappyAbsSyn44  happy_var_3) `HappyStk`
	(HappyAbsSyn46  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn45
		 (TyTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_107 = happySpecReduce_1  46 happyReduction_107
happyReduction_107 _
	 =  HappyAbsSyn46
		 (TyInt
	)

happyReduce_108 = happySpecReduce_1  46 happyReduction_108
happyReduction_108 _
	 =  HappyAbsSyn46
		 (TyBool
	)

happyReduce_109 = happySpecReduce_1  46 happyReduction_109
happyReduction_109 _
	 =  HappyAbsSyn46
		 (TyString
	)

happyReduce_110 = happySpecReduce_1  46 happyReduction_110
happyReduction_110 _
	 =  HappyAbsSyn46
		 (TyUnit
	)

happyReduce_111 = happyReduce 5 46 happyReduction_111
happyReduction_111 ((HappyAbsSyn46  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 (TyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_112 = happyReduce 6 46 happyReduction_112
happyReduction_112 ((HappyAbsSyn46  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn43  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 (TyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_113 = happySpecReduce_3  46 happyReduction_113
happyReduction_113 _
	_
	_
	 =  HappyAbsSyn46
		 (TyModule
	)

happyReduce_114 = happySpecReduce_3  46 happyReduction_114
happyReduction_114 _
	_
	_
	 =  HappyAbsSyn46
		 (TyInterface
	)

happyReduce_115 = happyReduce 4 46 happyReduction_115
happyReduction_115 (_ `HappyStk`
	(HappyAbsSyn48  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 (TyStruct happy_var_3
	) `HappyStk` happyRest

happyReduce_116 = happySpecReduce_1  46 happyReduction_116
happyReduction_116 (HappyAbsSyn45  happy_var_1)
	 =  HappyAbsSyn46
		 (happy_var_1
	)
happyReduction_116 _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_1  46 happyReduction_117
happyReduction_117 (HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn46
		 (TyRef happy_var_1
	)
happyReduction_117 _  = notHappyAtAll 

happyReduce_118 = happySpecReduce_3  46 happyReduction_118
happyReduction_118 _
	_
	(HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn46
		 (TyList happy_var_1
	)
happyReduction_118 _ _ _  = notHappyAtAll 

happyReduce_119 = happySpecReduce_3  47 happyReduction_119
happyReduction_119 _
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	(HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn47
		 ((happy_var_2, happy_var_1)
	)
happyReduction_119 _ _ _  = notHappyAtAll 

happyReduce_120 = happySpecReduce_1  48 happyReduction_120
happyReduction_120 (HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn48
		 ([happy_var_1]
	)
happyReduction_120 _  = notHappyAtAll 

happyReduce_121 = happySpecReduce_2  48 happyReduction_121
happyReduction_121 (HappyAbsSyn47  happy_var_2)
	(HappyAbsSyn48  happy_var_1)
	 =  HappyAbsSyn48
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_121 _ _  = notHappyAtAll 

happyReduce_122 = happySpecReduce_0  48 happyReduction_122
happyReduction_122  =  HappyAbsSyn48
		 ([]
	)

happyReduce_123 = happyReduce 4 49 happyReduction_123
happyReduction_123 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn49
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_124 = happySpecReduce_1  50 happyReduction_124
happyReduction_124 (HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn50
		 ([happy_var_1]
	)
happyReduction_124 _  = notHappyAtAll 

happyReduce_125 = happySpecReduce_2  50 happyReduction_125
happyReduction_125 (HappyAbsSyn49  happy_var_2)
	(HappyAbsSyn50  happy_var_1)
	 =  HappyAbsSyn50
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_125 _ _  = notHappyAtAll 

happyReduce_126 = happySpecReduce_0  50 happyReduction_126
happyReduction_126  =  HappyAbsSyn50
		 ([]
	)

happyReduce_127 = happySpecReduce_1  51 happyReduction_127
happyReduction_127 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn51
		 (Id happy_var_1
	)
happyReduction_127 _  = notHappyAtAll 

happyReduce_128 = happySpecReduce_3  51 happyReduction_128
happyReduction_128 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn51
		 (Path happy_var_1 happy_var_3
	)
happyReduction_128 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 95 95 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 52;
	Token _ TokenImport -> cont 53;
	Token _ TokenType -> cont 54;
	Token _ TokenInterface -> cont 55;
	Token _ TokenFun -> cont 56;
	Token _ TokenImp -> cont 57;
	Token _ TokenTest -> cont 58;
	Token _ TokenStruct -> cont 59;
	Token _ TokenDef -> cont 60;
	Token _ TokenTrue -> cont 61;
	Token _ TokenFalse -> cont 62;
	Token _ TokenInt -> cont 63;
	Token _ TokenBool -> cont 64;
	Token _ TokenStringTy -> cont 65;
	Token _ TokenUnit -> cont 66;
	Token _ TokenIf -> cont 67;
	Token _ TokenElse -> cont 68;
	Token _ TokenSwitch -> cont 69;
	Token _ TokenCase -> cont 70;
	Token _ TokenAssign -> cont 71;
	Token _ TokenArrow -> cont 72;
	Token _ TokenCons -> cont 73;
	Token _ TokenLBracket -> cont 74;
	Token _ TokenRBracket -> cont 75;
	Token _ TokenLBrace -> cont 76;
	Token _ TokenRBrace -> cont 77;
	Token _ TokenLParen -> cont 78;
	Token _ TokenRParen -> cont 79;
	Token _ TokenPipe -> cont 80;
	Token _ TokenPlus -> cont 81;
	Token _ TokenMinus -> cont 82;
	Token _ TokenStar -> cont 83;
	Token _ TokenFSlash -> cont 84;
	Token _ TokenExclamation -> cont 85;
	Token _ TokenSemi -> cont 86;
	Token _ TokenDot -> cont 87;
	Token _ TokenEq -> cont 88;
	Token _ TokenColon -> cont 89;
	Token _ TokenComma -> cont 90;
	Token _ TokenUnderscore -> cont 91;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 92;
	Token _ (TokenId happy_dollar_dollar) -> cont 93;
	Token _ (TokenString happy_dollar_dollar) -> cont 94;
	_ -> happyError' tk
	})

happyError_ 95 tk = happyError' tk
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

