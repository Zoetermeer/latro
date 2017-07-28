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
            type String = Char[]

            protocol Show(a) {
              show : a -> String
            }

            imp Int : Show {
              show(0) = "0"
              show(x) = ">0"
            }

            showit(x) = show(x)

            hdapp(f, x @"@" _) = f(x)

            map(_, [])   = []
            map(f, x @"@" xs) = f(x) @"@" map(f, xs)

            println(v) = prim(println)(v)

            main(_) = {
              println(map(show, [1, 2, 0, 3, 0]))
            }
          }
        }
        '("[\">0\", \">0\", \"0\", \">0\", \"0\"]"))))
)
