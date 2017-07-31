#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "partition"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Main {
            type Int = primtype(int)
            type Bool = primtype(bool)
            type Char = primtype(char)
            type String = Char[]

            //infixl (+)(a, b) = prim(intAdd)(a, b)
            //infixl (==)(a, b)  = prim(intEq)(a, b)

            //length<a> : a[] -> Int
            //length([])    = 0
            //length(x @"@" xs) = 1 + length(xs)

            foldr<a, b> : (a -> b -> b) -> b -> a[] -> b
            foldr(f, b, x @"@" xs) = f(x, foldr(f, b, xs))
            foldr(f, b, [])   = b


            select<a> : (a -> Bool) -> a -> %(a[], a[]) -> %(a[], a[])
            select(p, x, %(ts, fs)) =
              cond {
                p(x) -> %(x @"@" ts, fs)
                _    -> %(ts, x @"@" fs)
              }


            partition<a> : (a -> Bool) -> a[] -> %(a[], a[])
            partition(p, xs) = {
              let selector = (fun(x, pr) = { select(p, x, pr) })
              //foldr(fun(x, pr) = select(p, x, pr), %([], []), xs)
              foldr(selector, %([], []), xs)
            }

            //isFiveChars : String -> Bool
            //isFiveChars(str) = length(str) == 5
            isHello("hello") = True
            isHello(_) = False

            main(_) = {
              prim(println)(
                partition(
                  isHello, ["he", "hello", "world", "foo", "bar", "fubar"]))
            }
          }
        }
        '("%([\"hello\", \"world\", \"fubar\"], [\"he\", \"foo\", \"bar\"])"))))
)
