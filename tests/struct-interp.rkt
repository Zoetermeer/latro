#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it returns the empty struct"
    (check-match
      @interp-sexp{
        type t = struct { }

        main(_) = IO::println(t %{ })
      }
      't))

  (test-case "it evaluates struct instances"
    (check-match
      @interp-sexp{
        type Point = struct {
          X : Int
          Y : Int
        }

        main(_) = IO::println(Point %{ X = 3; Y = 4; })
      }
      'Point))

  (test-case "it evaluates struct field accesses"
    (check-equal?
      @interp-sexp{
        type Point = struct {
          X : Int
          Y : Int
        }

        main(_) = {
          let p = Point %{ X = 3; Y = 4; }
          IO::println(Y(p))
        }
      }
      4))

  (test-case "it returns an error on undefined-field accesses"
    (check-match
      @interp-sexp{
        type t = struct { }

        main(_) = {
          let v = t %{ }
          IO::println(x(v))
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier x))))

  (test-case "it evaluates nested struct field accesses"
    (check-equal?
      @interp-sexp{
        type Point = struct {
          X : Int
          Y : Int
        }

        type Line = struct {
          A : Point
          B : Point
        }

        main(_) = {
          let l = Line %{
            A = Point %{ X = 0; Y = 0; };
            B = Point %{ X = 3; Y = 4; };
          }

          IO::println(Y(B(l)))
        }
      }
      4))

  (test-case "it evaluates module-exported struct types"
    (check-equal?
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
            A = Geometry::Point %{ X = 0; Y = 0; };
            B = Geometry::Point %{ X = 3; Y = 4; };
          }

          IO::println(Geometry::Y(Geometry::B(l)))
        }
      }
      4))
)
