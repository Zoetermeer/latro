#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it evaluates literals"
  (check-equal? @interp{True} 'True)
  (check-equal? @interp{False} 'False)
  (check-equal? @interp{42} 42)
  (check-equal? @interp{"hello"} "hello")
  (check-equal? @interp{'f'} #\f))

(test-case "it returns an error for unbound identifiers"
  (check-equal? @interp{x} '(UnboundRawIdentifier x)))

(test-case "it evaluates arithmetic exps"
  (check-equal? (interp "4 + 3") 7)
  (check-equal? (interp "4 + 3 * 2") 10)
  (check-equal? (interp "4 - 3 / 3") 3)
  (check-equal? (interp "3 * 2 + 4") 10)
  (check-equal? (interp "(4 + 3) * 2") 14))

(test-case "it evaluates arithmetic expressions involving application"
  (check-equal?
    @interp{
      f => fun(Int) : Int
      fun f(x) = x

      3 + f(4)
    }
    7))

(test-case "it evaluates string patterns"
  (check-equal?
    @interp{
      switch ("hello") {
        case "foo" -> "bar"
        case "hello" -> "world"
        case _ -> "no match"
      }
    }
    "world"))

(test-case "it evaluates if-else expressions"
  (check-equal?
    @interp{
      if (True) {
        42
      } else {
        43
      }
    }
    42))

(test-case "it takes the else branch on false"
  (check-equal?
    @interp{
      if (False) {
        42
      } else {
        43
      }
    }
    43))

(test-case "it does not allow bindings to escape from then/else scopes"
  (check-match
    @interp{
      def v = if (True) {
        def x = 42
        x
      } else { 0 }

      x
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id x ,_)))))

(test-case "it does not allow bindings to escape the test exp of an if/else"
  (check-match
    @interp{
      if (if (True) { def x = 42 True } else { False }) {
        x
      } else {
        x
      }
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id x ,_)))))

(test-case "it does not allow argument bindings to escape"
  (check-match
    @typecheck{
      fun f(x, runForever) {
        if (runForever) {
          f(x, runForever)
        } else {
          x
        }
      }

      runForever(3, False)
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id runForever ,_)))))

(test-case "it does not add bindings introduced in subexpressions to the module export env"
  (check-match
    @interp{
      module m {
        if (True) {
          def x = 42
        } else {
          ()
        }
      }

      m
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports ()))))

(test-case "it evaluates non-literals in the test position"
  (check-equal?
    @interp{
      def f = fun(x) {
        if (x) { True } else { False }
      }

      if (f(True)) {
        42
      } else {
        43
      }
    }
    42))

(test-case "it evaluates nested if-else expressions"
  (check-equal?
    @interp{
      42 + (if (True) { 1 } else { 2 })
    }
    43))

(test-case "it returns function values"
  (check-match
    @interp{
      fun f() = 42

      f
    }
    `(Fun (Id f ,_) (CloEnv ()))))

(test-case "it returns function values with closures"
  (check-match
    @interp{
      def v = 1
      fun f() = v

      f
    }
    `(Fun (Id f ,_) (CloEnv ((Id v ,_))))))

(test-case "it evaluates the shorthand syntax for single-expression function bodies"
  (check-equal?
    @typecheck{
      weird => fun(Int, Int) : Int
      fun weird(0, 0) = 100
      fun weird(x, y) = x + y

      weird(1, 2)
    }
    'Int))

(test-case "it returns module values"
  (check-match
    @interp{
      module m {} m
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports ()))))

(test-case "it adds definitions to module exports"
  (check-match
    @interp{
      module m { def v = 42 } m
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports ((Id v ,_))))))

(test-case "it applies functions on modules with multiple decs"
  (check-equal?
    @interp{
      module m {
        fun f() = 42
        fun g() = 43
      }

      m.g()
    }
    43))

(test-case "it returns values defined in modules"
  (check-equal?
    @interp{
      module m { def v = 42 }
      m.v
    }
    42))

(test-case "it can apply module-exported functions"
  (check-equal?
    @interp{
      module m {
        f => fun() : Int
        fun f() = 42
      }
      m.f()
    }
    42))

(test-case "it can apply module-exported functions occurring after a nested module dec"
  (check-equal?
    @interp{
      module m {
        module n { }

        f => fun() : Int
        fun f() = 42
      }
      m.f()
    }
    42))

(test-case "it can apply module-exported functions occurring before a nested module dec"
  (check-equal?
    @interp{
      module m {
        f => fun() : Int
        fun f() = 42

         module n { }
      }
      m.f()
    }
    42))

(test-case "it returns values defined in nested modules"
  (check-equal?
    @interp{
      module a {
        module b {
          def v = 42
        }
      }

      a.b.v
    }
    42))

(test-case "it applies defined functions"
  (check-equal?
    @interp{
      f => fun() : Int
      fun f() = 42
      f()
    }
    42))

(test-case "it substitutes function args"
  (check-equal?
    @interp{
      f => fun(Int) : Int
      fun f(x) = x
      f(42)
    }
    42))

(test-case "it correctly shadows bindings in function bodies"
  (check-equal?
    @interp{
      module m { }
      f => fun(Int) : Int
      fun f(m) = m
      f(42)
    }
    42))

(test-case "it captures bindings from the env in function bodies"
  (check-equal?
    @interp{
      def v = 42
      f => fun() : Int
      fun f() = v
      f()
    }
    42))

(test-case "it does not add locals in function bodies to the module export env"
  (check-match
    @interp{
      module m {
        f => fun() : Int
        fun f() {
          def x = 42
          x
        }
      }

      m
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports ((Id f ,_))))))

(test-case "it returns nested module values"
  (check-match
    @interp{
      module m {
        module m' {
          g => fun() : Int
          fun g() { 43 }
        }

        f => fun() : Int
        fun f() { 42 }
      }

      m.m'
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports ((Id g ,_))))))

(test-case "it resolves functions on nested modules"
  (check-equal?
    @interp{
      module m {
        module m' {
          g => fun() : Int
          fun g() = 43
        }

        f => fun() : Int
        fun f() = 42
      }

      m.m'.g()
    }
    43))

(test-case "it evaluates functions with compound bodies on nested modules"
  (check-equal?
    @interp{
      module m {
        module m1 {
          g => fun(Int, Int) : Int
          fun g(x, y) { y + x }
        }

        f => fun() : Int
        fun f() = 42
      }

      m.m1.g(m.f(), 1)
    }
    43))

(test-case "it evaluates higher-order functions"
  (check-equal?
    @interp{
      f => fun(fun(Int) : Int, Int) : Int
      fun f(g, x) {
        g(10) + x
      }

      h => fun(Int) : Int
      fun h(x) {
        x + 1
      }

      f(h, 3)
    }
    14))

(test-case "it does not allow nested modules to escape the local env"
  (check-match
    @interp{
      module m {
        module m1 {
          g => fun(Int, Int) : Int
          fun g(x, y) {
            y + x
          }
        }
      }

      m1.g(1, 1)
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id m1 ,_)))))

(test-case "it does not capture id's in lexical scope for modules as exports"
  (check-match
    @interp{
      module m {
        f => fun() : Int
        fun f() = 42

        module n { }
      }

      m.n.f()
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier f))))

(test-case "it evaluates recursive functions"
  (check-equal?
    @interp{
      fun not(True) = False
      fun not(_) = True

      f => fun(Int) : Int
      fun f(x) {
        def isZero = switch (x) {
          case 0 -> True
          case _ -> False
        }

        if (not(isZero)) {
          x + f(x - 1)
        } else {
          x
        }
      }
      f(4)
    }
    10))

(test-case "it resolves member accesses on captured modules"
  (check-equal?
    @interp{
      module m {
        module n {
          module o {
            def v = 42
          }
        }

        f => fun() : Int
        fun f() = n.o.v
      }

      m.f()
    }
    42))

(test-case "it evaluates accesses on module-level scalars"
  (check-equal?
    @interp{
      module m {
        def v = 6
      }

      m.v
    }
    6))

(test-case "it can access prior bindings in a module closure"
  (check-match
    @interp{
      module m { }
      f => fun() : Int
      fun f() = 1

      module n {
        def v = 2
      }

      n
    }
    `(Module
      (CloEnv ((Id f ,_) (Id m ,_)))
      (Params ())
      (Exports ((Id v ,_))))))

(test-case "it evaluates accesses on nested-module-level scalars"
  (check-equal?
    @interp{
      module m {
        module n {
          def v = 6
        }
      }

      m.n.v
    }
    6))

(test-case "it returns the empty struct"
  (check-match
    @interp{
      type t = struct { }
      t { }
    }
    `(Adt (Id t ,_) 0 ())))

(test-case "it evaluates struct instances"
  (check-match
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      }

      Point { X = 3; Y = 4; }
    }
    `(Adt (Id Point ,_) 0 (3 4))))

(test-case "it evaluates struct field accesses"
  (check-equal?
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      }

      def p = Point { X = 3; Y = 4; }
      Y(p)
    }
    4))

(test-case "it returns an error on undefined-field accesses"
  (check-equal?
    @interp{
      type t = struct { }
      def v = t { }
      x(v)
    }
    '(UnboundRawIdentifier x)))

(test-case "it evaluates nested struct field accesses"
  (check-equal?
    @interp{
      type Point = struct {
        Int X;
        Int Y;
      }

      type Line = struct {
        Point A;
        Point B;
      }

      def l = Line {
        A = Point { X = 0; Y = 0; };
        B = Point { X = 3; Y = 4; };
      }

      Y(B(l))
    }
    4))

(test-case "it evaluates module-exported struct types"
  (check-equal?
    @interp{
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

      def l = Geometry.Line {
        A = Geometry.Point { X = 0; Y = 0; };
        B = Geometry.Point { X = 3; Y = 4; };
      }

      Geometry.Y(Geometry.B(l))
    }
    4))

(test-case "it exports algebraic data type constructors"
  (check-match
    @interp{
      module Prims {
        type IntOption =
          | Just(Int)
          | None
      }
      Prims
    }
    `(Module
       (CloEnv ())
       (Params ())
       (Exports
         ((Id Just ,_) (Id None ,_))))))

(test-case "it constructs ADT instances"
  (check-match
    @interp{
      type IntOption =
        | Just(Int)
        | None

      Just(42)
    }
    `(Adt (Id Just ,_) 0 (42))))

(test-case "it scopes ADT defs/ctors to module exports"
  (check-match
    @interp{
      module m {
        type IntOption =
          | Just(Int)
          | None
      }

      Just(42)
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier (Id Just ,_)))))

(test-case "it evaluates multi-arity ADT constructors"
  (check-match
    @interp{
      type T =
        | IBTuple(Int, Bool)
        | B(Bool)

      %(B(True), IBTuple(2, False))
    }
    `(Tuple ((Adt (Id B ,_) 1 (True)) (Adt (Id IBTuple ,_) 0 (2 False))))))

(test-case "it evaluates tuple expressions"
  (check-equal?
    @interp{
      %(4, False)
    }
    '(Tuple (4 False))))

(test-case "it evaluates 3-tuples"
  (check-equal?
    @interp{
      %(3, True, 4)
    }
    '(Tuple (3 True 4))))

(test-case "it applies functions with tuple arguments"
  (check-equal?
    @interp{
      f => fun(%(Int, Bool)) : %(Int, Bool)
      fun f(pair) = pair

      f(%(5, False))
    }
    '(Tuple (5 False))))

(test-case "it evaluates list expressions"
  (check-equal?
    @interp{
      [1, 2, 3]
    }
    '(List (1 2 3))))

(test-case "it evaluates list bindings"
  (check-equal?
    @interp{
      def ls = [1, 2, 3, 4]
      ls
    }
    '(List (1 2 3 4))))

(test-case "it evaluates list cons operations"
  (check-equal?
    @interp{
      1 :: [2, 3, 4]
    }
    '(List (1 2 3 4))))

(test-case "it makes cons right-associative"
  (check-equal?
    @interp{
      f => fun(Int, Int) : Int[]
      fun f(x, y) {
        x :: y :: [3, 4, 5]
      }

      f(1, 2)
    }
    '(List (1 2 3 4 5))))

(test-case "it evaluates list patterns"
  (check-equal?
    @interp{
      def [a, b, c] = [1, 2, 3]
      a + b + c
    }
    6))

(test-case "it evaluates list patterns with pattern subexpressions"
  (check-equal?
    @interp{
      def [_, b, 3] = [1, 2, 3]
      b
    }
    2))

(test-case "it fails to bind to list patterns if lengths don't match"
  (check-match
    @interp{
      def [a, b] = []
      a
    }
    `(AtPos ,_ (CompilerModule Interp) (PatMatchFail ,_ (List ())))))

(test-case "it evaluates list cons patterns"
  (check-equal?
    @interp{
      def x::xs = [1, 2, 3, 4]
      %(x, xs)
    }
    '(Tuple (1 (List (2 3 4))))))

(test-case "it evaluates cons patterns with list pat subexpressions"
  (check-equal?
    @interp{
      def x::[] = [3]
      x
    }
    3))

(test-case "it evaluates cons patterns in sublists"
  (check-equal?
    @interp{
      def xs::[[3, 4], [x, _, z]] = [[1, 2], [3, 4], [5, 6, 7]]
      %(xs, x, z)
    }
    '(Tuple ((List (1 2)) 5 7))))

(test-case "it evaluates tuple pattern bindings"
  (check-equal?
    @interp{
      def %(a, b) = %(1, True)
      b
    }
    'True))

(test-case "it evaluates wildcards in tuple patterns"
  (check-equal?
    @interp{
      def %(_, b) = %(1, 43)
      b
    }
    43))

(test-case "it throws away expressions bound to wildcards"
  (check-equal?
    @interp{
      def _ = 42
      43
    }
    43))

(test-case "it evaluates switch expressions"
  (check-equal?
    @interp{
      def v = %(4, False)
      switch (v) {
        case %(0, _) -> 1
        case %(4, True) -> 2
        case %(_, False) -> 3
        case _ -> 4
      }
    }
    3))

(test-case "it evaluates switch expressions with mixed block-style and short-form bodies"
  (check-equal?
    @interp{
      switch ([1, 2, 3]) {
        case [x, y, z] -> {
          def v = z + y
          v * 2
        }
        case _ -> 3
      }
    }
    10))

(test-case "it evaluates patterns in argument-binding position"
  (check-equal?
    @interp{
      IsZero => fun(Int) : Bool
      fun IsZero(0) = True
      fun IsZero(_) = False

      %(IsZero(1), IsZero(0))
    }
    '(Tuple (False True))))

(test-case "it evaluates tuple patterns in argument bindings"
  (check-equal?
    @interp{
      Fst => fun(%(Int, Bool)) : Int
      fun Fst(%(a, _)) = a

      Snd => fun(%(Int, Bool)) : Bool
      fun Snd(%(_, b)) = b

      def v = %(42, False)
      %(Snd(v), Fst(v))
    }
    '(Tuple (False 42))))

(test-case "it returns an error for non-exhaustive patterns in argument bindings"
  (check-match
    @interp{
      IsZero => fun(Int) : Bool
      fun IsZero(0) = True

      IsZero(1)
    }
    `(AtPos ,_ (CompilerModule Interp) (NonExhaustivePattern ,_ (Tuple (1))))))

(test-case "it evaluates ADT patterns"
  (check-equal?
    @interp{
      type String = Char[]
      type StringOption =
        | Some(String)
        | None

      def Some(x) = Some("hello world")
      x
    }
    "hello world"))

(test-case "it returns an error for non-exhaustive patterns in ADT bindings"
  (check-match
    @interp{
      type IntOption =
        | Some(Int)
        | None

      def None() = Some(10)
    }
    `(AtPos
       ,_
       (CompilerModule Interp)
       (PatMatchFail
         ,_
         (Adt (Id Some ,_) 0 (10))))))

(test-case "it evaluates ADT argument patterns"
  (check-equal?
    @interp{
      type IntOption = | Some(Int) | None

      IsSome => fun(IntOption) : Bool
      fun IsSome(Some(_)) = True
      fun IsSome(_) = False

      def s = Some(42)
      def Some(v) = s
      %(IsSome(None()), IsSome(s), v)
    }
    '(Tuple (False True 42))))

(test-case "can encode a module with common list operations"
  (check-equal?
    @typecheck{
      module IntList {
        type t = Int[]
        type BoolList = Bool[]


        Concat => fun(t, t) : t
        fun Concat(xs, []) = xs
        fun Concat([], ys) = ys
        fun Concat(x::xs, ys) {
          x :: Concat(xs, ys)
        }

        Map => fun(fun(Int) : Bool, t) : BoolList
        fun Map(f, []) = []
        fun Map(f, x::xs) {
          f(x) :: Map(f, xs)
        }
      }

      [
        IntList.Concat([], []),
        IntList.Concat([1, 2], []),
        IntList.Concat([1, 2], [3, 4, 5])
      ]
    }
    '(App List ((App List (Int))))))

(test-case "it evaluates recursive function defs that depend on pattern ordering"
  (check-equal?
    @interp{
      GetTwoOrLess => fun(Int) : Int
      fun GetTwoOrLess(0) = 0
      fun GetTwoOrLess(1) = 1
      fun GetTwoOrLess(2) = 2
      fun GetTwoOrLess(x) = GetTwoOrLess(x - 1)

      %(GetTwoOrLess(1), GetTwoOrLess(4))
    }
    '(Tuple (1 2))))

(test-case "it evaluates anonymous lambda expressions"
  (check-match
    @interp{
      fun(x, y) { x + y }
    }
    `(Fun ,_ (CloEnv ()))))

(test-case "it evaluates anonymous function application"
  (check-equal?
    @interp{
      fun (x, y) { x + y }(1, 2)
    }
    3))

(test-case "it evaluates polymorphic functions"
  (check-equal?
    @interp{
      IsEven => fun(Int) : Bool
      fun IsEven(x) {
        switch (x) {
          case 0 -> True
          case 1 -> False
          case 2 -> True
          case _ -> IsEven(x - 2)
        }
      }

      module Lists {
        Map<a, b> => fun(fun(a) : b, a[]) : b[]
        fun Map(_, []) = []
        fun Map(f, x::xs) {
          f(x) :: Map(f, xs)
        }
      }

      Lists.Map(fun(n) { IsEven(n) }, [1, 2, 3, 4])
    }
    '(List (False True False True))))

(test-case "it evaluates a string-length function"
  (check-equal?
    @interp{
      type String = Char[]

      len => fun(String) : Int
      fun len("") = 0
      fun len(c::cs) { 1 + len(cs) }

      len("hello")
    }
    5))

(test-case "it evaluates instance function applications"
  (check-equal?
    @interp{
      fun (True).isTrue() = True
      fun (_).isFalse() = False

      True.isFalse()
    }
    'False))

(test-case "it evaluates recursive instance functions"
  (check-equal?
    @interp{
      fun ([]).len() = 0
      fun (x::xs).len() = 1 + xs.len()

      [1, 2, 3].len()
    }
    3))

(test-case "it accepts identifiers with non-alphanumeric characters"
  (check-equal?
    @interp{
      def x+ = 1 + 2
      x+
    }
    3))

(test-case "it accepts special characters in function names"
  (check-equal?
    @interp{
      fun foo/bar(n) = n + 1
      foo/bar(19) / 2
    }
    10))
