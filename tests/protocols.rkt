#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right overload when operand types are known at compile time"
    (check-equal?
      @interp-lines{
        module M {
          import Core

          protocol Eq(a) {
            infixl (===) : a -> a -> Bool
          }

          imp Int : Eq {
            infixl (===)(x, y) = prim(intEq)(x, y)
          }
        }

        module Program {
          import IO
          import M

          x(y) = y
          //main(_) = IO.println(42 === 43)
          main(_) = IO.println(x(43) === 42)
        }
      }
      '("42")))

  #;(test-case "it selects the right overload when operand types are unknown at compile time"
    (check-equal?
      @interp-lines{
        module M {
          import Core
          import Core.Int (toString) { renaming (toString -> intToString) }

          protocol Stringable(a) {
            toString : a -> String 
          }

          imp Int : Stringable {
            toString(i) = intToString(i)
          }

          imp Bool : Stringable {
            toString(True) = "True"
            toString(False) = "False"
          }
        }

        module Program {
          import IO
          import M

          //display : a -> Unit where a : Stringable
          display(v) = IO.println(toString(v))

          main(_) = {
            display(False)
            display(42)
          }
        }
      }
      '("42")))
)
