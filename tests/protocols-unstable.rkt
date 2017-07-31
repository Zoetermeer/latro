#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right overload when operand types are unknown at compile time"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Main {
            type Bool = primtype(bool)
            type Int = primtype(int)

            protocol Equatable(a) {
              infixl (==) : a -> a -> Bool
            }

            imp Equatable(Int) {
              infixl (==)(a, b) = prim(intEq)(a, b)
            }

            mod(n, d) = prim(intMod)(n, d)

            infixl (++)([], bs)    = bs
            infixl (++)(as, [])    = as
            infixl (++)(a @"@" as, bs) = a @"@" (as ++ bs)

            infixl (/)(a, b) = prim(intDiv)(a, b)

            digits : Int -> Int[]
            digits(0) = [0]
            digits(n) = {
              let m = mod(n, 10)
              let n' = n / 10
              if (n' == 0) [m] digits(n') ++ [m]
            }

            main(_) = {
              prim(println)(digits(42))
            }
          }
        }
        '("[4, 2]"))))
)
