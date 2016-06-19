#lang at-exp racket

(require "common.rkt"
         rackunit)

(compile!)

#|
@interp{
  fun +(a, b) = primitive("int+", a, b)
  fun -(a, b) = primitive("int-", a, b)
  fun *(a, b) = primitive("int*", a, b)
  fun /(a, b) = primitive("int/", a, b)

  infix - 2
  infix + 2
  infix / 1
  infix * 1

  1 + 2 * 3 - 4 / 5
}
|#

@alpha-convert{
  fun &&(True, True) = True
  fun &&(_, _) = False

  fun <(0, 0) = False
  fun <(0, _) = True
  fun <(_, 0) = False
  fun <(x, y) = (x - 1) < (y - 1)

  fun <=(0, 0) = True
  fun <=(0, _) = True
  fun <=(_, 0) = False
  fun <=(x, y) = (x - 1) <= (y - 1)

  (3 < 4) && (10 <= 10)
}
