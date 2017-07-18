#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right overload when operand types are known at compile time"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module M {
            type Bool = primtype(bool)
            type Char = primtype(char)
            type Int = primtype(int)

            protocol Eq(a) {
              infixl (===) : a -> a -> Bool
            }

            imp Int : Eq {
              infixl (===)(x, y) = prim(intEq)(x, y)
            }

            imp Char : Eq {
              infixl (===)(a, b) = prim(intEq)(prim(charToInt)(a), prim(charToInt)(b))
            }

            imp Bool : Eq {
              infixl (===)(True, True) = True
              infixl (===)(False, False) = True
              infixl (===)(_, _) = False
            }
          }

          module Program {
            import M

            x(y) = y
            main(_) = {
              prim(println)(42 === 43)
              prim(println)('a' === 'a')
              prim(println)(False === True)
            }
            //main(_) = IO.println(x(43) === 42)
          }
        }
        '("False" "True" "False"))))

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

            println : a -> Unit when a : Show
            println(v) = prim(println)(v)

            printv(v) = println(show(v))

            main(_) = {
              printv(42)
              printv("hello")
            }
          }
        }
        '("42"))))
)
