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
    45))

(test-case "it does not allow rebinding in the same scope"
  (check-match
    @interp{
      def v = 42
      def v = 43
      v
    }
    `(AtPos ,_ (IdAlreadyBound v))))

(test-case "it does allow rebinding in nested scopes"
  (check-match
    @interp{
      def v = 42
      (fun(x) { def v = 43  v })(1)
    }
    43))

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

      B.boolId(False)
    }
    'False))
