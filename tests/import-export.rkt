#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

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

          main(_) = prim(println)(Y::foo(1))
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

          import B
          import A

          main(_) = prim(println)(B::foo(1))
        }
        `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport A (foo))))))

  (test-case "it does not re-export imported bindings"
    (check-match
      @interp-sexp{
        module Foo {
          let v = 42
        }

        module Bar {
          import Foo
        }

        main(_) = IO::println(Bar::v)
      }
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier Bar::v))))

  (test-case "it exports ADT constructors"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Root {
            type A = | Foo(Int) | Bar(Int)

            module M { }
          }

          main(_) = prim(println)(Root::Foo(42))
        }
        '("Foo(42)"))))
)
