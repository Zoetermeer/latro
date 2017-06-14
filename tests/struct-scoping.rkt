#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it binds struct field initializer names at the top level"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import IO

          type Person = struct {
            Name : String
          }

          main(_) = {
            let p = Person %{ Name = "james"; }
            IO.println(p#Name)
          }
        }
      }
      '("\"james\"")))

  (test-case "it binds struct field initializers on locals returned by a function"
    (check-equal?
      @interp-lines{
        module Main {
          import Core
          import IO (println)

          type Person = struct {
            Name : String
          }

          mkPerson(name) = Person %{ Name = name; }

          main(_) = {
            let p = mkPerson("james")
            println(p#Name)
          }
        }
      }
      '("\"james\"")))

  (test-case "it resolves nested struct field initializers"
    (check-equal?
      @interp-lines{
        module Geometry {
          import Core

          type Point = struct {
            X : Int
            Y : Int
          }

          type Line = struct {
            A : Point
            B : Point
          }
        }

        module Main {
          import Core (+)
          import Geometry
          import IO (println)

          main(_) = {
            let l = Geometry.Line %{
              A = Geometry.Point %{ X = 0; Y = 42; };
              B = Geometry.Point %{ X = 3; Y = 4; };
            }

            IO.println(l#A#Y + 1)
          }
        }
      }
      '("43")))

  (test-case "it does not allow a field defined in one struct type to be initialized in another"
    (check-match
      @interp-sexp{
        type Foo { A : Int }
        type Bar { B : Int }

        main(_) = IO::println(Bar %{ A = 42; })
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier A))))

  (test-case "it does not allow a field defined in one struct type to be accessed in another"
    (check-match
      @interp-sexp{
        type Foo { A : Int }
        type Bar { B : Int }

        main(_) = {
          let b = Bar %{ B = 42; }
          IO::println(b.A)
          IO.println(b->A)
          IO.println(b[A])
        }
      }
      ; Note that we expect the typechecker to detect this, because the alpha-converter cannot always
      ; know the type of an expression
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule Types) (UnboundStructField Bar A))))

	(test-case "it does not allow multiple struct types to use the same field identifier"
		(check-match
			@interp-sexp{
        type a = struct { X : Int }
        type b = struct { X : Bool }

        main(_) = IO::println(42)
			}
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound X))))

	(test-case "it does not allow multiple struct types to use the same field identifier inside a module"
		(check-match
			@interp-sexp{
        module Types {
          type a = struct { X : Int }
          type b = struct { X : Bool }
        }

        main(_) = IO::println(42)
			}
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound X))))

	(test-case "it does not allow a struct field with the same name as one in an imported module"
		(check-match
			@interp-sexp{
        module A {
          type a = struct { X : Int }
        }

        import A
        type b = struct { X : Bool }

        main(_) = IO::println(42)
			}
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound X))))

	(test-case "it does not allow an imported struct field id to match one in an already-defined struct type"
		(check-match
			@interp-sexp{
        module A {
          type a = struct { X : Int }
        }

        type b = struct { X : Bool }
        import A

        main(_) = IO::println(42)
			}
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound X))))

  (test-case "it rejects unbound id's on nested struct field references"
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
            A = Geometry::Point %{ X = 0; Y = 42; };
            B = Geometry::Point %{ X = 3; Y = 4; };
          }

          IO::println(l.A.BogusId + 1)
        }
      }
      `(AtPos (SourcePos ,_ 19 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier BogusId))))

  (test-case "it does not allow module-exported struct type bindings to escape"
    (check-match
      @interp-sexp{
        module Geometry {
          type Point = struct {
            X : Int
            Y : Int
          }
        }

        main(_) = {
          let p = Point %{ X = 0; Y = 0; }
          IO::println(p)
        }
      }
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule AlphaConvert) (UnboundRawIdentifier Point))))
)
