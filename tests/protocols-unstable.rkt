#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right overload when operand types are unknown at compile time"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Program {
            protocol Show(a) {
              show : a -> String
            }

            type Int = primtype(int)
            type Char = primtype(char)
            type String = Char[]
            type Unit = primtype(unit)

            imp Int : Show {
              show(_) = "it's an int"
            }

            imp String : Show {
              show(s) = s
            }

            println<a> : a -> Unit
            println(v) = prim(println)(v)

            printv<a> : a -> Unit when a : Show
            printv(v) = println(show(v))

            main(_) = {
              printv(42)
              printv("hello")
            }
          }
        }
        '("42"))))
)
