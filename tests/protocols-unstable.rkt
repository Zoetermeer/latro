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
            type Bool = primtype(bool)
            type Char = primtype(char)
            type String = Char[]
            type Unit = primtype(unit)

            imp Int : Show {
              show(42) = "it's 42"
              show(_) = "it's not 42"
            }

            imp String : Show {
              show(s) = s
            }

            imp Bool : Show {
              show(True) = "true!"
              show(False) = "false!"
            }

            toString(v) = show(v)

            doit() = {
              prim(println)(toString(False))
              prim(println)(toString(42))
              prim(println)(toString(True))
            }

            main(_) = {
              doit()
            }
          }
        }
        '("42"))))
)
