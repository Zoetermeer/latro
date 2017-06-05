{-# OPTIONS_GHC -w #-}
module Latro.Parse where

import Control.Monad.Except
import Data.Bifunctor (first)
import Latro.Errors
import Latro.Lex
import Latro.Semant
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65 t66 t67 t68 t69 t70 t71 t72 t73 t74 t75 t76 t77 t78 t79 t80 t81 t82 t83 t84 t85 t86 t87 t88 t89 t90 t91 t92 t93 t94 t95 t96 t97 t98 t99 t100 t101
	= HappyTerminal (Token)
	| HappyErrorToken Int
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
	| HappyAbsSyn66 t66
	| HappyAbsSyn67 t67
	| HappyAbsSyn68 t68
	| HappyAbsSyn69 t69
	| HappyAbsSyn70 t70
	| HappyAbsSyn71 t71
	| HappyAbsSyn72 t72
	| HappyAbsSyn73 t73
	| HappyAbsSyn74 t74
	| HappyAbsSyn75 t75
	| HappyAbsSyn76 t76
	| HappyAbsSyn77 t77
	| HappyAbsSyn78 t78
	| HappyAbsSyn79 t79
	| HappyAbsSyn80 t80
	| HappyAbsSyn81 t81
	| HappyAbsSyn82 t82
	| HappyAbsSyn83 t83
	| HappyAbsSyn84 t84
	| HappyAbsSyn85 t85
	| HappyAbsSyn86 t86
	| HappyAbsSyn87 t87
	| HappyAbsSyn88 t88
	| HappyAbsSyn89 t89
	| HappyAbsSyn90 t90
	| HappyAbsSyn91 t91
	| HappyAbsSyn92 t92
	| HappyAbsSyn93 t93
	| HappyAbsSyn94 t94
	| HappyAbsSyn95 t95
	| HappyAbsSyn96 t96
	| HappyAbsSyn97 t97
	| HappyAbsSyn98 t98
	| HappyAbsSyn99 t99
	| HappyAbsSyn100 t100
	| HappyAbsSyn101 t101

action_0 (102) = happyShift action_6
action_0 (5) = happyGoto action_54
action_0 (10) = happyGoto action_3
action_0 (12) = happyGoto action_4
action_0 (27) = happyGoto action_5
action_0 _ = happyFail

action_1 (102) = happyShift action_6
action_1 (103) = happyShift action_32
action_1 (104) = happyShift action_33
action_1 (105) = happyShift action_34
action_1 (106) = happyShift action_35
action_1 (110) = happyShift action_36
action_1 (111) = happyShift action_37
action_1 (112) = happyShift action_38
action_1 (113) = happyShift action_39
action_1 (115) = happyShift action_40
action_1 (116) = happyShift action_41
action_1 (118) = happyShift action_42
action_1 (119) = happyShift action_43
action_1 (124) = happyShift action_44
action_1 (131) = happyShift action_45
action_1 (133) = happyShift action_46
action_1 (135) = happyShift action_47
action_1 (137) = happyShift action_48
action_1 (150) = happyShift action_49
action_1 (151) = happyShift action_50
action_1 (152) = happyShift action_51
action_1 (154) = happyShift action_52
action_1 (155) = happyShift action_53
action_1 (6) = happyGoto action_7
action_1 (9) = happyGoto action_8
action_1 (16) = happyGoto action_9
action_1 (27) = happyGoto action_10
action_1 (44) = happyGoto action_11
action_1 (46) = happyGoto action_12
action_1 (47) = happyGoto action_13
action_1 (48) = happyGoto action_14
action_1 (51) = happyGoto action_15
action_1 (52) = happyGoto action_16
action_1 (53) = happyGoto action_17
action_1 (54) = happyGoto action_18
action_1 (55) = happyGoto action_19
action_1 (56) = happyGoto action_20
action_1 (57) = happyGoto action_21
action_1 (58) = happyGoto action_22
action_1 (59) = happyGoto action_23
action_1 (63) = happyGoto action_24
action_1 (67) = happyGoto action_25
action_1 (70) = happyGoto action_26
action_1 (77) = happyGoto action_27
action_1 (78) = happyGoto action_28
action_1 (96) = happyGoto action_29
action_1 (98) = happyGoto action_30
action_1 (99) = happyGoto action_31
action_1 _ = happyFail

action_2 (102) = happyShift action_6
action_2 (10) = happyGoto action_3
action_2 (12) = happyGoto action_4
action_2 (27) = happyGoto action_5
action_2 _ = happyFail

action_3 _ = happyReduce_14

action_4 (102) = happyShift action_6
action_4 (10) = happyGoto action_110
action_4 (27) = happyGoto action_5
action_4 _ = happyReduce_2

action_5 _ = happyReduce_10

action_6 (151) = happyShift action_50
action_6 (152) = happyShift action_51
action_6 (96) = happyGoto action_109
action_6 (98) = happyGoto action_30
action_6 (99) = happyGoto action_56
action_6 _ = happyFail

action_7 (156) = happyAccept
action_7 _ = happyFail

action_8 _ = happyReduce_130

action_9 _ = happyReduce_3

action_10 _ = happyReduce_29

action_11 _ = happyReduce_112

action_12 _ = happyReduce_95

action_13 _ = happyReduce_96

action_14 (144) = happyShift action_108
action_14 (65) = happyGoto action_107
action_14 _ = happyFail

action_15 _ = happyReduce_116

action_16 _ = happyReduce_118

action_17 _ = happyReduce_120

action_18 (137) = happyShift action_104
action_18 (148) = happyShift action_105
action_18 (149) = happyShift action_106
action_18 _ = happyReduce_122

action_19 _ = happyReduce_124

action_20 (139) = happyShift action_59
action_20 (140) = happyShift action_60
action_20 (141) = happyShift action_61
action_20 (144) = happyShift action_62
action_20 (153) = happyShift action_63
action_20 (100) = happyGoto action_103
action_20 _ = happyReduce_126

action_21 _ = happyReduce_127

action_22 _ = happyReduce_135

action_23 _ = happyReduce_31

action_24 _ = happyReduce_30

action_25 _ = happyReduce_132

action_26 _ = happyReduce_27

action_27 _ = happyReduce_177

action_28 _ = happyReduce_28

action_29 (132) = happyShift action_101
action_29 (143) = happyShift action_102
action_29 _ = happyReduce_107

action_30 _ = happyReduce_218

action_31 (139) = happyShift action_99
action_31 (145) = happyShift action_100
action_31 _ = happyReduce_217

action_32 (151) = happyShift action_50
action_32 (152) = happyShift action_51
action_32 (96) = happyGoto action_98
action_32 (98) = happyGoto action_30
action_32 (99) = happyGoto action_56
action_32 _ = happyFail

action_33 (139) = happyShift action_97
action_33 (151) = happyShift action_50
action_33 (152) = happyShift action_51
action_33 (66) = happyGoto action_95
action_33 (99) = happyGoto action_96
action_33 _ = happyReduce_151

action_34 (151) = happyShift action_50
action_34 (152) = happyShift action_51
action_34 (99) = happyGoto action_94
action_34 _ = happyFail

action_35 (137) = happyShift action_93
action_35 _ = happyFail

action_36 (111) = happyShift action_84
action_36 (112) = happyShift action_85
action_36 (131) = happyShift action_86
action_36 (133) = happyShift action_87
action_36 (137) = happyShift action_88
action_36 (147) = happyShift action_89
action_36 (150) = happyShift action_90
action_36 (151) = happyShift action_50
action_36 (152) = happyShift action_51
action_36 (154) = happyShift action_91
action_36 (155) = happyShift action_92
action_36 (34) = happyGoto action_75
action_36 (36) = happyGoto action_76
action_36 (37) = happyGoto action_77
action_36 (40) = happyGoto action_78
action_36 (41) = happyGoto action_79
action_36 (42) = happyGoto action_80
action_36 (96) = happyGoto action_81
action_36 (98) = happyGoto action_82
action_36 (99) = happyGoto action_83
action_36 _ = happyFail

action_37 _ = happyReduce_103

action_38 _ = happyReduce_104

action_39 (137) = happyShift action_74
action_39 _ = happyFail

action_40 (137) = happyShift action_73
action_40 _ = happyFail

action_41 (135) = happyShift action_72
action_41 _ = happyFail

action_42 (139) = happyShift action_59
action_42 (140) = happyShift action_60
action_42 (141) = happyShift action_61
action_42 (144) = happyShift action_62
action_42 (153) = happyShift action_63
action_42 (100) = happyGoto action_71
action_42 _ = happyFail

action_43 (137) = happyShift action_70
action_43 _ = happyFail

action_44 (137) = happyShift action_69
action_44 _ = happyFail

action_45 (106) = happyShift action_35
action_45 (111) = happyShift action_37
action_45 (112) = happyShift action_38
action_45 (113) = happyShift action_39
action_45 (115) = happyShift action_40
action_45 (116) = happyShift action_41
action_45 (119) = happyShift action_43
action_45 (131) = happyShift action_45
action_45 (133) = happyShift action_46
action_45 (135) = happyShift action_47
action_45 (137) = happyShift action_48
action_45 (150) = happyShift action_49
action_45 (151) = happyShift action_50
action_45 (152) = happyShift action_51
action_45 (154) = happyShift action_52
action_45 (155) = happyShift action_53
action_45 (9) = happyGoto action_8
action_45 (44) = happyGoto action_11
action_45 (46) = happyGoto action_12
action_45 (47) = happyGoto action_13
action_45 (48) = happyGoto action_14
action_45 (51) = happyGoto action_15
action_45 (52) = happyGoto action_16
action_45 (53) = happyGoto action_17
action_45 (54) = happyGoto action_18
action_45 (55) = happyGoto action_19
action_45 (56) = happyGoto action_20
action_45 (57) = happyGoto action_21
action_45 (58) = happyGoto action_68
action_45 (96) = happyGoto action_29
action_45 (98) = happyGoto action_30
action_45 (99) = happyGoto action_56
action_45 _ = happyFail

action_46 (106) = happyShift action_35
action_46 (111) = happyShift action_37
action_46 (112) = happyShift action_38
action_46 (113) = happyShift action_39
action_46 (115) = happyShift action_40
action_46 (116) = happyShift action_41
action_46 (119) = happyShift action_43
action_46 (131) = happyShift action_45
action_46 (133) = happyShift action_46
action_46 (135) = happyShift action_47
action_46 (137) = happyShift action_48
action_46 (150) = happyShift action_49
action_46 (151) = happyShift action_50
action_46 (152) = happyShift action_51
action_46 (154) = happyShift action_52
action_46 (155) = happyShift action_53
action_46 (9) = happyGoto action_8
action_46 (43) = happyGoto action_66
action_46 (44) = happyGoto action_11
action_46 (46) = happyGoto action_12
action_46 (47) = happyGoto action_13
action_46 (48) = happyGoto action_14
action_46 (51) = happyGoto action_15
action_46 (52) = happyGoto action_16
action_46 (53) = happyGoto action_17
action_46 (54) = happyGoto action_18
action_46 (55) = happyGoto action_19
action_46 (56) = happyGoto action_20
action_46 (57) = happyGoto action_21
action_46 (58) = happyGoto action_67
action_46 (96) = happyGoto action_29
action_46 (98) = happyGoto action_30
action_46 (99) = happyGoto action_56
action_46 _ = happyReduce_88

action_47 (103) = happyShift action_32
action_47 (106) = happyShift action_35
action_47 (110) = happyShift action_36
action_47 (111) = happyShift action_37
action_47 (112) = happyShift action_38
action_47 (113) = happyShift action_39
action_47 (115) = happyShift action_40
action_47 (116) = happyShift action_41
action_47 (119) = happyShift action_43
action_47 (124) = happyShift action_44
action_47 (131) = happyShift action_45
action_47 (133) = happyShift action_46
action_47 (135) = happyShift action_47
action_47 (137) = happyShift action_48
action_47 (150) = happyShift action_49
action_47 (151) = happyShift action_50
action_47 (152) = happyShift action_51
action_47 (154) = happyShift action_52
action_47 (155) = happyShift action_53
action_47 (9) = happyGoto action_8
action_47 (44) = happyGoto action_11
action_47 (46) = happyGoto action_12
action_47 (47) = happyGoto action_13
action_47 (48) = happyGoto action_14
action_47 (51) = happyGoto action_15
action_47 (52) = happyGoto action_16
action_47 (53) = happyGoto action_17
action_47 (54) = happyGoto action_18
action_47 (55) = happyGoto action_19
action_47 (56) = happyGoto action_20
action_47 (57) = happyGoto action_21
action_47 (58) = happyGoto action_22
action_47 (59) = happyGoto action_64
action_47 (60) = happyGoto action_65
action_47 (67) = happyGoto action_25
action_47 (96) = happyGoto action_29
action_47 (98) = happyGoto action_30
action_47 (99) = happyGoto action_31
action_47 _ = happyFail

action_48 (106) = happyShift action_35
action_48 (111) = happyShift action_37
action_48 (112) = happyShift action_38
action_48 (113) = happyShift action_39
action_48 (115) = happyShift action_40
action_48 (116) = happyShift action_41
action_48 (119) = happyShift action_43
action_48 (131) = happyShift action_45
action_48 (133) = happyShift action_46
action_48 (135) = happyShift action_47
action_48 (137) = happyShift action_48
action_48 (138) = happyShift action_58
action_48 (139) = happyShift action_59
action_48 (140) = happyShift action_60
action_48 (141) = happyShift action_61
action_48 (144) = happyShift action_62
action_48 (150) = happyShift action_49
action_48 (151) = happyShift action_50
action_48 (152) = happyShift action_51
action_48 (153) = happyShift action_63
action_48 (154) = happyShift action_52
action_48 (155) = happyShift action_53
action_48 (9) = happyGoto action_8
action_48 (44) = happyGoto action_11
action_48 (46) = happyGoto action_12
action_48 (47) = happyGoto action_13
action_48 (48) = happyGoto action_14
action_48 (51) = happyGoto action_15
action_48 (52) = happyGoto action_16
action_48 (53) = happyGoto action_17
action_48 (54) = happyGoto action_18
action_48 (55) = happyGoto action_19
action_48 (56) = happyGoto action_20
action_48 (57) = happyGoto action_21
action_48 (58) = happyGoto action_55
action_48 (96) = happyGoto action_29
action_48 (98) = happyGoto action_30
action_48 (99) = happyGoto action_56
action_48 (100) = happyGoto action_57
action_48 _ = happyFail

action_49 _ = happyReduce_102

action_50 _ = happyReduce_222

action_51 _ = happyReduce_223

action_52 _ = happyReduce_105

action_53 _ = happyReduce_106

action_54 (156) = happyAccept
action_54 _ = happyFail

action_55 (138) = happyShift action_173
action_55 _ = happyFail

action_56 _ = happyReduce_217

action_57 (138) = happyShift action_172
action_57 _ = happyFail

action_58 _ = happyReduce_109

action_59 (139) = happyShift action_59
action_59 (140) = happyShift action_60
action_59 (141) = happyShift action_61
action_59 (144) = happyShift action_62
action_59 (153) = happyShift action_63
action_59 (100) = happyGoto action_171
action_59 _ = happyReduce_229

action_60 (139) = happyShift action_59
action_60 (140) = happyShift action_60
action_60 (141) = happyShift action_61
action_60 (144) = happyShift action_62
action_60 (153) = happyShift action_63
action_60 (100) = happyGoto action_170
action_60 _ = happyReduce_230

action_61 (139) = happyShift action_59
action_61 (140) = happyShift action_60
action_61 (141) = happyShift action_61
action_61 (144) = happyShift action_62
action_61 (153) = happyShift action_63
action_61 (100) = happyGoto action_169
action_61 _ = happyReduce_227

action_62 (139) = happyShift action_59
action_62 (140) = happyShift action_60
action_62 (141) = happyShift action_61
action_62 (144) = happyShift action_62
action_62 (153) = happyShift action_63
action_62 (100) = happyGoto action_168
action_62 _ = happyReduce_225

action_63 _ = happyReduce_224

action_64 _ = happyReduce_136

action_65 (103) = happyShift action_32
action_65 (106) = happyShift action_35
action_65 (110) = happyShift action_36
action_65 (111) = happyShift action_37
action_65 (112) = happyShift action_38
action_65 (113) = happyShift action_39
action_65 (115) = happyShift action_40
action_65 (116) = happyShift action_41
action_65 (119) = happyShift action_43
action_65 (124) = happyShift action_44
action_65 (131) = happyShift action_45
action_65 (133) = happyShift action_46
action_65 (135) = happyShift action_47
action_65 (136) = happyShift action_167
action_65 (137) = happyShift action_48
action_65 (150) = happyShift action_49
action_65 (151) = happyShift action_50
action_65 (152) = happyShift action_51
action_65 (154) = happyShift action_52
action_65 (155) = happyShift action_53
action_65 (9) = happyGoto action_8
action_65 (44) = happyGoto action_11
action_65 (46) = happyGoto action_12
action_65 (47) = happyGoto action_13
action_65 (48) = happyGoto action_14
action_65 (51) = happyGoto action_15
action_65 (52) = happyGoto action_16
action_65 (53) = happyGoto action_17
action_65 (54) = happyGoto action_18
action_65 (55) = happyGoto action_19
action_65 (56) = happyGoto action_20
action_65 (57) = happyGoto action_21
action_65 (58) = happyGoto action_22
action_65 (59) = happyGoto action_166
action_65 (67) = happyGoto action_25
action_65 (96) = happyGoto action_29
action_65 (98) = happyGoto action_30
action_65 (99) = happyGoto action_31
action_65 _ = happyFail

action_66 (134) = happyShift action_164
action_66 (146) = happyShift action_165
action_66 _ = happyFail

action_67 _ = happyReduce_86

action_68 (146) = happyShift action_163
action_68 (33) = happyGoto action_162
action_68 _ = happyFail

action_69 (139) = happyShift action_59
action_69 (140) = happyShift action_60
action_69 (141) = happyShift action_61
action_69 (144) = happyShift action_62
action_69 (153) = happyShift action_63
action_69 (100) = happyGoto action_161
action_69 _ = happyFail

action_70 (151) = happyShift action_160
action_70 _ = happyFail

action_71 (150) = happyShift action_159
action_71 _ = happyFail

action_72 (106) = happyShift action_35
action_72 (111) = happyShift action_37
action_72 (112) = happyShift action_38
action_72 (113) = happyShift action_39
action_72 (115) = happyShift action_40
action_72 (116) = happyShift action_41
action_72 (119) = happyShift action_43
action_72 (131) = happyShift action_45
action_72 (133) = happyShift action_46
action_72 (135) = happyShift action_47
action_72 (137) = happyShift action_48
action_72 (147) = happyShift action_158
action_72 (150) = happyShift action_49
action_72 (151) = happyShift action_50
action_72 (152) = happyShift action_51
action_72 (154) = happyShift action_52
action_72 (155) = happyShift action_53
action_72 (9) = happyGoto action_8
action_72 (44) = happyGoto action_11
action_72 (46) = happyGoto action_12
action_72 (47) = happyGoto action_13
action_72 (48) = happyGoto action_14
action_72 (51) = happyGoto action_15
action_72 (52) = happyGoto action_16
action_72 (53) = happyGoto action_17
action_72 (54) = happyGoto action_18
action_72 (55) = happyGoto action_19
action_72 (56) = happyGoto action_20
action_72 (57) = happyGoto action_21
action_72 (58) = happyGoto action_155
action_72 (73) = happyGoto action_156
action_72 (74) = happyGoto action_157
action_72 (96) = happyGoto action_29
action_72 (98) = happyGoto action_30
action_72 (99) = happyGoto action_56
action_72 _ = happyFail

action_73 (106) = happyShift action_35
action_73 (111) = happyShift action_37
action_73 (112) = happyShift action_38
action_73 (113) = happyShift action_39
action_73 (115) = happyShift action_40
action_73 (116) = happyShift action_41
action_73 (119) = happyShift action_43
action_73 (131) = happyShift action_45
action_73 (133) = happyShift action_46
action_73 (135) = happyShift action_47
action_73 (137) = happyShift action_48
action_73 (150) = happyShift action_49
action_73 (151) = happyShift action_50
action_73 (152) = happyShift action_51
action_73 (154) = happyShift action_52
action_73 (155) = happyShift action_53
action_73 (9) = happyGoto action_8
action_73 (44) = happyGoto action_11
action_73 (46) = happyGoto action_12
action_73 (47) = happyGoto action_13
action_73 (48) = happyGoto action_14
action_73 (51) = happyGoto action_15
action_73 (52) = happyGoto action_16
action_73 (53) = happyGoto action_17
action_73 (54) = happyGoto action_18
action_73 (55) = happyGoto action_19
action_73 (56) = happyGoto action_20
action_73 (57) = happyGoto action_21
action_73 (58) = happyGoto action_154
action_73 (96) = happyGoto action_29
action_73 (98) = happyGoto action_30
action_73 (99) = happyGoto action_56
action_73 _ = happyFail

action_74 (106) = happyShift action_35
action_74 (111) = happyShift action_37
action_74 (112) = happyShift action_38
action_74 (113) = happyShift action_39
action_74 (115) = happyShift action_40
action_74 (116) = happyShift action_41
action_74 (119) = happyShift action_43
action_74 (131) = happyShift action_45
action_74 (133) = happyShift action_46
action_74 (135) = happyShift action_47
action_74 (137) = happyShift action_48
action_74 (150) = happyShift action_49
action_74 (151) = happyShift action_50
action_74 (152) = happyShift action_51
action_74 (154) = happyShift action_52
action_74 (155) = happyShift action_53
action_74 (9) = happyGoto action_8
action_74 (44) = happyGoto action_11
action_74 (46) = happyGoto action_12
action_74 (47) = happyGoto action_13
action_74 (48) = happyGoto action_14
action_74 (51) = happyGoto action_15
action_74 (52) = happyGoto action_16
action_74 (53) = happyGoto action_17
action_74 (54) = happyGoto action_18
action_74 (55) = happyGoto action_19
action_74 (56) = happyGoto action_20
action_74 (57) = happyGoto action_21
action_74 (58) = happyGoto action_153
action_74 (96) = happyGoto action_29
action_74 (98) = happyGoto action_30
action_74 (99) = happyGoto action_56
action_74 _ = happyFail

action_75 _ = happyReduce_77

action_76 _ = happyReduce_78

action_77 _ = happyReduce_79

action_78 (148) = happyShift action_152
action_78 _ = happyReduce_84

action_79 _ = happyReduce_85

action_80 (144) = happyShift action_151
action_80 _ = happyFail

action_81 (137) = happyShift action_150
action_81 (143) = happyShift action_102
action_81 _ = happyFail

action_82 (137) = happyReduce_218
action_82 (143) = happyReduce_218
action_82 _ = happyReduce_69

action_83 (137) = happyReduce_217
action_83 (143) = happyReduce_217
action_83 _ = happyReduce_80

action_84 _ = happyReduce_61

action_85 _ = happyReduce_62

action_86 (111) = happyShift action_84
action_86 (112) = happyShift action_85
action_86 (131) = happyShift action_86
action_86 (133) = happyShift action_87
action_86 (137) = happyShift action_88
action_86 (147) = happyShift action_89
action_86 (150) = happyShift action_90
action_86 (151) = happyShift action_50
action_86 (152) = happyShift action_51
action_86 (154) = happyShift action_91
action_86 (155) = happyShift action_92
action_86 (34) = happyGoto action_75
action_86 (36) = happyGoto action_76
action_86 (37) = happyGoto action_77
action_86 (40) = happyGoto action_78
action_86 (41) = happyGoto action_79
action_86 (42) = happyGoto action_149
action_86 (96) = happyGoto action_81
action_86 (98) = happyGoto action_82
action_86 (99) = happyGoto action_83
action_86 _ = happyFail

action_87 (111) = happyShift action_84
action_87 (112) = happyShift action_85
action_87 (131) = happyShift action_86
action_87 (133) = happyShift action_87
action_87 (137) = happyShift action_88
action_87 (147) = happyShift action_89
action_87 (150) = happyShift action_90
action_87 (151) = happyShift action_50
action_87 (152) = happyShift action_51
action_87 (154) = happyShift action_91
action_87 (155) = happyShift action_92
action_87 (34) = happyGoto action_75
action_87 (36) = happyGoto action_76
action_87 (37) = happyGoto action_77
action_87 (38) = happyGoto action_147
action_87 (40) = happyGoto action_78
action_87 (41) = happyGoto action_79
action_87 (42) = happyGoto action_148
action_87 (96) = happyGoto action_81
action_87 (98) = happyGoto action_82
action_87 (99) = happyGoto action_83
action_87 _ = happyReduce_72

action_88 (111) = happyShift action_84
action_88 (112) = happyShift action_85
action_88 (131) = happyShift action_86
action_88 (133) = happyShift action_87
action_88 (137) = happyShift action_88
action_88 (147) = happyShift action_89
action_88 (150) = happyShift action_90
action_88 (151) = happyShift action_50
action_88 (152) = happyShift action_51
action_88 (154) = happyShift action_91
action_88 (155) = happyShift action_92
action_88 (34) = happyGoto action_75
action_88 (36) = happyGoto action_76
action_88 (37) = happyGoto action_77
action_88 (40) = happyGoto action_78
action_88 (41) = happyGoto action_79
action_88 (42) = happyGoto action_146
action_88 (96) = happyGoto action_81
action_88 (98) = happyGoto action_82
action_88 (99) = happyGoto action_83
action_88 _ = happyFail

action_89 _ = happyReduce_81

action_90 _ = happyReduce_60

action_91 _ = happyReduce_63

action_92 _ = happyReduce_64

action_93 (111) = happyShift action_84
action_93 (112) = happyShift action_85
action_93 (131) = happyShift action_86
action_93 (133) = happyShift action_87
action_93 (137) = happyShift action_88
action_93 (138) = happyShift action_145
action_93 (147) = happyShift action_89
action_93 (150) = happyShift action_90
action_93 (151) = happyShift action_50
action_93 (152) = happyShift action_51
action_93 (154) = happyShift action_91
action_93 (155) = happyShift action_92
action_93 (34) = happyGoto action_75
action_93 (36) = happyGoto action_76
action_93 (37) = happyGoto action_77
action_93 (40) = happyGoto action_78
action_93 (41) = happyGoto action_79
action_93 (42) = happyGoto action_143
action_93 (83) = happyGoto action_144
action_93 (96) = happyGoto action_81
action_93 (98) = happyGoto action_82
action_93 (99) = happyGoto action_83
action_93 _ = happyReduce_188

action_94 (139) = happyShift action_97
action_94 (66) = happyGoto action_142
action_94 _ = happyReduce_151

action_95 (109) = happyShift action_128
action_95 (120) = happyShift action_129
action_95 (131) = happyShift action_130
action_95 (137) = happyShift action_131
action_95 (141) = happyShift action_141
action_95 (151) = happyShift action_132
action_95 (152) = happyShift action_51
action_95 (79) = happyGoto action_138
action_95 (80) = happyGoto action_139
action_95 (86) = happyGoto action_122
action_95 (89) = happyGoto action_123
action_95 (90) = happyGoto action_124
action_95 (91) = happyGoto action_140
action_95 (96) = happyGoto action_126
action_95 (97) = happyGoto action_127
action_95 (98) = happyGoto action_30
action_95 (99) = happyGoto action_56
action_95 _ = happyFail

action_96 (139) = happyShift action_97
action_96 (66) = happyGoto action_137
action_96 _ = happyReduce_151

action_97 (151) = happyShift action_50
action_97 (152) = happyShift action_51
action_97 (45) = happyGoto action_136
action_97 (99) = happyGoto action_134
action_97 _ = happyReduce_92

action_98 (143) = happyShift action_102
action_98 (144) = happyShift action_135
action_98 _ = happyReduce_133

action_99 (151) = happyShift action_50
action_99 (152) = happyShift action_51
action_99 (45) = happyGoto action_133
action_99 (99) = happyGoto action_134
action_99 _ = happyReduce_92

action_100 (109) = happyShift action_128
action_100 (120) = happyShift action_129
action_100 (131) = happyShift action_130
action_100 (137) = happyShift action_131
action_100 (151) = happyShift action_132
action_100 (152) = happyShift action_51
action_100 (86) = happyGoto action_122
action_100 (89) = happyGoto action_123
action_100 (90) = happyGoto action_124
action_100 (91) = happyGoto action_125
action_100 (96) = happyGoto action_126
action_100 (97) = happyGoto action_127
action_100 (98) = happyGoto action_30
action_100 (99) = happyGoto action_56
action_100 _ = happyFail

action_101 (151) = happyShift action_50
action_101 (152) = happyShift action_51
action_101 (94) = happyGoto action_119
action_101 (95) = happyGoto action_120
action_101 (99) = happyGoto action_121
action_101 _ = happyReduce_216

action_102 (151) = happyShift action_50
action_102 (152) = happyShift action_51
action_102 (99) = happyGoto action_118
action_102 _ = happyFail

action_103 (106) = happyShift action_35
action_103 (111) = happyShift action_37
action_103 (112) = happyShift action_38
action_103 (119) = happyShift action_43
action_103 (131) = happyShift action_45
action_103 (133) = happyShift action_46
action_103 (137) = happyShift action_48
action_103 (150) = happyShift action_49
action_103 (151) = happyShift action_50
action_103 (152) = happyShift action_51
action_103 (154) = happyShift action_52
action_103 (155) = happyShift action_53
action_103 (44) = happyGoto action_11
action_103 (46) = happyGoto action_12
action_103 (47) = happyGoto action_13
action_103 (48) = happyGoto action_14
action_103 (51) = happyGoto action_15
action_103 (52) = happyGoto action_16
action_103 (53) = happyGoto action_17
action_103 (54) = happyGoto action_18
action_103 (55) = happyGoto action_117
action_103 (96) = happyGoto action_29
action_103 (98) = happyGoto action_30
action_103 (99) = happyGoto action_56
action_103 _ = happyFail

action_104 (106) = happyShift action_35
action_104 (111) = happyShift action_37
action_104 (112) = happyShift action_38
action_104 (113) = happyShift action_39
action_104 (115) = happyShift action_40
action_104 (116) = happyShift action_41
action_104 (119) = happyShift action_43
action_104 (131) = happyShift action_45
action_104 (133) = happyShift action_46
action_104 (135) = happyShift action_47
action_104 (137) = happyShift action_48
action_104 (150) = happyShift action_49
action_104 (151) = happyShift action_50
action_104 (152) = happyShift action_51
action_104 (154) = happyShift action_52
action_104 (155) = happyShift action_53
action_104 (9) = happyGoto action_8
action_104 (44) = happyGoto action_11
action_104 (46) = happyGoto action_12
action_104 (47) = happyGoto action_13
action_104 (48) = happyGoto action_14
action_104 (51) = happyGoto action_15
action_104 (52) = happyGoto action_16
action_104 (53) = happyGoto action_17
action_104 (54) = happyGoto action_18
action_104 (55) = happyGoto action_19
action_104 (56) = happyGoto action_20
action_104 (57) = happyGoto action_21
action_104 (58) = happyGoto action_115
action_104 (75) = happyGoto action_116
action_104 (96) = happyGoto action_29
action_104 (98) = happyGoto action_30
action_104 (99) = happyGoto action_56
action_104 _ = happyReduce_169

action_105 (106) = happyShift action_35
action_105 (111) = happyShift action_37
action_105 (112) = happyShift action_38
action_105 (119) = happyShift action_43
action_105 (131) = happyShift action_45
action_105 (133) = happyShift action_46
action_105 (137) = happyShift action_48
action_105 (150) = happyShift action_49
action_105 (151) = happyShift action_50
action_105 (152) = happyShift action_51
action_105 (154) = happyShift action_52
action_105 (155) = happyShift action_53
action_105 (44) = happyGoto action_11
action_105 (46) = happyGoto action_12
action_105 (47) = happyGoto action_13
action_105 (48) = happyGoto action_14
action_105 (51) = happyGoto action_15
action_105 (52) = happyGoto action_16
action_105 (53) = happyGoto action_17
action_105 (54) = happyGoto action_18
action_105 (55) = happyGoto action_114
action_105 (96) = happyGoto action_29
action_105 (98) = happyGoto action_30
action_105 (99) = happyGoto action_56
action_105 _ = happyFail

action_106 (151) = happyShift action_50
action_106 (152) = happyShift action_51
action_106 (99) = happyGoto action_113
action_106 _ = happyFail

action_107 _ = happyReduce_114

action_108 (106) = happyShift action_35
action_108 (111) = happyShift action_37
action_108 (112) = happyShift action_38
action_108 (113) = happyShift action_39
action_108 (115) = happyShift action_40
action_108 (116) = happyShift action_41
action_108 (119) = happyShift action_43
action_108 (131) = happyShift action_45
action_108 (133) = happyShift action_46
action_108 (135) = happyShift action_47
action_108 (137) = happyShift action_48
action_108 (150) = happyShift action_49
action_108 (151) = happyShift action_50
action_108 (152) = happyShift action_51
action_108 (154) = happyShift action_52
action_108 (155) = happyShift action_53
action_108 (9) = happyGoto action_8
action_108 (44) = happyGoto action_11
action_108 (46) = happyGoto action_12
action_108 (47) = happyGoto action_13
action_108 (48) = happyGoto action_14
action_108 (51) = happyGoto action_15
action_108 (52) = happyGoto action_16
action_108 (53) = happyGoto action_17
action_108 (54) = happyGoto action_18
action_108 (55) = happyGoto action_19
action_108 (56) = happyGoto action_20
action_108 (57) = happyGoto action_21
action_108 (58) = happyGoto action_112
action_108 (96) = happyGoto action_29
action_108 (98) = happyGoto action_30
action_108 (99) = happyGoto action_56
action_108 _ = happyFail

action_109 (135) = happyShift action_111
action_109 (143) = happyShift action_102
action_109 _ = happyFail

action_110 _ = happyReduce_15

action_111 (103) = happyShift action_235
action_111 (104) = happyShift action_33
action_111 (105) = happyShift action_34
action_111 (107) = happyShift action_236
action_111 (110) = happyShift action_237
action_111 (118) = happyShift action_42
action_111 (121) = happyShift action_238
action_111 (124) = happyShift action_239
action_111 (151) = happyShift action_50
action_111 (152) = happyShift action_51
action_111 (13) = happyGoto action_222
action_111 (15) = happyGoto action_223
action_111 (17) = happyGoto action_224
action_111 (26) = happyGoto action_225
action_111 (31) = happyGoto action_226
action_111 (32) = happyGoto action_227
action_111 (61) = happyGoto action_228
action_111 (63) = happyGoto action_229
action_111 (64) = happyGoto action_230
action_111 (67) = happyGoto action_231
action_111 (70) = happyGoto action_232
action_111 (77) = happyGoto action_27
action_111 (78) = happyGoto action_233
action_111 (99) = happyGoto action_234
action_111 _ = happyReduce_18

action_112 _ = happyReduce_149

action_113 _ = happyReduce_117

action_114 _ = happyReduce_121

action_115 _ = happyReduce_167

action_116 (138) = happyShift action_220
action_116 (146) = happyShift action_221
action_116 _ = happyFail

action_117 _ = happyReduce_123

action_118 _ = happyReduce_221

action_119 _ = happyReduce_214

action_120 (136) = happyShift action_219
action_120 (151) = happyShift action_50
action_120 (152) = happyShift action_51
action_120 (94) = happyGoto action_218
action_120 (99) = happyGoto action_121
action_120 _ = happyFail

action_121 (144) = happyShift action_217
action_121 _ = happyFail

action_122 _ = happyReduce_201

action_123 (128) = happyShift action_215
action_123 (133) = happyShift action_216
action_123 _ = happyReduce_205

action_124 _ = happyReduce_208

action_125 (122) = happyShift action_214
action_125 (28) = happyGoto action_212
action_125 (29) = happyGoto action_213
action_125 _ = happyReduce_54

action_126 (143) = happyShift action_211
action_126 _ = happyFail

action_127 (139) = happyShift action_210
action_127 (88) = happyGoto action_209
action_127 _ = happyReduce_198

action_128 (135) = happyShift action_208
action_128 _ = happyFail

action_129 (137) = happyShift action_207
action_129 _ = happyFail

action_130 (109) = happyShift action_128
action_130 (120) = happyShift action_129
action_130 (131) = happyShift action_130
action_130 (137) = happyShift action_131
action_130 (151) = happyShift action_132
action_130 (152) = happyShift action_51
action_130 (86) = happyGoto action_122
action_130 (89) = happyGoto action_123
action_130 (90) = happyGoto action_124
action_130 (91) = happyGoto action_206
action_130 (96) = happyGoto action_126
action_130 (97) = happyGoto action_127
action_130 (98) = happyGoto action_30
action_130 (99) = happyGoto action_56
action_130 _ = happyFail

action_131 (109) = happyShift action_128
action_131 (120) = happyShift action_129
action_131 (128) = happyShift action_205
action_131 (131) = happyShift action_130
action_131 (137) = happyShift action_131
action_131 (151) = happyShift action_132
action_131 (152) = happyShift action_51
action_131 (86) = happyGoto action_122
action_131 (89) = happyGoto action_123
action_131 (90) = happyGoto action_124
action_131 (91) = happyGoto action_204
action_131 (96) = happyGoto action_126
action_131 (97) = happyGoto action_127
action_131 (98) = happyGoto action_30
action_131 (99) = happyGoto action_56
action_131 _ = happyFail

action_132 (143) = happyReduce_222
action_132 _ = happyReduce_219

action_133 (140) = happyShift action_203
action_133 (146) = happyShift action_201
action_133 _ = happyFail

action_134 _ = happyReduce_90

action_135 (151) = happyShift action_202
action_135 _ = happyFail

action_136 (140) = happyShift action_200
action_136 (146) = happyShift action_201
action_136 _ = happyFail

action_137 (144) = happyShift action_199
action_137 _ = happyFail

action_138 (141) = happyShift action_141
action_138 (80) = happyGoto action_198
action_138 _ = happyReduce_174

action_139 _ = happyReduce_178

action_140 _ = happyReduce_173

action_141 (151) = happyShift action_50
action_141 (152) = happyShift action_51
action_141 (99) = happyGoto action_197
action_141 _ = happyFail

action_142 (135) = happyShift action_196
action_142 _ = happyFail

action_143 (138) = happyShift action_195
action_143 _ = happyReduce_186

action_144 (146) = happyShift action_194
action_144 _ = happyFail

action_145 _ = happyReduce_97

action_146 (138) = happyShift action_193
action_146 _ = happyFail

action_147 (134) = happyShift action_191
action_147 (146) = happyShift action_192
action_147 _ = happyFail

action_148 _ = happyReduce_70

action_149 (146) = happyShift action_190
action_149 (35) = happyGoto action_189
action_149 _ = happyFail

action_150 (111) = happyShift action_84
action_150 (112) = happyShift action_85
action_150 (131) = happyShift action_86
action_150 (133) = happyShift action_87
action_150 (137) = happyShift action_88
action_150 (147) = happyShift action_89
action_150 (150) = happyShift action_90
action_150 (151) = happyShift action_50
action_150 (152) = happyShift action_51
action_150 (154) = happyShift action_91
action_150 (155) = happyShift action_92
action_150 (34) = happyGoto action_75
action_150 (36) = happyGoto action_76
action_150 (37) = happyGoto action_77
action_150 (38) = happyGoto action_188
action_150 (40) = happyGoto action_78
action_150 (41) = happyGoto action_79
action_150 (42) = happyGoto action_148
action_150 (96) = happyGoto action_81
action_150 (98) = happyGoto action_82
action_150 (99) = happyGoto action_83
action_150 _ = happyReduce_72

action_151 (106) = happyShift action_35
action_151 (111) = happyShift action_37
action_151 (112) = happyShift action_38
action_151 (113) = happyShift action_39
action_151 (115) = happyShift action_40
action_151 (116) = happyShift action_41
action_151 (119) = happyShift action_43
action_151 (131) = happyShift action_45
action_151 (133) = happyShift action_46
action_151 (135) = happyShift action_47
action_151 (137) = happyShift action_48
action_151 (150) = happyShift action_49
action_151 (151) = happyShift action_50
action_151 (152) = happyShift action_51
action_151 (154) = happyShift action_52
action_151 (155) = happyShift action_53
action_151 (9) = happyGoto action_8
action_151 (44) = happyGoto action_11
action_151 (46) = happyGoto action_12
action_151 (47) = happyGoto action_13
action_151 (48) = happyGoto action_14
action_151 (51) = happyGoto action_15
action_151 (52) = happyGoto action_16
action_151 (53) = happyGoto action_17
action_151 (54) = happyGoto action_18
action_151 (55) = happyGoto action_19
action_151 (56) = happyGoto action_20
action_151 (57) = happyGoto action_21
action_151 (58) = happyGoto action_187
action_151 (96) = happyGoto action_29
action_151 (98) = happyGoto action_30
action_151 (99) = happyGoto action_56
action_151 _ = happyFail

action_152 (111) = happyShift action_84
action_152 (112) = happyShift action_85
action_152 (131) = happyShift action_86
action_152 (133) = happyShift action_87
action_152 (137) = happyShift action_88
action_152 (147) = happyShift action_89
action_152 (150) = happyShift action_90
action_152 (151) = happyShift action_50
action_152 (152) = happyShift action_51
action_152 (154) = happyShift action_91
action_152 (155) = happyShift action_92
action_152 (34) = happyGoto action_75
action_152 (36) = happyGoto action_76
action_152 (37) = happyGoto action_77
action_152 (40) = happyGoto action_78
action_152 (41) = happyGoto action_186
action_152 (96) = happyGoto action_81
action_152 (98) = happyGoto action_82
action_152 (99) = happyGoto action_83
action_152 _ = happyFail

action_153 (138) = happyShift action_185
action_153 _ = happyFail

action_154 (138) = happyShift action_184
action_154 _ = happyFail

action_155 (128) = happyShift action_183
action_155 _ = happyFail

action_156 (106) = happyShift action_35
action_156 (111) = happyShift action_37
action_156 (112) = happyShift action_38
action_156 (113) = happyShift action_39
action_156 (115) = happyShift action_40
action_156 (116) = happyShift action_41
action_156 (119) = happyShift action_43
action_156 (131) = happyShift action_45
action_156 (133) = happyShift action_46
action_156 (135) = happyShift action_47
action_156 (136) = happyShift action_182
action_156 (137) = happyShift action_48
action_156 (147) = happyShift action_158
action_156 (150) = happyShift action_49
action_156 (151) = happyShift action_50
action_156 (152) = happyShift action_51
action_156 (154) = happyShift action_52
action_156 (155) = happyShift action_53
action_156 (9) = happyGoto action_8
action_156 (44) = happyGoto action_11
action_156 (46) = happyGoto action_12
action_156 (47) = happyGoto action_13
action_156 (48) = happyGoto action_14
action_156 (51) = happyGoto action_15
action_156 (52) = happyGoto action_16
action_156 (53) = happyGoto action_17
action_156 (54) = happyGoto action_18
action_156 (55) = happyGoto action_19
action_156 (56) = happyGoto action_20
action_156 (57) = happyGoto action_21
action_156 (58) = happyGoto action_155
action_156 (74) = happyGoto action_181
action_156 (96) = happyGoto action_29
action_156 (98) = happyGoto action_30
action_156 (99) = happyGoto action_56
action_156 _ = happyFail

action_157 _ = happyReduce_163

action_158 (128) = happyShift action_180
action_158 _ = happyFail

action_159 _ = happyReduce_146

action_160 (138) = happyShift action_179
action_160 _ = happyFail

action_161 (138) = happyShift action_178
action_161 _ = happyFail

action_162 (138) = happyShift action_176
action_162 (146) = happyShift action_177
action_162 _ = happyFail

action_163 (106) = happyShift action_35
action_163 (111) = happyShift action_37
action_163 (112) = happyShift action_38
action_163 (113) = happyShift action_39
action_163 (115) = happyShift action_40
action_163 (116) = happyShift action_41
action_163 (119) = happyShift action_43
action_163 (131) = happyShift action_45
action_163 (133) = happyShift action_46
action_163 (135) = happyShift action_47
action_163 (137) = happyShift action_48
action_163 (150) = happyShift action_49
action_163 (151) = happyShift action_50
action_163 (152) = happyShift action_51
action_163 (154) = happyShift action_52
action_163 (155) = happyShift action_53
action_163 (9) = happyGoto action_8
action_163 (44) = happyGoto action_11
action_163 (46) = happyGoto action_12
action_163 (47) = happyGoto action_13
action_163 (48) = happyGoto action_14
action_163 (51) = happyGoto action_15
action_163 (52) = happyGoto action_16
action_163 (53) = happyGoto action_17
action_163 (54) = happyGoto action_18
action_163 (55) = happyGoto action_19
action_163 (56) = happyGoto action_20
action_163 (57) = happyGoto action_21
action_163 (58) = happyGoto action_175
action_163 (96) = happyGoto action_29
action_163 (98) = happyGoto action_30
action_163 (99) = happyGoto action_56
action_163 _ = happyFail

action_164 _ = happyReduce_89

action_165 (106) = happyShift action_35
action_165 (111) = happyShift action_37
action_165 (112) = happyShift action_38
action_165 (113) = happyShift action_39
action_165 (115) = happyShift action_40
action_165 (116) = happyShift action_41
action_165 (119) = happyShift action_43
action_165 (131) = happyShift action_45
action_165 (133) = happyShift action_46
action_165 (135) = happyShift action_47
action_165 (137) = happyShift action_48
action_165 (150) = happyShift action_49
action_165 (151) = happyShift action_50
action_165 (152) = happyShift action_51
action_165 (154) = happyShift action_52
action_165 (155) = happyShift action_53
action_165 (9) = happyGoto action_8
action_165 (44) = happyGoto action_11
action_165 (46) = happyGoto action_12
action_165 (47) = happyGoto action_13
action_165 (48) = happyGoto action_14
action_165 (51) = happyGoto action_15
action_165 (52) = happyGoto action_16
action_165 (53) = happyGoto action_17
action_165 (54) = happyGoto action_18
action_165 (55) = happyGoto action_19
action_165 (56) = happyGoto action_20
action_165 (57) = happyGoto action_21
action_165 (58) = happyGoto action_174
action_165 (96) = happyGoto action_29
action_165 (98) = happyGoto action_30
action_165 (99) = happyGoto action_56
action_165 _ = happyFail

action_166 _ = happyReduce_137

action_167 _ = happyReduce_9

action_168 _ = happyReduce_226

action_169 _ = happyReduce_228

action_170 _ = happyReduce_232

action_171 _ = happyReduce_231

action_172 _ = happyReduce_110

action_173 _ = happyReduce_108

action_174 _ = happyReduce_87

action_175 _ = happyReduce_58

action_176 _ = happyReduce_111

action_177 (106) = happyShift action_35
action_177 (111) = happyShift action_37
action_177 (112) = happyShift action_38
action_177 (113) = happyShift action_39
action_177 (115) = happyShift action_40
action_177 (116) = happyShift action_41
action_177 (119) = happyShift action_43
action_177 (131) = happyShift action_45
action_177 (133) = happyShift action_46
action_177 (135) = happyShift action_47
action_177 (137) = happyShift action_48
action_177 (150) = happyShift action_49
action_177 (151) = happyShift action_50
action_177 (152) = happyShift action_51
action_177 (154) = happyShift action_52
action_177 (155) = happyShift action_53
action_177 (9) = happyGoto action_8
action_177 (44) = happyGoto action_11
action_177 (46) = happyGoto action_12
action_177 (47) = happyGoto action_13
action_177 (48) = happyGoto action_14
action_177 (51) = happyGoto action_15
action_177 (52) = happyGoto action_16
action_177 (53) = happyGoto action_17
action_177 (54) = happyGoto action_18
action_177 (55) = happyGoto action_19
action_177 (56) = happyGoto action_20
action_177 (57) = happyGoto action_21
action_177 (58) = happyGoto action_288
action_177 (96) = happyGoto action_29
action_177 (98) = happyGoto action_30
action_177 (99) = happyGoto action_56
action_177 _ = happyFail

action_178 (139) = happyShift action_97
action_178 (66) = happyGoto action_287
action_178 _ = happyReduce_151

action_179 _ = happyReduce_115

action_180 (106) = happyShift action_35
action_180 (111) = happyShift action_37
action_180 (112) = happyShift action_38
action_180 (113) = happyShift action_39
action_180 (115) = happyShift action_40
action_180 (116) = happyShift action_41
action_180 (119) = happyShift action_43
action_180 (131) = happyShift action_45
action_180 (133) = happyShift action_46
action_180 (135) = happyShift action_47
action_180 (137) = happyShift action_48
action_180 (150) = happyShift action_49
action_180 (151) = happyShift action_50
action_180 (152) = happyShift action_51
action_180 (154) = happyShift action_52
action_180 (155) = happyShift action_53
action_180 (9) = happyGoto action_8
action_180 (44) = happyGoto action_11
action_180 (46) = happyGoto action_12
action_180 (47) = happyGoto action_13
action_180 (48) = happyGoto action_14
action_180 (51) = happyGoto action_15
action_180 (52) = happyGoto action_16
action_180 (53) = happyGoto action_17
action_180 (54) = happyGoto action_18
action_180 (55) = happyGoto action_19
action_180 (56) = happyGoto action_20
action_180 (57) = happyGoto action_21
action_180 (58) = happyGoto action_286
action_180 (96) = happyGoto action_29
action_180 (98) = happyGoto action_30
action_180 (99) = happyGoto action_56
action_180 _ = happyFail

action_181 _ = happyReduce_164

action_182 _ = happyReduce_129

action_183 (106) = happyShift action_35
action_183 (111) = happyShift action_37
action_183 (112) = happyShift action_38
action_183 (113) = happyShift action_39
action_183 (115) = happyShift action_40
action_183 (116) = happyShift action_41
action_183 (119) = happyShift action_43
action_183 (131) = happyShift action_45
action_183 (133) = happyShift action_46
action_183 (135) = happyShift action_47
action_183 (137) = happyShift action_48
action_183 (150) = happyShift action_49
action_183 (151) = happyShift action_50
action_183 (152) = happyShift action_51
action_183 (154) = happyShift action_52
action_183 (155) = happyShift action_53
action_183 (9) = happyGoto action_8
action_183 (44) = happyGoto action_11
action_183 (46) = happyGoto action_12
action_183 (47) = happyGoto action_13
action_183 (48) = happyGoto action_14
action_183 (51) = happyGoto action_15
action_183 (52) = happyGoto action_16
action_183 (53) = happyGoto action_17
action_183 (54) = happyGoto action_18
action_183 (55) = happyGoto action_19
action_183 (56) = happyGoto action_20
action_183 (57) = happyGoto action_21
action_183 (58) = happyGoto action_285
action_183 (96) = happyGoto action_29
action_183 (98) = happyGoto action_30
action_183 (99) = happyGoto action_56
action_183 _ = happyFail

action_184 (135) = happyShift action_284
action_184 _ = happyFail

action_185 (106) = happyShift action_35
action_185 (111) = happyShift action_37
action_185 (112) = happyShift action_38
action_185 (113) = happyShift action_39
action_185 (115) = happyShift action_40
action_185 (116) = happyShift action_41
action_185 (119) = happyShift action_43
action_185 (131) = happyShift action_45
action_185 (133) = happyShift action_46
action_185 (135) = happyShift action_47
action_185 (137) = happyShift action_48
action_185 (150) = happyShift action_49
action_185 (151) = happyShift action_50
action_185 (152) = happyShift action_51
action_185 (154) = happyShift action_52
action_185 (155) = happyShift action_53
action_185 (9) = happyGoto action_8
action_185 (44) = happyGoto action_11
action_185 (46) = happyGoto action_12
action_185 (47) = happyGoto action_13
action_185 (48) = happyGoto action_14
action_185 (51) = happyGoto action_15
action_185 (52) = happyGoto action_16
action_185 (53) = happyGoto action_17
action_185 (54) = happyGoto action_18
action_185 (55) = happyGoto action_19
action_185 (56) = happyGoto action_20
action_185 (57) = happyGoto action_21
action_185 (58) = happyGoto action_283
action_185 (96) = happyGoto action_29
action_185 (98) = happyGoto action_30
action_185 (99) = happyGoto action_56
action_185 _ = happyFail

action_186 _ = happyReduce_82

action_187 _ = happyReduce_131

action_188 (138) = happyShift action_282
action_188 (146) = happyShift action_192
action_188 _ = happyFail

action_189 (138) = happyShift action_280
action_189 (146) = happyShift action_281
action_189 _ = happyFail

action_190 (111) = happyShift action_84
action_190 (112) = happyShift action_85
action_190 (131) = happyShift action_86
action_190 (133) = happyShift action_87
action_190 (137) = happyShift action_88
action_190 (147) = happyShift action_89
action_190 (150) = happyShift action_90
action_190 (151) = happyShift action_50
action_190 (152) = happyShift action_51
action_190 (154) = happyShift action_91
action_190 (155) = happyShift action_92
action_190 (34) = happyGoto action_75
action_190 (36) = happyGoto action_76
action_190 (37) = happyGoto action_77
action_190 (40) = happyGoto action_78
action_190 (41) = happyGoto action_79
action_190 (42) = happyGoto action_279
action_190 (96) = happyGoto action_81
action_190 (98) = happyGoto action_82
action_190 (99) = happyGoto action_83
action_190 _ = happyFail

action_191 _ = happyReduce_83

action_192 (111) = happyShift action_84
action_192 (112) = happyShift action_85
action_192 (131) = happyShift action_86
action_192 (133) = happyShift action_87
action_192 (137) = happyShift action_88
action_192 (147) = happyShift action_89
action_192 (150) = happyShift action_90
action_192 (151) = happyShift action_50
action_192 (152) = happyShift action_51
action_192 (154) = happyShift action_91
action_192 (155) = happyShift action_92
action_192 (34) = happyGoto action_75
action_192 (36) = happyGoto action_76
action_192 (37) = happyGoto action_77
action_192 (40) = happyGoto action_78
action_192 (41) = happyGoto action_79
action_192 (42) = happyGoto action_278
action_192 (96) = happyGoto action_81
action_192 (98) = happyGoto action_82
action_192 (99) = happyGoto action_83
action_192 _ = happyFail

action_193 _ = happyReduce_76

action_194 (111) = happyShift action_84
action_194 (112) = happyShift action_85
action_194 (131) = happyShift action_86
action_194 (133) = happyShift action_87
action_194 (137) = happyShift action_88
action_194 (147) = happyShift action_89
action_194 (150) = happyShift action_90
action_194 (151) = happyShift action_50
action_194 (152) = happyShift action_51
action_194 (154) = happyShift action_91
action_194 (155) = happyShift action_92
action_194 (34) = happyGoto action_75
action_194 (36) = happyGoto action_76
action_194 (37) = happyGoto action_77
action_194 (40) = happyGoto action_78
action_194 (41) = happyGoto action_79
action_194 (42) = happyGoto action_277
action_194 (96) = happyGoto action_81
action_194 (98) = happyGoto action_82
action_194 (99) = happyGoto action_83
action_194 _ = happyFail

action_195 _ = happyReduce_93

action_196 (124) = happyShift action_44
action_196 (151) = happyShift action_50
action_196 (152) = happyShift action_51
action_196 (67) = happyGoto action_274
action_196 (68) = happyGoto action_275
action_196 (99) = happyGoto action_276
action_196 _ = happyFail

action_197 (137) = happyShift action_273
action_197 _ = happyReduce_181

action_198 _ = happyReduce_179

action_199 (109) = happyShift action_128
action_199 (120) = happyShift action_129
action_199 (131) = happyShift action_130
action_199 (137) = happyShift action_131
action_199 (141) = happyShift action_141
action_199 (151) = happyShift action_132
action_199 (152) = happyShift action_51
action_199 (79) = happyGoto action_271
action_199 (80) = happyGoto action_139
action_199 (86) = happyGoto action_122
action_199 (89) = happyGoto action_123
action_199 (90) = happyGoto action_124
action_199 (91) = happyGoto action_272
action_199 (96) = happyGoto action_126
action_199 (97) = happyGoto action_127
action_199 (98) = happyGoto action_30
action_199 (99) = happyGoto action_56
action_199 _ = happyFail

action_200 _ = happyReduce_150

action_201 (151) = happyShift action_50
action_201 (152) = happyShift action_51
action_201 (99) = happyGoto action_270
action_201 _ = happyFail

action_202 _ = happyReduce_134

action_203 (145) = happyShift action_269
action_203 _ = happyFail

action_204 (138) = happyShift action_268
action_204 _ = happyFail

action_205 (109) = happyShift action_128
action_205 (120) = happyShift action_129
action_205 (131) = happyShift action_130
action_205 (137) = happyShift action_131
action_205 (151) = happyShift action_132
action_205 (152) = happyShift action_51
action_205 (86) = happyGoto action_122
action_205 (89) = happyGoto action_123
action_205 (90) = happyGoto action_124
action_205 (91) = happyGoto action_267
action_205 (96) = happyGoto action_126
action_205 (97) = happyGoto action_127
action_205 (98) = happyGoto action_30
action_205 (99) = happyGoto action_56
action_205 _ = happyFail

action_206 (146) = happyShift action_266
action_206 (85) = happyGoto action_265
action_206 _ = happyFail

action_207 (151) = happyShift action_264
action_207 _ = happyFail

action_208 (151) = happyShift action_50
action_208 (152) = happyShift action_51
action_208 (92) = happyGoto action_261
action_208 (93) = happyGoto action_262
action_208 (99) = happyGoto action_263
action_208 _ = happyReduce_212

action_209 _ = happyReduce_202

action_210 (109) = happyShift action_128
action_210 (120) = happyShift action_129
action_210 (131) = happyShift action_130
action_210 (137) = happyShift action_131
action_210 (151) = happyShift action_132
action_210 (152) = happyShift action_51
action_210 (84) = happyGoto action_259
action_210 (86) = happyGoto action_122
action_210 (89) = happyGoto action_123
action_210 (90) = happyGoto action_124
action_210 (91) = happyGoto action_260
action_210 (96) = happyGoto action_126
action_210 (97) = happyGoto action_127
action_210 (98) = happyGoto action_30
action_210 (99) = happyGoto action_56
action_210 _ = happyReduce_191

action_211 (151) = happyShift action_258
action_211 (152) = happyShift action_51
action_211 (99) = happyGoto action_118
action_211 _ = happyFail

action_212 _ = happyReduce_52

action_213 (122) = happyShift action_214
action_213 (28) = happyGoto action_257
action_213 _ = happyReduce_152

action_214 (151) = happyShift action_50
action_214 (152) = happyShift action_51
action_214 (99) = happyGoto action_256
action_214 _ = happyFail

action_215 (109) = happyShift action_128
action_215 (120) = happyShift action_129
action_215 (131) = happyShift action_130
action_215 (137) = happyShift action_131
action_215 (151) = happyShift action_132
action_215 (152) = happyShift action_51
action_215 (86) = happyGoto action_122
action_215 (89) = happyGoto action_123
action_215 (90) = happyGoto action_255
action_215 (96) = happyGoto action_126
action_215 (97) = happyGoto action_127
action_215 (98) = happyGoto action_30
action_215 (99) = happyGoto action_56
action_215 _ = happyFail

action_216 (134) = happyShift action_254
action_216 _ = happyFail

action_217 (106) = happyShift action_35
action_217 (111) = happyShift action_37
action_217 (112) = happyShift action_38
action_217 (113) = happyShift action_39
action_217 (115) = happyShift action_40
action_217 (116) = happyShift action_41
action_217 (119) = happyShift action_43
action_217 (131) = happyShift action_45
action_217 (133) = happyShift action_46
action_217 (135) = happyShift action_47
action_217 (137) = happyShift action_48
action_217 (150) = happyShift action_49
action_217 (151) = happyShift action_50
action_217 (152) = happyShift action_51
action_217 (154) = happyShift action_52
action_217 (155) = happyShift action_53
action_217 (9) = happyGoto action_8
action_217 (44) = happyGoto action_11
action_217 (46) = happyGoto action_12
action_217 (47) = happyGoto action_13
action_217 (48) = happyGoto action_14
action_217 (51) = happyGoto action_15
action_217 (52) = happyGoto action_16
action_217 (53) = happyGoto action_17
action_217 (54) = happyGoto action_18
action_217 (55) = happyGoto action_19
action_217 (56) = happyGoto action_20
action_217 (57) = happyGoto action_21
action_217 (58) = happyGoto action_253
action_217 (96) = happyGoto action_29
action_217 (98) = happyGoto action_30
action_217 (99) = happyGoto action_56
action_217 _ = happyFail

action_218 _ = happyReduce_215

action_219 _ = happyReduce_113

action_220 _ = happyReduce_119

action_221 (106) = happyShift action_35
action_221 (111) = happyShift action_37
action_221 (112) = happyShift action_38
action_221 (113) = happyShift action_39
action_221 (115) = happyShift action_40
action_221 (116) = happyShift action_41
action_221 (119) = happyShift action_43
action_221 (131) = happyShift action_45
action_221 (133) = happyShift action_46
action_221 (135) = happyShift action_47
action_221 (137) = happyShift action_48
action_221 (150) = happyShift action_49
action_221 (151) = happyShift action_50
action_221 (152) = happyShift action_51
action_221 (154) = happyShift action_52
action_221 (155) = happyShift action_53
action_221 (9) = happyGoto action_8
action_221 (44) = happyGoto action_11
action_221 (46) = happyGoto action_12
action_221 (47) = happyGoto action_13
action_221 (48) = happyGoto action_14
action_221 (51) = happyGoto action_15
action_221 (52) = happyGoto action_16
action_221 (53) = happyGoto action_17
action_221 (54) = happyGoto action_18
action_221 (55) = happyGoto action_19
action_221 (56) = happyGoto action_20
action_221 (57) = happyGoto action_21
action_221 (58) = happyGoto action_252
action_221 (96) = happyGoto action_29
action_221 (98) = happyGoto action_30
action_221 (99) = happyGoto action_56
action_221 _ = happyFail

action_222 (103) = happyShift action_235
action_222 (104) = happyShift action_33
action_222 (105) = happyShift action_34
action_222 (107) = happyShift action_236
action_222 (110) = happyShift action_237
action_222 (118) = happyShift action_42
action_222 (121) = happyShift action_238
action_222 (124) = happyShift action_239
action_222 (136) = happyShift action_251
action_222 (151) = happyShift action_50
action_222 (152) = happyShift action_51
action_222 (15) = happyGoto action_250
action_222 (17) = happyGoto action_224
action_222 (26) = happyGoto action_225
action_222 (31) = happyGoto action_226
action_222 (32) = happyGoto action_227
action_222 (61) = happyGoto action_228
action_222 (63) = happyGoto action_229
action_222 (64) = happyGoto action_230
action_222 (67) = happyGoto action_231
action_222 (70) = happyGoto action_232
action_222 (77) = happyGoto action_27
action_222 (78) = happyGoto action_233
action_222 (99) = happyGoto action_234
action_222 _ = happyFail

action_223 _ = happyReduce_16

action_224 (135) = happyShift action_248
action_224 (137) = happyShift action_249
action_224 (25) = happyGoto action_247
action_224 _ = happyReduce_49

action_225 _ = happyReduce_142

action_226 _ = happyReduce_23

action_227 _ = happyReduce_24

action_228 _ = happyReduce_26

action_229 _ = happyReduce_25

action_230 _ = happyReduce_140

action_231 _ = happyReduce_141

action_232 _ = happyReduce_21

action_233 _ = happyReduce_22

action_234 (137) = happyShift action_246
action_234 (139) = happyShift action_99
action_234 (145) = happyShift action_100
action_234 _ = happyFail

action_235 (151) = happyShift action_50
action_235 (152) = happyShift action_51
action_235 (96) = happyGoto action_245
action_235 (98) = happyGoto action_30
action_235 (99) = happyGoto action_56
action_235 _ = happyFail

action_236 (109) = happyShift action_128
action_236 (120) = happyShift action_129
action_236 (131) = happyShift action_130
action_236 (137) = happyShift action_244
action_236 (151) = happyShift action_132
action_236 (152) = happyShift action_51
action_236 (86) = happyGoto action_122
action_236 (89) = happyGoto action_243
action_236 (96) = happyGoto action_126
action_236 (97) = happyGoto action_127
action_236 (98) = happyGoto action_30
action_236 (99) = happyGoto action_56
action_236 _ = happyFail

action_237 (111) = happyShift action_84
action_237 (112) = happyShift action_85
action_237 (131) = happyShift action_86
action_237 (133) = happyShift action_87
action_237 (137) = happyShift action_88
action_237 (147) = happyShift action_89
action_237 (150) = happyShift action_90
action_237 (151) = happyShift action_50
action_237 (152) = happyShift action_51
action_237 (154) = happyShift action_91
action_237 (155) = happyShift action_92
action_237 (34) = happyGoto action_75
action_237 (36) = happyGoto action_76
action_237 (37) = happyGoto action_77
action_237 (40) = happyGoto action_78
action_237 (41) = happyGoto action_79
action_237 (42) = happyGoto action_242
action_237 (96) = happyGoto action_81
action_237 (98) = happyGoto action_82
action_237 (99) = happyGoto action_83
action_237 _ = happyFail

action_238 (151) = happyShift action_50
action_238 (152) = happyShift action_51
action_238 (99) = happyGoto action_241
action_238 _ = happyFail

action_239 (137) = happyShift action_240
action_239 _ = happyFail

action_240 (139) = happyShift action_59
action_240 (140) = happyShift action_60
action_240 (141) = happyShift action_61
action_240 (144) = happyShift action_62
action_240 (153) = happyShift action_63
action_240 (100) = happyGoto action_327
action_240 _ = happyFail

action_241 (123) = happyShift action_326
action_241 _ = happyFail

action_242 (144) = happyShift action_325
action_242 _ = happyFail

action_243 (133) = happyShift action_216
action_243 (145) = happyShift action_324
action_243 _ = happyFail

action_244 (109) = happyShift action_128
action_244 (120) = happyShift action_129
action_244 (131) = happyShift action_130
action_244 (137) = happyShift action_131
action_244 (151) = happyShift action_132
action_244 (152) = happyShift action_51
action_244 (86) = happyGoto action_122
action_244 (89) = happyGoto action_123
action_244 (90) = happyGoto action_124
action_244 (91) = happyGoto action_204
action_244 (96) = happyGoto action_126
action_244 (97) = happyGoto action_127
action_244 (98) = happyGoto action_30
action_244 (99) = happyGoto action_56
action_244 _ = happyFail

action_245 (143) = happyShift action_102
action_245 (144) = happyShift action_323
action_245 _ = happyReduce_32

action_246 (111) = happyShift action_84
action_246 (112) = happyShift action_85
action_246 (131) = happyShift action_86
action_246 (133) = happyShift action_87
action_246 (137) = happyShift action_88
action_246 (147) = happyShift action_89
action_246 (150) = happyShift action_90
action_246 (151) = happyShift action_50
action_246 (152) = happyShift action_51
action_246 (154) = happyShift action_91
action_246 (155) = happyShift action_92
action_246 (34) = happyGoto action_75
action_246 (36) = happyGoto action_76
action_246 (37) = happyGoto action_77
action_246 (40) = happyGoto action_78
action_246 (41) = happyGoto action_79
action_246 (42) = happyGoto action_321
action_246 (83) = happyGoto action_322
action_246 (96) = happyGoto action_81
action_246 (98) = happyGoto action_82
action_246 (99) = happyGoto action_83
action_246 _ = happyReduce_188

action_247 (135) = happyShift action_320
action_247 _ = happyReduce_48

action_248 (125) = happyShift action_318
action_248 (126) = happyShift action_319
action_248 (19) = happyGoto action_314
action_248 (22) = happyGoto action_315
action_248 (23) = happyGoto action_316
action_248 (24) = happyGoto action_317
action_248 _ = happyFail

action_249 (151) = happyShift action_50
action_249 (152) = happyShift action_51
action_249 (18) = happyGoto action_312
action_249 (99) = happyGoto action_313
action_249 _ = happyFail

action_250 _ = happyReduce_17

action_251 _ = happyReduce_50

action_252 _ = happyReduce_168

action_253 (142) = happyShift action_311
action_253 _ = happyFail

action_254 _ = happyReduce_203

action_255 _ = happyReduce_206

action_256 (145) = happyShift action_310
action_256 _ = happyFail

action_257 _ = happyReduce_53

action_258 (143) = happyReduce_222
action_258 _ = happyReduce_220

action_259 (140) = happyShift action_308
action_259 (146) = happyShift action_309
action_259 _ = happyFail

action_260 _ = happyReduce_189

action_261 _ = happyReduce_210

action_262 (136) = happyShift action_307
action_262 (151) = happyShift action_50
action_262 (152) = happyShift action_51
action_262 (92) = happyGoto action_306
action_262 (99) = happyGoto action_263
action_262 _ = happyFail

action_263 (145) = happyShift action_305
action_263 _ = happyFail

action_264 (138) = happyShift action_304
action_264 _ = happyFail

action_265 (138) = happyShift action_302
action_265 (146) = happyShift action_303
action_265 _ = happyFail

action_266 (109) = happyShift action_128
action_266 (120) = happyShift action_129
action_266 (131) = happyShift action_130
action_266 (137) = happyShift action_131
action_266 (151) = happyShift action_132
action_266 (152) = happyShift action_51
action_266 (86) = happyGoto action_122
action_266 (89) = happyGoto action_123
action_266 (90) = happyGoto action_124
action_266 (91) = happyGoto action_301
action_266 (96) = happyGoto action_126
action_266 (97) = happyGoto action_127
action_266 (98) = happyGoto action_30
action_266 (99) = happyGoto action_56
action_266 _ = happyFail

action_267 (138) = happyShift action_300
action_267 _ = happyFail

action_268 _ = happyReduce_204

action_269 (109) = happyShift action_128
action_269 (120) = happyShift action_129
action_269 (131) = happyShift action_130
action_269 (137) = happyShift action_131
action_269 (151) = happyShift action_132
action_269 (152) = happyShift action_51
action_269 (86) = happyGoto action_122
action_269 (89) = happyGoto action_123
action_269 (90) = happyGoto action_124
action_269 (91) = happyGoto action_299
action_269 (96) = happyGoto action_126
action_269 (97) = happyGoto action_127
action_269 (98) = happyGoto action_30
action_269 (99) = happyGoto action_56
action_269 _ = happyFail

action_270 _ = happyReduce_91

action_271 (141) = happyShift action_141
action_271 (80) = happyGoto action_198
action_271 _ = happyReduce_176

action_272 _ = happyReduce_175

action_273 (109) = happyShift action_128
action_273 (120) = happyShift action_129
action_273 (131) = happyShift action_130
action_273 (137) = happyShift action_131
action_273 (151) = happyShift action_132
action_273 (152) = happyShift action_51
action_273 (84) = happyGoto action_298
action_273 (86) = happyGoto action_122
action_273 (89) = happyGoto action_123
action_273 (90) = happyGoto action_124
action_273 (91) = happyGoto action_260
action_273 (96) = happyGoto action_126
action_273 (97) = happyGoto action_127
action_273 (98) = happyGoto action_30
action_273 (99) = happyGoto action_56
action_273 _ = happyReduce_191

action_274 _ = happyReduce_155

action_275 (124) = happyShift action_44
action_275 (136) = happyShift action_297
action_275 (151) = happyShift action_50
action_275 (152) = happyShift action_51
action_275 (67) = happyGoto action_296
action_275 (99) = happyGoto action_276
action_275 _ = happyFail

action_276 (139) = happyShift action_99
action_276 (145) = happyShift action_100
action_276 _ = happyFail

action_277 (138) = happyShift action_295
action_277 _ = happyReduce_187

action_278 _ = happyReduce_71

action_279 _ = happyReduce_65

action_280 _ = happyReduce_67

action_281 (111) = happyShift action_84
action_281 (112) = happyShift action_85
action_281 (131) = happyShift action_86
action_281 (133) = happyShift action_87
action_281 (137) = happyShift action_88
action_281 (147) = happyShift action_89
action_281 (150) = happyShift action_90
action_281 (151) = happyShift action_50
action_281 (152) = happyShift action_51
action_281 (154) = happyShift action_91
action_281 (155) = happyShift action_92
action_281 (34) = happyGoto action_75
action_281 (36) = happyGoto action_76
action_281 (37) = happyGoto action_77
action_281 (40) = happyGoto action_78
action_281 (41) = happyGoto action_79
action_281 (42) = happyGoto action_294
action_281 (96) = happyGoto action_81
action_281 (98) = happyGoto action_82
action_281 (99) = happyGoto action_83
action_281 _ = happyFail

action_282 _ = happyReduce_68

action_283 (106) = happyShift action_35
action_283 (111) = happyShift action_37
action_283 (112) = happyShift action_38
action_283 (113) = happyShift action_39
action_283 (115) = happyShift action_40
action_283 (116) = happyShift action_41
action_283 (119) = happyShift action_43
action_283 (131) = happyShift action_45
action_283 (133) = happyShift action_46
action_283 (135) = happyShift action_47
action_283 (137) = happyShift action_48
action_283 (150) = happyShift action_49
action_283 (151) = happyShift action_50
action_283 (152) = happyShift action_51
action_283 (154) = happyShift action_52
action_283 (155) = happyShift action_53
action_283 (9) = happyGoto action_8
action_283 (44) = happyGoto action_11
action_283 (46) = happyGoto action_12
action_283 (47) = happyGoto action_13
action_283 (48) = happyGoto action_14
action_283 (51) = happyGoto action_15
action_283 (52) = happyGoto action_16
action_283 (53) = happyGoto action_17
action_283 (54) = happyGoto action_18
action_283 (55) = happyGoto action_19
action_283 (56) = happyGoto action_20
action_283 (57) = happyGoto action_21
action_283 (58) = happyGoto action_293
action_283 (96) = happyGoto action_29
action_283 (98) = happyGoto action_30
action_283 (99) = happyGoto action_56
action_283 _ = happyFail

action_284 (111) = happyShift action_84
action_284 (112) = happyShift action_85
action_284 (131) = happyShift action_86
action_284 (133) = happyShift action_87
action_284 (137) = happyShift action_88
action_284 (147) = happyShift action_89
action_284 (150) = happyShift action_90
action_284 (151) = happyShift action_50
action_284 (152) = happyShift action_51
action_284 (154) = happyShift action_91
action_284 (155) = happyShift action_92
action_284 (34) = happyGoto action_75
action_284 (36) = happyGoto action_76
action_284 (37) = happyGoto action_77
action_284 (40) = happyGoto action_78
action_284 (41) = happyGoto action_79
action_284 (42) = happyGoto action_290
action_284 (71) = happyGoto action_291
action_284 (72) = happyGoto action_292
action_284 (96) = happyGoto action_81
action_284 (98) = happyGoto action_82
action_284 (99) = happyGoto action_83
action_284 _ = happyFail

action_285 _ = happyReduce_165

action_286 _ = happyReduce_166

action_287 (145) = happyShift action_289
action_287 _ = happyFail

action_288 _ = happyReduce_59

action_289 (109) = happyShift action_128
action_289 (120) = happyShift action_129
action_289 (131) = happyShift action_130
action_289 (137) = happyShift action_131
action_289 (151) = happyShift action_132
action_289 (152) = happyShift action_51
action_289 (86) = happyGoto action_122
action_289 (89) = happyGoto action_123
action_289 (90) = happyGoto action_124
action_289 (91) = happyGoto action_354
action_289 (96) = happyGoto action_126
action_289 (97) = happyGoto action_127
action_289 (98) = happyGoto action_30
action_289 (99) = happyGoto action_56
action_289 _ = happyFail

action_290 (128) = happyShift action_353
action_290 _ = happyFail

action_291 (111) = happyShift action_84
action_291 (112) = happyShift action_85
action_291 (131) = happyShift action_86
action_291 (133) = happyShift action_87
action_291 (136) = happyShift action_352
action_291 (137) = happyShift action_88
action_291 (147) = happyShift action_89
action_291 (150) = happyShift action_90
action_291 (151) = happyShift action_50
action_291 (152) = happyShift action_51
action_291 (154) = happyShift action_91
action_291 (155) = happyShift action_92
action_291 (34) = happyGoto action_75
action_291 (36) = happyGoto action_76
action_291 (37) = happyGoto action_77
action_291 (40) = happyGoto action_78
action_291 (41) = happyGoto action_79
action_291 (42) = happyGoto action_290
action_291 (72) = happyGoto action_351
action_291 (96) = happyGoto action_81
action_291 (98) = happyGoto action_82
action_291 (99) = happyGoto action_83
action_291 _ = happyFail

action_292 _ = happyReduce_160

action_293 _ = happyReduce_125

action_294 _ = happyReduce_66

action_295 _ = happyReduce_94

action_296 _ = happyReduce_156

action_297 _ = happyReduce_159

action_298 (138) = happyShift action_350
action_298 (146) = happyShift action_309
action_298 _ = happyFail

action_299 (122) = happyShift action_214
action_299 (28) = happyGoto action_212
action_299 (29) = happyGoto action_349
action_299 _ = happyReduce_54

action_300 _ = happyReduce_207

action_301 _ = happyReduce_192

action_302 _ = happyReduce_194

action_303 (109) = happyShift action_128
action_303 (120) = happyShift action_129
action_303 (131) = happyShift action_130
action_303 (137) = happyShift action_131
action_303 (151) = happyShift action_132
action_303 (152) = happyShift action_51
action_303 (86) = happyGoto action_122
action_303 (89) = happyGoto action_123
action_303 (90) = happyGoto action_124
action_303 (91) = happyGoto action_348
action_303 (96) = happyGoto action_126
action_303 (97) = happyGoto action_127
action_303 (98) = happyGoto action_30
action_303 (99) = happyGoto action_56
action_303 _ = happyFail

action_304 _ = happyReduce_199

action_305 (109) = happyShift action_128
action_305 (120) = happyShift action_129
action_305 (131) = happyShift action_130
action_305 (137) = happyShift action_131
action_305 (151) = happyShift action_132
action_305 (152) = happyShift action_51
action_305 (86) = happyGoto action_122
action_305 (89) = happyGoto action_123
action_305 (90) = happyGoto action_124
action_305 (91) = happyGoto action_347
action_305 (96) = happyGoto action_126
action_305 (97) = happyGoto action_127
action_305 (98) = happyGoto action_30
action_305 (99) = happyGoto action_56
action_305 _ = happyFail

action_306 _ = happyReduce_211

action_307 _ = happyReduce_200

action_308 _ = happyReduce_197

action_309 (109) = happyShift action_128
action_309 (120) = happyShift action_129
action_309 (131) = happyShift action_130
action_309 (137) = happyShift action_131
action_309 (151) = happyShift action_132
action_309 (152) = happyShift action_51
action_309 (86) = happyGoto action_122
action_309 (89) = happyGoto action_123
action_309 (90) = happyGoto action_124
action_309 (91) = happyGoto action_346
action_309 (96) = happyGoto action_126
action_309 (97) = happyGoto action_127
action_309 (98) = happyGoto action_30
action_309 (99) = happyGoto action_56
action_309 _ = happyFail

action_310 (151) = happyShift action_50
action_310 (152) = happyShift action_51
action_310 (99) = happyGoto action_345
action_310 _ = happyFail

action_311 _ = happyReduce_213

action_312 (138) = happyShift action_343
action_312 (146) = happyShift action_344
action_312 _ = happyFail

action_313 _ = happyReduce_34

action_314 _ = happyReduce_41

action_315 _ = happyReduce_42

action_316 _ = happyReduce_43

action_317 (125) = happyShift action_318
action_317 (126) = happyShift action_319
action_317 (136) = happyShift action_342
action_317 (19) = happyGoto action_314
action_317 (22) = happyGoto action_315
action_317 (23) = happyGoto action_341
action_317 _ = happyFail

action_318 (137) = happyShift action_340
action_318 _ = happyFail

action_319 (137) = happyShift action_339
action_319 _ = happyFail

action_320 (125) = happyShift action_318
action_320 (126) = happyShift action_319
action_320 (19) = happyGoto action_314
action_320 (22) = happyGoto action_315
action_320 (23) = happyGoto action_316
action_320 (24) = happyGoto action_338
action_320 _ = happyFail

action_321 _ = happyReduce_186

action_322 (138) = happyShift action_336
action_322 (146) = happyShift action_337
action_322 _ = happyFail

action_323 (151) = happyShift action_335
action_323 _ = happyFail

action_324 (151) = happyShift action_50
action_324 (152) = happyShift action_51
action_324 (99) = happyGoto action_334
action_324 _ = happyFail

action_325 (111) = happyShift action_37
action_325 (112) = happyShift action_38
action_325 (133) = happyShift action_333
action_325 (150) = happyShift action_49
action_325 (151) = happyShift action_50
action_325 (152) = happyShift action_51
action_325 (154) = happyShift action_52
action_325 (155) = happyShift action_53
action_325 (50) = happyGoto action_330
action_325 (51) = happyGoto action_331
action_325 (96) = happyGoto action_332
action_325 (98) = happyGoto action_30
action_325 (99) = happyGoto action_56
action_325 _ = happyFail

action_326 (151) = happyShift action_50
action_326 (152) = happyShift action_51
action_326 (99) = happyGoto action_329
action_326 _ = happyFail

action_327 (138) = happyShift action_328
action_327 _ = happyFail

action_328 (137) = happyShift action_369
action_328 (139) = happyShift action_97
action_328 (66) = happyGoto action_287
action_328 _ = happyReduce_151

action_329 (122) = happyShift action_214
action_329 (28) = happyGoto action_212
action_329 (29) = happyGoto action_368
action_329 _ = happyReduce_54

action_330 _ = happyReduce_139

action_331 _ = happyReduce_138

action_332 (143) = happyShift action_102
action_332 _ = happyReduce_107

action_333 (111) = happyShift action_37
action_333 (112) = happyShift action_38
action_333 (150) = happyShift action_49
action_333 (151) = happyShift action_50
action_333 (152) = happyShift action_51
action_333 (154) = happyShift action_52
action_333 (155) = happyShift action_53
action_333 (49) = happyGoto action_366
action_333 (51) = happyGoto action_367
action_333 (96) = happyGoto action_332
action_333 (98) = happyGoto action_30
action_333 (99) = happyGoto action_56
action_333 _ = happyReduce_100

action_334 (122) = happyShift action_214
action_334 (28) = happyGoto action_212
action_334 (29) = happyGoto action_365
action_334 _ = happyReduce_54

action_335 _ = happyReduce_33

action_336 (144) = happyShift action_108
action_336 (65) = happyGoto action_364
action_336 _ = happyFail

action_337 (111) = happyShift action_84
action_337 (112) = happyShift action_85
action_337 (131) = happyShift action_86
action_337 (133) = happyShift action_87
action_337 (137) = happyShift action_88
action_337 (147) = happyShift action_89
action_337 (150) = happyShift action_90
action_337 (151) = happyShift action_50
action_337 (152) = happyShift action_51
action_337 (154) = happyShift action_91
action_337 (155) = happyShift action_92
action_337 (34) = happyGoto action_75
action_337 (36) = happyGoto action_76
action_337 (37) = happyGoto action_77
action_337 (40) = happyGoto action_78
action_337 (41) = happyGoto action_79
action_337 (42) = happyGoto action_363
action_337 (96) = happyGoto action_81
action_337 (98) = happyGoto action_82
action_337 (99) = happyGoto action_83
action_337 _ = happyFail

action_338 (125) = happyShift action_318
action_338 (126) = happyShift action_319
action_338 (136) = happyShift action_362
action_338 (19) = happyGoto action_314
action_338 (22) = happyGoto action_315
action_338 (23) = happyGoto action_341
action_338 _ = happyFail

action_339 (151) = happyShift action_50
action_339 (152) = happyShift action_51
action_339 (20) = happyGoto action_359
action_339 (21) = happyGoto action_360
action_339 (99) = happyGoto action_361
action_339 _ = happyFail

action_340 (151) = happyShift action_50
action_340 (152) = happyShift action_51
action_340 (18) = happyGoto action_358
action_340 (99) = happyGoto action_313
action_340 _ = happyFail

action_341 _ = happyReduce_44

action_342 _ = happyReduce_47

action_343 _ = happyReduce_45

action_344 (151) = happyShift action_50
action_344 (152) = happyShift action_51
action_344 (99) = happyGoto action_357
action_344 _ = happyFail

action_345 _ = happyReduce_51

action_346 _ = happyReduce_190

action_347 _ = happyReduce_209

action_348 _ = happyReduce_193

action_349 (122) = happyShift action_214
action_349 (28) = happyGoto action_257
action_349 _ = happyReduce_153

action_350 _ = happyReduce_180

action_351 _ = happyReduce_161

action_352 _ = happyReduce_128

action_353 (106) = happyShift action_35
action_353 (111) = happyShift action_37
action_353 (112) = happyShift action_38
action_353 (113) = happyShift action_39
action_353 (115) = happyShift action_40
action_353 (116) = happyShift action_41
action_353 (119) = happyShift action_43
action_353 (131) = happyShift action_45
action_353 (133) = happyShift action_46
action_353 (135) = happyShift action_47
action_353 (137) = happyShift action_48
action_353 (150) = happyShift action_49
action_353 (151) = happyShift action_50
action_353 (152) = happyShift action_51
action_353 (154) = happyShift action_52
action_353 (155) = happyShift action_53
action_353 (9) = happyGoto action_8
action_353 (44) = happyGoto action_11
action_353 (46) = happyGoto action_12
action_353 (47) = happyGoto action_13
action_353 (48) = happyGoto action_14
action_353 (51) = happyGoto action_15
action_353 (52) = happyGoto action_16
action_353 (53) = happyGoto action_17
action_353 (54) = happyGoto action_18
action_353 (55) = happyGoto action_19
action_353 (56) = happyGoto action_20
action_353 (57) = happyGoto action_21
action_353 (58) = happyGoto action_356
action_353 (96) = happyGoto action_29
action_353 (98) = happyGoto action_30
action_353 (99) = happyGoto action_56
action_353 _ = happyFail

action_354 (122) = happyShift action_214
action_354 (28) = happyGoto action_212
action_354 (29) = happyGoto action_355
action_354 _ = happyReduce_54

action_355 (122) = happyShift action_214
action_355 (28) = happyGoto action_257
action_355 _ = happyReduce_154

action_356 _ = happyReduce_162

action_357 _ = happyReduce_35

action_358 (138) = happyShift action_379
action_358 (146) = happyShift action_344
action_358 _ = happyFail

action_359 _ = happyReduce_38

action_360 (138) = happyShift action_377
action_360 (146) = happyShift action_378
action_360 _ = happyFail

action_361 (128) = happyShift action_376
action_361 _ = happyFail

action_362 _ = happyReduce_46

action_363 _ = happyReduce_187

action_364 _ = happyReduce_147

action_365 (122) = happyShift action_214
action_365 (135) = happyShift action_375
action_365 (28) = happyGoto action_257
action_365 _ = happyFail

action_366 (134) = happyShift action_373
action_366 (146) = happyShift action_374
action_366 _ = happyFail

action_367 _ = happyReduce_98

action_368 (122) = happyShift action_214
action_368 (135) = happyShift action_372
action_368 (28) = happyGoto action_257
action_368 (30) = happyGoto action_371
action_368 _ = happyFail

action_369 (111) = happyShift action_84
action_369 (112) = happyShift action_85
action_369 (131) = happyShift action_86
action_369 (133) = happyShift action_87
action_369 (137) = happyShift action_88
action_369 (147) = happyShift action_89
action_369 (150) = happyShift action_90
action_369 (151) = happyShift action_50
action_369 (152) = happyShift action_51
action_369 (154) = happyShift action_91
action_369 (155) = happyShift action_92
action_369 (34) = happyGoto action_75
action_369 (36) = happyGoto action_76
action_369 (37) = happyGoto action_77
action_369 (40) = happyGoto action_78
action_369 (41) = happyGoto action_79
action_369 (42) = happyGoto action_321
action_369 (83) = happyGoto action_370
action_369 (96) = happyGoto action_81
action_369 (98) = happyGoto action_82
action_369 (99) = happyGoto action_83
action_369 _ = happyReduce_188

action_370 (138) = happyShift action_387
action_370 (146) = happyShift action_337
action_370 _ = happyFail

action_371 _ = happyReduce_56

action_372 (124) = happyShift action_44
action_372 (151) = happyShift action_50
action_372 (152) = happyShift action_51
action_372 (67) = happyGoto action_274
action_372 (68) = happyGoto action_385
action_372 (69) = happyGoto action_386
action_372 (99) = happyGoto action_276
action_372 _ = happyReduce_158

action_373 _ = happyReduce_101

action_374 (111) = happyShift action_37
action_374 (112) = happyShift action_38
action_374 (150) = happyShift action_49
action_374 (151) = happyShift action_50
action_374 (152) = happyShift action_51
action_374 (154) = happyShift action_52
action_374 (155) = happyShift action_53
action_374 (51) = happyGoto action_384
action_374 (96) = happyGoto action_332
action_374 (98) = happyGoto action_30
action_374 (99) = happyGoto action_56
action_374 _ = happyFail

action_375 (103) = happyShift action_235
action_375 (110) = happyShift action_237
action_375 (124) = happyShift action_239
action_375 (151) = happyShift action_50
action_375 (152) = happyShift action_51
action_375 (17) = happyGoto action_224
action_375 (26) = happyGoto action_225
action_375 (61) = happyGoto action_382
action_375 (62) = happyGoto action_383
action_375 (64) = happyGoto action_230
action_375 (67) = happyGoto action_231
action_375 (99) = happyGoto action_234
action_375 _ = happyReduce_145

action_376 (151) = happyShift action_50
action_376 (152) = happyShift action_51
action_376 (99) = happyGoto action_381
action_376 _ = happyFail

action_377 _ = happyReduce_40

action_378 (151) = happyShift action_50
action_378 (152) = happyShift action_51
action_378 (20) = happyGoto action_380
action_378 (99) = happyGoto action_361
action_378 _ = happyFail

action_379 _ = happyReduce_36

action_380 _ = happyReduce_39

action_381 _ = happyReduce_37

action_382 _ = happyReduce_143

action_383 (103) = happyShift action_235
action_383 (110) = happyShift action_237
action_383 (124) = happyShift action_239
action_383 (136) = happyShift action_391
action_383 (151) = happyShift action_50
action_383 (152) = happyShift action_51
action_383 (17) = happyGoto action_224
action_383 (26) = happyGoto action_225
action_383 (61) = happyGoto action_390
action_383 (64) = happyGoto action_230
action_383 (67) = happyGoto action_231
action_383 (99) = happyGoto action_234
action_383 _ = happyFail

action_384 _ = happyReduce_99

action_385 (124) = happyShift action_44
action_385 (151) = happyShift action_50
action_385 (152) = happyShift action_51
action_385 (67) = happyGoto action_296
action_385 (99) = happyGoto action_276
action_385 _ = happyReduce_157

action_386 (136) = happyShift action_389
action_386 _ = happyFail

action_387 (144) = happyShift action_108
action_387 (65) = happyGoto action_388
action_387 _ = happyFail

action_388 _ = happyReduce_148

action_389 _ = happyReduce_55

action_390 _ = happyReduce_144

action_391 _ = happyReduce_57

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn5
		 (CompUnit (firstPos happy_var_1) happy_var_1
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn6
		 (CompUnit (nodeData happy_var_1) [happy_var_1]
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn7
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  7 happyReduction_5
happyReduction_5 (HappyAbsSyn58  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_1  8 happyReduction_6
happyReduction_6 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  8 happyReduction_7
happyReduction_7 (HappyAbsSyn58  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_0  8 happyReduction_8
happyReduction_8  =  HappyAbsSyn8
		 ([]
	)

happyReduce_9 = happySpecReduce_3  9 happyReduction_9
happyReduction_9 _
	(HappyAbsSyn60  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (ExpBegin (pos happy_var_1) happy_var_2
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  10 happyReduction_10
happyReduction_10 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  11 happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ([happy_var_1]
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_2  11 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_0  11 happyReduction_13
happyReduction_13  =  HappyAbsSyn11
		 ([]
	)

happyReduce_14 = happySpecReduce_1  12 happyReduction_14
happyReduction_14 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn12
		 ([happy_var_1]
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_2  12 happyReduction_15
happyReduction_15 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  13 happyReduction_16
happyReduction_16 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_2  13 happyReduction_17
happyReduction_17 (HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_17 _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_0  13 happyReduction_18
happyReduction_18  =  HappyAbsSyn13
		 ([]
	)

happyReduce_19 = happySpecReduce_1  14 happyReduction_19
happyReduction_19 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  14 happyReduction_20
happyReduction_20 (HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  15 happyReduction_21
happyReduction_21 (HappyAbsSyn70  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  15 happyReduction_22
happyReduction_22 (HappyAbsSyn78  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpTypeDec (nodeData happy_var_1) happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  15 happyReduction_23
happyReduction_23 (HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  15 happyReduction_24
happyReduction_24 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  15 happyReduction_25
happyReduction_25 (HappyAbsSyn63  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  15 happyReduction_26
happyReduction_26 (HappyAbsSyn61  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  16 happyReduction_27
happyReduction_27 (HappyAbsSyn70  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  16 happyReduction_28
happyReduction_28 (HappyAbsSyn78  happy_var_1)
	 =  HappyAbsSyn16
		 (ExpTypeDec (nodeData happy_var_1) happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  16 happyReduction_29
happyReduction_29 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  16 happyReduction_30
happyReduction_30 (HappyAbsSyn63  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  16 happyReduction_31
happyReduction_31 (HappyAbsSyn59  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_2  17 happyReduction_32
happyReduction_32 (HappyAbsSyn96  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 (ExpImport (pos happy_var_1) happy_var_2
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happyReduce 4 17 happyReduction_33
happyReduction_33 ((HappyTerminal happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn96  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (ExpImportAs (pos happy_var_1) happy_var_2 (tokValue happy_var_4)
	) `HappyStk` happyRest

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn18
		 ([tokValue happy_var_1]
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1 ++ [tokValue happy_var_3]
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happyReduce 4 19 happyReduction_36
happyReduction_36 (_ `HappyStk`
	(HappyAbsSyn18  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (ImportClauseExcept (pos happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_37 = happySpecReduce_3  20 happyReduction_37
happyReduction_37 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn20
		 ((tokValue happy_var_1, tokValue happy_var_3)
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  21 happyReduction_38
happyReduction_38 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 ([happy_var_1]
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  21 happyReduction_39
happyReduction_39 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happyReduce 4 22 happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (ImportClauseRenaming (pos happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_1  23 happyReduction_41
happyReduction_41 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  23 happyReduction_42
happyReduction_42 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  24 happyReduction_43
happyReduction_43 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_2  24 happyReduction_44
happyReduction_44 (HappyAbsSyn23  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  25 happyReduction_45
happyReduction_45 _
	(HappyAbsSyn18  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (happy_var_2
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happyReduce 5 26 happyReduction_46
happyReduction_46 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_2) `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (ExpSelectiveImport (nodeData happy_var_1) happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_47 = happyReduce 4 26 happyReduction_47
happyReduction_47 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (ExpSelectiveImport (nodeData happy_var_1) happy_var_1 [] happy_var_3
	) `HappyStk` happyRest

happyReduce_48 = happySpecReduce_2  26 happyReduction_48
happyReduction_48 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn26
		 (ExpSelectiveImport (nodeData happy_var_1) happy_var_1 happy_var_2 []
	)
happyReduction_48 _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  26 happyReduction_49
happyReduction_49 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn26
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happyReduce 5 27 happyReduction_50
happyReduction_50 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_4) `HappyStk`
	(HappyTerminal happy_var_3) `HappyStk`
	(HappyAbsSyn96  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn27
		 (ExpModule (pos happy_var_3) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_51 = happyReduce 4 28 happyReduction_51
happyReduction_51 ((HappyAbsSyn99  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn28
		 (Constraint (pos happy_var_1) (tokValue happy_var_2) (tokValue happy_var_4)
	) `HappyStk` happyRest

happyReduce_52 = happySpecReduce_1  29 happyReduction_52
happyReduction_52 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn29
		 ([happy_var_1]
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_2  29 happyReduction_53
happyReduction_53 (HappyAbsSyn28  happy_var_2)
	(HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn29
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_53 _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_0  29 happyReduction_54
happyReduction_54  =  HappyAbsSyn29
		 ([]
	)

happyReduce_55 = happySpecReduce_3  30 happyReduction_55
happyReduction_55 _
	(HappyAbsSyn69  happy_var_2)
	_
	 =  HappyAbsSyn30
		 (happy_var_2
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happyReduce 6 31 happyReduction_56
happyReduction_56 ((HappyAbsSyn30  happy_var_6) `HappyStk`
	(HappyAbsSyn29  happy_var_5) `HappyStk`
	(HappyAbsSyn99  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn31
		 (ExpProtoDec (pos happy_var_1) (tokValue happy_var_2) (tokValue happy_var_4) happy_var_5 happy_var_6
	) `HappyStk` happyRest

happyReduce_57 = happyReduce 8 32 happyReduction_57
happyReduction_57 (_ `HappyStk`
	(HappyAbsSyn62  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn29  happy_var_5) `HappyStk`
	(HappyAbsSyn99  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn89  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (ExpProtoImp (pos happy_var_1) happy_var_2 (tokValue happy_var_4) happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_58 = happySpecReduce_2  33 happyReduction_58
happyReduction_58 (HappyAbsSyn58  happy_var_2)
	_
	 =  HappyAbsSyn33
		 ([happy_var_2]
	)
happyReduction_58 _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  33 happyReduction_59
happyReduction_59 (HappyAbsSyn58  happy_var_3)
	_
	(HappyAbsSyn33  happy_var_1)
	 =  HappyAbsSyn33
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  34 happyReduction_60
happyReduction_60 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn34
		 (PatExpNumLiteral (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  34 happyReduction_61
happyReduction_61 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn34
		 (PatExpBoolLiteral (pos happy_var_1) True
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  34 happyReduction_62
happyReduction_62 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn34
		 (PatExpBoolLiteral (pos happy_var_1) False
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  34 happyReduction_63
happyReduction_63 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn34
		 (PatExpStringLiteral (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  34 happyReduction_64
happyReduction_64 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn34
		 (PatExpCharLiteral (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  35 happyReduction_65
happyReduction_65 (HappyAbsSyn42  happy_var_2)
	_
	 =  HappyAbsSyn35
		 ([happy_var_2]
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  35 happyReduction_66
happyReduction_66 (HappyAbsSyn42  happy_var_3)
	_
	(HappyAbsSyn35  happy_var_1)
	 =  HappyAbsSyn35
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happyReduce 4 36 happyReduction_67
happyReduction_67 (_ `HappyStk`
	(HappyAbsSyn35  happy_var_3) `HappyStk`
	(HappyAbsSyn42  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn36
		 (PatExpTuple (pos happy_var_1) ([happy_var_2] ++ happy_var_3)
	) `HappyStk` happyRest

happyReduce_68 = happyReduce 4 37 happyReduction_68
happyReduction_68 (_ `HappyStk`
	(HappyAbsSyn38  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn96  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn37
		 (PatExpAdt (nodeData happy_var_1) happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_69 = happySpecReduce_1  37 happyReduction_69
happyReduction_69 (HappyAbsSyn98  happy_var_1)
	 =  HappyAbsSyn37
		 (PatExpAdt (nodeData happy_var_1) happy_var_1 []
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  38 happyReduction_70
happyReduction_70 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn38
		 ([happy_var_1]
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  38 happyReduction_71
happyReduction_71 (HappyAbsSyn42  happy_var_3)
	_
	(HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn38
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_0  38 happyReduction_72
happyReduction_72  =  HappyAbsSyn38
		 ([]
	)

happyReduce_73 = happySpecReduce_1  39 happyReduction_73
happyReduction_73 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn39
		 ([happy_var_1]
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_3  39 happyReduction_74
happyReduction_74 (HappyAbsSyn42  happy_var_3)
	_
	(HappyAbsSyn39  happy_var_1)
	 =  HappyAbsSyn39
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_74 _ _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_0  39 happyReduction_75
happyReduction_75  =  HappyAbsSyn39
		 ([]
	)

happyReduce_76 = happySpecReduce_3  40 happyReduction_76
happyReduction_76 _
	(HappyAbsSyn42  happy_var_2)
	_
	 =  HappyAbsSyn40
		 (happy_var_2
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  40 happyReduction_77
happyReduction_77 (HappyAbsSyn34  happy_var_1)
	 =  HappyAbsSyn40
		 (happy_var_1
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  40 happyReduction_78
happyReduction_78 (HappyAbsSyn36  happy_var_1)
	 =  HappyAbsSyn40
		 (happy_var_1
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_1  40 happyReduction_79
happyReduction_79 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn40
		 (happy_var_1
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  40 happyReduction_80
happyReduction_80 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn40
		 (PatExpId (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_1  40 happyReduction_81
happyReduction_81 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn40
		 (PatExpWildcard (pos happy_var_1)
	)
happyReduction_81 _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_3  41 happyReduction_82
happyReduction_82 (HappyAbsSyn41  happy_var_3)
	_
	(HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn41
		 (PatExpListCons (nodeData happy_var_1) happy_var_1 happy_var_3
	)
happyReduction_82 _ _ _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_3  41 happyReduction_83
happyReduction_83 _
	(HappyAbsSyn38  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn41
		 (PatExpList (pos happy_var_1) happy_var_2
	)
happyReduction_83 _ _ _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  41 happyReduction_84
happyReduction_84 (HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn41
		 (happy_var_1
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_1  42 happyReduction_85
happyReduction_85 (HappyAbsSyn41  happy_var_1)
	 =  HappyAbsSyn42
		 (happy_var_1
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_1  43 happyReduction_86
happyReduction_86 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn43
		 ([happy_var_1]
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_3  43 happyReduction_87
happyReduction_87 (HappyAbsSyn58  happy_var_3)
	_
	(HappyAbsSyn43  happy_var_1)
	 =  HappyAbsSyn43
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_87 _ _ _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_0  43 happyReduction_88
happyReduction_88  =  HappyAbsSyn43
		 ([]
	)

happyReduce_89 = happySpecReduce_3  44 happyReduction_89
happyReduction_89 _
	(HappyAbsSyn43  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn44
		 (ExpList (pos happy_var_1) happy_var_2
	)
happyReduction_89 _ _ _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_1  45 happyReduction_90
happyReduction_90 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn45
		 ([tokValue happy_var_1]
	)
happyReduction_90 _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_3  45 happyReduction_91
happyReduction_91 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn45  happy_var_1)
	 =  HappyAbsSyn45
		 (happy_var_1 ++ [tokValue happy_var_3]
	)
happyReduction_91 _ _ _  = notHappyAtAll 

happyReduce_92 = happySpecReduce_0  45 happyReduction_92
happyReduction_92  =  HappyAbsSyn45
		 ([]
	)

happyReduce_93 = happyReduce 4 46 happyReduction_93
happyReduction_93 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn46
		 ((pos happy_var_1, happy_var_3)
	) `HappyStk` happyRest

happyReduce_94 = happyReduce 6 47 happyReduction_94
happyReduction_94 (_ `HappyStk`
	(HappyAbsSyn42  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn83  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn47
		 ((pos happy_var_1, happy_var_3 ++ [happy_var_5])
	) `HappyStk` happyRest

happyReduce_95 = happySpecReduce_1  48 happyReduction_95
happyReduction_95 (HappyAbsSyn46  happy_var_1)
	 =  HappyAbsSyn48
		 ((fst happy_var_1, [snd happy_var_1])
	)
happyReduction_95 _  = notHappyAtAll 

happyReduce_96 = happySpecReduce_1  48 happyReduction_96
happyReduction_96 (HappyAbsSyn47  happy_var_1)
	 =  HappyAbsSyn48
		 (happy_var_1
	)
happyReduction_96 _  = notHappyAtAll 

happyReduce_97 = happySpecReduce_3  48 happyReduction_97
happyReduction_97 _
	_
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn48
		 ((pos happy_var_1, [])
	)
happyReduction_97 _ _ _  = notHappyAtAll 

happyReduce_98 = happySpecReduce_1  49 happyReduction_98
happyReduction_98 (HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn49
		 ([happy_var_1]
	)
happyReduction_98 _  = notHappyAtAll 

happyReduce_99 = happySpecReduce_3  49 happyReduction_99
happyReduction_99 (HappyAbsSyn51  happy_var_3)
	_
	(HappyAbsSyn49  happy_var_1)
	 =  HappyAbsSyn49
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_99 _ _ _  = notHappyAtAll 

happyReduce_100 = happySpecReduce_0  49 happyReduction_100
happyReduction_100  =  HappyAbsSyn49
		 ([]
	)

happyReduce_101 = happySpecReduce_3  50 happyReduction_101
happyReduction_101 _
	(HappyAbsSyn49  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn50
		 (ExpList (pos happy_var_1) happy_var_2
	)
happyReduction_101 _ _ _  = notHappyAtAll 

happyReduce_102 = happySpecReduce_1  51 happyReduction_102
happyReduction_102 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn51
		 (ExpNum (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_102 _  = notHappyAtAll 

happyReduce_103 = happySpecReduce_1  51 happyReduction_103
happyReduction_103 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn51
		 (ExpBool (pos happy_var_1) True
	)
happyReduction_103 _  = notHappyAtAll 

happyReduce_104 = happySpecReduce_1  51 happyReduction_104
happyReduction_104 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn51
		 (ExpBool (pos happy_var_1) False
	)
happyReduction_104 _  = notHappyAtAll 

happyReduce_105 = happySpecReduce_1  51 happyReduction_105
happyReduction_105 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn51
		 (ExpString (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_105 _  = notHappyAtAll 

happyReduce_106 = happySpecReduce_1  51 happyReduction_106
happyReduction_106 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn51
		 (ExpChar (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_106 _  = notHappyAtAll 

happyReduce_107 = happySpecReduce_1  51 happyReduction_107
happyReduction_107 (HappyAbsSyn96  happy_var_1)
	 =  HappyAbsSyn51
		 (ExpQualifiedRef (nodeData happy_var_1) happy_var_1
	)
happyReduction_107 _  = notHappyAtAll 

happyReduce_108 = happySpecReduce_3  52 happyReduction_108
happyReduction_108 _
	(HappyAbsSyn58  happy_var_2)
	_
	 =  HappyAbsSyn52
		 (ExpInParens (nodeData happy_var_2) happy_var_2
	)
happyReduction_108 _ _ _  = notHappyAtAll 

happyReduce_109 = happySpecReduce_2  52 happyReduction_109
happyReduction_109 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn52
		 (ExpUnit (pos happy_var_1)
	)
happyReduction_109 _ _  = notHappyAtAll 

happyReduce_110 = happySpecReduce_3  52 happyReduction_110
happyReduction_110 _
	(HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn52
		 (ExpRef (pos happy_var_1) (tokValue happy_var_2)
	)
happyReduction_110 _ _ _  = notHappyAtAll 

happyReduce_111 = happyReduce 4 52 happyReduction_111
happyReduction_111 (_ `HappyStk`
	(HappyAbsSyn33  happy_var_3) `HappyStk`
	(HappyAbsSyn58  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (ExpTuple (pos happy_var_1) (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_112 = happySpecReduce_1  52 happyReduction_112
happyReduction_112 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn52
		 (happy_var_1
	)
happyReduction_112 _  = notHappyAtAll 

happyReduce_113 = happyReduce 4 52 happyReduction_113
happyReduction_113 (_ `HappyStk`
	(HappyAbsSyn95  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn96  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (ExpStruct (nodeData happy_var_1) happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_114 = happySpecReduce_2  52 happyReduction_114
happyReduction_114 (HappyAbsSyn65  happy_var_2)
	(HappyAbsSyn48  happy_var_1)
	 =  HappyAbsSyn52
		 (ExpFun (fst happy_var_1) (snd happy_var_1) happy_var_2
	)
happyReduction_114 _ _  = notHappyAtAll 

happyReduce_115 = happyReduce 4 52 happyReduction_115
happyReduction_115 (_ `HappyStk`
	(HappyTerminal happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn52
		 (ExpPrim (pos happy_var_1) (tokValue happy_var_3)
	) `HappyStk` happyRest

happyReduce_116 = happySpecReduce_1  52 happyReduction_116
happyReduction_116 (HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn52
		 (happy_var_1
	)
happyReduction_116 _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_3  53 happyReduction_117
happyReduction_117 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn54  happy_var_1)
	 =  HappyAbsSyn53
		 (ExpMemberAccess (nodeData happy_var_1) happy_var_1 (tokValue happy_var_3)
	)
happyReduction_117 _ _ _  = notHappyAtAll 

happyReduce_118 = happySpecReduce_1  53 happyReduction_118
happyReduction_118 (HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn53
		 (happy_var_1
	)
happyReduction_118 _  = notHappyAtAll 

happyReduce_119 = happyReduce 4 54 happyReduction_119
happyReduction_119 (_ `HappyStk`
	(HappyAbsSyn75  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn54  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn54
		 (ExpApp (nodeData happy_var_1) happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_120 = happySpecReduce_1  54 happyReduction_120
happyReduction_120 (HappyAbsSyn53  happy_var_1)
	 =  HappyAbsSyn54
		 (happy_var_1
	)
happyReduction_120 _  = notHappyAtAll 

happyReduce_121 = happySpecReduce_3  55 happyReduction_121
happyReduction_121 (HappyAbsSyn55  happy_var_3)
	_
	(HappyAbsSyn54  happy_var_1)
	 =  HappyAbsSyn55
		 (ExpCons (nodeData happy_var_1) happy_var_1 happy_var_3
	)
happyReduction_121 _ _ _  = notHappyAtAll 

happyReduce_122 = happySpecReduce_1  55 happyReduction_122
happyReduction_122 (HappyAbsSyn54  happy_var_1)
	 =  HappyAbsSyn55
		 (happy_var_1
	)
happyReduction_122 _  = notHappyAtAll 

happyReduce_123 = happySpecReduce_3  56 happyReduction_123
happyReduction_123 (HappyAbsSyn55  happy_var_3)
	(HappyAbsSyn100  happy_var_2)
	(HappyAbsSyn56  happy_var_1)
	 =  HappyAbsSyn56
		 (ExpCustomInfix (nodeData happy_var_1) happy_var_1 (tokValue happy_var_2) happy_var_3
	)
happyReduction_123 _ _ _  = notHappyAtAll 

happyReduce_124 = happySpecReduce_1  56 happyReduction_124
happyReduction_124 (HappyAbsSyn55  happy_var_1)
	 =  HappyAbsSyn56
		 (happy_var_1
	)
happyReduction_124 _  = notHappyAtAll 

happyReduce_125 = happyReduce 6 57 happyReduction_125
happyReduction_125 ((HappyAbsSyn58  happy_var_6) `HappyStk`
	(HappyAbsSyn58  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn58  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn57
		 (ExpIfElse (pos happy_var_1) happy_var_3 happy_var_5 happy_var_6
	) `HappyStk` happyRest

happyReduce_126 = happySpecReduce_1  58 happyReduction_126
happyReduction_126 (HappyAbsSyn56  happy_var_1)
	 =  HappyAbsSyn58
		 (happy_var_1
	)
happyReduction_126 _  = notHappyAtAll 

happyReduce_127 = happySpecReduce_1  58 happyReduction_127
happyReduction_127 (HappyAbsSyn57  happy_var_1)
	 =  HappyAbsSyn58
		 (happy_var_1
	)
happyReduction_127 _  = notHappyAtAll 

happyReduce_128 = happyReduce 7 58 happyReduction_128
happyReduction_128 (_ `HappyStk`
	(HappyAbsSyn71  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn58  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn58
		 (ExpSwitch (pos happy_var_1) happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_129 = happyReduce 4 58 happyReduction_129
happyReduction_129 (_ `HappyStk`
	(HappyAbsSyn73  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn58
		 (ExpCond (pos happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_130 = happySpecReduce_1  58 happyReduction_130
happyReduction_130 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn58
		 (happy_var_1
	)
happyReduction_130 _  = notHappyAtAll 

happyReduce_131 = happyReduce 4 59 happyReduction_131
happyReduction_131 ((HappyAbsSyn58  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn59
		 (ExpAssign (pos happy_var_1) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_132 = happySpecReduce_1  59 happyReduction_132
happyReduction_132 (HappyAbsSyn67  happy_var_1)
	 =  HappyAbsSyn59
		 (ExpTyAnn happy_var_1
	)
happyReduction_132 _  = notHappyAtAll 

happyReduce_133 = happySpecReduce_2  59 happyReduction_133
happyReduction_133 (HappyAbsSyn96  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn59
		 (ExpImport (pos happy_var_1) happy_var_2
	)
happyReduction_133 _ _  = notHappyAtAll 

happyReduce_134 = happyReduce 4 59 happyReduction_134
happyReduction_134 ((HappyTerminal happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn96  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn59
		 (ExpImportAs (pos happy_var_1) happy_var_2 (tokValue happy_var_4)
	) `HappyStk` happyRest

happyReduce_135 = happySpecReduce_1  59 happyReduction_135
happyReduction_135 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn59
		 (happy_var_1
	)
happyReduction_135 _  = notHappyAtAll 

happyReduce_136 = happySpecReduce_1  60 happyReduction_136
happyReduction_136 (HappyAbsSyn59  happy_var_1)
	 =  HappyAbsSyn60
		 ([happy_var_1]
	)
happyReduction_136 _  = notHappyAtAll 

happyReduce_137 = happySpecReduce_2  60 happyReduction_137
happyReduction_137 (HappyAbsSyn59  happy_var_2)
	(HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn60
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_137 _ _  = notHappyAtAll 

happyReduce_138 = happyReduce 4 61 happyReduction_138
happyReduction_138 ((HappyAbsSyn51  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn61
		 (ExpTopLevelAssign (pos happy_var_1) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_139 = happyReduce 4 61 happyReduction_139
happyReduction_139 ((HappyAbsSyn50  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn61
		 (ExpTopLevelAssign (pos happy_var_1) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_140 = happySpecReduce_1  61 happyReduction_140
happyReduction_140 (HappyAbsSyn64  happy_var_1)
	 =  HappyAbsSyn61
		 (ExpFunDef happy_var_1
	)
happyReduction_140 _  = notHappyAtAll 

happyReduce_141 = happySpecReduce_1  61 happyReduction_141
happyReduction_141 (HappyAbsSyn67  happy_var_1)
	 =  HappyAbsSyn61
		 (ExpTopLevelTyAnn happy_var_1
	)
happyReduction_141 _  = notHappyAtAll 

happyReduce_142 = happySpecReduce_1  61 happyReduction_142
happyReduction_142 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn61
		 (happy_var_1
	)
happyReduction_142 _  = notHappyAtAll 

happyReduce_143 = happySpecReduce_1  62 happyReduction_143
happyReduction_143 (HappyAbsSyn61  happy_var_1)
	 =  HappyAbsSyn62
		 ([happy_var_1]
	)
happyReduction_143 _  = notHappyAtAll 

happyReduce_144 = happySpecReduce_2  62 happyReduction_144
happyReduction_144 (HappyAbsSyn61  happy_var_2)
	(HappyAbsSyn62  happy_var_1)
	 =  HappyAbsSyn62
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_144 _ _  = notHappyAtAll 

happyReduce_145 = happySpecReduce_0  62 happyReduction_145
happyReduction_145  =  HappyAbsSyn62
		 ([]
	)

happyReduce_146 = happySpecReduce_3  63 happyReduction_146
happyReduction_146 (HappyTerminal happy_var_3)
	(HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn63
		 (ExpPrecAssign (pos happy_var_1) (tokValue happy_var_2) (read (tokValue happy_var_3))
	)
happyReduction_146 _ _ _  = notHappyAtAll 

happyReduce_147 = happyReduce 5 64 happyReduction_147
happyReduction_147 ((HappyAbsSyn65  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn83  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn64
		 (FunDefFun (pos happy_var_1) (tokValue happy_var_1) happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_148 = happyReduce 8 64 happyReduction_148
happyReduction_148 ((HappyAbsSyn65  happy_var_8) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn83  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn100  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn64
		 (FunDefFun (pos happy_var_1) (tokValue happy_var_3) happy_var_6 happy_var_8
	) `HappyStk` happyRest

happyReduce_149 = happySpecReduce_2  65 happyReduction_149
happyReduction_149 (HappyAbsSyn58  happy_var_2)
	_
	 =  HappyAbsSyn65
		 (happy_var_2
	)
happyReduction_149 _ _  = notHappyAtAll 

happyReduce_150 = happySpecReduce_3  66 happyReduction_150
happyReduction_150 _
	(HappyAbsSyn45  happy_var_2)
	_
	 =  HappyAbsSyn66
		 (happy_var_2
	)
happyReduction_150 _ _ _  = notHappyAtAll 

happyReduce_151 = happySpecReduce_0  66 happyReduction_151
happyReduction_151  =  HappyAbsSyn66
		 ([]
	)

happyReduce_152 = happyReduce 4 67 happyReduction_152
happyReduction_152 ((HappyAbsSyn29  happy_var_4) `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn67
		 (TyAnn (pos happy_var_1) (tokValue happy_var_1) [] happy_var_3 happy_var_4
	) `HappyStk` happyRest

happyReduce_153 = happyReduce 7 67 happyReduction_153
happyReduction_153 ((HappyAbsSyn29  happy_var_7) `HappyStk`
	(HappyAbsSyn91  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn45  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn67
		 (TyAnn (pos happy_var_1) (tokValue happy_var_1) happy_var_3 happy_var_6 happy_var_7
	) `HappyStk` happyRest

happyReduce_154 = happyReduce 8 67 happyReduction_154
happyReduction_154 ((HappyAbsSyn29  happy_var_8) `HappyStk`
	(HappyAbsSyn91  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn66  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn100  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn67
		 (TyAnn (pos happy_var_1) (tokValue happy_var_3) happy_var_5 happy_var_7 happy_var_8
	) `HappyStk` happyRest

happyReduce_155 = happySpecReduce_1  68 happyReduction_155
happyReduction_155 (HappyAbsSyn67  happy_var_1)
	 =  HappyAbsSyn68
		 ([happy_var_1]
	)
happyReduction_155 _  = notHappyAtAll 

happyReduce_156 = happySpecReduce_2  68 happyReduction_156
happyReduction_156 (HappyAbsSyn67  happy_var_2)
	(HappyAbsSyn68  happy_var_1)
	 =  HappyAbsSyn68
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_156 _ _  = notHappyAtAll 

happyReduce_157 = happySpecReduce_1  69 happyReduction_157
happyReduction_157 (HappyAbsSyn68  happy_var_1)
	 =  HappyAbsSyn69
		 (happy_var_1
	)
happyReduction_157 _  = notHappyAtAll 

happyReduce_158 = happySpecReduce_0  69 happyReduction_158
happyReduction_158  =  HappyAbsSyn69
		 ([]
	)

happyReduce_159 = happyReduce 6 70 happyReduction_159
happyReduction_159 (_ `HappyStk`
	(HappyAbsSyn68  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn66  happy_var_3) `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn70
		 (ExpInterfaceDec (pos happy_var_1) (tokValue happy_var_2) happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_160 = happySpecReduce_1  71 happyReduction_160
happyReduction_160 (HappyAbsSyn72  happy_var_1)
	 =  HappyAbsSyn71
		 ([happy_var_1]
	)
happyReduction_160 _  = notHappyAtAll 

happyReduce_161 = happySpecReduce_2  71 happyReduction_161
happyReduction_161 (HappyAbsSyn72  happy_var_2)
	(HappyAbsSyn71  happy_var_1)
	 =  HappyAbsSyn71
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_161 _ _  = notHappyAtAll 

happyReduce_162 = happySpecReduce_3  72 happyReduction_162
happyReduction_162 (HappyAbsSyn58  happy_var_3)
	_
	(HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn72
		 (CaseClause (nodeData happy_var_1) happy_var_1 happy_var_3
	)
happyReduction_162 _ _ _  = notHappyAtAll 

happyReduce_163 = happySpecReduce_1  73 happyReduction_163
happyReduction_163 (HappyAbsSyn74  happy_var_1)
	 =  HappyAbsSyn73
		 ([happy_var_1]
	)
happyReduction_163 _  = notHappyAtAll 

happyReduce_164 = happySpecReduce_2  73 happyReduction_164
happyReduction_164 (HappyAbsSyn74  happy_var_2)
	(HappyAbsSyn73  happy_var_1)
	 =  HappyAbsSyn73
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_164 _ _  = notHappyAtAll 

happyReduce_165 = happySpecReduce_3  74 happyReduction_165
happyReduction_165 (HappyAbsSyn58  happy_var_3)
	_
	(HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn74
		 (CondCaseClause (nodeData happy_var_1) happy_var_1 happy_var_3
	)
happyReduction_165 _ _ _  = notHappyAtAll 

happyReduce_166 = happySpecReduce_3  74 happyReduction_166
happyReduction_166 (HappyAbsSyn58  happy_var_3)
	_
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn74
		 (CondCaseClauseWildcard (pos happy_var_1) happy_var_3
	)
happyReduction_166 _ _ _  = notHappyAtAll 

happyReduce_167 = happySpecReduce_1  75 happyReduction_167
happyReduction_167 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn75
		 ([happy_var_1]
	)
happyReduction_167 _  = notHappyAtAll 

happyReduce_168 = happySpecReduce_3  75 happyReduction_168
happyReduction_168 (HappyAbsSyn58  happy_var_3)
	_
	(HappyAbsSyn75  happy_var_1)
	 =  HappyAbsSyn75
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_168 _ _ _  = notHappyAtAll 

happyReduce_169 = happySpecReduce_0  75 happyReduction_169
happyReduction_169  =  HappyAbsSyn75
		 ([]
	)

happyReduce_170 = happySpecReduce_1  76 happyReduction_170
happyReduction_170 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn76
		 ([tokValue happy_var_1]
	)
happyReduction_170 _  = notHappyAtAll 

happyReduce_171 = happySpecReduce_3  76 happyReduction_171
happyReduction_171 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn76  happy_var_1)
	 =  HappyAbsSyn76
		 (happy_var_1 ++ [tokValue happy_var_3]
	)
happyReduction_171 _ _ _  = notHappyAtAll 

happyReduce_172 = happySpecReduce_0  76 happyReduction_172
happyReduction_172  =  HappyAbsSyn76
		 ([]
	)

happyReduce_173 = happySpecReduce_3  77 happyReduction_173
happyReduction_173 (HappyAbsSyn91  happy_var_3)
	(HappyAbsSyn66  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn77
		 (TypeDecImplicit (pos happy_var_1) (TypeDecTy (nodeData happy_var_3) "<implicit>" happy_var_2 happy_var_3)
	)
happyReduction_173 _ _ _  = notHappyAtAll 

happyReduce_174 = happySpecReduce_3  77 happyReduction_174
happyReduction_174 (HappyAbsSyn79  happy_var_3)
	(HappyAbsSyn66  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn77
		 (TypeDecImplicit (pos happy_var_1) (TypeDecAdt (pos happy_var_1) "<implicit>" happy_var_2 happy_var_3)
	)
happyReduction_174 _ _ _  = notHappyAtAll 

happyReduce_175 = happyReduce 5 78 happyReduction_175
happyReduction_175 ((HappyAbsSyn91  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn66  happy_var_3) `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn78
		 (TypeDecTy (pos happy_var_1) (tokValue happy_var_2) happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_176 = happyReduce 5 78 happyReduction_176
happyReduction_176 ((HappyAbsSyn79  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn66  happy_var_3) `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn78
		 (TypeDecAdt (pos happy_var_1) (tokValue happy_var_2) happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_177 = happySpecReduce_1  78 happyReduction_177
happyReduction_177 (HappyAbsSyn77  happy_var_1)
	 =  HappyAbsSyn78
		 (happy_var_1
	)
happyReduction_177 _  = notHappyAtAll 

happyReduce_178 = happySpecReduce_1  79 happyReduction_178
happyReduction_178 (HappyAbsSyn80  happy_var_1)
	 =  HappyAbsSyn79
		 ([happy_var_1]
	)
happyReduction_178 _  = notHappyAtAll 

happyReduce_179 = happySpecReduce_2  79 happyReduction_179
happyReduction_179 (HappyAbsSyn80  happy_var_2)
	(HappyAbsSyn79  happy_var_1)
	 =  HappyAbsSyn79
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_179 _ _  = notHappyAtAll 

happyReduce_180 = happyReduce 5 80 happyReduction_180
happyReduction_180 (_ `HappyStk`
	(HappyAbsSyn84  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn80
		 (AdtAlternative (pos happy_var_1) (tokValue happy_var_2) 0 happy_var_4
	) `HappyStk` happyRest

happyReduce_181 = happySpecReduce_2  80 happyReduction_181
happyReduction_181 (HappyAbsSyn99  happy_var_2)
	_
	 =  HappyAbsSyn80
		 (AdtAlternative (pos happy_var_2) (tokValue happy_var_2) 0 []
	)
happyReduction_181 _ _  = notHappyAtAll 

happyReduce_182 = happySpecReduce_1  81 happyReduction_182
happyReduction_182 (HappyAbsSyn91  happy_var_1)
	 =  HappyAbsSyn81
		 ([happy_var_1]
	)
happyReduction_182 _  = notHappyAtAll 

happyReduce_183 = happySpecReduce_2  81 happyReduction_183
happyReduction_183 (HappyAbsSyn91  happy_var_2)
	(HappyAbsSyn81  happy_var_1)
	 =  HappyAbsSyn81
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_183 _ _  = notHappyAtAll 

happyReduce_184 = happySpecReduce_0  81 happyReduction_184
happyReduction_184  =  HappyAbsSyn81
		 ([]
	)

happyReduce_185 = happyReduce 4 82 happyReduction_185
happyReduction_185 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn42  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn82
		 (happy_var_2
	) `HappyStk` happyRest

happyReduce_186 = happySpecReduce_1  83 happyReduction_186
happyReduction_186 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn83
		 ([happy_var_1]
	)
happyReduction_186 _  = notHappyAtAll 

happyReduce_187 = happySpecReduce_3  83 happyReduction_187
happyReduction_187 (HappyAbsSyn42  happy_var_3)
	_
	(HappyAbsSyn83  happy_var_1)
	 =  HappyAbsSyn83
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_187 _ _ _  = notHappyAtAll 

happyReduce_188 = happySpecReduce_0  83 happyReduction_188
happyReduction_188  =  HappyAbsSyn83
		 ([]
	)

happyReduce_189 = happySpecReduce_1  84 happyReduction_189
happyReduction_189 (HappyAbsSyn91  happy_var_1)
	 =  HappyAbsSyn84
		 ([happy_var_1]
	)
happyReduction_189 _  = notHappyAtAll 

happyReduce_190 = happySpecReduce_3  84 happyReduction_190
happyReduction_190 (HappyAbsSyn91  happy_var_3)
	_
	(HappyAbsSyn84  happy_var_1)
	 =  HappyAbsSyn84
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_190 _ _ _  = notHappyAtAll 

happyReduce_191 = happySpecReduce_0  84 happyReduction_191
happyReduction_191  =  HappyAbsSyn84
		 ([]
	)

happyReduce_192 = happySpecReduce_2  85 happyReduction_192
happyReduction_192 (HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn85
		 ([happy_var_2]
	)
happyReduction_192 _ _  = notHappyAtAll 

happyReduce_193 = happySpecReduce_3  85 happyReduction_193
happyReduction_193 (HappyAbsSyn91  happy_var_3)
	_
	(HappyAbsSyn85  happy_var_1)
	 =  HappyAbsSyn85
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_193 _ _ _  = notHappyAtAll 

happyReduce_194 = happyReduce 4 86 happyReduction_194
happyReduction_194 (_ `HappyStk`
	(HappyAbsSyn85  happy_var_3) `HappyStk`
	(HappyAbsSyn91  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn86
		 (SynTyTuple (pos happy_var_1) (happy_var_2:happy_var_3)
	) `HappyStk` happyRest

happyReduce_195 = happySpecReduce_2  87 happyReduction_195
happyReduction_195 (HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn87
		 (Just happy_var_2
	)
happyReduction_195 _ _  = notHappyAtAll 

happyReduce_196 = happySpecReduce_0  87 happyReduction_196
happyReduction_196  =  HappyAbsSyn87
		 (Nothing
	)

happyReduce_197 = happySpecReduce_3  88 happyReduction_197
happyReduction_197 _
	(HappyAbsSyn84  happy_var_2)
	_
	 =  HappyAbsSyn88
		 (happy_var_2
	)
happyReduction_197 _ _ _  = notHappyAtAll 

happyReduce_198 = happySpecReduce_0  88 happyReduction_198
happyReduction_198  =  HappyAbsSyn88
		 ([]
	)

happyReduce_199 = happyReduce 4 89 happyReduction_199
happyReduction_199 (_ `HappyStk`
	(HappyTerminal happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn89
		 (SynTyPrim (pos happy_var_1) (tokValue happy_var_3)
	) `HappyStk` happyRest

happyReduce_200 = happyReduce 4 89 happyReduction_200
happyReduction_200 (_ `HappyStk`
	(HappyAbsSyn93  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn89
		 (SynTyStruct (pos happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_201 = happySpecReduce_1  89 happyReduction_201
happyReduction_201 (HappyAbsSyn86  happy_var_1)
	 =  HappyAbsSyn89
		 (happy_var_1
	)
happyReduction_201 _  = notHappyAtAll 

happyReduce_202 = happySpecReduce_2  89 happyReduction_202
happyReduction_202 (HappyAbsSyn88  happy_var_2)
	(HappyAbsSyn97  happy_var_1)
	 =  HappyAbsSyn89
		 (SynTyRef (nodeData happy_var_1) happy_var_1 happy_var_2
	)
happyReduction_202 _ _  = notHappyAtAll 

happyReduce_203 = happySpecReduce_3  89 happyReduction_203
happyReduction_203 _
	_
	(HappyAbsSyn89  happy_var_1)
	 =  HappyAbsSyn89
		 (SynTyList (nodeData happy_var_1) happy_var_1
	)
happyReduction_203 _ _ _  = notHappyAtAll 

happyReduce_204 = happySpecReduce_3  89 happyReduction_204
happyReduction_204 _
	(HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn89
		 (happy_var_2
	)
happyReduction_204 _ _ _  = notHappyAtAll 

happyReduce_205 = happySpecReduce_1  90 happyReduction_205
happyReduction_205 (HappyAbsSyn89  happy_var_1)
	 =  HappyAbsSyn90
		 ([happy_var_1]
	)
happyReduction_205 _  = notHappyAtAll 

happyReduce_206 = happySpecReduce_3  90 happyReduction_206
happyReduction_206 (HappyAbsSyn90  happy_var_3)
	_
	(HappyAbsSyn89  happy_var_1)
	 =  HappyAbsSyn90
		 (happy_var_1 : happy_var_3
	)
happyReduction_206 _ _ _  = notHappyAtAll 

happyReduce_207 = happyReduce 4 90 happyReduction_207
happyReduction_207 (_ `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn90
		 ([SynTyArrow (pos happy_var_1) [] happy_var_3]
	) `HappyStk` happyRest

happyReduce_208 = happySpecReduce_1  91 happyReduction_208
happyReduction_208 (HappyAbsSyn90  happy_var_1)
	 =  HappyAbsSyn91
		 (if length happy_var_1 == 1 then head happy_var_1 else SynTyArrow (firstPos happy_var_1) (take (length happy_var_1 - 1) happy_var_1) (last happy_var_1)
	)
happyReduction_208 _  = notHappyAtAll 

happyReduce_209 = happySpecReduce_3  92 happyReduction_209
happyReduction_209 (HappyAbsSyn91  happy_var_3)
	_
	(HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn92
		 ((tokValue happy_var_1, happy_var_3)
	)
happyReduction_209 _ _ _  = notHappyAtAll 

happyReduce_210 = happySpecReduce_1  93 happyReduction_210
happyReduction_210 (HappyAbsSyn92  happy_var_1)
	 =  HappyAbsSyn93
		 ([happy_var_1]
	)
happyReduction_210 _  = notHappyAtAll 

happyReduce_211 = happySpecReduce_2  93 happyReduction_211
happyReduction_211 (HappyAbsSyn92  happy_var_2)
	(HappyAbsSyn93  happy_var_1)
	 =  HappyAbsSyn93
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_211 _ _  = notHappyAtAll 

happyReduce_212 = happySpecReduce_0  93 happyReduction_212
happyReduction_212  =  HappyAbsSyn93
		 ([]
	)

happyReduce_213 = happyReduce 4 94 happyReduction_213
happyReduction_213 (_ `HappyStk`
	(HappyAbsSyn58  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn99  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn94
		 (FieldInit (tokValue happy_var_1) happy_var_3
	) `HappyStk` happyRest

happyReduce_214 = happySpecReduce_1  95 happyReduction_214
happyReduction_214 (HappyAbsSyn94  happy_var_1)
	 =  HappyAbsSyn95
		 ([happy_var_1]
	)
happyReduction_214 _  = notHappyAtAll 

happyReduce_215 = happySpecReduce_2  95 happyReduction_215
happyReduction_215 (HappyAbsSyn94  happy_var_2)
	(HappyAbsSyn95  happy_var_1)
	 =  HappyAbsSyn95
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_215 _ _  = notHappyAtAll 

happyReduce_216 = happySpecReduce_0  95 happyReduction_216
happyReduction_216  =  HappyAbsSyn95
		 ([]
	)

happyReduce_217 = happySpecReduce_1  96 happyReduction_217
happyReduction_217 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn96
		 (Id (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_217 _  = notHappyAtAll 

happyReduce_218 = happySpecReduce_1  96 happyReduction_218
happyReduction_218 (HappyAbsSyn98  happy_var_1)
	 =  HappyAbsSyn96
		 (happy_var_1
	)
happyReduction_218 _  = notHappyAtAll 

happyReduce_219 = happySpecReduce_1  97 happyReduction_219
happyReduction_219 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn97
		 (Id (pos happy_var_1) (tokValue happy_var_1)
	)
happyReduction_219 _  = notHappyAtAll 

happyReduce_220 = happySpecReduce_3  97 happyReduction_220
happyReduction_220 (HappyTerminal happy_var_3)
	_
	(HappyAbsSyn96  happy_var_1)
	 =  HappyAbsSyn97
		 (Path (nodeData happy_var_1) happy_var_1 (tokValue happy_var_3)
	)
happyReduction_220 _ _ _  = notHappyAtAll 

happyReduce_221 = happySpecReduce_3  98 happyReduction_221
happyReduction_221 (HappyAbsSyn99  happy_var_3)
	_
	(HappyAbsSyn96  happy_var_1)
	 =  HappyAbsSyn98
		 (Path (nodeData happy_var_1) happy_var_1 (tokValue happy_var_3)
	)
happyReduction_221 _ _ _  = notHappyAtAll 

happyReduce_222 = happySpecReduce_1  99 happyReduction_222
happyReduction_222 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn99
		 (happy_var_1
	)
happyReduction_222 _  = notHappyAtAll 

happyReduce_223 = happySpecReduce_1  99 happyReduction_223
happyReduction_223 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn99
		 (happy_var_1
	)
happyReduction_223 _  = notHappyAtAll 

happyReduce_224 = happySpecReduce_1  100 happyReduction_224
happyReduction_224 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (happy_var_1
	)
happyReduction_224 _  = notHappyAtAll 

happyReduce_225 = happySpecReduce_1  100 happyReduction_225
happyReduction_225 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId "="
	)
happyReduction_225 _  = notHappyAtAll 

happyReduce_226 = happySpecReduce_2  100 happyReduction_226
happyReduction_226 (HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId $ "=" ++ tokValue happy_var_2
	)
happyReduction_226 _ _  = notHappyAtAll 

happyReduce_227 = happySpecReduce_1  100 happyReduction_227
happyReduction_227 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId "|"
	)
happyReduction_227 _  = notHappyAtAll 

happyReduce_228 = happySpecReduce_2  100 happyReduction_228
happyReduction_228 (HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId $ "|" ++ tokValue happy_var_2
	)
happyReduction_228 _ _  = notHappyAtAll 

happyReduce_229 = happySpecReduce_1  100 happyReduction_229
happyReduction_229 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId "<"
	)
happyReduction_229 _  = notHappyAtAll 

happyReduce_230 = happySpecReduce_1  100 happyReduction_230
happyReduction_230 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId ">"
	)
happyReduction_230 _  = notHappyAtAll 

happyReduce_231 = happySpecReduce_2  100 happyReduction_231
happyReduction_231 (HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId $ "<" ++ tokValue happy_var_2
	)
happyReduction_231 _ _  = notHappyAtAll 

happyReduce_232 = happySpecReduce_2  100 happyReduction_232
happyReduction_232 (HappyAbsSyn100  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn100
		 (Token (pos happy_var_1) $ TokenSpecialId $ ">" ++ tokValue happy_var_2
	)
happyReduction_232 _ _  = notHappyAtAll 

happyReduce_233 = happySpecReduce_1  101 happyReduction_233
happyReduction_233 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn101
		 (happy_var_1
	)
happyReduction_233 _  = notHappyAtAll 

happyReduce_234 = happySpecReduce_1  101 happyReduction_234
happyReduction_234 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn101
		 (happy_var_1
	)
happyReduction_234 _  = notHappyAtAll 

happyReduce_235 = happySpecReduce_1  101 happyReduction_235
happyReduction_235 (HappyAbsSyn100  happy_var_1)
	 =  HappyAbsSyn101
		 (happy_var_1
	)
happyReduction_235 _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Token _ TokenEOF -> action 156 156 tk (HappyState action) sts stk;
	Token _ TokenModule -> cont 102;
	Token _ TokenImport -> cont 103;
	Token _ TokenType -> cont 104;
	Token _ TokenInterface -> cont 105;
	Token _ TokenFun -> cont 106;
	Token _ TokenImp -> cont 107;
	Token _ TokenTest -> cont 108;
	Token _ TokenStruct -> cont 109;
	Token _ TokenLet -> cont 110;
	Token _ TokenTrue -> cont 111;
	Token _ TokenFalse -> cont 112;
	Token _ TokenIf -> cont 113;
	Token _ TokenElse -> cont 114;
	Token _ TokenSwitch -> cont 115;
	Token _ TokenCond -> cont 116;
	Token _ TokenCase -> cont 117;
	Token _ TokenPrecedence -> cont 118;
	Token _ TokenPrim -> cont 119;
	Token _ TokenPrimType -> cont 120;
	Token _ TokenProtocol -> cont 121;
	Token _ TokenWhen -> cont 122;
	Token _ TokenOn -> cont 123;
	Token _ TokenInfixl -> cont 124;
	Token _ TokenExcept -> cont 125;
	Token _ TokenRenaming -> cont 126;
	Token _ TokenAssign -> cont 127;
	Token _ TokenArrow -> cont 128;
	Token _ TokenRocket -> cont 129;
	Token _ TokenDblColon -> cont 130;
	Token _ TokenPctLParen -> cont 131;
	Token _ TokenPctLBrace -> cont 132;
	Token _ TokenLBracket -> cont 133;
	Token _ TokenRBracket -> cont 134;
	Token _ TokenLBrace -> cont 135;
	Token _ TokenRBrace -> cont 136;
	Token _ TokenLParen -> cont 137;
	Token _ TokenRParen -> cont 138;
	Token _ TokenLt -> cont 139;
	Token _ TokenGt -> cont 140;
	Token _ TokenPipe -> cont 141;
	Token _ TokenSemi -> cont 142;
	Token _ TokenDot -> cont 143;
	Token _ TokenEq -> cont 144;
	Token _ TokenColon -> cont 145;
	Token _ TokenComma -> cont 146;
	Token _ TokenUnderscore -> cont 147;
	Token _ TokenAtSymbol -> cont 148;
	Token _ TokenHash -> cont 149;
	Token _ (TokenNumLit _) -> cont 150;
	Token _ (TokenSimpleId _) -> cont 151;
	Token _ (TokenMixedId _) -> cont 152;
	Token _ (TokenSpecialId _) -> cont 153;
	Token _ (TokenString _) -> cont 154;
	Token _ (TokenChar _) -> cont 155;
	_ -> happyError' tk
	})

happyError_ 156 tk = happyError' tk
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

ruleParseTopLevel = happySomeParser where
  happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn5 z -> happyReturn z; _other -> notHappyAtAll })

ruleParseInteractive = happySomeParser where
  happySomeParser = happyThen (happyParse action_1) (\x -> case x of {HappyAbsSyn6 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


pos :: Token -> SourcePos
pos (Token sourcePos _) = sourcePos

firstPos :: AstNode a => [a SourcePos RawId] -> SourcePos
firstPos [] = SourcePos "" 0 0
firstPos (e:_) = nodeData e

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

getIdStr :: Token -> Alex String
getIdStr tok@(Token _ tokC) =
  case tokC of
    TokenSimpleId s  -> return s
    TokenMixedId s   -> return s
    TokenSpecialId s -> return s
    _                -> happyError tok

expectContextSensitiveKw :: Token -> String -> Alex Bool
expectContextSensitiveKw tok matchStr = do
  str <- getIdStr tok
  unless (str == matchStr) $ happyError tok
  return True 

happyError :: Token -> Alex a
happyError (Token (SourcePos _ line col) t) =
  alexError' (AlexPn 0 line col) ("parse error at token '" ++ unlex t ++ "'")


parse :: Alex a -> FilePath -> String -> Either Err a
parse rule filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' rule filePath input


parseInteractive :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseInteractive = parse ruleParseInteractive


parseTopLevel :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseTopLevel = parse ruleParseTopLevel
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 16 "<built-in>" #-}
{-# LINE 1 "/Applications/ghc-7.10.3.app/Contents/lib/ghc-7.10.3/include/ghcversion.h" #-}


















{-# LINE 17 "<built-in>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 


{-# LINE 13 "templates/GenericTemplate.hs" #-}


{-# LINE 46 "templates/GenericTemplate.hs" #-}









{-# LINE 67 "templates/GenericTemplate.hs" #-}


{-# LINE 77 "templates/GenericTemplate.hs" #-}










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


{-# LINE 155 "templates/GenericTemplate.hs" #-}

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

