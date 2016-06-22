#lang at-exp racket

(require "common.rkt"
         rackunit)

(test-case "it reorders expressions by user-defined precedence"
  (check-equal?
    @interp{
      fun <(0, 0) = False
      fun <(0, _) = True
      fun <(_, 0) = False
      fun <(a, b) = a - 1 < b - 1

      precedence < 1

      fun &&(True, True) = True
      fun &&(_, _) = False

      precedence && 2

      def i = 1
      def j = 2
      def k = 3
      cond {
        case i < k && j < k -> 42
        case _ -> 43
      }
    }
    42))
