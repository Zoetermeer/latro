#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it checks module-exported struct field initializers/getters"
    (check-match
      @interp-lines{
        module Geometry {
          type Point = struct {
            X : Int
            Y : Int
          }

          type Line = struct {
            A : Point
            B : Point
          }
        }

        main(_) = {
          let l = Geometry::Line %{
            A = Geometry::Point %{ X = 0; Y = 0; };
            B = Geometry::Point %{ X = 3; Y = 4; };
          }

          let x = Geometry::Y(Geometry::B(l))
          IO::println(x)
        }
      }
      '("4")))

  (test-case "it rejects invalid arguments to struct field initializers"
    (check-match
      @interp-sexp{
        type S = struct {
          X : Int
          Y : Int
        }

        main(_) = {
          let s = S %{ X = 42; Y = False; }
          let x = s.Y + 2
          IO::println(x)
        }
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it rejects invalid arguments to nested struct field initializers"
    (check-match
      @interp-sexp{
        module Geometry {
          type Point = struct {
            X : Int
            Y : Int
          }

          type Line = struct {
            A : Point
            B : Point
          }
        }

        main(_) = {
          let l = Geometry::Line %{
            A = Geometry::Point %{ X = 0; Y = False; };
            B = Geometry::Point %{ X = 3; Y = 4; };
          }

          IO::println(l.A.Y + 1)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))
)
