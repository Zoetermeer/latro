#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it parses"
    (check-equal?
      @interp-lines{
        module M {
          import Core

          protocol Eq(a) {
            infixl (===) : a -> a -> Bool
          }

          imp Int : Eq {
            infixl (===)(x, y) = x == y
          }
        }

        module Program {
          import IO
          import M
          main(_) = IO.println(42 === 43)
        }
      }
      '("42")))
)
