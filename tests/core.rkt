#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

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
        "3"
        "Unit")))

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
      '("%([\"hello\", \"world\", \"fubar\"], [\"he\", \"foo\", \"bar\"])"
        "Unit")))
)
