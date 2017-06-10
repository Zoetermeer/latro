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
          main(_) = prim(println)(42)
        }
      }
      '("42")))
)
