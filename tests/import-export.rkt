#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it does not re-export imported bindings"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module Foo {
            let v = 42
          }

          module Bar {
            import Foo
          }

          module Program {
            main(_) = prim(println)(Bar.v)
          }

          module Baz { }

          module Goo { let y = 8 }
        }
        `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier Bar.v)))))

  (test-case "it imports type modules"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Root {
            module Foo {
              type | A | B
            }

            module Main {
              main(_) = ()
            }
          }
        }
        '())))

  (test-case "it does not allow rebinding of imported identifiers"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module X {
            foo(_) = 42
          }

          module Y {
            import X

            foo(_) = 43
          }

          module Main {
            main(_) = prim(println)(Y.foo(1))
          }
        }
        `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport X (foo))))))

  (test-case "it does not allow overlapping imports"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module A {
            foo(_) = 42
          }

          module B {
            foo(_) = 43
          }

          module Pgm {
            import B
            import A

            main(_) = prim(println)(B.foo(1))
          }
        }
        `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport A (foo))))))

  (test-case "it exports ADT constructors"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Root {
            type A = | Foo(primtype(int)) | Bar(primtype(int))

            module M { }
          }

          module P {
            main(_) = prim(println)(Root.Foo(42))
          }
        }
        '("Foo(42)"))))

  (test-case "it imports into the module closure"
    (check-equal?
      @interp-lines{
        module Foo {
          length(ls) = 3

          module Bar {
            len(ls) = length(ls)
          }
        }

        module Pgm {
          main(_) = IO.println(Foo.Bar.len([1, 2, 3]))
        }
      }
      '("3")))

  (test-case "it aliases modules"
    (check-equal?
      @interp-lines{
        module Program {
          import Core.List = Lst

          main(_) = IO.println(Lst.append([1, 2], [3, 4]))
        }
      }
      '("[1, 2, 3, 4]")))

  (test-case "it keeps module aliases in scope in deeply nested scopes"
    (check-equal?
      @interp-lines{
        module Program {
          import Core.String = Str

          module Foo {
            module Bar {
              f(a, b) = Str.areEqual(a, b)
            }
          }

          main(_) = IO.println(Program.Foo.Bar.f("hello", "world"))
        }
      }
      '("False")))

  (test-case "it lexically scopes alias imports"
    (check-match
      @interp-sexp{
        module Foo {
          import Core.List = Lst

          combine(a, b) = Lst.append(a, b)
        }

        module Program {
          main(_) = IO.println(Lst.append([3, 4], [5, 6]))
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath Lst))))

  (test-case "it defines modules with qualified names"
    (check-equal?
      @interp-lines{
        module Foo.Bar {
          let v = 42
        }

        module Main {
          main(_) = IO.println(Foo.Bar.v)
        }
      }
      '("42")))

  (test-case "it defines submodules with qualified names"
    (check-equal?
      @interp-lines{
        module Foo.Bar {
          let v = 42
        }

        module Foo {
          let x = 41
        }

        module Main {
          import Core
          main(_) = IO.println(Foo.Bar.v + Foo.x)
        }
      }
      '("83")))
)
