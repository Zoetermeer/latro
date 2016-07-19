#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "partition"
    (check-equal?
      @interp{
        import Core.List

        fun isFiveChars(str) = length(str) == 5

        partition(
          isFiveChars, ["he", "hello", "world", "foo", "bar", "fubar"])
      }
      @line{%(["hello", "world", "fubar"], ["he", "foo", "bar"])})))

