#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it selects the right method implementation when operand types are known at compile time"
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

  (test-case "it only binds proto dec type parameters in the body"
    (check-match
      @interp-sexp{
        module Program {
          import Core
          import IO = IO

          protocol Foo(x) {
            identity : x -> x
          }

          imp Bool : Foo {
            identity(b) = b
          }

          bad : x -> Int
          bad(_) = 42

          main(_) = IO.println(bad(False))
        }
      }
    `(AtPos (SourcePos ,_ 13 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it selects the right dictionary when operand types are unknown at compile time"
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
        '("\"false!\"" "\"it's 42\"" "\"true!\""))))

  (test-case "it passes the correct dictionary at runtime to polymorphic functions"
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

  (test-case "it passes dictionaries to recursive function calls"
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
