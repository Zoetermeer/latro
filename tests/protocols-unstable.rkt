#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it rejects unspecified constraints on rigid type variables"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module Main {
            type Char = primtype(char)
            type String = Char[]

            protocol Show(a) {
              show : a -> String
            }

            imp Show(Char) {
              show(c) = [c]
            }

            showIt<a> : a -> String
            showIt(v) = show(v)

            main(_) = prim(println)(showIt('x'))
          }
        }
        `(AtPos (SourcePos ,_ 16 ,_) (CompilerModule Typecheck) (CannotResolve Show a)))))
)
