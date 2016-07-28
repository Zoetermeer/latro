#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "mod"
    (check-equal?
      @interp-lines{
        main(_) {
          IO.println(mod(1, 1))
          IO.println(mod(10, 2))
          IO.println(mod(10, 3))
          IO.println(mod(14, 11))
        }
      }
      '("0"
        "0"
        "1"
        "3")))

  (test-case "foldl"
    (check-equal?
      @interp-lines{
        import Core.List

        main(_) {
          IO.println(foldl((+), 0, [1, 2, 3, 4]))
        }
      }
      '("10")))

  (test-case "length"
    (check-equal?
      @interp-lines{
        import Core.List

        main(_) {
          IO.println(length([]))
          IO.println(length([1]))
          IO.println(length([1, 2]))

          def xs = [1, 2, 3]
          IO.println(length(xs))
        }
      }
      '("0"
        "1"
        "2"
        "3")))

  (test-case "partition"
    (check-equal?
      @interp-lines{
        import Core.List

        isFiveChars(str) = length(str) == 5

        main(_) {
          IO.println(
            partition(
              isFiveChars, ["he", "hello", "world", "foo", "bar", "fubar"]))
        }
      }
      '("%([\"hello\", \"world\", \"fubar\"], [\"he\", \"foo\", \"bar\"])")))

  (test-case "map"
    (check-equal?
      @interp-lines{
        import Core.List

        main(_) {
          def strs = [
            "hello",
            "ab",
            "helloworld",
            "hello world"
          ]
          def lengths = map(length, strs)
          IO.println(lengths)
        }
      }
      '("[5, 2, 10, 11]")))


  (test-case "|>"
    (check-equal?
      @interp-lines{
        main(_) {
          IO.println(42 |> (fun(x) = x + 1) |> (fun(y) = 2 * y))
        }
      }
      '("86")))

  (test-case "|>"
    (check-equal?
      @interp-lines{
        lessThan5(x) = x < 5
        andTrue(b) = b && True

        main(_) {
          IO.println(3
            |> (fun(x) = x + 1)
            |> lessThan5
            |> andTrue
          )
        }
      }
      '("True")))
)
