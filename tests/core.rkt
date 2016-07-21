#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "length"
    (check-equal?
      @interp-lines{
        import Core.List

        IO.println(length([]))
        IO.println(length([1]))
        IO.println(length([1, 2]))

        def xs = [1, 2, 3]
        IO.println(length(xs))
      }
      '("0"
        "1"
        "2"
        "3"
        "Unit")))

  (test-case "partition"
    (check-equal?
      @interp{
        import Core.List

        fun isFiveChars(str) = length(str) == 5

        partition(
          isFiveChars, ["he", "hello", "world", "foo", "bar", "fubar"])
      }
      @line{%(["hello", "world", "fubar"], ["he", "foo", "bar"])})))

