{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Data.Bifunctor (first)
import Errors
import Lex
import Semant
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65
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
	| HappyAbsSyn52 t52
	| HappyAbsSyn53 t53
	| HappyAbsSyn54 t54
	| HappyAbsSyn55 t55
	| HappyAbsSyn56 t56
	| HappyAbsSyn57 t57
	| HappyAbsSyn58 t58
	| HappyAbsSyn59 t59
	| HappyAbsSyn60 t60
	| HappyAbsSyn61 t61
	| HappyAbsSyn62 t62
	| HappyAbsSyn63 t63
	| HappyAbsSyn64 t64
	| HappyAbsSyn65 t65

action_0 (66) = happyShift action_19
action_0 (67) = happyShift action_20
action_0 (68) = happyShift action_21
action_0 (69) = happyShift action_22
action_0 (71) = happyShift action_23
action_0 (75) = happyShift action_24
action_0 (76) = happyShift action_25
action_0 (77) = happyShift action_26
action_0 (82) = happyShift action_27
action_0 (84) = happyShift action_28
action_0 (90) = happyShift action_29
action_0 (94) = happyShift action_30
action_0 (103) = happyShift action_31
action_0 (110) = happyShift action_32
action_0 (111) = happyShift action_33
action_0 (112) = happyShift action_34
action_0 (4) = happyGoto action_35
action_0 (8) = happyGoto action_2
action_0 (9) = happyGoto action_3
action_0 (21) = happyGoto action_4
action_0 (24) = happyGoto action_5
action_0 (25) = happyGoto action_6
action_0 (26) = happyGoto action_7
action_0 (27) = happyGoto action_8
action_0 (28) = happyGoto action_9
action_0 (29) = happyGoto action_10
action_0 (30) = happyGoto action_11
action_0 (31) = happyGoto action_12
action_0 (32) = happyGoto action_13
action_0 (33) = happyGoto action_14
action_0 (37) = happyGoto action_15
action_0 (40) = happyGoto action_16
action_0 (41) = happyGoto action_17
action_0 (46) = happyGoto action_18
action_0 _ = happyFail

action_1 (66) = happyShift action_19
action_1 (67) = happyShift action_20
action_1 (68) = happyShift action_21
action_1 (69) = happyShift action_22
action_1 (71) = happyShift action_23
action_1 (75) = happyShift action_24
action_1 (76) = happyShift action_25
action_1 (77) = happyShift action_26
action_1 (82) = happyShift action_27
action_1 (84) = happyShift action_28
action_1 (90) = happyShift action_29
action_1 (94) = happyShift action_30
action_1 (103) = happyShift action_31
action_1 (110) = happyShift action_32
action_1 (111) = happyShift action_33
action_1 (112) = happyShift action_34
action_1 (8) = happyGoto action_2
action_1 (9) = happyGoto action_3
action_1 (21) = happyGoto action_4
action_1 (24) = happyGoto action_5
action_1 (25) = happyGoto action_6
action_1 (26) = happyGoto action_7
action_1 (27) = happyGoto action_8
action_1 (28) = happyGoto action_9
action_1 (29) = happyGoto action_10
action_1 (30) = happyGoto action_11
action_1 (31) = happyGoto action_12
action_1 (32) = happyGoto action_13
action_1 (33) = happyGoto action_14
action_1 (37) = happyGoto action_15
action_1 (40) = happyGoto action_16
action_1 (41) = happyGoto action_17
action_1 (46) = happyGoto action_18
action_1 _ = happyFail

action_2 (66) = happyShift action_19
action_2 (67) = happyShift action_20
action_2 (68) = happyShift action_21
action_2 (69) = happyShift action_22
action_2 (71) = happyShift action_23
action_2 (75) = happyShift action_24
action_2 (76) = happyShift action_25
action_2 (77) = happyShift action_26
action_2 (82) = happyShift action_27
action_2 (84) = happyShift action_28
action_2 (90) = happyShift action_29
action_2 (94) = happyShift action_30
action_2 (103) = happyShift action_31
action_2 (110) = happyShift action_32
action_2 (111) = happyShift action_33
action_2 (112) = happyShift action_34
action_2 (9) = happyGoto action_3
action_2 (21) = happyGoto action_4
action_2 (24) = happyGoto action_5
action_2 (25) = happyGoto action_6
action_2 (26) = happyGoto action_7
action_2 (27) = happyGoto action_8
action_2 (28) = happyGoto action_9
action_2 (29) = happyGoto action_10
action_2 (30) = happyGoto action_11
action_2 (31) = happyGoto action_12
action_2 (32) = happyGoto action_13
action_2 (33) = happyGoto action_14
action_2 (37) = happyGoto action_15
action_2 (40) = happyGoto action_16
action_2 (41) = happyGoto action_77
action_2 (46) = happyGoto action_18
action_2 _ = happyReduce_1

action_3 _ = happyReduce_95

action_4 _ = happyReduce_53

action_5 _ = happyReduce_50

action_6 _ = happyReduce_61

action_7 (92) = happyShift action_76
action_7 _ = happyReduce_63

action_8 (94) = happyShift action_74
action_8 (105) = happyShift action_75
action_8 _ = happyReduce_65

action_9 (101) = happyShift action_73
action_9 _ = happyReduce_67

action_10 (102) = happyShift action_72
action_10 _ = happyReduce_69

action_11 (99) = happyShift action_71
action_11 _ = happyReduce_71

action_12 (89) = happyShift action_69
action_12 (100) = happyShift action_70
action_12 _ = happyReduce_73

action_13 _ = happyReduce_75

action_14 (104) = happyShift action_68
action_14 _ = happyFail

action_15 _ = happyReduce_93

action_16 (104) = happyShift action_67
action_16 _ = happyFail

action_17 _ = happyReduce_10

action_18 _ = happyReduce_79

action_19 (94) = happyShift action_66
action_19 (23) = happyGoto action_65
action_19 _ = happyReduce_47

action_20 (111) = happyShift action_64
action_20 (65) = happyGoto action_63
action_20 _ = happyFail

action_21 (111) = happyShift action_62
action_21 _ = happyFail

action_22 (111) = happyShift action_61
action_22 _ = happyFail

action_23 (94) = happyShift action_60
action_23 _ = happyFail

action_24 (76) = happyShift action_53
action_24 (77) = happyShift action_54
action_24 (90) = happyShift action_55
action_24 (94) = happyShift action_56
action_24 (109) = happyShift action_57
action_24 (110) = happyShift action_58
action_24 (111) = happyShift action_59
action_24 (11) = happyGoto action_47
action_24 (13) = happyGoto action_48
action_24 (14) = happyGoto action_49
action_24 (17) = happyGoto action_50
action_24 (18) = happyGoto action_51
action_24 (19) = happyGoto action_52
action_24 _ = happyFail

action_25 _ = happyReduce_56

action_26 _ = happyReduce_57

action_27 (94) = happyShift action_46
action_27 _ = happyFail

action_28 (94) = happyShift action_45
action_28 _ = happyFail

action_29 (66) = happyShift action_19
action_29 (67) = happyShift action_20
action_29 (68) = happyShift action_21
action_29 (71) = happyShift action_23
action_29 (75) = happyShift action_24
action_29 (76) = happyShift action_25
action_29 (77) = happyShift action_26
action_29 (82) = happyShift action_27
action_29 (84) = happyShift action_28
action_29 (90) = happyShift action_29
action_29 (94) = happyShift action_30
action_29 (103) = happyShift action_31
action_29 (110) = happyShift action_32
action_29 (111) = happyShift action_40
action_29 (112) = happyShift action_34
action_29 (20) = happyGoto action_43
action_29 (21) = happyGoto action_4
action_29 (24) = happyGoto action_5
action_29 (25) = happyGoto action_6
action_29 (26) = happyGoto action_7
action_29 (27) = happyGoto action_8
action_29 (28) = happyGoto action_9
action_29 (29) = happyGoto action_10
action_29 (30) = happyGoto action_11
action_29 (31) = happyGoto action_12
action_29 (32) = happyGoto action_13
action_29 (33) = happyGoto action_44
action_29 (46) = happyGoto action_18
action_29 _ = happyReduce_40

action_30 (66) = happyShift action_19
action_30 (67) = happyShift action_20
action_30 (68) = happyShift action_21
action_30 (71) = happyShift action_23
action_30 (75) = happyShift action_24
action_30 (76) = happyShift action_25
action_30 (77) = happyShift action_26
action_30 (82) = happyShift action_27
action_30 (84) = happyShift action_28
action_30 (90) = happyShift action_29
action_30 (94) = happyShift action_30
action_30 (95) = happyShift action_42
action_30 (103) = happyShift action_31
action_30 (110) = happyShift action_32
action_30 (111) = happyShift action_40
action_30 (112) = happyShift action_34
action_30 (21) = happyGoto action_4
action_30 (24) = happyGoto action_5
action_30 (25) = happyGoto action_6
action_30 (26) = happyGoto action_7
action_30 (27) = happyGoto action_8
action_30 (28) = happyGoto action_9
action_30 (29) = happyGoto action_10
action_30 (30) = happyGoto action_11
action_30 (31) = happyGoto action_12
action_30 (32) = happyGoto action_13
action_30 (33) = happyGoto action_41
action_30 (46) = happyGoto action_18
action_30 _ = happyFail

action_31 (66) = happyShift action_19
action_31 (71) = happyShift action_23
action_31 (76) = happyShift action_25
action_31 (77) = happyShift action_26
action_31 (90) = happyShift action_29
action_31 (94) = happyShift action_30
action_31 (110) = happyShift action_32
action_31 (111) = happyShift action_40
action_31 (112) = happyShift action_34
action_31 (21) = happyGoto action_4
action_31 (24) = happyGoto action_5
action_31 (25) = happyGoto action_6
action_31 (26) = happyGoto action_38
action_31 (27) = happyGoto action_8
action_31 (28) = happyGoto action_9
action_31 (29) = happyGoto action_10
action_31 (30) = happyGoto action_11
action_31 (31) = happyGoto action_12
action_31 (32) = happyGoto action_39
action_31 _ = happyFail

action_32 _ = happyReduce_55

action_33 (89) = happyReduce_59
action_33 (92) = happyReduce_59
action_33 (94) = happyReduce_59
action_33 (96) = happyShift action_37
action_33 (99) = happyReduce_59
action_33 (100) = happyReduce_59
action_33 (101) = happyReduce_59
action_33 (102) = happyReduce_59
action_33 (104) = happyReduce_59
action_33 (105) = happyReduce_59
action_33 (36) = happyGoto action_36
action_33 _ = happyReduce_87

action_34 _ = happyReduce_58

action_35 (113) = happyAccept
action_35 _ = happyFail

action_36 (88) = happyShift action_111
action_36 _ = happyFail

action_37 (111) = happyShift action_91
action_37 (22) = happyGoto action_110
action_37 _ = happyReduce_44

action_38 _ = happyReduce_63

action_39 _ = happyReduce_74

action_40 _ = happyReduce_59

action_41 (95) = happyShift action_108
action_41 (108) = happyShift action_109
action_41 (10) = happyGoto action_107
action_41 _ = happyFail

action_42 _ = happyReduce_51

action_43 (91) = happyShift action_105
action_43 (108) = happyShift action_106
action_43 _ = happyFail

action_44 _ = happyReduce_38

action_45 (66) = happyShift action_19
action_45 (67) = happyShift action_20
action_45 (68) = happyShift action_21
action_45 (71) = happyShift action_23
action_45 (75) = happyShift action_24
action_45 (76) = happyShift action_25
action_45 (77) = happyShift action_26
action_45 (82) = happyShift action_27
action_45 (84) = happyShift action_28
action_45 (90) = happyShift action_29
action_45 (94) = happyShift action_30
action_45 (103) = happyShift action_31
action_45 (110) = happyShift action_32
action_45 (111) = happyShift action_40
action_45 (112) = happyShift action_34
action_45 (21) = happyGoto action_4
action_45 (24) = happyGoto action_5
action_45 (25) = happyGoto action_6
action_45 (26) = happyGoto action_7
action_45 (27) = happyGoto action_8
action_45 (28) = happyGoto action_9
action_45 (29) = happyGoto action_10
action_45 (30) = happyGoto action_11
action_45 (31) = happyGoto action_12
action_45 (32) = happyGoto action_13
action_45 (33) = happyGoto action_104
action_45 (46) = happyGoto action_18
action_45 _ = happyFail

action_46 (66) = happyShift action_19
action_46 (67) = happyShift action_20
action_46 (68) = happyShift action_21
action_46 (71) = happyShift action_23
action_46 (75) = happyShift action_24
action_46 (76) = happyShift action_25
action_46 (77) = happyShift action_26
action_46 (82) = happyShift action_27
action_46 (84) = happyShift action_28
action_46 (90) = happyShift action_29
action_46 (94) = happyShift action_30
action_46 (103) = happyShift action_31
action_46 (110) = happyShift action_32
action_46 (111) = happyShift action_40
action_46 (112) = happyShift action_34
action_46 (21) = happyGoto action_4
action_46 (24) = happyGoto action_5
action_46 (25) = happyGoto action_6
action_46 (26) = happyGoto action_7
action_46 (27) = happyGoto action_8
action_46 (28) = happyGoto action_9
action_46 (29) = happyGoto action_10
action_46 (30) = happyGoto action_11
action_46 (31) = happyGoto action_12
action_46 (32) = happyGoto action_13
action_46 (33) = happyGoto action_103
action_46 (46) = happyGoto action_18
action_46 _ = happyFail

action_47 _ = happyReduce_29

action_48 _ = happyReduce_30

action_49 _ = happyReduce_31

action_50 (89) = happyShift action_102
action_50 _ = happyReduce_36

action_51 _ = happyReduce_37

action_52 (106) = happyShift action_101
action_52 _ = happyFail

action_53 _ = happyReduce_16

action_54 _ = happyReduce_17

action_55 (76) = happyShift action_53
action_55 (77) = happyShift action_54
action_55 (90) = happyShift action_55
action_55 (94) = happyShift action_56
action_55 (109) = happyShift action_57
action_55 (110) = happyShift action_58
action_55 (111) = happyShift action_59
action_55 (11) = happyGoto action_47
action_55 (13) = happyGoto action_48
action_55 (14) = happyGoto action_49
action_55 (15) = happyGoto action_99
action_55 (17) = happyGoto action_50
action_55 (18) = happyGoto action_51
action_55 (19) = happyGoto action_100
action_55 _ = happyReduce_24

action_56 (76) = happyShift action_53
action_56 (77) = happyShift action_54
action_56 (90) = happyShift action_55
action_56 (94) = happyShift action_56
action_56 (109) = happyShift action_57
action_56 (110) = happyShift action_58
action_56 (111) = happyShift action_59
action_56 (11) = happyGoto action_47
action_56 (13) = happyGoto action_48
action_56 (14) = happyGoto action_49
action_56 (17) = happyGoto action_50
action_56 (18) = happyGoto action_51
action_56 (19) = happyGoto action_98
action_56 _ = happyFail

action_57 _ = happyReduce_33

action_58 _ = happyReduce_15

action_59 (94) = happyShift action_97
action_59 _ = happyReduce_32

action_60 (111) = happyShift action_91
action_60 (22) = happyGoto action_96
action_60 _ = happyReduce_44

action_61 (96) = happyShift action_37
action_61 (36) = happyGoto action_95
action_61 _ = happyReduce_87

action_62 (106) = happyShift action_94
action_62 _ = happyFail

action_63 (105) = happyShift action_93
action_63 _ = happyReduce_76

action_64 _ = happyReduce_156

action_65 (92) = happyShift action_92
action_65 _ = happyFail

action_66 (95) = happyShift action_90
action_66 (111) = happyShift action_91
action_66 (22) = happyGoto action_89
action_66 _ = happyReduce_44

action_67 _ = happyReduce_94

action_68 _ = happyReduce_12

action_69 (66) = happyShift action_19
action_69 (71) = happyShift action_23
action_69 (76) = happyShift action_25
action_69 (77) = happyShift action_26
action_69 (90) = happyShift action_29
action_69 (94) = happyShift action_30
action_69 (110) = happyShift action_32
action_69 (111) = happyShift action_40
action_69 (112) = happyShift action_34
action_69 (21) = happyGoto action_4
action_69 (24) = happyGoto action_5
action_69 (25) = happyGoto action_6
action_69 (26) = happyGoto action_38
action_69 (27) = happyGoto action_8
action_69 (28) = happyGoto action_9
action_69 (29) = happyGoto action_10
action_69 (30) = happyGoto action_11
action_69 (31) = happyGoto action_12
action_69 (32) = happyGoto action_88
action_69 _ = happyFail

action_70 (66) = happyShift action_19
action_70 (71) = happyShift action_23
action_70 (76) = happyShift action_25
action_70 (77) = happyShift action_26
action_70 (90) = happyShift action_29
action_70 (94) = happyShift action_30
action_70 (110) = happyShift action_32
action_70 (111) = happyShift action_40
action_70 (112) = happyShift action_34
action_70 (21) = happyGoto action_4
action_70 (24) = happyGoto action_5
action_70 (25) = happyGoto action_6
action_70 (26) = happyGoto action_38
action_70 (27) = happyGoto action_8
action_70 (28) = happyGoto action_9
action_70 (29) = happyGoto action_10
action_70 (30) = happyGoto action_87
action_70 _ = happyFail

action_71 (66) = happyShift action_19
action_71 (71) = happyShift action_23
action_71 (76) = happyShift action_25
action_71 (77) = happyShift action_26
action_71 (90) = happyShift action_29
action_71 (94) = happyShift action_30
action_71 (110) = happyShift action_32
action_71 (111) = happyShift action_40
action_71 (112) = happyShift action_34
action_71 (21) = happyGoto action_4
action_71 (24) = happyGoto action_5
action_71 (25) = happyGoto action_6
action_71 (26) = happyGoto action_38
action_71 (27) = happyGoto action_8
action_71 (28) = happyGoto action_9
action_71 (29) = happyGoto action_86
action_71 _ = happyFail

action_72 (66) = happyShift action_19
action_72 (71) = happyShift action_23
action_72 (76) = happyShift action_25
action_72 (77) = happyShift action_26
action_72 (90) = happyShift action_29
action_72 (94) = happyShift action_30
action_72 (110) = happyShift action_32
action_72 (111) = happyShift action_40
action_72 (112) = happyShift action_34
action_72 (21) = happyGoto action_4
action_72 (24) = happyGoto action_5
action_72 (25) = happyGoto action_6
action_72 (26) = happyGoto action_38
action_72 (27) = happyGoto action_8
action_72 (28) = happyGoto action_85
action_72 _ = happyFail

action_73 (66) = happyShift action_19
action_73 (71) = happyShift action_23
action_73 (76) = happyShift action_25
action_73 (77) = happyShift action_26
action_73 (90) = happyShift action_29
action_73 (94) = happyShift action_30
action_73 (110) = happyShift action_32
action_73 (111) = happyShift action_40
action_73 (112) = happyShift action_34
action_73 (21) = happyGoto action_4
action_73 (24) = happyGoto action_5
action_73 (25) = happyGoto action_6
action_73 (26) = happyGoto action_38
action_73 (27) = happyGoto action_84
action_73 _ = happyFail

action_74 (66) = happyShift action_19
action_74 (67) = happyShift action_20
action_74 (68) = happyShift action_21
action_74 (71) = happyShift action_23
action_74 (75) = happyShift action_24
action_74 (76) = happyShift action_25
action_74 (77) = happyShift action_26
action_74 (82) = happyShift action_27
action_74 (84) = happyShift action_28
action_74 (90) = happyShift action_29
action_74 (94) = happyShift action_30
action_74 (103) = happyShift action_31
action_74 (110) = happyShift action_32
action_74 (111) = happyShift action_40
action_74 (112) = happyShift action_34
action_74 (21) = happyGoto action_4
action_74 (24) = happyGoto action_5
action_74 (25) = happyGoto action_6
action_74 (26) = happyGoto action_7
action_74 (27) = happyGoto action_8
action_74 (28) = happyGoto action_9
action_74 (29) = happyGoto action_10
action_74 (30) = happyGoto action_11
action_74 (31) = happyGoto action_12
action_74 (32) = happyGoto action_13
action_74 (33) = happyGoto action_82
action_74 (44) = happyGoto action_83
action_74 (46) = happyGoto action_18
action_74 _ = happyReduce_101

action_75 (111) = happyShift action_81
action_75 _ = happyFail

action_76 (111) = happyShift action_80
action_76 (63) = happyGoto action_78
action_76 (64) = happyGoto action_79
action_76 _ = happyReduce_155

action_77 _ = happyReduce_11

action_78 _ = happyReduce_153

action_79 (93) = happyShift action_155
action_79 (111) = happyShift action_80
action_79 (63) = happyGoto action_154
action_79 _ = happyFail

action_80 (106) = happyShift action_153
action_80 _ = happyFail

action_81 _ = happyReduce_60

action_82 _ = happyReduce_99

action_83 (95) = happyShift action_151
action_83 (108) = happyShift action_152
action_83 _ = happyFail

action_84 (94) = happyShift action_74
action_84 (105) = happyShift action_75
action_84 _ = happyReduce_64

action_85 (101) = happyShift action_73
action_85 _ = happyReduce_66

action_86 (102) = happyShift action_72
action_86 _ = happyReduce_68

action_87 (99) = happyShift action_71
action_87 _ = happyReduce_70

action_88 _ = happyReduce_72

action_89 (95) = happyShift action_150
action_89 (108) = happyShift action_126
action_89 _ = happyFail

action_90 _ = happyReduce_45

action_91 _ = happyReduce_42

action_92 (66) = happyShift action_19
action_92 (67) = happyShift action_20
action_92 (68) = happyShift action_21
action_92 (69) = happyShift action_22
action_92 (71) = happyShift action_23
action_92 (75) = happyShift action_24
action_92 (76) = happyShift action_25
action_92 (77) = happyShift action_26
action_92 (82) = happyShift action_27
action_92 (84) = happyShift action_28
action_92 (90) = happyShift action_29
action_92 (94) = happyShift action_30
action_92 (103) = happyShift action_31
action_92 (110) = happyShift action_32
action_92 (111) = happyShift action_33
action_92 (112) = happyShift action_34
action_92 (7) = happyGoto action_148
action_92 (9) = happyGoto action_3
action_92 (21) = happyGoto action_4
action_92 (24) = happyGoto action_5
action_92 (25) = happyGoto action_6
action_92 (26) = happyGoto action_7
action_92 (27) = happyGoto action_8
action_92 (28) = happyGoto action_9
action_92 (29) = happyGoto action_10
action_92 (30) = happyGoto action_11
action_92 (31) = happyGoto action_12
action_92 (32) = happyGoto action_13
action_92 (33) = happyGoto action_14
action_92 (37) = happyGoto action_15
action_92 (40) = happyGoto action_16
action_92 (41) = happyGoto action_149
action_92 (46) = happyGoto action_18
action_92 _ = happyReduce_9

action_93 (111) = happyShift action_147
action_93 _ = happyFail

action_94 (66) = happyShift action_115
action_94 (69) = happyShift action_116
action_94 (70) = happyShift action_117
action_94 (71) = happyShift action_118
action_94 (74) = happyShift action_119
action_94 (78) = happyShift action_120
action_94 (79) = happyShift action_121
action_94 (80) = happyShift action_122
action_94 (81) = happyShift action_123
action_94 (94) = happyShift action_124
action_94 (98) = happyShift action_146
action_94 (111) = happyShift action_64
action_94 (47) = happyGoto action_143
action_94 (48) = happyGoto action_144
action_94 (57) = happyGoto action_112
action_94 (60) = happyGoto action_145
action_94 (65) = happyGoto action_114
action_94 _ = happyFail

action_95 (92) = happyShift action_142
action_95 _ = happyFail

action_96 (95) = happyShift action_141
action_96 (108) = happyShift action_126
action_96 _ = happyFail

action_97 (76) = happyShift action_53
action_97 (77) = happyShift action_54
action_97 (90) = happyShift action_55
action_97 (94) = happyShift action_56
action_97 (109) = happyShift action_57
action_97 (110) = happyShift action_58
action_97 (111) = happyShift action_59
action_97 (11) = happyGoto action_47
action_97 (13) = happyGoto action_48
action_97 (14) = happyGoto action_49
action_97 (15) = happyGoto action_140
action_97 (17) = happyGoto action_50
action_97 (18) = happyGoto action_51
action_97 (19) = happyGoto action_100
action_97 _ = happyReduce_24

action_98 (95) = happyShift action_138
action_98 (108) = happyShift action_139
action_98 (12) = happyGoto action_137
action_98 _ = happyFail

action_99 (91) = happyShift action_135
action_99 (108) = happyShift action_136
action_99 _ = happyFail

action_100 _ = happyReduce_22

action_101 (66) = happyShift action_19
action_101 (67) = happyShift action_20
action_101 (68) = happyShift action_21
action_101 (71) = happyShift action_23
action_101 (75) = happyShift action_24
action_101 (76) = happyShift action_25
action_101 (77) = happyShift action_26
action_101 (82) = happyShift action_27
action_101 (84) = happyShift action_28
action_101 (90) = happyShift action_29
action_101 (94) = happyShift action_30
action_101 (103) = happyShift action_31
action_101 (110) = happyShift action_32
action_101 (111) = happyShift action_40
action_101 (112) = happyShift action_34
action_101 (21) = happyGoto action_4
action_101 (24) = happyGoto action_5
action_101 (25) = happyGoto action_6
action_101 (26) = happyGoto action_7
action_101 (27) = happyGoto action_8
action_101 (28) = happyGoto action_9
action_101 (29) = happyGoto action_10
action_101 (30) = happyGoto action_11
action_101 (31) = happyGoto action_12
action_101 (32) = happyGoto action_13
action_101 (33) = happyGoto action_134
action_101 (46) = happyGoto action_18
action_101 _ = happyFail

action_102 (76) = happyShift action_53
action_102 (77) = happyShift action_54
action_102 (90) = happyShift action_55
action_102 (94) = happyShift action_56
action_102 (109) = happyShift action_57
action_102 (110) = happyShift action_58
action_102 (111) = happyShift action_59
action_102 (11) = happyGoto action_47
action_102 (13) = happyGoto action_48
action_102 (14) = happyGoto action_49
action_102 (17) = happyGoto action_50
action_102 (18) = happyGoto action_133
action_102 _ = happyFail

action_103 (95) = happyShift action_132
action_103 _ = happyFail

action_104 (95) = happyShift action_131
action_104 _ = happyFail

action_105 _ = happyReduce_41

action_106 (66) = happyShift action_19
action_106 (67) = happyShift action_20
action_106 (68) = happyShift action_21
action_106 (71) = happyShift action_23
action_106 (75) = happyShift action_24
action_106 (76) = happyShift action_25
action_106 (77) = happyShift action_26
action_106 (82) = happyShift action_27
action_106 (84) = happyShift action_28
action_106 (90) = happyShift action_29
action_106 (94) = happyShift action_30
action_106 (103) = happyShift action_31
action_106 (110) = happyShift action_32
action_106 (111) = happyShift action_40
action_106 (112) = happyShift action_34
action_106 (21) = happyGoto action_4
action_106 (24) = happyGoto action_5
action_106 (25) = happyGoto action_6
action_106 (26) = happyGoto action_7
action_106 (27) = happyGoto action_8
action_106 (28) = happyGoto action_9
action_106 (29) = happyGoto action_10
action_106 (30) = happyGoto action_11
action_106 (31) = happyGoto action_12
action_106 (32) = happyGoto action_13
action_106 (33) = happyGoto action_130
action_106 (46) = happyGoto action_18
action_106 _ = happyFail

action_107 (95) = happyShift action_128
action_107 (108) = happyShift action_129
action_107 _ = happyFail

action_108 _ = happyReduce_49

action_109 (66) = happyShift action_19
action_109 (67) = happyShift action_20
action_109 (68) = happyShift action_21
action_109 (71) = happyShift action_23
action_109 (75) = happyShift action_24
action_109 (76) = happyShift action_25
action_109 (77) = happyShift action_26
action_109 (82) = happyShift action_27
action_109 (84) = happyShift action_28
action_109 (90) = happyShift action_29
action_109 (94) = happyShift action_30
action_109 (103) = happyShift action_31
action_109 (110) = happyShift action_32
action_109 (111) = happyShift action_40
action_109 (112) = happyShift action_34
action_109 (21) = happyGoto action_4
action_109 (24) = happyGoto action_5
action_109 (25) = happyGoto action_6
action_109 (26) = happyGoto action_7
action_109 (27) = happyGoto action_8
action_109 (28) = happyGoto action_9
action_109 (29) = happyGoto action_10
action_109 (30) = happyGoto action_11
action_109 (31) = happyGoto action_12
action_109 (32) = happyGoto action_13
action_109 (33) = happyGoto action_127
action_109 (46) = happyGoto action_18
action_109 _ = happyFail

action_110 (97) = happyShift action_125
action_110 (108) = happyShift action_126
action_110 _ = happyFail

action_111 (66) = happyShift action_115
action_111 (69) = happyShift action_116
action_111 (70) = happyShift action_117
action_111 (71) = happyShift action_118
action_111 (74) = happyShift action_119
action_111 (78) = happyShift action_120
action_111 (79) = happyShift action_121
action_111 (80) = happyShift action_122
action_111 (81) = happyShift action_123
action_111 (94) = happyShift action_124
action_111 (111) = happyShift action_64
action_111 (57) = happyGoto action_112
action_111 (60) = happyGoto action_113
action_111 (65) = happyGoto action_114
action_111 _ = happyFail

action_112 _ = happyReduce_144

action_113 (90) = happyShift action_161
action_113 (104) = happyShift action_185
action_113 _ = happyFail

action_114 (96) = happyShift action_184
action_114 (105) = happyShift action_93
action_114 _ = happyReduce_145

action_115 (94) = happyShift action_182
action_115 (107) = happyShift action_183
action_115 (58) = happyGoto action_181
action_115 _ = happyReduce_130

action_116 (92) = happyShift action_180
action_116 _ = happyFail

action_117 (111) = happyShift action_64
action_117 (65) = happyGoto action_179
action_117 _ = happyFail

action_118 (94) = happyShift action_178
action_118 _ = happyFail

action_119 (92) = happyShift action_177
action_119 _ = happyFail

action_120 _ = happyReduce_133

action_121 _ = happyReduce_134

action_122 _ = happyReduce_135

action_123 _ = happyReduce_136

action_124 (66) = happyShift action_115
action_124 (69) = happyShift action_116
action_124 (70) = happyShift action_117
action_124 (71) = happyShift action_118
action_124 (74) = happyShift action_119
action_124 (78) = happyShift action_120
action_124 (79) = happyShift action_121
action_124 (80) = happyShift action_122
action_124 (81) = happyShift action_123
action_124 (94) = happyShift action_124
action_124 (111) = happyShift action_64
action_124 (57) = happyGoto action_112
action_124 (60) = happyGoto action_176
action_124 (65) = happyGoto action_114
action_124 _ = happyFail

action_125 _ = happyReduce_86

action_126 (111) = happyShift action_175
action_126 _ = happyFail

action_127 _ = happyReduce_13

action_128 _ = happyReduce_52

action_129 (66) = happyShift action_19
action_129 (67) = happyShift action_20
action_129 (68) = happyShift action_21
action_129 (71) = happyShift action_23
action_129 (75) = happyShift action_24
action_129 (76) = happyShift action_25
action_129 (77) = happyShift action_26
action_129 (82) = happyShift action_27
action_129 (84) = happyShift action_28
action_129 (90) = happyShift action_29
action_129 (94) = happyShift action_30
action_129 (103) = happyShift action_31
action_129 (110) = happyShift action_32
action_129 (111) = happyShift action_40
action_129 (112) = happyShift action_34
action_129 (21) = happyGoto action_4
action_129 (24) = happyGoto action_5
action_129 (25) = happyGoto action_6
action_129 (26) = happyGoto action_7
action_129 (27) = happyGoto action_8
action_129 (28) = happyGoto action_9
action_129 (29) = happyGoto action_10
action_129 (30) = happyGoto action_11
action_129 (31) = happyGoto action_12
action_129 (32) = happyGoto action_13
action_129 (33) = happyGoto action_174
action_129 (46) = happyGoto action_18
action_129 _ = happyFail

action_130 _ = happyReduce_39

action_131 (92) = happyShift action_173
action_131 _ = happyFail

action_132 (92) = happyShift action_172
action_132 _ = happyFail

action_133 _ = happyReduce_34

action_134 _ = happyReduce_77

action_135 _ = happyReduce_35

action_136 (76) = happyShift action_53
action_136 (77) = happyShift action_54
action_136 (90) = happyShift action_55
action_136 (94) = happyShift action_56
action_136 (109) = happyShift action_57
action_136 (110) = happyShift action_58
action_136 (111) = happyShift action_59
action_136 (11) = happyGoto action_47
action_136 (13) = happyGoto action_48
action_136 (14) = happyGoto action_49
action_136 (17) = happyGoto action_50
action_136 (18) = happyGoto action_51
action_136 (19) = happyGoto action_171
action_136 _ = happyFail

action_137 (95) = happyShift action_169
action_137 (108) = happyShift action_170
action_137 _ = happyFail

action_138 _ = happyReduce_28

action_139 (76) = happyShift action_53
action_139 (77) = happyShift action_54
action_139 (90) = happyShift action_55
action_139 (94) = happyShift action_56
action_139 (109) = happyShift action_57
action_139 (110) = happyShift action_58
action_139 (111) = happyShift action_59
action_139 (11) = happyGoto action_47
action_139 (13) = happyGoto action_48
action_139 (14) = happyGoto action_49
action_139 (17) = happyGoto action_50
action_139 (18) = happyGoto action_51
action_139 (19) = happyGoto action_168
action_139 _ = happyFail

action_140 (95) = happyShift action_167
action_140 (108) = happyShift action_136
action_140 _ = happyFail

action_141 (92) = happyShift action_166
action_141 _ = happyFail

action_142 (111) = happyShift action_165
action_142 (38) = happyGoto action_163
action_142 (39) = happyGoto action_164
action_142 _ = happyFail

action_143 (98) = happyShift action_146
action_143 (48) = happyGoto action_162
action_143 _ = happyReduce_106

action_144 _ = happyReduce_107

action_145 (90) = happyShift action_161
action_145 _ = happyReduce_105

action_146 (111) = happyShift action_160
action_146 _ = happyFail

action_147 _ = happyReduce_157

action_148 (66) = happyShift action_19
action_148 (67) = happyShift action_20
action_148 (68) = happyShift action_21
action_148 (69) = happyShift action_22
action_148 (71) = happyShift action_23
action_148 (75) = happyShift action_24
action_148 (76) = happyShift action_25
action_148 (77) = happyShift action_26
action_148 (82) = happyShift action_27
action_148 (84) = happyShift action_28
action_148 (90) = happyShift action_29
action_148 (93) = happyShift action_159
action_148 (94) = happyShift action_30
action_148 (103) = happyShift action_31
action_148 (110) = happyShift action_32
action_148 (111) = happyShift action_33
action_148 (112) = happyShift action_34
action_148 (9) = happyGoto action_3
action_148 (21) = happyGoto action_4
action_148 (24) = happyGoto action_5
action_148 (25) = happyGoto action_6
action_148 (26) = happyGoto action_7
action_148 (27) = happyGoto action_8
action_148 (28) = happyGoto action_9
action_148 (29) = happyGoto action_10
action_148 (30) = happyGoto action_11
action_148 (31) = happyGoto action_12
action_148 (32) = happyGoto action_13
action_148 (33) = happyGoto action_14
action_148 (37) = happyGoto action_15
action_148 (40) = happyGoto action_16
action_148 (41) = happyGoto action_158
action_148 (46) = happyGoto action_18
action_148 _ = happyFail

action_149 _ = happyReduce_7

action_150 _ = happyReduce_46

action_151 _ = happyReduce_62

action_152 (66) = happyShift action_19
action_152 (67) = happyShift action_20
action_152 (68) = happyShift action_21
action_152 (71) = happyShift action_23
action_152 (75) = happyShift action_24
action_152 (76) = happyShift action_25
action_152 (77) = happyShift action_26
action_152 (82) = happyShift action_27
action_152 (84) = happyShift action_28
action_152 (90) = happyShift action_29
action_152 (94) = happyShift action_30
action_152 (103) = happyShift action_31
action_152 (110) = happyShift action_32
action_152 (111) = happyShift action_40
action_152 (112) = happyShift action_34
action_152 (21) = happyGoto action_4
action_152 (24) = happyGoto action_5
action_152 (25) = happyGoto action_6
action_152 (26) = happyGoto action_7
action_152 (27) = happyGoto action_8
action_152 (28) = happyGoto action_9
action_152 (29) = happyGoto action_10
action_152 (30) = happyGoto action_11
action_152 (31) = happyGoto action_12
action_152 (32) = happyGoto action_13
action_152 (33) = happyGoto action_157
action_152 (46) = happyGoto action_18
action_152 _ = happyFail

action_153 (66) = happyShift action_19
action_153 (67) = happyShift action_20
action_153 (68) = happyShift action_21
action_153 (71) = happyShift action_23
action_153 (75) = happyShift action_24
action_153 (76) = happyShift action_25
action_153 (77) = happyShift action_26
action_153 (82) = happyShift action_27
action_153 (84) = happyShift action_28
action_153 (90) = happyShift action_29
action_153 (94) = happyShift action_30
action_153 (103) = happyShift action_31
action_153 (110) = happyShift action_32
action_153 (111) = happyShift action_40
action_153 (112) = happyShift action_34
action_153 (21) = happyGoto action_4
action_153 (24) = happyGoto action_5
action_153 (25) = happyGoto action_6
action_153 (26) = happyGoto action_7
action_153 (27) = happyGoto action_8
action_153 (28) = happyGoto action_9
action_153 (29) = happyGoto action_10
action_153 (30) = happyGoto action_11
action_153 (31) = happyGoto action_12
action_153 (32) = happyGoto action_13
action_153 (33) = happyGoto action_156
action_153 (46) = happyGoto action_18
action_153 _ = happyFail

action_154 _ = happyReduce_154

action_155 _ = happyReduce_78

action_156 (104) = happyShift action_220
action_156 _ = happyFail

action_157 _ = happyReduce_100

action_158 _ = happyReduce_8

action_159 _ = happyReduce_48

action_160 (66) = happyShift action_115
action_160 (69) = happyShift action_116
action_160 (70) = happyShift action_117
action_160 (71) = happyShift action_118
action_160 (74) = happyShift action_119
action_160 (78) = happyShift action_120
action_160 (79) = happyShift action_121
action_160 (80) = happyShift action_122
action_160 (81) = happyShift action_123
action_160 (94) = happyShift action_124
action_160 (111) = happyShift action_64
action_160 (49) = happyGoto action_218
action_160 (57) = happyGoto action_112
action_160 (60) = happyGoto action_219
action_160 (65) = happyGoto action_114
action_160 _ = happyReduce_112

action_161 (91) = happyShift action_217
action_161 _ = happyFail

action_162 _ = happyReduce_108

action_163 _ = happyReduce_90

action_164 (93) = happyShift action_216
action_164 (111) = happyShift action_165
action_164 (38) = happyGoto action_215
action_164 _ = happyFail

action_165 (96) = happyShift action_37
action_165 (36) = happyGoto action_214
action_165 _ = happyReduce_87

action_166 (66) = happyShift action_19
action_166 (67) = happyShift action_20
action_166 (68) = happyShift action_21
action_166 (71) = happyShift action_23
action_166 (75) = happyShift action_24
action_166 (76) = happyShift action_25
action_166 (77) = happyShift action_26
action_166 (82) = happyShift action_27
action_166 (84) = happyShift action_28
action_166 (90) = happyShift action_29
action_166 (94) = happyShift action_30
action_166 (103) = happyShift action_31
action_166 (110) = happyShift action_32
action_166 (111) = happyShift action_40
action_166 (112) = happyShift action_34
action_166 (5) = happyGoto action_209
action_166 (6) = happyGoto action_213
action_166 (9) = happyGoto action_211
action_166 (21) = happyGoto action_4
action_166 (24) = happyGoto action_5
action_166 (25) = happyGoto action_6
action_166 (26) = happyGoto action_7
action_166 (27) = happyGoto action_8
action_166 (28) = happyGoto action_9
action_166 (29) = happyGoto action_10
action_166 (30) = happyGoto action_11
action_166 (31) = happyGoto action_12
action_166 (32) = happyGoto action_13
action_166 (33) = happyGoto action_14
action_166 (46) = happyGoto action_18
action_166 _ = happyReduce_6

action_167 _ = happyReduce_21

action_168 _ = happyReduce_18

action_169 _ = happyReduce_20

action_170 (76) = happyShift action_53
action_170 (77) = happyShift action_54
action_170 (90) = happyShift action_55
action_170 (94) = happyShift action_56
action_170 (109) = happyShift action_57
action_170 (110) = happyShift action_58
action_170 (111) = happyShift action_59
action_170 (11) = happyGoto action_47
action_170 (13) = happyGoto action_48
action_170 (14) = happyGoto action_49
action_170 (17) = happyGoto action_50
action_170 (18) = happyGoto action_51
action_170 (19) = happyGoto action_212
action_170 _ = happyFail

action_171 _ = happyReduce_23

action_172 (66) = happyShift action_19
action_172 (67) = happyShift action_20
action_172 (68) = happyShift action_21
action_172 (71) = happyShift action_23
action_172 (75) = happyShift action_24
action_172 (76) = happyShift action_25
action_172 (77) = happyShift action_26
action_172 (82) = happyShift action_27
action_172 (84) = happyShift action_28
action_172 (90) = happyShift action_29
action_172 (94) = happyShift action_30
action_172 (103) = happyShift action_31
action_172 (110) = happyShift action_32
action_172 (111) = happyShift action_40
action_172 (112) = happyShift action_34
action_172 (5) = happyGoto action_209
action_172 (6) = happyGoto action_210
action_172 (9) = happyGoto action_211
action_172 (21) = happyGoto action_4
action_172 (24) = happyGoto action_5
action_172 (25) = happyGoto action_6
action_172 (26) = happyGoto action_7
action_172 (27) = happyGoto action_8
action_172 (28) = happyGoto action_9
action_172 (29) = happyGoto action_10
action_172 (30) = happyGoto action_11
action_172 (31) = happyGoto action_12
action_172 (32) = happyGoto action_13
action_172 (33) = happyGoto action_14
action_172 (46) = happyGoto action_18
action_172 _ = happyReduce_6

action_173 (85) = happyShift action_208
action_173 (42) = happyGoto action_206
action_173 (43) = happyGoto action_207
action_173 _ = happyFail

action_174 _ = happyReduce_14

action_175 _ = happyReduce_43

action_176 (90) = happyShift action_161
action_176 (108) = happyShift action_205
action_176 (56) = happyGoto action_204
action_176 _ = happyFail

action_177 (66) = happyShift action_115
action_177 (69) = happyShift action_116
action_177 (70) = happyShift action_117
action_177 (71) = happyShift action_118
action_177 (74) = happyShift action_119
action_177 (78) = happyShift action_120
action_177 (79) = happyShift action_121
action_177 (80) = happyShift action_122
action_177 (81) = happyShift action_123
action_177 (94) = happyShift action_124
action_177 (111) = happyShift action_64
action_177 (57) = happyGoto action_112
action_177 (60) = happyGoto action_201
action_177 (61) = happyGoto action_202
action_177 (62) = happyGoto action_203
action_177 (65) = happyGoto action_114
action_177 _ = happyReduce_151

action_178 (66) = happyShift action_115
action_178 (69) = happyShift action_116
action_178 (70) = happyShift action_117
action_178 (71) = happyShift action_118
action_178 (74) = happyShift action_119
action_178 (78) = happyShift action_120
action_178 (79) = happyShift action_121
action_178 (80) = happyShift action_122
action_178 (81) = happyShift action_123
action_178 (94) = happyShift action_124
action_178 (95) = happyShift action_200
action_178 (111) = happyShift action_64
action_178 (55) = happyGoto action_199
action_178 (57) = happyGoto action_112
action_178 (60) = happyGoto action_193
action_178 (65) = happyGoto action_114
action_178 _ = happyReduce_125

action_179 (96) = happyShift action_198
action_179 (105) = happyShift action_93
action_179 (59) = happyGoto action_197
action_179 _ = happyReduce_132

action_180 (93) = happyShift action_196
action_180 _ = happyFail

action_181 _ = happyReduce_139

action_182 (66) = happyShift action_115
action_182 (69) = happyShift action_116
action_182 (70) = happyShift action_117
action_182 (71) = happyShift action_118
action_182 (74) = happyShift action_119
action_182 (78) = happyShift action_120
action_182 (79) = happyShift action_121
action_182 (80) = happyShift action_122
action_182 (81) = happyShift action_123
action_182 (94) = happyShift action_124
action_182 (111) = happyShift action_64
action_182 (55) = happyGoto action_195
action_182 (57) = happyGoto action_112
action_182 (60) = happyGoto action_193
action_182 (65) = happyGoto action_114
action_182 _ = happyReduce_125

action_183 (66) = happyShift action_115
action_183 (69) = happyShift action_116
action_183 (70) = happyShift action_117
action_183 (71) = happyShift action_118
action_183 (74) = happyShift action_119
action_183 (78) = happyShift action_120
action_183 (79) = happyShift action_121
action_183 (80) = happyShift action_122
action_183 (81) = happyShift action_123
action_183 (94) = happyShift action_124
action_183 (111) = happyShift action_64
action_183 (57) = happyGoto action_112
action_183 (60) = happyGoto action_194
action_183 (65) = happyGoto action_114
action_183 _ = happyFail

action_184 (66) = happyShift action_115
action_184 (69) = happyShift action_116
action_184 (70) = happyShift action_117
action_184 (71) = happyShift action_118
action_184 (74) = happyShift action_119
action_184 (78) = happyShift action_120
action_184 (79) = happyShift action_121
action_184 (80) = happyShift action_122
action_184 (81) = happyShift action_123
action_184 (94) = happyShift action_124
action_184 (111) = happyShift action_64
action_184 (55) = happyGoto action_192
action_184 (57) = happyGoto action_112
action_184 (60) = happyGoto action_193
action_184 (65) = happyGoto action_114
action_184 _ = happyReduce_125

action_185 (94) = happyShift action_190
action_185 (111) = happyShift action_191
action_185 (34) = happyGoto action_186
action_185 (35) = happyGoto action_187
action_185 (52) = happyGoto action_188
action_185 (53) = happyGoto action_189
action_185 _ = happyFail

action_186 _ = happyReduce_84

action_187 (94) = happyShift action_190
action_187 (104) = happyShift action_246
action_187 (111) = happyShift action_191
action_187 (34) = happyGoto action_245
action_187 (52) = happyGoto action_188
action_187 (53) = happyGoto action_189
action_187 _ = happyFail

action_188 _ = happyReduce_83

action_189 (111) = happyShift action_244
action_189 _ = happyFail

action_190 (76) = happyShift action_53
action_190 (77) = happyShift action_54
action_190 (90) = happyShift action_55
action_190 (94) = happyShift action_56
action_190 (109) = happyShift action_57
action_190 (110) = happyShift action_58
action_190 (111) = happyShift action_59
action_190 (11) = happyGoto action_47
action_190 (13) = happyGoto action_48
action_190 (14) = happyGoto action_49
action_190 (17) = happyGoto action_50
action_190 (18) = happyGoto action_51
action_190 (19) = happyGoto action_243
action_190 _ = happyFail

action_191 (94) = happyShift action_241
action_191 (106) = happyShift action_242
action_191 _ = happyFail

action_192 (97) = happyShift action_240
action_192 (108) = happyShift action_237
action_192 _ = happyFail

action_193 (90) = happyShift action_161
action_193 _ = happyReduce_123

action_194 (90) = happyShift action_161
action_194 _ = happyReduce_129

action_195 (95) = happyShift action_239
action_195 (108) = happyShift action_237
action_195 _ = happyFail

action_196 _ = happyReduce_141

action_197 _ = happyReduce_142

action_198 (66) = happyShift action_115
action_198 (69) = happyShift action_116
action_198 (70) = happyShift action_117
action_198 (71) = happyShift action_118
action_198 (74) = happyShift action_119
action_198 (78) = happyShift action_120
action_198 (79) = happyShift action_121
action_198 (80) = happyShift action_122
action_198 (81) = happyShift action_123
action_198 (94) = happyShift action_124
action_198 (111) = happyShift action_64
action_198 (55) = happyGoto action_238
action_198 (57) = happyGoto action_112
action_198 (60) = happyGoto action_193
action_198 (65) = happyGoto action_114
action_198 _ = happyReduce_125

action_199 (95) = happyShift action_236
action_199 (108) = happyShift action_237
action_199 _ = happyFail

action_200 (107) = happyShift action_235
action_200 _ = happyFail

action_201 (90) = happyShift action_161
action_201 (111) = happyShift action_234
action_201 _ = happyFail

action_202 _ = happyReduce_149

action_203 (66) = happyShift action_115
action_203 (69) = happyShift action_116
action_203 (70) = happyShift action_117
action_203 (71) = happyShift action_118
action_203 (74) = happyShift action_119
action_203 (78) = happyShift action_120
action_203 (79) = happyShift action_121
action_203 (80) = happyShift action_122
action_203 (81) = happyShift action_123
action_203 (93) = happyShift action_233
action_203 (94) = happyShift action_124
action_203 (111) = happyShift action_64
action_203 (57) = happyGoto action_112
action_203 (60) = happyGoto action_201
action_203 (61) = happyGoto action_232
action_203 (65) = happyGoto action_114
action_203 _ = happyFail

action_204 (95) = happyShift action_230
action_204 (108) = happyShift action_231
action_204 _ = happyFail

action_205 (66) = happyShift action_115
action_205 (69) = happyShift action_116
action_205 (70) = happyShift action_117
action_205 (71) = happyShift action_118
action_205 (74) = happyShift action_119
action_205 (78) = happyShift action_120
action_205 (79) = happyShift action_121
action_205 (80) = happyShift action_122
action_205 (81) = happyShift action_123
action_205 (94) = happyShift action_124
action_205 (111) = happyShift action_64
action_205 (57) = happyGoto action_112
action_205 (60) = happyGoto action_229
action_205 (65) = happyGoto action_114
action_205 _ = happyFail

action_206 (85) = happyShift action_208
action_206 (93) = happyShift action_228
action_206 (43) = happyGoto action_227
action_206 _ = happyFail

action_207 _ = happyReduce_96

action_208 (76) = happyShift action_53
action_208 (77) = happyShift action_54
action_208 (90) = happyShift action_55
action_208 (94) = happyShift action_56
action_208 (109) = happyShift action_57
action_208 (110) = happyShift action_58
action_208 (111) = happyShift action_59
action_208 (11) = happyGoto action_47
action_208 (13) = happyGoto action_48
action_208 (14) = happyGoto action_49
action_208 (17) = happyGoto action_50
action_208 (18) = happyGoto action_51
action_208 (19) = happyGoto action_226
action_208 _ = happyFail

action_209 (66) = happyShift action_19
action_209 (67) = happyShift action_20
action_209 (68) = happyShift action_21
action_209 (71) = happyShift action_23
action_209 (75) = happyShift action_24
action_209 (76) = happyShift action_25
action_209 (77) = happyShift action_26
action_209 (82) = happyShift action_27
action_209 (84) = happyShift action_28
action_209 (90) = happyShift action_29
action_209 (94) = happyShift action_30
action_209 (103) = happyShift action_31
action_209 (110) = happyShift action_32
action_209 (111) = happyShift action_40
action_209 (112) = happyShift action_34
action_209 (9) = happyGoto action_225
action_209 (21) = happyGoto action_4
action_209 (24) = happyGoto action_5
action_209 (25) = happyGoto action_6
action_209 (26) = happyGoto action_7
action_209 (27) = happyGoto action_8
action_209 (28) = happyGoto action_9
action_209 (29) = happyGoto action_10
action_209 (30) = happyGoto action_11
action_209 (31) = happyGoto action_12
action_209 (32) = happyGoto action_13
action_209 (33) = happyGoto action_14
action_209 (46) = happyGoto action_18
action_209 _ = happyFail

action_210 (93) = happyShift action_224
action_210 _ = happyFail

action_211 (93) = happyReduce_4
action_211 _ = happyReduce_2

action_212 _ = happyReduce_19

action_213 (93) = happyShift action_223
action_213 _ = happyFail

action_214 (88) = happyShift action_222
action_214 _ = happyFail

action_215 _ = happyReduce_91

action_216 _ = happyReduce_92

action_217 _ = happyReduce_147

action_218 (66) = happyShift action_115
action_218 (69) = happyShift action_116
action_218 (70) = happyShift action_117
action_218 (71) = happyShift action_118
action_218 (74) = happyShift action_119
action_218 (78) = happyShift action_120
action_218 (79) = happyShift action_121
action_218 (80) = happyShift action_122
action_218 (81) = happyShift action_123
action_218 (94) = happyShift action_124
action_218 (111) = happyShift action_64
action_218 (57) = happyGoto action_112
action_218 (60) = happyGoto action_221
action_218 (65) = happyGoto action_114
action_218 _ = happyReduce_109

action_219 (90) = happyShift action_161
action_219 _ = happyReduce_110

action_220 _ = happyReduce_152

action_221 (90) = happyShift action_161
action_221 _ = happyReduce_111

action_222 (66) = happyShift action_115
action_222 (69) = happyShift action_116
action_222 (70) = happyShift action_117
action_222 (71) = happyShift action_118
action_222 (74) = happyShift action_119
action_222 (78) = happyShift action_120
action_222 (79) = happyShift action_121
action_222 (80) = happyShift action_122
action_222 (81) = happyShift action_123
action_222 (94) = happyShift action_124
action_222 (111) = happyShift action_64
action_222 (57) = happyGoto action_112
action_222 (60) = happyGoto action_261
action_222 (65) = happyGoto action_114
action_222 _ = happyFail

action_223 _ = happyReduce_54

action_224 (83) = happyShift action_260
action_224 _ = happyFail

action_225 (93) = happyReduce_5
action_225 _ = happyReduce_3

action_226 (87) = happyShift action_259
action_226 _ = happyFail

action_227 _ = happyReduce_97

action_228 _ = happyReduce_81

action_229 (90) = happyShift action_161
action_229 _ = happyReduce_126

action_230 _ = happyReduce_128

action_231 (66) = happyShift action_115
action_231 (69) = happyShift action_116
action_231 (70) = happyShift action_117
action_231 (71) = happyShift action_118
action_231 (74) = happyShift action_119
action_231 (78) = happyShift action_120
action_231 (79) = happyShift action_121
action_231 (80) = happyShift action_122
action_231 (81) = happyShift action_123
action_231 (94) = happyShift action_124
action_231 (111) = happyShift action_64
action_231 (57) = happyGoto action_112
action_231 (60) = happyGoto action_258
action_231 (65) = happyGoto action_114
action_231 _ = happyFail

action_232 _ = happyReduce_150

action_233 _ = happyReduce_143

action_234 (104) = happyShift action_257
action_234 _ = happyFail

action_235 (66) = happyShift action_115
action_235 (69) = happyShift action_116
action_235 (70) = happyShift action_117
action_235 (71) = happyShift action_118
action_235 (74) = happyShift action_119
action_235 (78) = happyShift action_120
action_235 (79) = happyShift action_121
action_235 (80) = happyShift action_122
action_235 (81) = happyShift action_123
action_235 (94) = happyShift action_124
action_235 (111) = happyShift action_64
action_235 (57) = happyGoto action_112
action_235 (60) = happyGoto action_256
action_235 (65) = happyGoto action_114
action_235 _ = happyFail

action_236 (107) = happyShift action_255
action_236 _ = happyFail

action_237 (66) = happyShift action_115
action_237 (69) = happyShift action_116
action_237 (70) = happyShift action_117
action_237 (71) = happyShift action_118
action_237 (74) = happyShift action_119
action_237 (78) = happyShift action_120
action_237 (79) = happyShift action_121
action_237 (80) = happyShift action_122
action_237 (81) = happyShift action_123
action_237 (94) = happyShift action_124
action_237 (111) = happyShift action_64
action_237 (57) = happyGoto action_112
action_237 (60) = happyGoto action_254
action_237 (65) = happyGoto action_114
action_237 _ = happyFail

action_238 (97) = happyShift action_253
action_238 (108) = happyShift action_237
action_238 _ = happyFail

action_239 (107) = happyShift action_183
action_239 (58) = happyGoto action_252
action_239 _ = happyReduce_130

action_240 _ = happyReduce_146

action_241 (76) = happyShift action_53
action_241 (77) = happyShift action_54
action_241 (90) = happyShift action_55
action_241 (94) = happyShift action_56
action_241 (109) = happyShift action_57
action_241 (110) = happyShift action_58
action_241 (111) = happyShift action_59
action_241 (11) = happyGoto action_47
action_241 (13) = happyGoto action_48
action_241 (14) = happyGoto action_49
action_241 (17) = happyGoto action_50
action_241 (18) = happyGoto action_51
action_241 (19) = happyGoto action_250
action_241 (54) = happyGoto action_251
action_241 _ = happyReduce_122

action_242 (66) = happyShift action_19
action_242 (24) = happyGoto action_249
action_242 _ = happyFail

action_243 (95) = happyShift action_248
action_243 _ = happyFail

action_244 (94) = happyShift action_247
action_244 _ = happyFail

action_245 _ = happyReduce_85

action_246 _ = happyReduce_88

action_247 (76) = happyShift action_53
action_247 (77) = happyShift action_54
action_247 (90) = happyShift action_55
action_247 (94) = happyShift action_56
action_247 (109) = happyShift action_57
action_247 (110) = happyShift action_58
action_247 (111) = happyShift action_59
action_247 (11) = happyGoto action_47
action_247 (13) = happyGoto action_48
action_247 (14) = happyGoto action_49
action_247 (17) = happyGoto action_50
action_247 (18) = happyGoto action_51
action_247 (19) = happyGoto action_250
action_247 (54) = happyGoto action_270
action_247 _ = happyReduce_122

action_248 (105) = happyShift action_269
action_248 _ = happyFail

action_249 _ = happyReduce_82

action_250 _ = happyReduce_120

action_251 (95) = happyShift action_267
action_251 (108) = happyShift action_268
action_251 _ = happyFail

action_252 _ = happyReduce_140

action_253 _ = happyReduce_131

action_254 (90) = happyShift action_161
action_254 _ = happyReduce_124

action_255 (66) = happyShift action_115
action_255 (69) = happyShift action_116
action_255 (70) = happyShift action_117
action_255 (71) = happyShift action_118
action_255 (74) = happyShift action_119
action_255 (78) = happyShift action_120
action_255 (79) = happyShift action_121
action_255 (80) = happyShift action_122
action_255 (81) = happyShift action_123
action_255 (94) = happyShift action_124
action_255 (111) = happyShift action_64
action_255 (57) = happyGoto action_112
action_255 (60) = happyGoto action_266
action_255 (65) = happyGoto action_114
action_255 _ = happyFail

action_256 (90) = happyShift action_161
action_256 _ = happyReduce_137

action_257 _ = happyReduce_148

action_258 (90) = happyShift action_161
action_258 _ = happyReduce_127

action_259 (66) = happyShift action_19
action_259 (67) = happyShift action_20
action_259 (68) = happyShift action_21
action_259 (71) = happyShift action_23
action_259 (75) = happyShift action_24
action_259 (76) = happyShift action_25
action_259 (77) = happyShift action_26
action_259 (82) = happyShift action_27
action_259 (84) = happyShift action_28
action_259 (90) = happyShift action_29
action_259 (94) = happyShift action_30
action_259 (103) = happyShift action_31
action_259 (110) = happyShift action_32
action_259 (111) = happyShift action_40
action_259 (112) = happyShift action_34
action_259 (5) = happyGoto action_264
action_259 (9) = happyGoto action_265
action_259 (21) = happyGoto action_4
action_259 (24) = happyGoto action_5
action_259 (25) = happyGoto action_6
action_259 (26) = happyGoto action_7
action_259 (27) = happyGoto action_8
action_259 (28) = happyGoto action_9
action_259 (29) = happyGoto action_10
action_259 (30) = happyGoto action_11
action_259 (31) = happyGoto action_12
action_259 (32) = happyGoto action_13
action_259 (33) = happyGoto action_14
action_259 (46) = happyGoto action_18
action_259 _ = happyFail

action_260 (92) = happyShift action_263
action_260 _ = happyFail

action_261 (90) = happyShift action_161
action_261 (104) = happyShift action_262
action_261 _ = happyFail

action_262 _ = happyReduce_89

action_263 (66) = happyShift action_19
action_263 (67) = happyShift action_20
action_263 (68) = happyShift action_21
action_263 (71) = happyShift action_23
action_263 (75) = happyShift action_24
action_263 (76) = happyShift action_25
action_263 (77) = happyShift action_26
action_263 (82) = happyShift action_27
action_263 (84) = happyShift action_28
action_263 (90) = happyShift action_29
action_263 (94) = happyShift action_30
action_263 (103) = happyShift action_31
action_263 (110) = happyShift action_32
action_263 (111) = happyShift action_40
action_263 (112) = happyShift action_34
action_263 (5) = happyGoto action_209
action_263 (6) = happyGoto action_275
action_263 (9) = happyGoto action_211
action_263 (21) = happyGoto action_4
action_263 (24) = happyGoto action_5
action_263 (25) = happyGoto action_6
action_263 (26) = happyGoto action_7
action_263 (27) = happyGoto action_8
action_263 (28) = happyGoto action_9
action_263 (29) = happyGoto action_10
action_263 (30) = happyGoto action_11
action_263 (31) = happyGoto action_12
action_263 (32) = happyGoto action_13
action_263 (33) = happyGoto action_14
action_263 (46) = happyGoto action_18
action_263 _ = happyReduce_6

action_264 (66) = happyShift action_19
action_264 (67) = happyShift action_20
action_264 (68) = happyShift action_21
action_264 (71) = happyShift action_23
action_264 (75) = happyShift action_24
action_264 (76) = happyShift action_25
action_264 (77) = happyShift action_26
action_264 (82) = happyShift action_27
action_264 (84) = happyShift action_28
action_264 (90) = happyShift action_29
action_264 (94) = happyShift action_30
action_264 (103) = happyShift action_31
action_264 (110) = happyShift action_32
action_264 (111) = happyShift action_40
action_264 (112) = happyShift action_34
action_264 (9) = happyGoto action_274
action_264 (21) = happyGoto action_4
action_264 (24) = happyGoto action_5
action_264 (25) = happyGoto action_6
action_264 (26) = happyGoto action_7
action_264 (27) = happyGoto action_8
action_264 (28) = happyGoto action_9
action_264 (29) = happyGoto action_10
action_264 (30) = happyGoto action_11
action_264 (31) = happyGoto action_12
action_264 (32) = happyGoto action_13
action_264 (33) = happyGoto action_14
action_264 (46) = happyGoto action_18
action_264 _ = happyReduce_98

action_265 _ = happyReduce_2

action_266 (90) = happyShift action_161
action_266 _ = happyReduce_138

action_267 (92) = happyShift action_273
action_267 _ = happyFail

action_268 (76) = happyShift action_53
action_268 (77) = happyShift action_54
action_268 (90) = happyShift action_55
action_268 (94) = happyShift action_56
action_268 (109) = happyShift action_57
action_268 (110) = happyShift action_58
action_268 (111) = happyShift action_59
action_268 (11) = happyGoto action_47
action_268 (13) = happyGoto action_48
action_268 (14) = happyGoto action_49
action_268 (17) = happyGoto action_50
action_268 (18) = happyGoto action_51
action_268 (19) = happyGoto action_272
action_268 _ = happyFail

action_269 _ = happyReduce_119

action_270 (95) = happyShift action_271
action_270 (108) = happyShift action_268
action_270 _ = happyFail

action_271 (92) = happyShift action_278
action_271 _ = happyFail

action_272 _ = happyReduce_121

action_273 (66) = happyShift action_19
action_273 (67) = happyShift action_20
action_273 (68) = happyShift action_21
action_273 (71) = happyShift action_23
action_273 (75) = happyShift action_24
action_273 (76) = happyShift action_25
action_273 (77) = happyShift action_26
action_273 (82) = happyShift action_27
action_273 (84) = happyShift action_28
action_273 (90) = happyShift action_29
action_273 (94) = happyShift action_30
action_273 (103) = happyShift action_31
action_273 (110) = happyShift action_32
action_273 (111) = happyShift action_40
action_273 (112) = happyShift action_34
action_273 (5) = happyGoto action_277
action_273 (9) = happyGoto action_265
action_273 (21) = happyGoto action_4
action_273 (24) = happyGoto action_5
action_273 (25) = happyGoto action_6
action_273 (26) = happyGoto action_7
action_273 (27) = happyGoto action_8
action_273 (28) = happyGoto action_9
action_273 (29) = happyGoto action_10
action_273 (30) = happyGoto action_11
action_273 (31) = happyGoto action_12
action_273 (32) = happyGoto action_13
action_273 (33) = happyGoto action_14
action_273 (46) = happyGoto action_18
action_273 _ = happyFail

action_274 _ = happyReduce_3

action_275 (93) = happyShift action_276
action_275 _ = happyFail

action_276 _ = happyReduce_80

action_277 (66) = happyShift action_19
action_277 (67) = happyShift action_20
action_277 (68) = happyShift action_21
action_277 (71) = happyShift action_23
action_277 (75) = happyShift action_24
action_277 (76) = happyShift action_25
action_277 (77) = happyShift action_26
action_277 (82) = happyShift action_27
action_277 (84) = happyShift action_28
action_277 (90) = happyShift action_29
action_277 (93) = happyShift action_280
action_277 (94) = happyShift action_30
action_277 (103) = happyShift action_31
action_277 (110) = happyShift action_32
action_277 (111) = happyShift action_40
action_277 (112) = happyShift action_34
action_277 (9) = happyGoto action_274
action_277 (21) = happyGoto action_4
action_277 (24) = happyGoto action_5
action_277 (25) = happyGoto action_6
action_277 (26) = happyGoto action_7
action_277 (27) = happyGoto action_8
action_277 (28) = happyGoto action_9
action_277 (29) = happyGoto action_10
action_277 (30) = happyGoto action_11
action_277 (31) = happyGoto action_12
action_277 (32) = happyGoto action_13
action_277 (33) = happyGoto action_14
action_277 (46) = happyGoto action_18
action_277 _ = happyFail

action_278 (66) = happyShift action_19
action_278 (67) = happyShift action_20
action_278 (68) = happyShift action_21
action_278 (71) = happyShift action_23
action_278 (75) = happyShift action_24
action_278 (76) = happyShift action_25
action_278 (77) = happyShift action_26
action_278 (82) = happyShift action_27
action_278 (84) = happyShift action_28
action_278 (90) = happyShift action_29
action_278 (94) = happyShift action_30
action_278 (103) = happyShift action_31
action_278 (110) = happyShift action_32
action_278 (111) = happyShift action_40
action_278 (112) = happyShift action_34
action_278 (5) = happyGoto action_279
action_278 (9) = happyGoto action_265
action_278 (21) = happyGoto action_4
action_278 (24) = happyGoto action_5
action_278 (25) = happyGoto action_6
action_278 (26) = happyGoto action_7
action_278 (27) = happyGoto action_8
action_278 (28) = happyGoto action_9
action_278 (29) = happyGoto action_10
action_278 (30) = happyGoto action_11
action_278 (31) = happyGoto action_12
action_278 (32) = happyGoto action_13
action_278 (33) = happyGoto action_14
action_278 (46) = happyGoto action_18
action_278 _ = happyFail

action_279 (66) = happyShift action_19
action_279 (67) = happyShift action_20
action_279 (68) = happyShift action_21
action_279 (71) = happyShift action_23
action_279 (75) = happyShift action_24
action_279 (76) = happyShift action_25
action_279 (77) = happyShift action_26
action_279 (82) = happyShift action_27
action_279 (84) = happyShift action_28
action_279 (90) = happyShift action_29
action_279 (93) = happyShift action_281
action_279 (94) = happyShift action_30
action_279 (103) = happyShift action_31
action_279 (110) = happyShift action_32
action_279 (111) = happyShift action_40
action_279 (112) = happyShift action_34
action_279 (9) = happyGoto action_274
action_279 (21) = happyGoto action_4
action_279 (24) = happyGoto action_5
action_279 (25) = happyGoto action_6
action_279 (26) = happyGoto action_7
action_279 (27) = happyGoto action_8
action_279 (28) = happyGoto action_9
action_279 (29) = happyGoto action_10
action_279 (30) = happyGoto action_11
action_279 (31) = happyGoto action_12
action_279 (32) = happyGoto action_13
action_279 (33) = happyGoto action_14
action_279 (46) = happyGoto action_18
action_279 _ = happyFail

action_280 _ = happyReduce_118

action_281 _ = happyReduce_117

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn4
		 (CompUnit happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn6
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  6 happyReduction_5
happyReduction_5 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_0  6 happyReduction_6
happyReduction_6  =  HappyAbsSyn6
		 ([]
	)

happyReduce_7 = happySpecReduce_1  7 happyReduction_7
happyReduction_7 (HappyAbsSyn41  happy_var_1)
	 =  HappyAbsSyn7
		 ([happy_var_1]
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  7 happyReduction_8
happyReduction_8 (HappyAbsSyn41  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_0  7 happyReduction_9
happyReduction_9  =  HappyAbsSyn7
		 ([]
	)

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn41  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_2  8 happyReduction_11
happyReduction_11 (HappyAbsSyn41  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_2  9 happyReduction_12
happyReduction_12 _
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  10 happyReduction_13
happyReduction_13 (HappyAbsSyn33  happy_var_2)
	_
	 =  HappyAbsSyn10
		 ([happy_var_2]
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  10 happyReduction_14
happyReduction_14 (HappyAbsSyn33  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  11 happyReduction_15
happyReduction_15 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn11
		 (PatExpNumLiteral happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  11 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn11
		 (PatExpBoolLiteral True
	)

happyReduce_17 = happySpecReduce_1  11 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn11
		 (PatExpBoolLiteral False
	)

happyReduce_18 = happySpecReduce_2  12 happyReduction_18
happyReduction_18 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn12
		 ([happy_var_2]
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  12 happyReduction_19
happyReduction_19 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happyReduce 4 13 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (PatExpTuple ([happy_var_2] ++ happy_var_3)
	) `HappyStk` happyRest

happyReduce_21 = happyReduce 4 14 happyReduction_21
happyReduction_21 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (PatExpAdt happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_1  15 happyReduction_22
happyReduction_22 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn15
		 ([happy_var_1]
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  15 happyReduction_23
happyReduction_23 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_0  15 happyReduction_24
happyReduction_24  =  HappyAbsSyn15
		 ([]
	)

happyReduce_25 = happySpecReduce_1  16 happyReduction_25
happyReduction_25 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  16 happyReduction_26
happyReduction_26 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_0  16 happyReduction_27
happyReduction_27  =  HappyAbsSyn16
		 ([]
	)

happyReduce_28 = happySpecReduce_3  17 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn17
		 (happy_var_2
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  17 happyReduction_29
happyReduction_29 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  17 happyReduction_30
happyReduction_30 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  17 happyReduction_31
happyReduction_31 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn17
		 (PatExpId happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 _
	 =  HappyAbsSyn17
		 (PatExpWildcard
	)

happyReduce_34 = happySpecReduce_3  18 happyReduction_34
happyReduction_34 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 (PatExpListCons happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn18
		 (PatExpList happy_var_2
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  18 happyReduction_36
happyReduction_36 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  19 happyReduction_37
happyReduction_37 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn20
		 ([happy_var_1]
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  20 happyReduction_39
happyReduction_39 (HappyAbsSyn33  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_0  20 happyReduction_40
happyReduction_40  =  HappyAbsSyn20
		 ([]
	)

happyReduce_41 = happySpecReduce_3  21 happyReduction_41
happyReduction_41 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (ExpList happy_var_2
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  22 happyReduction_42
happyReduction_42 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn22
		 ([happy_var_1]
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  22 happyReduction_43
happyReduction_43 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_0  22 happyReduction_44
happyReduction_44  =  HappyAbsSyn22
		 ([]
	)

happyReduce_45 = happySpecReduce_2  23 happyReduction_45
happyReduction_45 _
	_
	 =  HappyAbsSyn23
		 ([]
	)

happyReduce_46 = happySpecReduce_3  23 happyReduction_46
happyReduction_46 _
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn23
		 (happy_var_2
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_0  23 happyReduction_47
happyReduction_47  =  HappyAbsSyn23
		 ([]
	)

happyReduce_48 = happyReduce 5 24 happyReduction_48
happyReduction_48 (_ `HappyStk`
	(HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (ExpModule happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_49 = happySpecReduce_3  25 happyReduction_49
happyReduction_49 _
	(HappyAbsSyn33  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (happy_var_2
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  25 happyReduction_50
happyReduction_50 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_2  25 happyReduction_51
happyReduction_51 _
	_
	 =  HappyAbsSyn25
		 (ExpUnit
	)

happyReduce_52 = happyReduce 4 25 happyReduction_52
happyReduction_52 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	(HappyAbsSyn33  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (ExpTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_53 = happySpecReduce_1  25 happyReduction_53
happyReduction_53 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happyReduce 7 25 happyReduction_54
happyReduction_54 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (ExpFun happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_55 = happySpecReduce_1  25 happyReduction_55
happyReduction_55 (HappyTerminal (Token _ (TokenNumLit happy_var_1)))
	 =  HappyAbsSyn25
		 (ExpNum happy_var_1
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  25 happyReduction_56
happyReduction_56 _
	 =  HappyAbsSyn25
		 (ExpBool True
	)

happyReduce_57 = happySpecReduce_1  25 happyReduction_57
happyReduction_57 _
	 =  HappyAbsSyn25
		 (ExpBool False
	)

happyReduce_58 = happySpecReduce_1  25 happyReduction_58
happyReduction_58 (HappyTerminal (Token _ (TokenString happy_var_1)))
	 =  HappyAbsSyn25
		 (ExpString happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  25 happyReduction_59
happyReduction_59 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn25
		 (ExpRef happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  26 happyReduction_60
happyReduction_60 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (ExpMemberAccess happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  26 happyReduction_61
happyReduction_61 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happyReduce 4 27 happyReduction_62
happyReduction_62 (_ `HappyStk`
	(HappyAbsSyn44  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_63 = happySpecReduce_1  27 happyReduction_63
happyReduction_63 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  28 happyReduction_64
happyReduction_64 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (ExpMul happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  28 happyReduction_65
happyReduction_65 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  29 happyReduction_66
happyReduction_66 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (ExpDiv happy_var_1 happy_var_3
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_1  29 happyReduction_67
happyReduction_67 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_1
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  30 happyReduction_68
happyReduction_68 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (ExpAdd happy_var_1 happy_var_3
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  30 happyReduction_69
happyReduction_69 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn30
		 (happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  31 happyReduction_70
happyReduction_70 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (ExpSub happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  31 happyReduction_71
happyReduction_71 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  32 happyReduction_72
happyReduction_72 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn32
		 (ExpCons happy_var_1 happy_var_3
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  32 happyReduction_73
happyReduction_73 (HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn32
		 (happy_var_1
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_2  33 happyReduction_74
happyReduction_74 (HappyAbsSyn32  happy_var_2)
	_
	 =  HappyAbsSyn33
		 (ExpNot happy_var_2
	)
happyReduction_74 _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_1  33 happyReduction_75
happyReduction_75 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_2  33 happyReduction_76
happyReduction_76 (HappyAbsSyn65  happy_var_2)
	_
	 =  HappyAbsSyn33
		 (ExpImport happy_var_2
	)
happyReduction_76 _ _  = notHappyAtAll 

happyReduce_77 = happyReduce 4 33 happyReduction_77
happyReduction_77 ((HappyAbsSyn33  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn33
		 (ExpAssign happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_78 = happyReduce 4 33 happyReduction_78
happyReduction_78 (_ `HappyStk`
	(HappyAbsSyn64  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn33
		 (ExpStruct happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_79 = happySpecReduce_1  33 happyReduction_79
happyReduction_79 (HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn33
		 (ExpTypeDec happy_var_1
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happyReduce 11 33 happyReduction_80
happyReduction_80 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn33  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn33
		 (ExpIfElse happy_var_3 happy_var_6 happy_var_10
	) `HappyStk` happyRest

happyReduce_81 = happyReduce 7 33 happyReduction_81
happyReduction_81 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn33  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn33
		 (ExpSwitch happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_82 = happySpecReduce_3  34 happyReduction_82
happyReduction_82 (HappyAbsSyn24  happy_var_3)
	_
	(HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn34
		 (AnnDefModule happy_var_1 happy_var_3
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  34 happyReduction_83
happyReduction_83 (HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn34
		 (AnnDefFun happy_var_1
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  35 happyReduction_84
happyReduction_84 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn35
		 ([happy_var_1]
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_2  35 happyReduction_85
happyReduction_85 (HappyAbsSyn34  happy_var_2)
	(HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn35
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_85 _ _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_3  36 happyReduction_86
happyReduction_86 _
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn36
		 (happy_var_2
	)
happyReduction_86 _ _ _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_0  36 happyReduction_87
happyReduction_87  =  HappyAbsSyn36
		 ([]
	)

happyReduce_88 = happyReduce 7 37 happyReduction_88
happyReduction_88 (_ `HappyStk`
	(HappyAbsSyn35  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn60  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn36  happy_var_2) `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn37
		 (ExpAnnDec happy_var_1 happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_89 = happyReduce 5 38 happyReduction_89
happyReduction_89 (_ `HappyStk`
	(HappyAbsSyn60  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn36  happy_var_2) `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn38
		 (TyAnn happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_90 = happySpecReduce_1  39 happyReduction_90
happyReduction_90 (HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn39
		 ([happy_var_1]
	)
happyReduction_90 _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_2  39 happyReduction_91
happyReduction_91 (HappyAbsSyn38  happy_var_2)
	(HappyAbsSyn39  happy_var_1)
	 =  HappyAbsSyn39
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_91 _ _  = notHappyAtAll 

happyReduce_92 = happyReduce 6 40 happyReduction_92
happyReduction_92 (_ `HappyStk`
	(HappyAbsSyn39  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn36  happy_var_3) `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn40
		 (ExpInterfaceDec happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_93 = happySpecReduce_1  41 happyReduction_93
happyReduction_93 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1
	)
happyReduction_93 _  = notHappyAtAll 

happyReduce_94 = happySpecReduce_2  41 happyReduction_94
happyReduction_94 _
	(HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1
	)
happyReduction_94 _ _  = notHappyAtAll 

happyReduce_95 = happySpecReduce_1  41 happyReduction_95
happyReduction_95 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1
	)
happyReduction_95 _  = notHappyAtAll 

happyReduce_96 = happySpecReduce_1  42 happyReduction_96
happyReduction_96 (HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn42
		 ([happy_var_1]
	)
happyReduction_96 _  = notHappyAtAll 

happyReduce_97 = happySpecReduce_2  42 happyReduction_97
happyReduction_97 (HappyAbsSyn43  happy_var_2)
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn42
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_97 _ _  = notHappyAtAll 

happyReduce_98 = happyReduce 4 43 happyReduction_98
happyReduction_98 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn43
		 (CaseClause happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_99 = happySpecReduce_1  44 happyReduction_99
happyReduction_99 (HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn44
		 ([happy_var_1]
	)
happyReduction_99 _  = notHappyAtAll 

happyReduce_100 = happySpecReduce_3  44 happyReduction_100
happyReduction_100 (HappyAbsSyn33  happy_var_3)
	_
	(HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn44
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_100 _ _ _  = notHappyAtAll 

happyReduce_101 = happySpecReduce_0  44 happyReduction_101
happyReduction_101  =  HappyAbsSyn44
		 ([]
	)

happyReduce_102 = happySpecReduce_1  45 happyReduction_102
happyReduction_102 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn45
		 ([happy_var_1]
	)
happyReduction_102 _  = notHappyAtAll 

happyReduce_103 = happySpecReduce_3  45 happyReduction_103
happyReduction_103 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn45  happy_var_1)
	 =  HappyAbsSyn45
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_103 _ _ _  = notHappyAtAll 

happyReduce_104 = happySpecReduce_0  45 happyReduction_104
happyReduction_104  =  HappyAbsSyn45
		 ([]
	)

happyReduce_105 = happyReduce 4 46 happyReduction_105
happyReduction_105 ((HappyAbsSyn60  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_106 = happyReduce 4 46 happyReduction_106
happyReduction_106 ((HappyAbsSyn47  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_107 = happySpecReduce_1  47 happyReduction_107
happyReduction_107 (HappyAbsSyn48  happy_var_1)
	 =  HappyAbsSyn47
		 ([happy_var_1]
	)
happyReduction_107 _  = notHappyAtAll 

happyReduce_108 = happySpecReduce_2  47 happyReduction_108
happyReduction_108 (HappyAbsSyn48  happy_var_2)
	(HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn47
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_108 _ _  = notHappyAtAll 

happyReduce_109 = happySpecReduce_3  48 happyReduction_109
happyReduction_109 (HappyAbsSyn49  happy_var_3)
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	_
	 =  HappyAbsSyn48
		 (AdtAlternative happy_var_2 0 happy_var_3
	)
happyReduction_109 _ _ _  = notHappyAtAll 

happyReduce_110 = happySpecReduce_1  49 happyReduction_110
happyReduction_110 (HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn49
		 ([happy_var_1]
	)
happyReduction_110 _  = notHappyAtAll 

happyReduce_111 = happySpecReduce_2  49 happyReduction_111
happyReduction_111 (HappyAbsSyn60  happy_var_2)
	(HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn49
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_111 _ _  = notHappyAtAll 

happyReduce_112 = happySpecReduce_0  49 happyReduction_112
happyReduction_112  =  HappyAbsSyn49
		 ([]
	)

happyReduce_113 = happyReduce 12 50 happyReduction_113
happyReduction_113 ((HappyAbsSyn51  happy_var_12) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn60  happy_var_10) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn55  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_5))) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn60  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn50
		 (FunDecInstFun happy_var_5 happy_var_3 (SynTyArrow happy_var_7 happy_var_10) happy_var_12
	) `HappyStk` happyRest

happyReduce_114 = happyReduce 9 50 happyReduction_114
happyReduction_114 ((HappyAbsSyn51  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn60  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn55  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn50
		 (FunDecFun happy_var_2 (SynTyArrow happy_var_4 happy_var_7) happy_var_9
	) `HappyStk` happyRest

happyReduce_115 = happySpecReduce_1  51 happyReduction_115
happyReduction_115 (HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn51
		 ([happy_var_1]
	)
happyReduction_115 _  = notHappyAtAll 

happyReduce_116 = happySpecReduce_2  51 happyReduction_116
happyReduction_116 (HappyAbsSyn52  happy_var_2)
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn51
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_116 _ _  = notHappyAtAll 

happyReduce_117 = happyReduce 8 52 happyReduction_117
happyReduction_117 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn54  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_2))) `HappyStk`
	(HappyAbsSyn53  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (FunDefInstFun happy_var_1 happy_var_2 happy_var_4 happy_var_7
	) `HappyStk` happyRest

happyReduce_118 = happyReduce 7 52 happyReduction_118
happyReduction_118 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn54  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (FunDefFun happy_var_1 happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_119 = happyReduce 4 53 happyReduction_119
happyReduction_119 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn53
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_120 = happySpecReduce_1  54 happyReduction_120
happyReduction_120 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn54
		 ([happy_var_1]
	)
happyReduction_120 _  = notHappyAtAll 

happyReduce_121 = happySpecReduce_3  54 happyReduction_121
happyReduction_121 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn54  happy_var_1)
	 =  HappyAbsSyn54
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_121 _ _ _  = notHappyAtAll 

happyReduce_122 = happySpecReduce_0  54 happyReduction_122
happyReduction_122  =  HappyAbsSyn54
		 ([]
	)

happyReduce_123 = happySpecReduce_1  55 happyReduction_123
happyReduction_123 (HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn55
		 ([happy_var_1]
	)
happyReduction_123 _  = notHappyAtAll 

happyReduce_124 = happySpecReduce_3  55 happyReduction_124
happyReduction_124 (HappyAbsSyn60  happy_var_3)
	_
	(HappyAbsSyn55  happy_var_1)
	 =  HappyAbsSyn55
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_124 _ _ _  = notHappyAtAll 

happyReduce_125 = happySpecReduce_0  55 happyReduction_125
happyReduction_125  =  HappyAbsSyn55
		 ([]
	)

happyReduce_126 = happySpecReduce_2  56 happyReduction_126
happyReduction_126 (HappyAbsSyn60  happy_var_2)
	_
	 =  HappyAbsSyn56
		 ([happy_var_2]
	)
happyReduction_126 _ _  = notHappyAtAll 

happyReduce_127 = happySpecReduce_3  56 happyReduction_127
happyReduction_127 (HappyAbsSyn60  happy_var_3)
	_
	(HappyAbsSyn56  happy_var_1)
	 =  HappyAbsSyn56
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_127 _ _ _  = notHappyAtAll 

happyReduce_128 = happyReduce 4 57 happyReduction_128
happyReduction_128 (_ `HappyStk`
	(HappyAbsSyn56  happy_var_3) `HappyStk`
	(HappyAbsSyn60  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn57
		 (SynTyTuple (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_129 = happySpecReduce_2  58 happyReduction_129
happyReduction_129 (HappyAbsSyn60  happy_var_2)
	_
	 =  HappyAbsSyn58
		 (Just happy_var_2
	)
happyReduction_129 _ _  = notHappyAtAll 

happyReduce_130 = happySpecReduce_0  58 happyReduction_130
happyReduction_130  =  HappyAbsSyn58
		 (Nothing
	)

happyReduce_131 = happySpecReduce_3  59 happyReduction_131
happyReduction_131 _
	(HappyAbsSyn55  happy_var_2)
	_
	 =  HappyAbsSyn59
		 (happy_var_2
	)
happyReduction_131 _ _ _  = notHappyAtAll 

happyReduce_132 = happySpecReduce_0  59 happyReduction_132
happyReduction_132  =  HappyAbsSyn59
		 ([]
	)

happyReduce_133 = happySpecReduce_1  60 happyReduction_133
happyReduction_133 _
	 =  HappyAbsSyn60
		 (SynTyInt
	)

happyReduce_134 = happySpecReduce_1  60 happyReduction_134
happyReduction_134 _
	 =  HappyAbsSyn60
		 (SynTyBool
	)

happyReduce_135 = happySpecReduce_1  60 happyReduction_135
happyReduction_135 _
	 =  HappyAbsSyn60
		 (SynTyString
	)

happyReduce_136 = happySpecReduce_1  60 happyReduction_136
happyReduction_136 _
	 =  HappyAbsSyn60
		 (SynTyUnit
	)

happyReduce_137 = happyReduce 5 60 happyReduction_137
happyReduction_137 ((HappyAbsSyn60  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn60
		 (SynTyArrow [] happy_var_5
	) `HappyStk` happyRest

happyReduce_138 = happyReduce 6 60 happyReduction_138
happyReduction_138 ((HappyAbsSyn60  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn55  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn60
		 (SynTyArrow happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_139 = happySpecReduce_2  60 happyReduction_139
happyReduction_139 (HappyAbsSyn58  happy_var_2)
	_
	 =  HappyAbsSyn60
		 (SynTyModule [] happy_var_2
	)
happyReduction_139 _ _  = notHappyAtAll 

happyReduce_140 = happyReduce 5 60 happyReduction_140
happyReduction_140 ((HappyAbsSyn58  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn55  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn60
		 (SynTyModule happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_141 = happySpecReduce_3  60 happyReduction_141
happyReduction_141 _
	_
	_
	 =  HappyAbsSyn60
		 (SynTyInterface []
	)

happyReduce_142 = happySpecReduce_3  60 happyReduction_142
happyReduction_142 (HappyAbsSyn59  happy_var_3)
	(HappyAbsSyn65  happy_var_2)
	_
	 =  HappyAbsSyn60
		 (SynTyDefault happy_var_2 happy_var_3
	)
happyReduction_142 _ _ _  = notHappyAtAll 

happyReduce_143 = happyReduce 4 60 happyReduction_143
happyReduction_143 (_ `HappyStk`
	(HappyAbsSyn62  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn60
		 (SynTyStruct happy_var_3
	) `HappyStk` happyRest

happyReduce_144 = happySpecReduce_1  60 happyReduction_144
happyReduction_144 (HappyAbsSyn57  happy_var_1)
	 =  HappyAbsSyn60
		 (happy_var_1
	)
happyReduction_144 _  = notHappyAtAll 

happyReduce_145 = happySpecReduce_1  60 happyReduction_145
happyReduction_145 (HappyAbsSyn65  happy_var_1)
	 =  HappyAbsSyn60
		 (SynTyRef happy_var_1 []
	)
happyReduction_145 _  = notHappyAtAll 

happyReduce_146 = happyReduce 4 60 happyReduction_146
happyReduction_146 (_ `HappyStk`
	(HappyAbsSyn55  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn65  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn60
		 (SynTyRef happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_147 = happySpecReduce_3  60 happyReduction_147
happyReduction_147 _
	_
	(HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn60
		 (SynTyList happy_var_1
	)
happyReduction_147 _ _ _  = notHappyAtAll 

happyReduce_148 = happySpecReduce_3  61 happyReduction_148
happyReduction_148 _
	(HappyTerminal (Token _ (TokenId happy_var_2)))
	(HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn61
		 ((happy_var_2, happy_var_1)
	)
happyReduction_148 _ _ _  = notHappyAtAll 

happyReduce_149 = happySpecReduce_1  62 happyReduction_149
happyReduction_149 (HappyAbsSyn61  happy_var_1)
	 =  HappyAbsSyn62
		 ([happy_var_1]
	)
happyReduction_149 _  = notHappyAtAll 

happyReduce_150 = happySpecReduce_2  62 happyReduction_150
happyReduction_150 (HappyAbsSyn61  happy_var_2)
	(HappyAbsSyn62  happy_var_1)
	 =  HappyAbsSyn62
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_150 _ _  = notHappyAtAll 

happyReduce_151 = happySpecReduce_0  62 happyReduction_151
happyReduction_151  =  HappyAbsSyn62
		 ([]
	)

happyReduce_152 = happyReduce 4 63 happyReduction_152
happyReduction_152 (_ `HappyStk`
	(HappyAbsSyn33  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (Token _ (TokenId happy_var_1))) `HappyStk`
	happyRest)
	 = HappyAbsSyn63
		 ((happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_153 = happySpecReduce_1  64 happyReduction_153
happyReduction_153 (HappyAbsSyn63  happy_var_1)
	 =  HappyAbsSyn64
		 ([happy_var_1]
	)
happyReduction_153 _  = notHappyAtAll 

happyReduce_154 = happySpecReduce_2  64 happyReduction_154
happyReduction_154 (HappyAbsSyn63  happy_var_2)
	(HappyAbsSyn64  happy_var_1)
	 =  HappyAbsSyn64
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_154 _ _  = notHappyAtAll 

happyReduce_155 = happySpecReduce_0  64 happyReduction_155
happyReduction_155  =  HappyAbsSyn64
		 ([]
	)

happyReduce_156 = happySpecReduce_1  65 happyReduction_156
happyReduction_156 (HappyTerminal (Token _ (TokenId happy_var_1)))
	 =  HappyAbsSyn65
		 (Id happy_var_1
	)
happyReduction_156 _  = notHappyAtAll 

happyReduce_157 = happySpecReduce_3  65 happyReduction_157
happyReduction_157 (HappyTerminal (Token _ (TokenId happy_var_3)))
	_
	(HappyAbsSyn65  happy_var_1)
	 =  HappyAbsSyn65
		 (Path happy_var_1 happy_var_3
	)
happyReduction_157 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 113 113 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 66;
	Token _ TokenImport -> cont 67;
	Token _ TokenType -> cont 68;
	Token _ TokenInterface -> cont 69;
	Token _ TokenDefault -> cont 70;
	Token _ TokenFun -> cont 71;
	Token _ TokenImp -> cont 72;
	Token _ TokenTest -> cont 73;
	Token _ TokenStruct -> cont 74;
	Token _ TokenDef -> cont 75;
	Token _ TokenTrue -> cont 76;
	Token _ TokenFalse -> cont 77;
	Token _ TokenInt -> cont 78;
	Token _ TokenBool -> cont 79;
	Token _ TokenStringTy -> cont 80;
	Token _ TokenUnit -> cont 81;
	Token _ TokenIf -> cont 82;
	Token _ TokenElse -> cont 83;
	Token _ TokenSwitch -> cont 84;
	Token _ TokenCase -> cont 85;
	Token _ TokenAssign -> cont 86;
	Token _ TokenArrow -> cont 87;
	Token _ TokenRocket -> cont 88;
	Token _ TokenCons -> cont 89;
	Token _ TokenLBracket -> cont 90;
	Token _ TokenRBracket -> cont 91;
	Token _ TokenLBrace -> cont 92;
	Token _ TokenRBrace -> cont 93;
	Token _ TokenLParen -> cont 94;
	Token _ TokenRParen -> cont 95;
	Token _ TokenLt -> cont 96;
	Token _ TokenGt -> cont 97;
	Token _ TokenPipe -> cont 98;
	Token _ TokenPlus -> cont 99;
	Token _ TokenMinus -> cont 100;
	Token _ TokenStar -> cont 101;
	Token _ TokenFSlash -> cont 102;
	Token _ TokenExclamation -> cont 103;
	Token _ TokenSemi -> cont 104;
	Token _ TokenDot -> cont 105;
	Token _ TokenEq -> cont 106;
	Token _ TokenColon -> cont 107;
	Token _ TokenComma -> cont 108;
	Token _ TokenUnderscore -> cont 109;
	Token _ (TokenNumLit happy_dollar_dollar) -> cont 110;
	Token _ (TokenId happy_dollar_dollar) -> cont 111;
	Token _ (TokenString happy_dollar_dollar) -> cont 112;
	_ -> happyError' tk
	})

happyError_ 113 tk = happyError' tk
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

parseExp :: FilePath -> String -> Either Err (CompUnit RawId)
parseExp filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' parse filePath input
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

