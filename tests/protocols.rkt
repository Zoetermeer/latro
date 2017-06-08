#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it parses"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module M {
            protocol Eq(a) {
              infixl (==) : a -> a -> Bool
            }
          }

          module Program {
            main(_) = prim(println)(42)
          }
        }
        '("42"))))
)
