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
            type Char = primtype(char)
            type Int = primtype(int)
            type String = Char[]

            protocol Eq(a) {
              infixl (==) : a -> a -> Bool
            }

            imp Eq(Int) {
              infixl (==)(a, b) = prim(intEq)(a, b)
            }

            protocol Show(a) {
              show : a -> String
            }

            infixl (++)([], bs)    = bs
            infixl (++)(as, [])    = as
            infixl (++)(a @"@" as, bs) = a @"@" (as ++ bs)

            map(_, [])   = []
            map(f, x @"@" xs) = f(x) @"@" map(f, xs)


            infixl (< )(a, b)  = prim(intLt)(a, b)
            infixl (-)(a, b) = prim(intSub)(a, b)
            infixl (*)(a, b) = prim(intMul)(a, b)
            infixl (/)(a, b) = prim(intDiv)(a, b)

            precedence < 9
            precedence - 6
            precedence * 5
            precedence / 5

            imp Show(Int) {
              show(0) = "0"
              show(n) = {
                cond {
                  n < 0 -> "-" ++ show(n - n * 2)
                  _     -> {
                    let r = prim(intMod)(n, 10)
                    let c = switch (r) {
                      0 -> '0'
                      1 -> '1'
                      2 -> '2'
                      3 -> '3'
                      4 -> '4'
                      5 -> '5'
                      6 -> '6'
                      7 -> '7'
                      8 -> '8'
                      9 -> '9'
                    }
                    let n' = n / 10
                    cond {
                      n' == 0 -> [c]
                      _       -> show(n') ++ [c]
                    }
                  }
                }
              }
            }

            main(_) = {
              prim(println)(map(show, [1, 2, 0, 3, 0]))
            }
          }
        }
        '("[\"1\", \"2\", \"0\", \"3\", \"0\"]"))))
)
