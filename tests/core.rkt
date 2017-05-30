#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "mod"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import IO

          main(_) = {
            println(mod(1, 1))
            println(mod(10, 2))
            println(mod(10, 3))
            println(mod(14, 11))
          }
        }
      }
      '("0"
        "0"
        "1"
        "3")))

  (test-case "foldl"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import Core.List
          import IO

          main(_) = {
            println(foldl((+), 0, [1, 2, 3, 4]))
          }
        }
      }
      '("10")))

  (test-case "length"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import Core.List
          import IO

          main(_) = {
            println(length([]))
            println(length([1]))
            println(length([1, 2]))

            let xs = [1, 2, 3]
            println(length(xs))
          }
        }
      }
      '("0"
        "1"
        "2"
        "3")))

  (test-case "partition"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import Core.List
          import IO

          isFiveChars(str) = length(str) == 5

          main(_) = {
            println(
              partition(
                isFiveChars, ["he", "hello", "world", "foo", "bar", "fubar"]))
          }
        }
      }
      '("%([\"hello\", \"world\", \"fubar\"], [\"he\", \"foo\", \"bar\"])")))

  (test-case "map"
    (check-equal?
      @interp-lines{
        module Test {
          import Core
          import Core.List
          import IO

          main(_) = {
            let strs = [
              "hello",
              "ab",
              "helloworld",
              "hello world"
            ]
            let lengths = map(length, strs)
            println(lengths)
          }
        }
      }
      '("[5, 2, 10, 11]")))


  (test-case "|>"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import IO
          main(_) = {
            println(42 |> (fun(x) = x + 1) |> (fun(y) = 2 * y))
          }
        }
      }
      '("86")))

  (test-case "|>"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import IO

          lessThan5(x) = x < 5
          andTrue(b) = b && True

          main(_) = {
            println(3
              |> (fun(x) = x + 1)
              |> lessThan5
              |> andTrue
            )
          }
        }
      }
      '("True")))
)
