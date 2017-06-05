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
            import Bar
            main(_) = prim(println)(Bar.v)
          }

          module Baz { }

          module Goo { let y = 8 }
        }
        `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier Bar.v)))))

  (test-case "it defines type modules"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Root.Foo {
            type | A | B
          }

          module Main {
            main(_) = ()
          }
        }
        '())))

  (test-case "it does not allow top-level type modules"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module Foo {
            type | A | B
          }

          module Main {
            import Foo
            main(_) = ()
          }
        }
        `(AtPos (SourcePos ,_ 1 ,_) (CompilerModule AlphaConvert) (IllegalTopLevelTypeModule Foo)))))

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
            import Y
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

            main(_) = prim(println)(foo(1))
          }
        }
        `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport A (foo))))))

  (test-case "it exports ADT constructors"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Root {
            type A = | Foo(primtype(int)) | Bar(primtype(int))
          }

          module P {
            import Root
            main(_) = prim(println)(Foo(42))
          }
        }
        '("Foo(42)"))))

  (test-case "it does not import parent exports into submodules"
    (check-match
      @interp-sexp{
        module Foo {
          length(ls) = 3
        }

        module Foo.Bar {
          len(ls) = length(ls)
        }

        module Pgm {
          import Foo.Bar
          import IO
          main(_) = println(Foo.Bar.len([1, 2, 3]))
        }
      }
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier length))))

  (test-case "it binds explicitly imported variables from parent modules"
    (check-equal?
      @interp-lines{
        module Foo {
          length(ls) = 3
        }

        module Foo.Bar {
          import Foo
          len(ls) = length(ls)
        }

        module Pgm {
          import Foo.Bar
          import IO
          main(_) = println(len([1, 2, 3]))
        }
      }
      '("3")))

  (test-case "it aliases modules"
    (check-equal?
      @interp-lines{
        module Program {
          import Core.List = Lst
          import IO

          main(_) = IO.println(Lst.append([1, 2], [3, 4]))
        }
      }
      '("[1, 2, 3, 4]")))

  (test-case "it lexically scopes alias imports"
    (check-match
      @interp-sexp{
        module Foo {
          import Core.List = Lst

          combine(a, b) = Lst.append(a, b)
        }

        module Program {
          import Foo
          import IO
          main(_) = println(Lst.append([3, 4], [5, 6]))
        }
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath Lst))))

  (test-case "it allows reopening and accumulates exports"
    (check-equal?
      @interp-lines{
        module A {
          f() = 42
        }

        module B {
      
        }

        module A {
          g() = f()
        }

        module Main {
          import A
          import Core
          import IO
          main(_) = println(g() + f())
        }
      }
      '("84")))

  (test-case "it drops all imported bindings in a module reopening"
    (check-match
      @interp-sexp{
        module Foo {
          let x = 42
        }

        module Bar {
          import Foo

          let y = x
        }

        module Bar {
          let z = x
        }

        module Main {
          import Bar
          import IO
          main(_) = println(z)
        }
      }
      `(AtPos (SourcePos ,_ 12 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it defines modules with qualified names"
    (check-equal?
      @interp-lines{
        module Foo.Bar {
          let v = 42
        }

        module Main {
          import Foo.Bar
          import IO
          main(_) = println(Foo.Bar.v)
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
          import Foo
          import Foo.Bar
          import IO
          main(_) = println(v + x)
        }
      }
      '("83")))

  (test-case "it does not implicitly import bindings in a parent module defined further down"
    (check-match
      @interp-sexp{
        module Foo.Bar {
          let v = x
        }

        module Foo {
          let x = 41
        }

        module Main {
          import Foo.Bar
          import IO
          main(_) = println(v)
        }
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it replaces the implicit importing of a parent module when an explicit import is used"
    (check-match
      @interp-sexp{
        module Foo.Bar {
          import Foo = F
          let v = x
        }

        module Foo {
          let x = 41
        }

        module Main {
          import Foo.Bar
          import IO
          main(_) = println(v)
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it allows aliased imports of parent modules"
    (check-equal?
      @interp-lines{
        module Foo.Bar {
          import Foo = F
          let v = F.x
        }

        module Foo {
          let x = 41
        }

        module Main {
          import Foo.Bar
          import IO
          main(_) = println(Foo.Bar.v)
        }
      }
      '("41")))

  (test-case "it allows fully-qualified references on imported modules"
    (check-equal?
      @interp-lines{
        module Foo {
          let x = 42
        }

        module Bar {
          import Foo

          let y = Foo.x
        }

        module Main {
          import Bar
          import IO
          main(_) = println(Bar.y)
        }
      }
      '("42")))

  (test-case "it does not allow fully-qualified references to unimported modules"
    (check-match
      @interp-sexp{
        module Foo {
          let x = 42
        }

        module Bar {
          let y = Foo.x
        }

        module Main {
          import IO
          main(_) = println(Bar.y)
        }
      }
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath Foo))))

  (test-case "it imports infix operators"
    (check-equal?
      @interp-sexp{
        module Prims {
          infixl (&&&)(True, True) = True
          infixl (&&&)(_, _) = False
        }

        module Foo {
          import Prims

          f() = True &&& False
        }

        module Main {
          import IO
          import Foo
          main(_) = println(Foo.f())
        }
      }
      'False))

  (test-case "it imports submodule infix operators"
    (check-equal?
      @interp-sexp{
        module Prims.BoolOps {
          infixl (&&&)(True, True) = True
          infixl (&&&)(_, _) = False
        }

        module Main {
          import IO
          import Prims.BoolOps
          main(_) = println(True &&& False)
        }
      }
      'False))

  (test-case "it does not allow pattern bindings to escape modules"
    (check-match
      @interp-sexp{
        module Opt {
          type t<a> = | Some(a) | None

          GetOne() = Some(42)
        }

        module Main {
          import IO
          import Opt = Opt
          main(_) = {
            let x = switch (Opt.GetOne()) {
                Some(43) -> False
                _ -> True
              }

            IO.println(x)
          }
        }
      }
      `(AtPos (SourcePos ,_ 12 ,_) (CompilerModule AlphaConvert) (UnboundConstructor Some))))

  (test-case "it restricts the set of imported bindings with selective imports"
    (check-match
      @interp-sexp{
        module M {
          let x = 1
          let y = 2
          let z = 3
        }

        module N {
          import M (x, z)
          import Core

          v() = x + y
        }

        module Main {
          import N
          import IO

          main(_) = println(v())
        }
      }
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier y))))

  (test-case "it restricts the set of imported bindings with excepting imports"
    (check-match
      @interp-sexp{
        module M {
          let x = 1
          let y = 2
          let z = 3
        }

        module N {
          import M { except(z) }
          import Core

          v() = x + y + z
        }

        module Main {
          import IO
          import N = M

          main(_) = println(M.v())
        }
      }
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier z))))

  (test-case "it renames imported bindings"
    (check-equal?
      @interp-lines{
        module M {
          let x = 1
          let y = 2
          let z = 3
        }

        module N {
          import Core
          import M (x, y, z) { except(z) renaming(x -> z) }

          v() = z + y
        }

        module Main {
          import N
          import IO

          main(_) = println(N.v())
        }
      }
      '("3")))
)
