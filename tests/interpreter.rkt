#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it applies built-in primitives"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = prim(println)(42)
      }
      '("42")))

  (test-case "it applies functions from core modules"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = IO.println(42)
      }
      '("42")))

  (test-case "it rejects application of unknown primitives"
    (check-match
      @interp-sexp-with-wrapper-module{
        main(_) = prim(foo)(42)
      }
      `(AtPos ,_ (CompilerModule Typecheck) (PrimUnknown foo))))

  (test-case "it evaluates built-in integer primitives"
    (check-match
      @interp-lines-with-wrapper-module{
        main(_) = IO.println(prim(intEq)(3, 4))
      }
      '("False")))

  (test-case "it evaluates (in)equality comparisons on ints"
    (check-match
      @interp-lines-with-wrapper-module{
        main(_) = {
          IO.println(4 < 5)
          IO.println(99 == 99)
          IO.println(5 >= 5)
          IO.println(21 + 3 != 8 * 3)
        }
      }
      '("True"
        "True"
        "True"
        "False")))

  (test-case "it evaluates literals"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          IO.println(True)
          IO.println(False)
          IO.println(42)
          IO.println("hello")
          IO.println('f')
        }
      }
      '("True"
        "False"
        "42"
        "\"hello\""
        "'f'")))

  (test-case "it evaluates arithmetic exps"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          IO.println(4 + 3)
          IO.println(4 + 3 * 2)
          IO.println(4 - 3 / 3)
          IO.println(3 * 2 + 4)
          IO.println(((4 + 3) - 42 * 3) + 100 / 10)
          IO.println((4 + 3) * 2)
          IO.println(4 + 8 / 4)
        }
      }
      '("7"
        "10"
        "3"
        "10"
        "-109"
        "14"
        "6")))

  (test-case "it evaluates arithmetic expressions involving application"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        f : Int -> Int
        f(x) = x

        main(_) = IO.println(3 + f(4))
      }
      7))

  (test-case "it evaluates string patterns"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let s = switch ("hello") {
            "foo" -> "bar"
            "hello" -> "world"
            _ -> "no match"
          }

          IO.println(s)
        }
      }
      "world"))

  (test-case "it evaluates if-else expressions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println(if (True) 42 43)
      }
      42))

  (test-case "it takes the else branch on false"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println(if (False) 42 43)
      }
      43))

  (test-case "it evaluates non-literals in the test position"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        f(x) = {
          if (x) True False
        }

        main(_) = {
          if (f(True))
            IO.println(42)
            IO.println(43)
        }
      }
      42))

  (test-case "it evaluates nested if-else expressions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          IO.println(42 + (if (True) 1 2))
        }
      }
      43))

  (test-case "it returns function values"
    (check-equal?
      @interp-lines-with-wrapper-module{
        f() = 42

        main(_) = IO.println(f)
      }
      '("fun f : (-> Int)")))

  (test-case "it returns function values with closures"
    (check-equal?
      @interp-lines-with-wrapper-module{
        let v = 1
        f() = v

        main(_) = IO.println(f)
      }
      '("fun f : (-> Int)")))

  (test-case "it evaluates the shorthand syntax for single-expression function bodies"
    (check-equal?
      @interp-lines-with-wrapper-module{
        weird : Int -> Int -> Int
        weird(0, 0) = 100
        weird(x, y) = x + y

        main(_) = IO.println(weird(1, 2))
      }
      '("3")))

  (test-case "it applies functions on modules with multiple decs"
    (check-equal?
      @interp-sexp{
        module m {
          f() = 42
          g() = 43
        }

        module M {
          import IO
          import m
          main(_) = IO.println(m.g())
        }
      }
      43))

  (test-case "it can apply module-exported functions"
    (check-equal?
      @interp-sexp{
        module m {
          import Core

          f : (-> Int)
          f() = 42
        }

        module Main {
          import IO
          import m
          main(_) = IO.println(m.f())
        }
      }
      42))

  (test-case "it applies defined functions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        f : (-> Int)
        f() = 42

        main(_) = IO.println(f())
      }
      42))

  (test-case "it substitutes function args"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        f : Int -> Int
        f(x) = x
        main(_) = IO.println(f(42))
      }
      42))

  (test-case "it captures bindings from the env in function bodies"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        let v = 42

        f : (-> Int)
        f() = v
        main(_) = IO.println(f())
      }
      42))

  (test-case "it evaluates higher-order functions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        f : (Int -> Int) -> Int -> Int
        f(g, x) = {
          g(10) + x
        }

        h : Int -> Int
        h(x) = {
          x + 1
        }

        main(_) = IO.println(f(h, 3))
      }
      14))

  (test-case "it evaluates recursive functions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        bnot(True) = False
        bnot(_) = True

        f : Int -> Int
        f(x) = {
          let isZero = switch (x) {
            0 -> True
            _ -> False
          }

          if (bnot(isZero))
            x + f(x - 1)
            x
        }

        main(_) = IO.println(f(4))
      }
      10))

  (test-case "it evaluates accesses on module-level scalars"
    (check-equal?
      @interp-sexp{
        module m {
          let v = 6
        }

        module Main {
          import IO
          import m
          main(_) = IO.println(m.v)
        }
      }
      6))

  (test-case "it evaluates accesses on nested-module-level scalars"
    (check-equal?
      @interp-sexp{
        module m.n {
          let v = 6
        }

        module Main {
          import IO
          import m.n

          main(_) = println(m.n.v)
        }
      }
      6))

  (test-case "it constructs ADT instances"
    (check-equal?
      @interp-lines-with-wrapper-module{
        type IntOption =
          | Just(Int)
          | None

        main(_) = IO.println(Just(42))
      }
      '("Just(42)")))

  (test-case "it evaluates multi-arity ADT constructors"
    (check-equal?
      @interp-lines-with-wrapper-module{
        type T =
          | IBTuple(Int, Bool)
          | B(Bool)

        main(_) = IO.println(%(B(True), IBTuple(2, False)))
      }
      '("%(B(True), IBTuple(2, False))")))

  (test-case "it evaluates tuple expressions"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = IO.println(%(4, False))
      }
      '("%(4, False)")))

  (test-case "it evaluates 3-tuples"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = IO.println(%(3, True, 4))
      }
      '("%(3, True, 4)")))

  (test-case "it applies functions with tuple arguments"
    (check-equal?
      @interp-lines-with-wrapper-module{
        f : %(Int, Bool) -> %(Int, Bool)
        f(pair) = pair

        main(_) = IO.println(f(%(5, False)))
      }
      '("%(5, False)")))

  (test-case "it evaluates list expressions"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = IO.println([1, 2, 3])
      }
      '("[1, 2, 3]")))

  (test-case "it evaluates list bindings"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          let ls = [1, 2, 3, 4]
          IO.println(ls)
        }
      }
      '("[1, 2, 3, 4]")))

  (test-case "it evaluates list cons operations"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = IO.println(1 @"@" [2, 3, 4])
      }
      '("[1, 2, 3, 4]")))

  (test-case "it makes cons right-associative"
    (check-equal?
      @interp-lines-with-wrapper-module{
        f : Int -> Int -> Int[]
        f(x, y) = {
          x @"@" y @"@" [3, 4, 5]
        }

        main(_) = IO.println(f(1, 2))
      }
      '("[1, 2, 3, 4, 5]")))

  (test-case "it evaluates list patterns"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let [a, b, c] = [1, 2, 3]
          IO.println(a + b + c)
        }
      }
      6))

  (test-case "it evaluates list patterns with pattern subexpressions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let [_, b, 3] = [1, 2, 3]
          IO.println(b)
        }
      }
      2))

  (test-case "it fails to bind to list patterns if lengths don't match"
    (check-match
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let [a, b] = []
          IO.println(a)
        }
      }
      `(AtPos ,_ (CompilerModule Interp) (PatMatchFail ,_ (List ())))))

  (test-case "it evaluates list cons patterns"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          let x @"@" xs = [1, 2, 3, 4]
          IO.println(%(x, xs))
        }
      }
      '("%(1, [2, 3, 4])")))

  (test-case "it evaluates cons patterns with list pat subexpressions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let x @"@" [] = [3]
          IO.println(x)
        }
      }
      3))

  (test-case "it evaluates cons patterns in sublists"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          let xs @"@" [[3, 4], [x, _, z]] = [[1, 2], [3, 4], [5, 6, 7]]
          IO.println(%(xs, x, z))
        }
      }
      '("%([1, 2], 5, 7)")))

  (test-case "it evaluates tuple pattern bindings"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let %(a, b) = %(1, True)
          IO.println(b)
        }
      }
      'True))

  (test-case "it evaluates wildcards in tuple patterns"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let %(_, b) = %(1, 43)
          IO.println(b)
        }
      }
      43))

  (test-case "it throws away expressions bound to wildcards"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let _ = 42
          IO.println(43)
        }
      }
      43))

  (test-case "it evaluates switch expressions"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          let v = %(4, False)
          let x = switch (v) {
            %(0, _) -> 1
            %(4, True) -> 2
            %(_, False) -> 3
            _ -> 4
          }

          IO.println(x)
        }
      }
      '("3")))

  (test-case "it evaluates switch expressions with mixed block-style and short-form bodies"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          let x = switch ([1, 2, 3]) {
            [x, y] -> {
              let z = x + y
              z + 1
            }
            _ -> 3
          }

          IO.println(x)
        }
      }
      '("3")))

  (test-case "it evaluates switch expressions with mixed block-style and short-form bodies"
    (check-equal?
      @interp-lines-with-wrapper-module{
        main(_) = {
          IO.println(switch ([1, 2, 3]) {
              [x, y, z] -> {
                let v = z + y
                v * 2
              }
              _ -> 3
            }
          )
        }
      }
      '("10")))

  (test-case "it evaluates patterns in argument-binding position"
    (check-equal?
      @interp-lines-with-wrapper-module{
        IsZero : Int -> Bool
        IsZero(0) = True
        IsZero(_) = False

        main(_) = IO.println(%(IsZero(1), IsZero(0)))
      }
      '("%(False, True)")))

  (test-case "it evaluates tuple patterns in argument bindings"
    (check-equal?
      @interp-lines-with-wrapper-module{
        Fst : %(Int, Bool) -> Int
        Fst(%(a, _)) = a

        Snd : %(Int, Bool) -> Bool
        Snd(%(_, b)) = b

        main(_) = {
          let v = %(42, False)
          IO.println(%(Snd(v), Fst(v)))
        }
      }
      '("%(False, 42)")))

  (test-case "it returns an error for non-exhaustive patterns in argument bindings"
    (check-match
      @interp-sexp-with-wrapper-module{
        IsZero : Int -> Bool
        IsZero(0) = True

        main(_) = IO.println(IsZero(1))
      }
      `(AtPos ,_ (CompilerModule Interp) (NonExhaustivePattern ,_ (Tuple (1))))))

  (test-case "it evaluates ADT patterns"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        type StringOption =
          | Some(String)
          | None

        main(_) = {
          let Some(x) = Some("hello world")
          IO.println(x)
        }
      }
      "hello world"))

  (test-case "it returns an error for non-exhaustive patterns in ADT bindings"
    (check-match
      @interp-sexp-with-wrapper-module{
        type IntOption =
          | Some(Int)
          | None

        main(_) = {
          let None() = Some(10)
          IO.println("OMG!")
        }
      }
      `(AtPos
         ,_
         (CompilerModule Interp)
         (PatMatchFail
           ,_
           (Adt (Id Some ,_) 0 (10))))))

  (test-case "it evaluates ADT argument patterns"
    (check-equal?
      @interp-lines-with-wrapper-module{
        type IntOption = | Some(Int) | None

        IsSome : IntOption -> Bool
        IsSome(Some(_)) = True
        IsSome(_) = False

        main(_) = {
          let s = Some(42)
          let Some(v) = s
          IO.println(%(IsSome(None()), IsSome(s), v))
        }
      }
      '("%(False, True, 42)")))

  (test-case "can encode a module with monomorphic list operations"
    (check-equal?
      @interp-lines{
        module IntList {
          import Core

          type t = Int[]
          type BoolList = Bool[]


          concat : t -> t -> t
          concat(xs, []) = xs
          concat([], ys) = ys
          concat(x @"@" xs, ys) = {
            x @"@" concat(xs, ys)
          }

          map : (Int -> Bool) -> t -> BoolList
          map(f, []) = []
          map(f, x @"@" xs) = {
            f(x) @"@" map(f, xs)
          }
        }

        module Main {
          import IO
          import IntList

          main(_) = {
            println(
              [
                IntList.concat([], []),
                IntList.concat([1, 2], []),
                IntList.concat([1, 2], [3, 4, 5])
              ]
            )
          }
        }
      }
      '("[[], [1, 2], [1, 2, 3, 4, 5]]")))

  (test-case "it evaluates recursive function defs that depend on pattern ordering"
    (check-equal?
      @interp-lines-with-wrapper-module{
        GetTwoOrLess : Int -> Int
        GetTwoOrLess(0) = 0
        GetTwoOrLess(1) = 1
        GetTwoOrLess(2) = 2
        GetTwoOrLess(x) = GetTwoOrLess(x - 1)

        main(_) = {
          IO.println(%(GetTwoOrLess(1), GetTwoOrLess(4)))
        }
      }
      '("%(1, 2)")))

  (test-case "it evaluates anonymous lambda expressions"
    (check-regexp-match
      #px"fun x\\d* : Int -> Int -> Int"
      @interp{
        module Main {
          import Core
          import IO
          
          main(_) = IO.println(fun(x, y) = { x + y })
        }
      }))

  (test-case "it evaluates anonymous function application"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println(fun (x, y) = { x + y }(1, 2))
      }
      3))

  (test-case "it evaluates polymorphic functions"
    (check-equal?
      @interp-lines{
        module Numbers {
          import Core

          isEven : Int -> Bool
          isEven(x) = {
            switch (x) {
              0 -> True
              1 -> False
              2 -> True
              _ -> isEven(x - 2)
            }
          }
        }

        module Lists {
          map<a, b> : (a -> b) -> a[] -> b[]
          map(_, []) = []
          map(f, x @"@" xs) = {
            f(x) @"@" map(f, xs)
          }
        }

        module Main {
          import IO
          import Lists
          import Numbers
          main(_) = {
            IO.println(Lists.map(fun(n) = { isEven(n) }, [1, 2, 3, 4]))
          }
        }
      }
      '("[False, True, False, True]")))

  (test-case "it evaluates a string-length function"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        len : String -> Int
        len("") = 0
        len(c @"@" cs) = { 1 + len(cs) }

        main(_) = IO.println(len("hello"))
      }
      5))

  (test-case "it accepts identifiers with non-alphanumeric characters"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = {
          let x/! = 1 + 2
          IO.println(x/!)
        }
      }
      3))

  (test-case "it accepts special characters in function names"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        foo/bar(n) = n + 1
        main(_) = IO.println(foo/bar(19) / 2)
      }
      10))

  (test-case "it evaluates infix application of binary functions"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        infixl (!!)(a, b) = a * b
        precedence !! 10

        main(_) = IO.println(2 !! 3 + 4)
      }
      14))

  (test-case "it evaluates clauses on custom infix operators"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println(True || False || False)
      }
      'True))

  (test-case "it evaluates a boolean AND infix operator"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println(True && False)
      }
      'False))

  (test-case "it evaluates recursive infix operators"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        infixl (~)(0, 0) = False
        infixl (~)(0, _) = True
        infixl (~)(_, 0) = False
        infixl (~)(x, y) = (x - 1) ~ (y - 1)

        infixl (~!)(0, 0) = True
        infixl (~!)(0, _) = True
        infixl (~!)(_, 0) = False
        infixl (~!)(x, y) = (x - 1) ~! (y - 1)

        main(_) = IO.println(3 ~ 4 && (10 ~! 10))
      }
      'True))


  (test-case "it evaluates user-defined precedence assignments"
    (check-equal?
      @interp-sexp{
        module Ops {
          import IO

          infixl (||)(True, _) = True
          infixl (||)(_, True) = True
          infixl (||)(_, _) = False

          //XOR
          infixl (!!)(False, False) = False
          infixl (!!)(True, True) = False
          infixl (!!)(_, _) = True

          precedence || 1
          precedence !! 2

          main(_) = println(True !! True || True)
        }
      }
      'False))

  (test-case "it evaluates user-defined arithmetic operators"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        //& = +
        //!! = *
        //~ = -
        //| = /
        infixl (&)(a, b) = a + b
        infixl (!)(a, b) = a * b
        infixl (~)(a, b) = a - b
        infixl (|)(a, b) = a / b

        precedence ! 1
        precedence | 1
        precedence & 2
        precedence ~ 2

        main(_) = IO.println(1 & 2 ! 3 ~ 4 | 4)
      }
      6))

  (test-case "it reorders expressions by user-defined precedence"
    (check-equal?
      @interp-sexp{
        module Test {
          import IO
          
          infixl (-)(a, b) = prim(intSub)(a, b)

          infixl (<)(0, 0) = False
          infixl (<)(0, _) = True
          infixl (<)(_, 0) = False
          infixl (<)(a, b) = a - 1 < b - 1

          precedence - 9
          precedence < 10

          infixl (&&)(True, True) = True
          infixl (&&)(_, _) = False

          precedence && 11

          main(_) = {
            let i = 1
            let j = 2
            let k = 3
            let l = cond {
              i < k && j < k -> 42
              _ -> 43
            }

            println(l)
          }
        }
      }
      42))

  (test-case "it allows direct references/application to operators"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        main(_) = IO.println((+)(1, 2))
      }
      3))

  (test-case "it returns operator function values"
    (check-equal?
      @interp-lines-with-wrapper-module{main(_) = IO.println((*))}
      '("fun * : Int -> Int -> Int")))

  (test-case "it distinguishes between types and values with the same name"
    (check-equal?
      @interp-sexp-with-wrapper-module{
        foo(a, b) = a + b
        type foo = Int

        main(_) = IO.println(foo(2, 4))
      }
      6))
)
