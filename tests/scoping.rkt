#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it does not allow argument bindings to escape"
    (check-match
      @interp-sexp{
        module Test {
          import IO
          f(x, runForever) = {
            if (runForever)
              f(x, runForever)
              x
          }

          main(_) = println(runForever(3, False))
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundUniqIdentifier runForever))))

  (test-case "it binds identifiers introduced in cons patterns in switches"
    (check-equal?
      @interp-lines{
        module Test {
          import IO
          main(_) = {
            println(
              switch ([2, 3]) {
                [] -> [1]
                x@"@"xs -> xs
              }
            )
          }
        }
      }
      '("[3]")))

  (test-case "it does not allow arbitrary rebinding in patterns in nested switch scopes"
    (check-match
      @interp-sexp{
        module Test {
          import Core
          import IO

          f(x) =
            switch (x) {
              %(x, y) -> {
                switch (x) {
                  x@"@"_ -> x + 1
                  _    -> 0
                }
              }
              _       -> 1
            }

          main(_) = println(f(%([10], False)))
        }
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it distinguishes between type and value names in annotations"
    (check-equal?
      @interp-sexp{
        module Test {
          import Core
          import IO

          type foo = Int

          foo : foo -> foo -> foo
          foo(a, b) = a + b

          main(_) = println(foo(2, 4))
        }
      }
      6))

	(test-case "it does not allow redefinition on pattern-based top-level bindings"
		(check-match
			@interp-sexp{
				module M {
          import Core
          import IO

					let [y, z] = [3, 4]
					let [x, y] = [1, 2]

				  main(_) = println(M.x + M.z)
				}
			}
			`(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound y))))

	(test-case "it does not allow redefinition on id-pattern-based top-level bindings"
		(check-match
			@interp-sexp{
				module M {
          import IO

					let x = 42
					let x = False

				  main(_) = IO.println(M.x)
				}
			}
			`(AtPos (SourcePos ,_ 5 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

	(test-case "it does not allow redefinition on pattern-based, annotated top-level bindings"
		(check-match
			@interp-sexp{
				module M {
          import Core
          import IO

					x : Int
					let x = 42

					x : Bool
					let x = False

				  main(_) = IO.println(M.x)
				}
			}
			`(AtPos (SourcePos ,_ 9 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

	(test-case "it does not allow shadowing in pattern bindings"
		(check-match
			@interp-sexp{
        module Test {
          import IO

          f(x) = switch(x) {
            [x] -> x
            _		-> 0
          }

          main(_) = println(f([1]))
        }
			}
			`(AtPos (SourcePos ,_ 5 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

	(test-case "it binds annotated locals"
		(check-equal?
			@interp-lines{
        module Test {
          import Core
          import IO

          f(a) = {
            x : Bool
            let x = True

            y : Bool
            let y = True

            if (x && y) { 1 } { 2 }
          }

          main(_) = println(f(1))
        }
			}
			'("1")))

	(test-case "it does not allow redefinition on annotated locals"
		(check-match
			@interp-sexp{
        module Test {
          import Core
          import IO

          f(a) = {
            x : Bool
            let x = True

            y : Bool
            let y = True

            x : Int
            let x = 42

            if (x && y) { 1 } { 2 }
          }

          main(_) = println(42)
        }
			}
			`(AtPos (SourcePos ,_ 13 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it does not export local definitions on modules"
    (check-match
      @interp-sexp{
        module M {
          f() = {
            let v = 3
            v
          }
        }

        module Main {
          import IO
          import M

          main(_) = IO.println(M.v)
        }
      }
      `(AtPos (SourcePos ,_ 12 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier M.v))))

  (test-case "it does not capture id's in lexical scope for modules as exports"
    (check-match
      @interp-sexp{
        module m {
          import Core

          f : (-> Int)
          f() = 42
        }

        module m.n { }

        module Main {
          import IO
          import m
          import m.n

          main(_) = IO.println(m.n.f())
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundQualIdentifier m.n.f))))

  (test-case "it does not bind nested modules at the root level"
    (check-match
      @interp-sexp{
        module m.m1 {
          import Core

          g : Int -> Int -> Int
          g(x, y) = {
            y + x
          }
        }

        module Main {
          import m1
          main(_) = IO.println(m1.g(1, 1))
        }
      }
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath m1))))

  (test-case "it can resolve qualified type names with matching local id's"
    (check-equal?
      @interp-lines{
        module Number {
          import Core
          type t = Int
        }

        module Div {
          import Core
          import Number = Number

          type t =
            | Num(Number.t)
            | ByZero

          div(x, 0) = ByZero()
          div(x, y) = Num(x / y)
        }

        module Main {
          import Core
          import Div
          import IO

          main(_) = {
            let Div.Num(answer) = Div.div(100, 10)
            IO.println(answer)
          }
        }
      }
      '("10")))

  (test-case "it allows rebinding of a non-module-bound id to a module"
    (check-equal?
      @interp-lines{
        module M {
          let m = 42
        }

        module M.m {
          import M
          let x = m

          f() = x
        }

        module Main {
          import Core
          import IO
          import M
          import M.m = m

          main(_) = println(m.f() + m)
        }
      }
      '("84")))

  (test-case "it does not allow rebinding at the top level of a module"
    (check-match
      @interp-sexp{
        module M {
          let x = 42
          let x = 43
        }

        module Main {
          import IO
          import M
          main(_) = println(M.x)
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it allows submodules to define variables with names matching those of a parent module"
    (check-equal?
      @interp-lines{
        module M {
          let x = 42
        }

        module M.N {
          let x = 43
        }

        module Main {
          import IO
          import M.N

          main(_) = println(x)
        }
      }
      '("43")))

  (test-case "it allows reopening of modules"
    (check-equal?
      @interp-lines{
        module Foo {
          f(x) = x
        }

        module Foo {
          g(y) = y
        }

        module Main {
          import Core
          import Foo
          import IO

          main(_) = println(Foo.f(1) + Foo.g(2))
        }
      }
      '("3")))

  (test-case "it does not allow shadowing/rebinding in a nested 'if' scope"
    (check-match
      @interp-sexp{
        module m {
          import IO

          let x = False

          f() = {
            if (True) {
                let x = 42
              }
              ()
          }

          main(_) = {
            let %(a, b) = %(f(), x)
            println(a)
            println(b)
          }
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it does not allow shadowing/rebinding of module-level variables in a local scope"
    (check-match
      @interp-sexp{
        module Test {
          import Core
          import IO

          let v = 3

          main(_) = {
            let v = fun(x) = { let v = 43  v }(1) + v
            println(v)
          }
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound v))))

  (test-case "it resolves module-scoped types with matching names"
    (check-equal?
      @interp-sexp{
        module Number {
          import Core
          type t = Int
        }

        module Div {
          import Core
          import Number = Number

          type t =
            | Num(Number.t)
            | ByZero

          div(x, 0) = ByZero()
          div(x, y) = Num(x / y)
        }

        module Main {
          import Div
          import IO

          main(_) = {
            let Div.Num(answer) = Div.div(100, 10)
            println(answer)
          }
        }
      }
      10))

  (test-case "it scopes shadowing type identifiers"
    (check-equal?
      @interp-lines{
        module I {
          import Core
          type t = Int
        }

        module I.B {
          import Core
          type t = Bool

          boolId : t -> t
          boolId(b) = b
        }

        module I {
          intId : t -> t
          intId(i) = i
        }

        module Main {
          import IO
          import I
          main(_) = println(I.intId(42))
        }
      }
      '("42")))

  (test-case "it does not allow multiple type declarations with the same id"
    (check-match
      @interp-sexp{
        module Test {
          import Core
          import IO

          type Same = Int
          type Same = Bool

          f : Same
          let f = False

          main(_) = println(f)
        }
      }
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound Same))))

  (test-case "it allows type definitions to 'shadow' ones in the module closure"
    (check-equal?
      @interp-lines{
        module Outer {
          import Core
          type Same = Int
        }

        module Outer.Inner {
          import Core
          type Same = Bool
        }

        module Test {
          import Core
          import IO
          import Outer = Outer
          import Outer.Inner = Inner

          f : Inner.Same -> Outer.Same -> Inner.Same
          f(True, x) = False
          f(_, x) = True

          main(_) = println(f(False, 42))
        }
      }
      '("True")))

  (test-case "it does not add bindings introduced in subexpressions to the module export env"
    (check-match
      @interp-sexp{
        module m {
          f() = {
            if (True) {
                let x = 42
              }
              ()
          }
        }

        module Main {
          import IO
          import m
          main(_) = println(m.x)
        }
      }
      `(AtPos (SourcePos ,_ 13 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier m.x))))

  (test-case "it does not add locals in function bodies to the module export env"
    (check-match
      @interp-sexp{
        module m {
          import Core

          f : (-> Int)
          f() = {
            let x = 42
            x
          }
        }

        module Main {
          import IO
          import m
          main(_) = println(m.x)
        }
      }
      `(AtPos (SourcePos ,_ 14 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier m.x))))

  (test-case "it does not allow bindings in a pattern to escape into other clauses"
    (check-match
      @interp-sexp{
        module Test {
          import Core
          type Foo =
            | B(Bool)
            | I(Int)

          main(_) = {
            let _ = switch (I(42)) {
                I(x) -> x
                B(b) -> x
              }
          }
        }
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not allow bindings to escape from then/else scopes"
    (check-match
      @interp-sexp{
        module Main {
          import IO

          main(_) = {
            let v = if (True) {
                let x = 42
                x
              }
              0

            println(x)
          }
        }
      }
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not allow bindings to escape the test exp of an if/else"
    (check-match
      @interp-sexp{
        module Main {
          main(_) = {
            let _ = if (if (True) { let x = 42 True } False) {
                  x
                }
                x
          }
        }
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not require type definitions to be in order"
    (check-equal?
      @interp-lines{
        module M {
          import Core
          import IO

          type foo = bar
          type bar = Int

          x : foo
          let x = 42

          main(_) = println(x)
        }
      }
      '("42")))

  (test-case "it allows circular dependencies between types"
    (check-equal?
      @interp-lines{
        module Syntax {
          import Core
          import IO

          type Expr =
            | ExprNum(Int)
            | ExprStm(Stm)

          type Stm =
            | StmDef(Char[], Expr)

          main(_) = println([ StmDef("x", ExprNum(42)) ])
        }
      }
      '("[StmDef(\"x\", ExprNum(42))]")))

  (test-case "it allows circular dependencies between types in different modules"
    (check-equal?
      @interp-lines{
        module Expr {
          import Core
          import Stm

          type e =
            | ExprNum(Int)
            | ExprStm(Stm.s)
        }

        module Stm {
          import Core
          import Expr

          type s =
            | StmDef(Char[], Expr.e)
        }

        module Main {
          import IO
          import Expr
          import Stm
          main(_) = println([ Stm.StmDef("x", Expr.ExprNum(42)) ])
        }
      }
      '("[StmDef(\"x\", ExprNum(42))]")))

  (test-case "it allows use-before-defines in module-level definitions"
    (check-equal?
      @interp-sexp{
        module M {
          import IO

          let y = x
          let x = 42

          main(_) = println(y)
        }
      }
      42))

  (test-case "it allows use-before-defines in module-level definitions"
    (check-equal?
      @interp-sexp{
        module M {
          let y = x
          let x = 42
        }

        module Main {
          import IO
          import M
          main(_) = println(M.y)
        }
      }
      42))

  (test-case "it allows use-before-defines that refer to other modules"
    (check-equal?
      @interp-sexp{
        module M {
          import N
          let y = N.x
        }

        module N {
          let x = 42
        }

        module Main {
          import IO
          import M
          main(_) = println(M.y)
        }
      }
      42))

  (test-case "it does not allow use-before-defines in local contexts"
    (check-match
      @interp-sexp{
        module M {
          foo(a) = {
            let x = y
            let y = a

            x + y
          }
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier y))))

  (test-case "it allows mutually recursive functions"
    (check-equal?
      @interp-lines{
        module Main {
          import Core.List
          import IO

          foo(0) = "zero"
          foo(x) = bar(x)

          bar(0) = foo(0)
          bar(x) = "not zero"

          main(_) = {
            println(foo(0) ++ foo(1))
          }
        }
      }
      '("\"zeronot zero\"")))

  (test-case "it fails on incorrect qualified paths"
    (check-match
      @interp-sexp{
        module M { }

        module M.N {
          let foo = 42
        }

        module M' {
          let bar = N.foo //The correct reference would be M.N.foo
        }

        module Main {
          import IO
          import M
          import N
          import M'

          main(_) = println(M'.bar)
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath N))))

  (test-case "it can resolve pattern names in a reopening"
    (check-equal?
      @interp-sexp{
        module MA {
          import Core
          type A = | Foo(Int) | Bar(Int)
        }

        module MA {
          f(a) = {
            switch (a) {
              Foo(x) -> x
              _ -> 0
            }
          }
        }

        module Main {
          import IO
          import MA
          main(_) = println(MA.f(MA.Foo(43)))
        }
      }
      43))

  (test-case "it can resolve imported constructors"
    (check-equal?
      @interp-lines{
        module Root {
          import Core
          type A = | Foo(Int) | Bar(Int)
        }

        module Root.M {
          import Root

          f(a) = {
            switch (a) {
              0 -> Foo(42)
              _ -> Bar(43)
            }
          }
        }

        module Main {
          import IO
          import Root.M

          main(_) = println(Root.M.f(1))
        }
      }
      '("Bar(43)")))

  (test-case "it does not re-export imported pattern names"
    (check-match
      @interp-sexp{
        module MA {
          import Core
          type A = | Foo(Int) | Bar(Int)
        }

        module M { import MA }

        module Main {
          import IO
          import MA
          import M

          main(_) = {
            let v = switch (Foo(42)) {
              M.Foo(x) -> x
              _ -> 0
            }

            println(v)
          }
        }
      }
			`(AtPos (SourcePos ,_ 15 ,_) (CompilerModule AlphaConvert) (UnboundConstructor M.Foo))))

  (test-case "it does not allow module-exported type bindings to escape"
    (check-match
      @interp-sexp{
        module Geometry {
          import Core
          type Thing = Int[]
        }

        module Main {
          import IO

          main(_) = {
            p : Thing
            let p = [1, 2]
            println(p)
          }
        }
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier Thing))))

  (test-case "it imports infix operators"
    (check-equal?
      @interp-lines{
        module Prims {
          infixl (&&)(True, True) = True
          infixl (&&)(_, _) = False
        }

        module Foo {
          import IO
          import Prims

          main(_) = {
            println(True && False)
          }
        }
      }
      '("False")))

  (test-case "it binds imported values"
    (check-equal?
      @interp-lines{
        module Foo {
          let v = 42
        }

        module Bar {
          import Foo
          let x = v
        }

        module Main {
          import Bar
          import IO

          main(_) = println(Bar.x)
        }
      }
      '("42")))

  (test-case "it does not allow direct references to module names"
    (check-match
      @interp-sexp{
        module M {
          import Core
          type Foo = | Bar(Int)
        }

        module Foo { }

        module Main {
          import M
          import Foo

          main(_) = {
            let _ = if (False) Foo(42) Bar(42)
          }
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundUniqIdentifier Foo))))

  (test-case "it does not allow self-imports"
    (check-match
      @interp-sexp{
        module Foo {
          import Foo

          bar(x) = x + 1
        }

        module Main {
          import IO
          main(_) = println(Foo.bar(42))
        }
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport Foo (bar)))))

  (test-case "it can handle mutually recursive modules"
    (check-match
      @interp-lines{
        module A {
          import B
          import Core

          f(x) = cond {
            x < 100 -> g(x)
            _       -> 1
          }
        }

        module B {
          import A
          import Core

          g(x) = cond {
            x < 100 -> x
            _       -> f(x)
          }
        }

        module Main {
          import B
          import A
          import IO

          main(_) = println(g(101))
        }
      }
    '("1")))

  (test-case "it can handle mutually recursive type definitions across modules"
    (check-match
      @interp-lines{
        module A {
          import B

          type AType<A> =
            | SimpleA(A)
            | ComplexA(BType<A>)
        }

        module B {
          import A

          type BType<B> =
            | SimpleB(B)
            | ComplexB(AType<B>)
        }

        module Main {
          import B
          import A
          import IO

          main(_) = {
            let a = ComplexA(ComplexB(SimpleA(42)))
            println(a)
          }
        }
      }
    '("ComplexA(ComplexB(SimpleA(42)))")))

  #;(test-case "it can handle mutually recursive type module definitions"
    (check-match
      @interp-lines{
        module Stuff.AType {
          import Stuff

          type <a> | SimpleA(a)
                   | ComplexA(BType<a>)
        }

        module Stuff.BType {
          import Stuff

          type <b> | SimpleB(b)
                   | ComplexB(AType<b>)
        }

        module Main {
          import IO
          import Stuff
          import Stuff.AType
          import Stuff.BType

          main(_) = {
            let a = ComplexA(ComplexB(SimpleA(42)))
            println(a)
          }
        }
      }
    '("ComplexA(ComplexB(SimpleA(42)))")))

  (test-case "it accumulates separate, same-named module declarations"
    (check-match
      @interp-lines{
        module A {
          let one = 1
        }

        module A {
          let two = 2
        }

        module Main {
          import A
          import Core
          import IO
          main(_) = println(A.one + A.two)
        }
      }
    '("3")))

  (test-case "it does not blow away prior exports with a reopening definition of a submodule"
    (check-equal?
      @interp-lines{
        module A {
          import Outer.B

          f() = Outer.B.g()
        }

        module Outer.B {
          g() = 42
        }

        module OuterB { }

        module Main {
          import A
          import Core
          import IO
          import Outer.B
          main(_) = println(A.f() + g())
        }
      }
      '("84")))

  (test-case "it does not blow away prior exports with a reopening definition"
    (check-equal?
      @interp-lines{
        module A {
          import B
          f() = B.g()
        }

        module B {
          g() = 42
        }

        module B { }

        module Main {
          import A
          import IO
          main(_) = println(A.f())
        }
      }
      '("42")))

  (test-case "it does not preserve bindings from imports in a prior module opening"
    (check-match
      @interp-sexp{
        module Foo {
          let v = 42
        }

        module Foo.A {
          import Foo
          f() = v
        }

        module Foo.A {
          import Core

          h() = f() //Ensure we retained the binding for f
          g() = h() + v //v should no longer be in scope
        } 

        module Main {
          import IO
          main(_) = println(Foo.A.g())
        }
      }
      `(AtPos (SourcePos ,_ 14 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier v))))

  (test-case "it does not allow shadowing across separate module declarations"
    (check-match
      @interp-sexp{
        module A {
          let one = 1
        }

        module A {
          let one = 2
        }

        module Main {
          main(_) = IO.println(A.one)
        }
      }
    `(AtPos ,_ (CompilerModule AlphaConvert) (IdAlreadyBound one))))

  (test-case "it does not allow partially-qualified references to submodules if the containing module is imported"
    (check-match
      @interp-sexp{
        module A.Foo {
          let x = 42
        }

        module B { }

        module B.Bar {
          let y = 43
        }

        module Main {
          import A.Foo
          import B

          main(_) = {
            let x' = A.Foo.x
            let y = Bar.y //importing B should not  bind Bar

            IO.println(x' + y)
          }
        }
      }
      `(AtPos (SourcePos ,_ 17 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath Bar))))

  (test-case "it resolves recursive references in explicitly typed functions"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module ListStuff {
            length<a> : a[] -> primtype(int)
            length([])    = 0
            length(x@"@"xs) = prim(intAdd)(1, length(xs))
          }

          module Pgm {
            import ListStuff
            main(_) = prim(println)(ListStuff.length([1, 2, 3]))
          }
        }
        '("3"))))

  (test-case "it resolves recursive references in implicitly typed functions"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module ListStuff {
            length([])    = 0
            length(x@"@"xs) = prim(intAdd)(1, length(xs))
          }

          module Pgm {
            import ListStuff
            main(_) = prim(println)(ListStuff.length([1, 2, 3]))
          }
        }
        '("3"))))

  (test-case "it resolves recursive references in top-level, implicitly typed functions"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Program {
            length([])    = 0
            length(x@"@"xs) = prim(intAdd)(1, length(xs))

            main(_) = prim(println)(length([1, 2, 3]))
          }
        }
        '("3"))))

  (test-case "it resolves recursive references in top-level, explicitly typed functions"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Program {
            length<a> : a[] -> primtype(int)
            length([])    = 0
            length(x@"@"xs) = prim(intAdd)(1, length(xs))

            main(_) = prim(println)(length([1, 2, 3]))
          }
        }
        '("3"))))

  (test-case "it does not allow constructors on different types to have the same name"
    (check-match
      @interp-sexp{
        module Types {
          type Foo =
            | CtorA
            | CtorB

          type Bar =
            | CtorA
            | CtorB

          main(_) = IO.println(42)
        }
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound CtorA))))

	(test-case "it rewrites aliases from type modules such that they use fully-qualified references"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Outer.Maybe {
            import Outer

            type <a>
              | Just(a)
              | Nothing


            isJust<a> : Maybe<a> -> primtype(bool)
            isJust(Just(_)) = True
            isJust(_) = False
          }

          module Program {
            import Outer.Maybe

            main(_) = prim(println)(Outer.Maybe.isJust(Outer.Maybe.Just(42)))
          }
        }
        '("True"))))
)
