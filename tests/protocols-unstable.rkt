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

            showList(x @"@" _) = show(x)

            main(_) = {
              prim(println)(showList([1, 2, 3, 4]))
            }
          }
        }
        '("\"an int\""))))
)
