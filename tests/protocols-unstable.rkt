#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right overload when operand types are unknown at compile time"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Main {
            type Char = primtype(char)
            type Int = primtype(int)

            protocol Show(a) {
              show : a -> Char[]
            }

            imp Int : Show {
              show(_) = "an int"
            }

            infixl (++)([], bs)    = bs
            infixl (++)(as, [])    = as
            infixl (++)(a @"@" as, bs) = a @"@" (as ++ bs)

            showList([]) = "[]"
            showList(x @"@" xs) = show(x) ++ ", " ++ showList(xs)

            main(_) = {
              prim(println)(showList([1, 2, 3, 4]))
            }
          }
        }
        '("\"an int, an int, an int, an int, []\""))))
)
