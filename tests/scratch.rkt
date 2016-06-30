#lang at-exp racket

(require "common.rkt"
         rackunit)

@alpha-convert{
  module M {
    fun f() {
      def v = 3
      v
    }
  }

  M.v
}
