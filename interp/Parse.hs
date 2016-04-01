{-# OPTIONS_GHC -w #-}
module Parse where

import Control.Monad.Except
import Lex
import Syntax
import Control.Applicative(Applicative(..))

-- parser produced by Happy Version 1.19.4

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13
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

action_0 (14) = happyShift action_7
action_0 (15) = happyShift action_8
action_0 (16) = happyShift action_9
action_0 (21) = happyShift action_10
action_0 (22) = happyShift action_11
action_0 (28) = happyShift action_12
action_0 (33) = happyShift action_13
action_0 (39) = happyShift action_14
action_0 (40) = happyShift action_15
action_0 (4) = happyGoto action_16
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (9) = happyGoto action_5
action_0 (13) = happyGoto action_6
action_0 _ = happyReduce_4

action_1 (14) = happyShift action_7
action_1 (15) = happyShift action_8
action_1 (16) = happyShift action_9
action_1 (21) = happyShift action_10
action_1 (22) = happyShift action_11
action_1 (28) = happyShift action_12
action_1 (33) = happyShift action_13
action_1 (39) = happyShift action_14
action_1 (40) = happyShift action_15
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (9) = happyGoto action_5
action_1 (13) = happyGoto action_6
action_1 _ = happyFail

action_2 (14) = happyShift action_7
action_2 (15) = happyShift action_8
action_2 (16) = happyShift action_9
action_2 (21) = happyShift action_10
action_2 (22) = happyShift action_11
action_2 (28) = happyShift action_12
action_2 (33) = happyShift action_13
action_2 (39) = happyShift action_14
action_2 (40) = happyShift action_15
action_2 (6) = happyGoto action_29
action_2 (7) = happyGoto action_4
action_2 (9) = happyGoto action_5
action_2 (13) = happyGoto action_6
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 (28) = happyShift action_25
action_4 (31) = happyShift action_26
action_4 (32) = happyShift action_27
action_4 (34) = happyShift action_28
action_4 _ = happyFail

action_5 _ = happyReduce_13

action_6 (35) = happyShift action_24
action_6 _ = happyReduce_18

action_7 (26) = happyShift action_23
action_7 _ = happyFail

action_8 (40) = happyShift action_22
action_8 (13) = happyGoto action_21
action_8 _ = happyFail

action_9 (40) = happyShift action_20
action_9 _ = happyFail

action_10 _ = happyReduce_16

action_11 _ = happyReduce_17

action_12 (14) = happyShift action_7
action_12 (15) = happyShift action_8
action_12 (16) = happyShift action_9
action_12 (21) = happyShift action_10
action_12 (22) = happyShift action_11
action_12 (28) = happyShift action_12
action_12 (33) = happyShift action_13
action_12 (39) = happyShift action_14
action_12 (40) = happyShift action_15
action_12 (7) = happyGoto action_19
action_12 (9) = happyGoto action_5
action_12 (13) = happyGoto action_6
action_12 _ = happyFail

action_13 (14) = happyShift action_7
action_13 (15) = happyShift action_8
action_13 (16) = happyShift action_9
action_13 (21) = happyShift action_10
action_13 (22) = happyShift action_11
action_13 (28) = happyShift action_12
action_13 (33) = happyShift action_13
action_13 (39) = happyShift action_14
action_13 (40) = happyShift action_15
action_13 (7) = happyGoto action_18
action_13 (9) = happyGoto action_5
action_13 (13) = happyGoto action_6
action_13 _ = happyFail

action_14 _ = happyReduce_15

action_15 (23) = happyShift action_17
action_15 _ = happyReduce_28

action_16 (41) = happyAccept
action_16 _ = happyFail

action_17 (14) = happyShift action_7
action_17 (15) = happyShift action_8
action_17 (16) = happyShift action_9
action_17 (21) = happyShift action_10
action_17 (22) = happyShift action_11
action_17 (28) = happyShift action_12
action_17 (33) = happyShift action_13
action_17 (39) = happyShift action_14
action_17 (40) = happyShift action_15
action_17 (7) = happyGoto action_38
action_17 (9) = happyGoto action_5
action_17 (13) = happyGoto action_6
action_17 _ = happyFail

action_18 (28) = happyShift action_25
action_18 (31) = happyShift action_26
action_18 (32) = happyShift action_27
action_18 _ = happyReduce_10

action_19 (28) = happyShift action_25
action_19 (29) = happyShift action_37
action_19 (31) = happyShift action_26
action_19 (32) = happyShift action_27
action_19 _ = happyFail

action_20 (36) = happyShift action_36
action_20 _ = happyFail

action_21 (35) = happyShift action_24
action_21 _ = happyReduce_11

action_22 _ = happyReduce_28

action_23 (14) = happyShift action_7
action_23 (15) = happyShift action_8
action_23 (16) = happyShift action_9
action_23 (21) = happyShift action_10
action_23 (22) = happyShift action_11
action_23 (28) = happyShift action_12
action_23 (33) = happyShift action_13
action_23 (39) = happyShift action_14
action_23 (40) = happyShift action_15
action_23 (5) = happyGoto action_35
action_23 (6) = happyGoto action_3
action_23 (7) = happyGoto action_4
action_23 (9) = happyGoto action_5
action_23 (13) = happyGoto action_6
action_23 _ = happyReduce_4

action_24 (40) = happyShift action_34
action_24 _ = happyFail

action_25 (14) = happyShift action_7
action_25 (15) = happyShift action_8
action_25 (16) = happyShift action_9
action_25 (21) = happyShift action_10
action_25 (22) = happyShift action_11
action_25 (28) = happyShift action_12
action_25 (33) = happyShift action_13
action_25 (39) = happyShift action_14
action_25 (40) = happyShift action_15
action_25 (7) = happyGoto action_32
action_25 (8) = happyGoto action_33
action_25 (9) = happyGoto action_5
action_25 (13) = happyGoto action_6
action_25 _ = happyFail

action_26 (14) = happyShift action_7
action_26 (15) = happyShift action_8
action_26 (16) = happyShift action_9
action_26 (21) = happyShift action_10
action_26 (22) = happyShift action_11
action_26 (28) = happyShift action_12
action_26 (33) = happyShift action_13
action_26 (39) = happyShift action_14
action_26 (40) = happyShift action_15
action_26 (7) = happyGoto action_31
action_26 (9) = happyGoto action_5
action_26 (13) = happyGoto action_6
action_26 _ = happyFail

action_27 (14) = happyShift action_7
action_27 (15) = happyShift action_8
action_27 (16) = happyShift action_9
action_27 (21) = happyShift action_10
action_27 (22) = happyShift action_11
action_27 (28) = happyShift action_12
action_27 (33) = happyShift action_13
action_27 (39) = happyShift action_14
action_27 (40) = happyShift action_15
action_27 (7) = happyGoto action_30
action_27 (9) = happyGoto action_5
action_27 (13) = happyGoto action_6
action_27 _ = happyFail

action_28 _ = happyReduce_5

action_29 _ = happyReduce_3

action_30 (28) = happyShift action_25
action_30 (31) = happyShift action_26
action_30 (32) = happyShift action_27
action_30 _ = happyReduce_7

action_31 (28) = happyShift action_25
action_31 (31) = happyShift action_26
action_31 (32) = happyShift action_27
action_31 _ = happyReduce_6

action_32 (28) = happyShift action_25
action_32 (31) = happyShift action_26
action_32 (32) = happyShift action_27
action_32 _ = happyReduce_19

action_33 (29) = happyShift action_44
action_33 (38) = happyShift action_45
action_33 _ = happyFail

action_34 _ = happyReduce_29

action_35 (14) = happyShift action_7
action_35 (15) = happyShift action_8
action_35 (16) = happyShift action_9
action_35 (21) = happyShift action_10
action_35 (22) = happyShift action_11
action_35 (27) = happyShift action_43
action_35 (28) = happyShift action_12
action_35 (33) = happyShift action_13
action_35 (39) = happyShift action_14
action_35 (40) = happyShift action_15
action_35 (6) = happyGoto action_29
action_35 (7) = happyGoto action_4
action_35 (9) = happyGoto action_5
action_35 (13) = happyGoto action_6
action_35 _ = happyFail

action_36 (30) = happyShift action_42
action_36 (40) = happyShift action_22
action_36 (10) = happyGoto action_39
action_36 (11) = happyGoto action_40
action_36 (13) = happyGoto action_41
action_36 _ = happyFail

action_37 _ = happyReduce_9

action_38 (28) = happyShift action_25
action_38 (31) = happyShift action_26
action_38 (32) = happyShift action_27
action_38 _ = happyReduce_12

action_39 (30) = happyShift action_42
action_39 (11) = happyGoto action_48
action_39 _ = happyReduce_22

action_40 _ = happyReduce_23

action_41 (35) = happyShift action_24
action_41 _ = happyReduce_21

action_42 (40) = happyShift action_47
action_42 _ = happyFail

action_43 _ = happyReduce_14

action_44 _ = happyReduce_8

action_45 (14) = happyShift action_7
action_45 (15) = happyShift action_8
action_45 (16) = happyShift action_9
action_45 (21) = happyShift action_10
action_45 (22) = happyShift action_11
action_45 (28) = happyShift action_12
action_45 (33) = happyShift action_13
action_45 (39) = happyShift action_14
action_45 (40) = happyShift action_15
action_45 (7) = happyGoto action_46
action_45 (9) = happyGoto action_5
action_45 (13) = happyGoto action_6
action_45 _ = happyFail

action_46 (28) = happyShift action_25
action_46 (31) = happyShift action_26
action_46 (32) = happyShift action_27
action_46 _ = happyReduce_20

action_47 (40) = happyShift action_22
action_47 (12) = happyGoto action_49
action_47 (13) = happyGoto action_50
action_47 _ = happyFail

action_48 _ = happyReduce_24

action_49 (40) = happyShift action_22
action_49 (13) = happyGoto action_51
action_49 _ = happyReduce_25

action_50 (35) = happyShift action_24
action_50 _ = happyReduce_26

action_51 (35) = happyShift action_24
action_51 _ = happyReduce_27

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1
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

happyReduce_8 = happyReduce 4 7 happyReduction_8
happyReduction_8 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ExpApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_9 = happySpecReduce_3  7 happyReduction_9
happyReduction_9 _
	(HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (happy_var_2
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_2  7 happyReduction_10
happyReduction_10 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (ExpNot happy_var_2
	)
happyReduction_10 _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_2  7 happyReduction_11
happyReduction_11 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (ExpImport happy_var_2
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  7 happyReduction_12
happyReduction_12 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenId happy_var_1))
	 =  HappyAbsSyn7
		 (ExpAssign happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  7 happyReduction_13
happyReduction_13 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpTypeDec happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happyReduce 4 7 happyReduction_14
happyReduction_14 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ExpModule happy_var_3
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_1  7 happyReduction_15
happyReduction_15 (HappyTerminal (TokenNumLit happy_var_1))
	 =  HappyAbsSyn7
		 (ExpNum happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  7 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn7
		 (ExpBool True
	)

happyReduce_17 = happySpecReduce_1  7 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn7
		 (ExpBool False
	)

happyReduce_18 = happySpecReduce_1  7 happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn7
		 (ExpQualId happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  8 happyReduction_19
happyReduction_19 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  8 happyReduction_20
happyReduction_20 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happyReduce 4 9 happyReduction_21
happyReduction_21 ((HappyAbsSyn13  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (TypeDecTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_22 = happyReduce 4 9 happyReduction_22
happyReduction_22 ((HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenId happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (TypeDecAdt happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_23 = happySpecReduce_1  10 happyReduction_23
happyReduction_23 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 ([happy_var_1]
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  10 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  11 happyReduction_25
happyReduction_25 (HappyAbsSyn12  happy_var_3)
	(HappyTerminal (TokenId happy_var_2))
	_
	 =  HappyAbsSyn11
		 (AdtAlternative happy_var_2 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  12 happyReduction_26
happyReduction_26 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 ([happy_var_1]
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  12 happyReduction_27
happyReduction_27 (HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  13 happyReduction_28
happyReduction_28 (HappyTerminal (TokenId happy_var_1))
	 =  HappyAbsSyn13
		 (Id happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  13 happyReduction_29
happyReduction_29 (HappyTerminal (TokenId happy_var_3))
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (Path happy_var_1 happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 41 41 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenModule -> cont 14;
	TokenImport -> cont 15;
	TokenType -> cont 16;
	TokenInterface -> cont 17;
	TokenFun -> cont 18;
	TokenImp -> cont 19;
	TokenTest -> cont 20;
	TokenTrue -> cont 21;
	TokenFalse -> cont 22;
	TokenAssign -> cont 23;
	TokenLBracket -> cont 24;
	TokenRBracket -> cont 25;
	TokenLBrace -> cont 26;
	TokenRBrace -> cont 27;
	TokenLParen -> cont 28;
	TokenRParen -> cont 29;
	TokenPipe -> cont 30;
	TokenPlus -> cont 31;
	TokenMinus -> cont 32;
	TokenExclamation -> cont 33;
	TokenSemi -> cont 34;
	TokenDot -> cont 35;
	TokenEq -> cont 36;
	TokenColon -> cont 37;
	TokenComma -> cont 38;
	TokenNumLit happy_dollar_dollar -> cont 39;
	TokenId happy_dollar_dollar -> cont 40;
	_ -> happyError' (tk:tks)
	}

happyError_ 41 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

happyThen :: () => Except String a -> (a -> Except String b) -> Except String b
happyThen = ((>>=))
happyReturn :: () => a -> Except String a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Except String a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> Except String a
happyError' = parseError

parseIt tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError _ = error "Parse error"

parse = parseIt . scan
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

