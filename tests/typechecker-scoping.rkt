#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it distinguishes between type and value names in annotations"
  (check-equal?
    @typecheck{
      type foo = Int

      foo => fun(foo, foo) : foo
      fun foo(a, b) = a + b

      foo(2, 4)
    }
    'Int))

(test-case "it respects lexical scope for functions"
  (check-equal?
    @typecheck{
      def v = 42
      fun foo(v) = v + 1
      v + foo(3)
    }
    'Int))

(test-case "it does not export local definitions on modules"
  (check-match
    @typecheck{
      module M {
        fun f() {
          def v = 3
          v
        }
      }

      M.v
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier v))))

(test-case "it does not allow rebinding in the same scope"
  (check-match
    @typecheck{
      def v = 42
      def v = 43
      v
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (IdAlreadyBound v))))

(test-case "it does not allow rebinding of an id to a module"
  (check-match
    @typecheck{
      def m = 42
      module m {
        def x = 43
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (IdAlreadyBound m))))

(test-case "it does allow rebinding in nested scopes"
  (check-match
    @typecheck{
      def v = 42
      fun(x) { def v = 43  v }(1)
    }
    'Int))

(test-case "it allows rebinding in a nested 'if' scope"
  (check-match
    @typecheck{
      module m {
        def x = False
        if (True) {
          def x = 42
        } else {
          ()
        }
      }

      m.x
    }
    'Bool))

(test-case "it refers to the correct value after a rebinding in a nested scope"
  (check-match
    @typecheck{
      def v = 3
      fun(x) { def v = 43  v }(1) + v
    }
    'Int))

(test-case "it resolves module-scoped types with matching names"
  (check-equal?
    @typecheck{
      module Number {
        type t = Int
      }

      module Div {
        type t =
          | Num(Number.t)
          | ByZero

        fun div(x, 0) = ByZero()
        fun div(x, y) = Num(x / y)
      }

      def Div.Num(answer) = Div.div(100, 10)
      answer
    }
    'Int))

(test-case "it scopes shadowing type identifiers"
  (check-equal?
    @typecheck{
      module I {
        type t = Int

        module B {
          type t = Bool

          boolId => fun(t) : t
          fun boolId(b) = b
        }

        intId => fun(t) : t
        fun intId(i) = i
      }

      I.B.boolId(False)
    }
    'Bool))

(test-case "it does not add bindings introduced in subexpressions to the module export env"
  (check-match
    @typecheck{
      module m {
        if (True) {
          def x = 42
        } else {
          ()
        }
      }

      m.x
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not add locals in function bodies to the module export env"
  (check-match
    @typecheck{
      module m {
        f => fun() : Int
        fun f() {
          def x = 42
          x
        }
      }

      m.x
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not re-export imported bindings"
  (check-match
    @typecheck{
      module Foo {
        def v = 42
      }

      module Bar {
        import Foo
      }

      Bar.v
    }
    `(AtPos ,_ (CompilerModule Types) (UnboundUniqIdentifier v))))

(test-case "it does not allow bindings in a pattern to escape into other clauses"
  (check-match
    @typecheck{
      type Foo =
        | B(Bool)
        | I(Int)

      switch (I(42)) {
        case I(x) -> x
        case B(b) -> x
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not allow bindings to escape from then/else scopes"
  (check-match
    @typecheck{
      def v = if (True) {
        def x = 42
        x
      } else { 0 }

      x
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not allow bindings to escape the test exp of an if/else"
  (check-match
    @typecheck{
      if (if (True) { def x = 42 True } else { False }) {
        x
      } else {
        x
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not require type definitions to be in order"
  (check-equal?
    @typecheck{
      type foo = bar
      type bar = Int

      x => foo
      def x = 42

      x
    }
    'Int))

(test-case "it allows circular dependencies between types"
  (check-match
    @typecheck{
      type Expr =
        | ExprNum(Int)
        | ExprStm(Stm)

      type Stm =
        | StmDef(Char[], Expr)

      [ StmDef("x", ExprNum(42)) ]
    }
    `(List
       ((Adt (Id StmDef ,_) 0 ("x" (Adt (Id ExprNum ,_) 0 (42))))))))

(test-case "it allows circular dependencies between module-level types"
  (check-match
    @typecheck{
      module Expr {
        type t =
          | ExprNum(Int)
          | ExprStm(Stm.t)
      }

      module Stm {
        type t =
          | StmDef(Char[], Expr.t)
      }

      [ Stm.StmDef("x", Expr.ExprNum(42)) ]
    }
    `(List
       ((Adt (Id StmDef ,_) 0 ("x" (Adt (Id ExprNum ,_) 0 (42))))))))

(test-case "it allows use-before-defines in top-level definitions"
  (check-equal?
    @typecheck{
      def y = x
      def x = 42

      y
    }
    'Int))

(test-case "it allows use-before-defines in module-level definitions"
  (check-equal?
    @typecheck{
      module M {
        def y = x
        def x = 42
      }

      M.y
    }
    'Int))

(test-case "it allows use-before-defines that refer to other modules"
  (check-equal?
    @typecheck{
      module M {
        def y = N.x
      }

      module N {
        def x = 42
      }

      M.y
    }
    'Int))

(test-case "it does not allow use-before-defines in local contexts"
  (check-match
    @typecheck{
      fun foo(a) {
        def x = y
        def y = a

        x + y
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier y))))

(test-case "it fails on incorrect qualified paths"
  (check-match
    @typecheck{
      module M {
        module N {
          def foo = 42
        }
      }

      module M' {
        def bar = N.foo
      }

      M'.bar
    }
    `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier N))))

(test-case "it does not extend type name resolution to closures of closed modules"
  (check-match
    @typecheck{
      type String = Char[]

      module M { }

      f => fun(M.String) : M.String
      fun f(s) { s }
    }
    `(AtPos (SourcePos ,_ 5 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier String))))

(test-case "it does not extend variable name resolution to closures of closed modules"
  (check-match
    @typecheck{
      def foo = 42

      module M {
        def bar = foo
      }

      M.foo + M.bar
    }
    `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier foo))))

(test-case "it can resolve pattern names in the module closure"
  (check-equal?
    @typecheck{
      module Root {
        type A = | Foo(Int) | Bar(Int)

        module M {
          def f = fun(a) {
            switch (a) {
              case Foo(x) -> x
              case _ -> 0
            }
          }
        }
      }

      Root.M.f(Root.Foo(43))
    }
    'Int))

(test-case "does not re-export pattern names from the module closure"
  (check-match
    @typecheck{
      type A = | Foo(Int) | Bar(Int)

      module M { }

      switch (Foo(42)) {
        case M.Foo(x) -> x
        case _ -> 0
      }
    }
    `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier Foo))))

(test-case "it does not allow module-exported type bindings to escape"
  (check-match
    @typecheck{
      module Geometry {
        type Point = struct {
          Int X;
          Int Y;
        }
      }

      def p = Point %{ X = 0; Y = 0; }
      p
    }
    `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier Point))))

