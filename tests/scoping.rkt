#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it distinguishes between type and value names in annotations"
  (check-equal?
    @interp{
      type foo = Int

      foo => fun(foo, foo) : foo
      fun foo(a, b) = a + b

      foo(2, 4)
    }
    6))

(test-case "it respects lexical scope for functions"
  (check-equal?
    @interp{
      def v = 42
      fun foo(v) = v + 1
      v + foo(3)
    }
    46))

(test-case "it does not export local definitions on modules"
  (check-match
    @interp{
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
    @interp{
      def v = 42
      def v = 43
      v
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (IdAlreadyBound v))))

(test-case "it does allow rebinding in nested scopes"
  (check-match
    @interp{
      def v = 42
      fun(x) { def v = 43  v }(1)
    }
    43))

(test-case "it allows rebinding in a nested 'if' scope"
  (check-match
    @interp{
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
    'False))

(test-case "it refers to the correct value after a rebinding in a nested scope"
  (check-match
    @interp{
      def v = 3
      fun(x) { def v = 43  v }(1) + v
    }
    46))

(test-case "it resolves module-scoped types with matching names"
  (check-equal?
    @interp{
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
    10))

(test-case "it scopes shadowing type identifiers"
  (check-equal?
    @interp{
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
    'False))

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

      m.x
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

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
    @interp{
      def v = if (True) {
        def x = 42
        x
      } else { 0 }

      x
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not allow bindings to escape the test exp of an if/else"
  (check-match
    @interp{
      if (if (True) { def x = 42 True } else { False }) {
        x
      } else {
        x
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

(test-case "it does not require type definitions to be in order"
  (check-equal?
    @interp{
      type foo = bar
      type bar = Int

      x => foo
      def x = 42

      x
    }
    42))

(test-case "it allows use-before-defines at the top level"
  (check-equal?
    @interp{
      module M {
        def y = x
        def x = 42
      }

      M.y
    }
    42))

(test-case "it does not allow use-before-defines in local contexts"
  (check-match
    @interp{
      fun foo(a) {
        def x = y
        def y = a

        x + y
      }
    }
    `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier y))))
