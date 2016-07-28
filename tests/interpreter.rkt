#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it applies built-in primitives"
    (check-equal?
      @interp-lines{
        main(_) = prim(println)(42)
      }
      '("42"
        "Unit")))

  (test-case "it applies functions from core modules"
    (check-equal?
      @interp-lines{
        main(_) = IO.println(42)
      }
      '("42"
        "Unit")))

  (test-case "it rejects application of unknown primitives"
    (check-match
      @interp-sexp{
        main(_) = prim(foo)(42)
      }
      `(AtPos ,_ (CompilerModule Types) (PrimUnknown foo))))

  (test-case "it evaluates built-in integer primitives"
    (check-match
      @interp-lines{
        main(_) = IO.println(prim(intEq)(3, 4))
      }
      '("False"
        "Unit")))

  (test-case "it evaluates (in)equality comparisons on ints"
    (check-match
      @interp-lines{
        main(_) {
          IO.println(4 < 5)
          IO.println(99 == 99)
          IO.println(5 >= 5)
          IO.println(21 + 3 != 8 * 3)
        }
      }
      '("True"
        "True"
        "True"
        "False"
        "Unit")))

  (test-case "it evaluates literals"
    (check-equal?
      @interp-lines{
        main(_) {
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
        "'f'"
        "Unit")))

  (test-case "it returns an error for unbound identifiers"
    (check-match
      @interp-sexp{main(_) = x}
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

  (test-case "it evaluates arithmetic exps"
    (check-equal?
      @interp-lines{
        main(_) {
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
        "6"
        "Unit")))

  (test-case "it evaluates arithmetic expressions involving application"
    (check-equal?
      @interp-sexp{
        f : Int -> Int
        f(x) = x

        main(_) = IO.println(3 + f(4))
      }
      7))

  (test-case "it evaluates string patterns"
    (check-equal?
      @interp-sexp{
        main(_) {
          def s = switch ("hello") {
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
      @interp-sexp{
        main(_) = IO.println(if (True) { 42 } else { 43 })
      }
      42))

  (test-case "it takes the else branch on false"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println(if (False) { 42 } else { 43 })
      }
      43))

  (test-case "it does not allow argument bindings to escape"
    (check-match
      @interp-sexp{
        f(x, runForever) {
          if (runForever) {
            f(x, runForever)
          } else {
            x
          }
        }

        main(_) = IO.println(runForever(3, False))
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier runForever))))

  (test-case "it evaluates non-literals in the test position"
    (check-equal?
      @interp-sexp{
        f(x) {
          if (x) { True } else { False }
        }

        main(_) {
          if (f(True)) {
            IO.println(42)
          } else {
            IO.println(43)
          }
        }
      }
      42))

  (test-case "it evaluates nested if-else expressions"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println(42 + (if (True) { 1 } else { 2 }))
      }
      43))

  (test-case "it returns function values"
    (check-equal?
      @interp-lines{
        f() = 42

        main(_) = IO.println(f)
      }
      '("fun f : Int"
        "Unit")))

  (test-case "it returns function values with closures"
    (check-equal?
      @interp-lines{
        def v = 1
        f() = v

        main(_) = IO.println(f)
      }
      '("fun f : Int"
        "Unit")))

  (test-case "it evaluates the shorthand syntax for single-expression function bodies"
    (check-equal?
      @interp-lines{
        weird : Int -> Int -> Int
        weird(0, 0) = 100
        weird(x, y) = x + y

        main(_) = IO.println(weird(1, 2))
      }
      '("3"
        "Unit")))

  (test-case "it adds definitions to module exports"
    (check-match
      @interp-sexp{
        module m { def v = 42 }
        main(_) = IO.println(m.v)
      }
      42))

  (test-case "it applies functions on modules with multiple decs"
    (check-equal?
      @interp-sexp{
        module m {
          f() = 42
          g() = 43
        }

        main(_) = IO.println(m.g())
      }
      43))

  (test-case "it returns values defined in modules"
    (check-equal?
      @interp-sexp{
        module m { def v = 42 }
        main(_) = IO.println(m.v)
      }
      42))

  (test-case "it can apply module-exported functions"
    (check-equal?
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = 42
        }

        main(_) = IO.println(m.f())
      }
      42))

  (test-case "it can apply module-exported functions occurring after a nested module dec"
    (check-equal?
      @interp-sexp{
        module m {
          module n { }

          f : (-> Int)
          f() = 42
        }

        main(_) = IO.println(m.f())
      }
      42))

  (test-case "it can apply module-exported functions occurring before a nested module dec"
    (check-equal?
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = 42

          module n { }
        }
        main(_) = IO.println(m.f())
      }
      42))

  (test-case "it returns values defined in nested modules"
    (check-equal?
      @interp-sexp{
        module a {
          module b {
            def v = 42
          }
        }

        main(_) = IO.println(a.b.v)
      }
      42))

  (test-case "it applies defined functions"
    (check-equal?
      @interp-sexp{
        f : (-> Int)
        f() = 42

        main(_) = IO.println(f())
      }
      42))

  (test-case "it substitutes function args"
    (check-equal?
      @interp-sexp{
        f : Int -> Int
        f(x) = x
        main(_) = IO.println(f(42))
      }
      42))

  (test-case "it correctly shadows bindings in function bodies"
    (check-equal?
      @interp-sexp{
        module m { }
        f : Int -> Int
        f(m) = m
        main(_) = IO.println(f(42))
      }
      42))

  (test-case "it captures bindings from the env in function bodies"
    (check-equal?
      @interp-sexp{
        def v = 42
        f : (-> Int)
        f() = v
        main(_) = IO.println(f())
      }
      42))

  (test-case "it returns nested module values"
    (check-match
      @interp-sexp{
        module m {
          module m' {
            g : (-> Int)
            g() { 43 }
          }

          f : (-> Int)
          f() { 42 }
        }

        main(_) = IO.println(m.m'.g())
      }
      43))

  (test-case "it resolves functions on nested modules"
    (check-equal?
      @interp-sexp{
        module m {
          module m' {
            g : (-> Int)
            g() = 43
          }

          f : (-> Int)
          f() = 42
        }

        main(_) = IO.println(m.m'.g())
      }
      43))

  (test-case "it evaluates functions with compound bodies on nested modules"
    (check-equal?
      @interp-sexp{
        module m {
          module m1 {
            g : Int -> Int -> Int
            g(x, y) { y + x }
          }

          f : (-> Int)
          f() = 42
        }

        main(_) = IO.println(m.m1.g(m.f(), 1))
      }
      43))

  (test-case "it evaluates higher-order functions"
    (check-equal?
      @interp-sexp{
        f : (Int -> Int) -> Int -> Int
        f(g, x) {
          g(10) + x
        }

        h : Int -> Int
        h(x) {
          x + 1
        }

        main(_) = IO.println(f(h, 3))
      }
      14))

  (test-case "it does not allow nested modules to escape the local env"
    (check-match
      @interp-sexp{
        module m {
          module m1 {
            g : Int -> Int -> Int
            g(x, y) {
              y + x
            }
          }
        }

        main(_) = IO.println(m1.g(1, 1))
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier m1))))

  (test-case "it does not capture id's in lexical scope for modules as exports"
    (check-match
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = 42

          module n { }
        }

        main(_) = IO.println(m.n.f())
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier f))))

  (test-case "it evaluates recursive functions"
    (check-equal?
      @interp-sexp{
        not(True) = False
        not(_) = True

        f : Int -> Int
        f(x) {
          def isZero = switch (x) {
            0 -> True
            _ -> False
          }

          if (not(isZero)) {
            x + f(x - 1)
          } else {
            x
          }
        }

        main(_) = IO.println(f(4))
      }
      10))

  (test-case "it resolves member accesses on captured modules"
    (check-equal?
      @interp-sexp{
        module m {
          module n {
            module o {
              def v = 42
            }
          }

          f : (-> Int)
          f() = n.o.v
        }

        main(_) = IO.println(m.f())
      }
      42))

  (test-case "it evaluates accesses on module-level scalars"
    (check-equal?
      @interp-sexp{
        module m {
          def v = 6
        }

        main(_) = IO.println(m.v)
      }
      6))

  (test-case "it can access prior bindings in a module closure"
    (check-match
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = 2
        }

        g : (-> Int)
        g() = 1

        module n {
          h() = m.f() + g()
        }

        main(_) = IO.println(n.h())
      }
      3))

  (test-case "it evaluates accesses on nested-module-level scalars"
    (check-equal?
      @interp-sexp{
        module m {
          module n {
            def v = 6
          }
        }

        main(_) = IO.println(m.n.v)
      }
      6))

  (test-case "it returns the empty struct"
    (check-match
      @interp-sexp{
        type t = struct { }

        main(_) = IO.println(t %{ })
      }
      't))

  #;(test-case "it evaluates struct instances"
    (check-match
      @interp-sexp{
        type Point = struct {
          Int X;
          Int Y;
        }

        main(_) = IO.println(Point %{ X = 3; Y = 4; })
      }
      'Point))

  #;(test-case "it evaluates struct field accesses"
    (check-equal?
      @interp-sexp{
        type Point = struct {
          Int X;
          Int Y;
        }

        main(_) {
          def p = Point %{ X = 3; Y = 4; }
          IO.println(Y(p))
        }
      }
      4))

  (test-case "it returns an error on undefined-field accesses"
    (check-match
      @interp-sexp{
        type t = struct { }

        main(_) {
          def v = t %{ }
          IO.println(x(v))
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

  #;(test-case "it evaluates nested struct field accesses"
    (check-equal?
      @interp-sexp{
        type Point = struct {
          Int X;
          Int Y;
        }

        type Line = struct {
          Point A;
          Point B;
        }

        main(_) {
          def l = Line %{
            A = Point %{ X = 0; Y = 0; };
            B = Point %{ X = 3; Y = 4; };
          }

          IO.println(Y(B(l)))
        }
      }
      4))

  (test-case "it evaluates module-exported struct types"
    (check-equal?
      @interp-sexp{
        module Geometry {
          type Point = struct {
            Int X;
            Int Y;
          }

          type Line = struct {
            Point A;
            Point B;
          }
        }

        main(_) {
          def l = Geometry.Line %{
            A = Geometry.Point %{ X = 0; Y = 0; };
            B = Geometry.Point %{ X = 3; Y = 4; };
          }

          IO.println(Geometry.Y(Geometry.B(l)))
        }
      }
      4))

  (test-case "it exports algebraic data type constructors"
    (check-regexp-match
      #px"fun x\\d* : Int -> IntOption"
      @interp{
        module Prims {
          type IntOption =
            | Just(Int)
            | None
        }

        main(_) = IO.println(Prims.Just)
      }))

  (test-case "it constructs ADT instances"
    (check-equal?
      @interp-lines{
        type IntOption =
          | Just(Int)
          | None

        main(_) = IO.println(Just(42))
      }
      '("Just(42)"
        "Unit")))

  (test-case "it scopes ADT defs/ctors to module exports"
    (check-match
      @interp-sexp{
        module m {
          type IntOption =
            | Some(Int)
            | None
        }

        main(_) = IO.println(Some(42))
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier Some))))

  (test-case "it evaluates multi-arity ADT constructors"
    (check-equal?
      @interp-lines{
        type T =
          | IBTuple(Int, Bool)
          | B(Bool)

        main(_) = IO.println(%(B(True), IBTuple(2, False)))
      }
      '("%(B(True), IBTuple(2, False))"
        "Unit")))

  (test-case "it evaluates tuple expressions"
    (check-equal?
      @interp-lines{
        main(_) = IO.println(%(4, False))
      }
      '("%(4, False)"
        "Unit")))

  (test-case "it evaluates 3-tuples"
    (check-equal?
      @interp-lines{
        main(_) = IO.println(%(3, True, 4))
      }
      '("%(3, True, 4)"
        "Unit")))

  (test-case "it applies functions with tuple arguments"
    (check-equal?
      @interp-lines{
        f : %(Int, Bool) -> %(Int, Bool)
        f(pair) = pair

        main(_) = IO.println(f(%(5, False)))
      }
      '("%(5, False)"
        "Unit")))

  (test-case "it evaluates list expressions"
    (check-equal?
      @interp-lines{
        main(_) = IO.println([1, 2, 3])
      }
      '("[1, 2, 3]"
        "Unit")))

  (test-case "it evaluates list bindings"
    (check-equal?
      @interp-lines{
        main(_) {
          def ls = [1, 2, 3, 4]
          IO.println(ls)
        }
      }
      '("[1, 2, 3, 4]"
        "Unit")))

  (test-case "it evaluates list cons operations"
    (check-equal?
      @interp-lines{
        main(_) = IO.println(1 :: [2, 3, 4])
      }
      '("[1, 2, 3, 4]"
        "Unit")))

  (test-case "it makes cons right-associative"
    (check-equal?
      @interp-lines{
        f : Int -> Int -> Int[]
        f(x, y) {
          x :: y :: [3, 4, 5]
        }

        main(_) = IO.println(f(1, 2))
      }
      '("[1, 2, 3, 4, 5]"
        "Unit")))

  (test-case "it evaluates list patterns"
    (check-equal?
      @interp-sexp{
        main(_) {
          def [a, b, c] = [1, 2, 3]
          IO.println(a + b + c)
        }
      }
      6))

  (test-case "it evaluates list patterns with pattern subexpressions"
    (check-equal?
      @interp-sexp{
        main(_) {
          def [_, b, 3] = [1, 2, 3]
          IO.println(b)
        }
      }
      2))

  (test-case "it fails to bind to list patterns if lengths don't match"
    (check-match
      @interp-sexp{
        main(_) {
          def [a, b] = []
          IO.println(a)
        }
      }
      `(AtPos ,_ (CompilerModule Interp) (PatMatchFail ,_ (List ())))))

  (test-case "it evaluates list cons patterns"
    (check-equal?
      @interp-lines{
        main(_) {
          def x::xs = [1, 2, 3, 4]
          IO.println(%(x, xs))
        }
      }
      '("%(1, [2, 3, 4])"
        "Unit")))

  (test-case "it evaluates cons patterns with list pat subexpressions"
    (check-equal?
      @interp-sexp{
        main(_) {
          def x::[] = [3]
          IO.println(x)
        }
      }
      3))

  (test-case "it evaluates cons patterns in sublists"
    (check-equal?
      @interp-lines{
        main(_) {
          def xs::[[3, 4], [x, _, z]] = [[1, 2], [3, 4], [5, 6, 7]]
          IO.println(%(xs, x, z))
        }
      }
      '("%([1, 2], 5, 7)"
        "Unit")))

  (test-case "it evaluates tuple pattern bindings"
    (check-equal?
      @interp-sexp{
        main(_) {
          def %(a, b) = %(1, True)
          IO.println(b)
        }
      }
      'True))

  (test-case "it evaluates wildcards in tuple patterns"
    (check-equal?
      @interp-sexp{
        main(_) {
          def %(_, b) = %(1, 43)
          IO.println(b)
        }
      }
      43))

  (test-case "it throws away expressions bound to wildcards"
    (check-equal?
      @interp-sexp{
        main(_) {
          def _ = 42
          IO.println(43)
        }
      }
      43))

  (test-case "it evaluates switch expressions"
    (check-equal?
      @interp-sexp{
        main(_) {
          def v = %(4, False)
          def x = switch (v) {
            %(0, _) -> 1
            %(4, True) -> 2
            %(_, False) -> 3
            _ -> 4
          }

          IO.println(x)
        }
      }
      3))

  (test-case "it evaluates switch expressions with mixed block-style and short-form bodies"
    (check-equal?
      @interp-sexp{
        main(_) {
          IO.println(switch ([1, 2, 3]) {
              [x, y, z] -> {
                def v = z + y
                v * 2
              }
              _ -> 3
            }
          )
        }
      }
      10))

  (test-case "it evaluates patterns in argument-binding position"
    (check-equal?
      @interp-lines{
        IsZero : Int -> Bool
        IsZero(0) = True
        IsZero(_) = False

        main(_) = IO.println(%(IsZero(1), IsZero(0)))
      }
      '("%(False, True)"
        "Unit")))

  (test-case "it evaluates tuple patterns in argument bindings"
    (check-equal?
      @interp-lines{
        Fst : %(Int, Bool) -> Int
        Fst(%(a, _)) = a

        Snd : %(Int, Bool) -> Bool
        Snd(%(_, b)) = b

        main(_) {
          def v = %(42, False)
          IO.println(%(Snd(v), Fst(v)))
        }
      }
      '("%(False, 42)"
        "Unit")))

  (test-case "it returns an error for non-exhaustive patterns in argument bindings"
    (check-match
      @interp-sexp{
        IsZero : Int -> Bool
        IsZero(0) = True

        main(_) = IO.println(IsZero(1))
      }
      `(AtPos ,_ (CompilerModule Interp) (NonExhaustivePattern ,_ (Tuple (1))))))

  (test-case "it evaluates ADT patterns"
    (check-equal?
      @interp-sexp{
        type String = Char[]
        type StringOption =
          | Some(String)
          | None

        main(_) {
          def Some(x) = Some("hello world")
          IO.println(x)
        }
      }
      "hello world"))

  (test-case "it returns an error for non-exhaustive patterns in ADT bindings"
    (check-match
      @interp-sexp{
        type IntOption =
          | Some(Int)
          | None

        main(_) {
          def None() = Some(10)
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
      @interp-lines{
        type IntOption = | Some(Int) | None

        IsSome : IntOption -> Bool
        IsSome(Some(_)) = True
        IsSome(_) = False

        main(_) {
          def s = Some(42)
          def Some(v) = s
          IO.println(%(IsSome(None()), IsSome(s), v))
        }
      }
      '("%(False, True, 42)"
        "Unit")))

  (test-case "can encode a module with common list operations"
    (check-equal?
      @interp-lines{
        module IntList {
          type t = Int[]
          type BoolList = Bool[]


          Concat : t -> t -> t
          Concat(xs, []) = xs
          Concat([], ys) = ys
          Concat(x::xs, ys) {
            x :: Concat(xs, ys)
          }

          Map : (Int -> Bool) -> t -> BoolList
          Map(f, []) = []
          Map(f, x::xs) {
            f(x) :: Map(f, xs)
          }
        }

        main(_) {
          IO.println(
            [
              IntList.Concat([], []),
              IntList.Concat([1, 2], []),
              IntList.Concat([1, 2], [3, 4, 5])
            ]
          )
        }
      }
      '("[[], [1, 2], [1, 2, 3, 4, 5]]"
        "Unit")))

  (test-case "it evaluates recursive function defs that depend on pattern ordering"
    (check-equal?
      @interp-lines{
        GetTwoOrLess : Int -> Int
        GetTwoOrLess(0) = 0
        GetTwoOrLess(1) = 1
        GetTwoOrLess(2) = 2
        GetTwoOrLess(x) = GetTwoOrLess(x - 1)

        main(_) {
          IO.println(%(GetTwoOrLess(1), GetTwoOrLess(4)))
        }
      }
      '("%(1, 2)"
        "Unit")))

  (test-case "it evaluates anonymous lambda expressions"
    (check-regexp-match
      #px"fun x\\d* : Int -> Int -> Int"
      @interp{
        main(_) = IO.println(fun(x, y) { x + y })
      }))

  (test-case "it evaluates anonymous function application"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println(fun (x, y) { x + y }(1, 2))
      }
      3))

  (test-case "it evaluates polymorphic functions"
    (check-equal?
      @interp-lines{
        IsEven : Int -> Bool
        IsEven(x) {
          switch (x) {
            0 -> True
            1 -> False
            2 -> True
            _ -> IsEven(x - 2)
          }
        }

        module Lists {
          Map{a, b} : (a -> b) -> a[] -> b[]
          Map(_, []) = []
          Map(f, x::xs) {
            f(x) :: Map(f, xs)
          }
        }

        main(_) {
          IO.println(Lists.Map(fun(n) { IsEven(n) }, [1, 2, 3, 4]))
        }
      }
      '("[False, True, False, True]"
        "Unit")))

  (test-case "it evaluates a string-length function"
    (check-equal?
      @interp-sexp{
        type String = Char[]

        len : String -> Int
        len("") = 0
        len(c::cs) { 1 + len(cs) }

        main(_) = IO.println(len("hello"))
      }
      5))

  #;(test-case "it evaluates instance function applications"
    (check-equal?
      @interp-sexp{
        fun (True).isTrue() = True
        fun (_).isFalse() = False

        main(_) {
          IO.println(True.isFalse())
        }
      }
      'False))

  #;(test-case "it evaluates recursive instance functions"
    (check-equal?
      @interp-sexp{
        fun ([]).len() = 0
        fun (x::xs).len() = 1 + xs.len()

        main(_) {
          IO.println([1, 2, 3].len())
        }
      }
      3))

  (test-case "it accepts identifiers with non-alphanumeric characters"
    (check-equal?
      @interp-sexp{
        main(_) {
          def x/! = 1 + 2
          IO.println(x/!)
        }
      }
      3))

  (test-case "it accepts special characters in function names"
    (check-equal?
      @interp-sexp{
        foo/bar(n) = n + 1
        main(_) = IO.println(foo/bar(19) / 2)
      }
      10))

  (test-case "it evaluates infix application of binary functions"
    (check-equal?
      @interp-sexp{
        @"@"(!!)(a, b) = a * b
        precedence !! 10

        main(_) = IO.println(2 !! 3 + 4)
      }
      14))

  (test-case "it evaluates clauses on custom infix operators"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println(True || False || False)
      }
      'True))

  (test-case "it evaluates a boolean AND infix operator"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println(True && False)
      }
      'False))

  (test-case "it evaluates recursive infix operators"
    (check-equal?
      @interp-sexp{
        @"@"(~)(0, 0) = False
        @"@"(~)(0, _) = True
        @"@"(~)(_, 0) = False
        @"@"(~)(x, y) = (x - 1) ~ (y - 1)

        @"@"(~!)(0, 0) = True
        @"@"(~!)(0, _) = True
        @"@"(~!)(_, 0) = False
        @"@"(~!)(x, y) = (x - 1) ~! (y - 1)

        main(_) = IO.println(3 ~ 4 && (10 ~! 10))
      }
      'True))


  (test-case "it evaluates user-defined precedence assignments"
    (check-equal?
      @interp-sexp{
        @"@"(||)(True, _) = True
        @"@"(||)(_, True) = True
        @"@"(||)(_, _) = False

        //XOR
        @"@"(!!)(False, False) = False
        @"@"(!!)(True, True) = False
        @"@"(!!)(_, _) = True

        precedence || 1
        precedence !! 2

        main(_) = IO.println(True !! True || True)
      }
      'False))

  (test-case "it evaluates user-defined arithmetic operators"
    (check-equal?
      @interp-sexp{
        //& = +
        //!! = *
        //~ = -
        //| = /
        @"@"(&)(a, b) = a + b
        @"@"(!)(a, b) = a * b
        @"@"(~)(a, b) = a - b
        @"@"(|)(a, b) = a / b

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
        @"@"(<)(0, 0) = False
        @"@"(<)(0, _) = True
        @"@"(<)(_, 0) = False
        @"@"(<)(a, b) = a - 1 < b - 1

        precedence < 10

        @"@"(&&)(True, True) = True
        @"@"(&&)(_, _) = False

        precedence && 11

        main(_) {
          def i = 1
          def j = 2
          def k = 3
          def l = cond {
            i < k && j < k -> 42
            _ -> 43
          }

          IO.println(l)
        }
      }
      42))

  (test-case "it allows direct references/application to operators"
    (check-equal?
      @interp-sexp{
        main(_) = IO.println((+)(1, 2))
      }
      3))

  (test-case "it returns operator function values"
    (check-equal?
      @interp-lines{main(_) = IO.println((*))}
      '("fun * : Int -> Int -> Int"
        "Unit")))

  (test-case "it binds imported values"
    (check-equal?
      @interp-sexp{
        module Foo {
          def v = 42
        }

        module Bar {
          import Foo
          def x = v
        }

        main(_) = IO.println(Bar.x)
      }
      42))

  (test-case "it imports infix operators"
    (check-equal?
      @interp-sexp{
        module Prims {
          @"@"(&&)(True, True) = True
          @"@"(&&)(_, _) = False
        }

        module Foo {
          import Prims

          f() = True && False
        }

        main(_) = IO.println(Foo.f())
      }
      'False))

  (test-case "it imports submodule infix operators"
    (check-equal?
      @interp-sexp{
        module Prims {
          module BoolOps {
            @"@"(&&)(True, True) = True
            @"@"(&&)(_, _) = False
          }
        }

        import Prims.BoolOps

        main(_) = IO.println(True && False)
      }
      'False))

  (test-case "it distinguishes between types and values with the same name"
    (check-equal?
      @interp-sexp{
        foo(a, b) = a + b
        type foo = Int

        main(_) = IO.println(foo(2, 4))
      }
      6))
)
