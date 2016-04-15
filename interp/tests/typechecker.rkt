#lang at-exp racket
(require "common.rkt"
         rackunit)

(test-case "it typechecks literals"
  (check-equal? @typecheck{42;} '(App Int))
  (check-equal? @typecheck{True;} '(App Bool)))
