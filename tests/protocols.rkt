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

            imp Eq(Int) {
              infixl (===)(x, y) = prim(intEq)(x, y)
            }

            imp Eq(Char) {
              infixl (===)(a, b) = prim(intEq)(prim(charToInt)(a), prim(charToInt)(b))
            }

            imp Eq(Bool) {
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

          imp Foo(Bool) {
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

            imp Show(Int) {
              show(42) = "it's 42"
              show(_) = "it's not 42"
            }

            imp Show(String) {
              show(s) = s
            }

            imp Show(Bool) {
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

            imp Show(Int) {
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

            imp Show(Int) {
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

  (test-case "it resolves methods applied to higher-order functions"
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

            imp Show(Int) {
              show(0) = "0"
              show(x) = ">0"
            }

            map(_, [])   = []
            map(f, x @"@" xs) = f(x) @"@" map(f, xs)

            println(v) = prim(println)(v)

            main(_) = {
              println(map(show, [1, 2, 0, 3, 0]))
            }
          }
        }
        '("[\">0\", \">0\", \"0\", \">0\", \"0\"]"))))

  (test-case "it resolves recursive method implementations"
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

  (test-case "it can resolve overloads in type-annotated functions"
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
