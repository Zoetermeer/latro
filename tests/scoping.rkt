#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it does not allow argument bindings to escape"
    (check-match
      @interp-sexp{
        f(x, runForever) = {
          if (runForever)
            f(x, runForever)
            x
        }

        main(_) = IO.println(runForever(3, False))
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundUniqIdentifier runForever))))

  (test-case "it binds identifiers introduced in cons patterns in switches"
    (check-equal?
      @interp-lines{
        main(_) = {
          IO.println(
            switch ([2, 3]) {
              [] -> [1]
              x@"@"xs -> xs
            }
          )
        }
      }
      '("[3]")))

  (test-case "it allows arbitrary rebinding in nested switch scopes"
    (check-equal?
      @interp-lines{
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

        main(_) = IO.println(f(%([10], False)))
      }
      '("11")))

  (test-case "it distinguishes between type and value names in annotations"
    (check-equal?
      @interp-sexp{
        type foo = Int

        foo : foo -> foo -> foo
        foo(a, b) = a + b

        main(_) = IO.println(foo(2, 4))
      }
      6))

	(test-case "it does not allow redefinition on pattern-based top-level bindings"
		(check-match
			@interp-sexp{
				module M {
					let [y, z] = [3, 4]
					let [x, y] = [1, 2]
				}

				main(_) = IO.println(M.x + M.z)
			}
			`(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound y))))

	(test-case "it does not allow redefinition on id-pattern-based top-level bindings"
		(check-match
			@interp-sexp{
				module M {
					let x = 42
					let x = False
				}

				main(_) = IO.println(M.x)
			}
			`(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

	(test-case "it does not allow redefinition on pattern-based, annotated top-level bindings"
		(check-match
			@interp-sexp{
				module M {
					x : Int
					let x = 42

					x : Bool
					let x = False
				}

				main(_) = IO.println(M.x)
			}
			`(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

	(test-case "it allows shadowing in pattern bindings"
		(check-equal?
			@interp-lines{
				f(x) = switch(x) {
					[x] -> x
					_		-> 0
				}

				main(_) = IO.println(f([1]))
			}
			'("1")))

	(test-case "it binds annotated locals"
		(check-equal?
			@interp-lines{
				f(a) = {
					x : Bool
					let x = True

					y : Bool
					let y = True

					if (x && y) { 1 } { 2 }
				}

				main(_) = IO.println(f(1))
			}
			'("1")))

	(test-case "it does not allow redefinition on annotated locals"
		(check-match
			@interp-sexp{
				f(a) = {
					x : Bool
					let x = True

					y : Bool
					let y = True

					x : Int
					let x = 42

					if (x && y) { 1 } { 2 }
				}

				main(_) = IO.println(42)
			}
			`(AtPos (SourcePos ,_ 9 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it respects lexical scope for functions"
    (check-equal?
      @interp-sexp{
        let v = 42
        foo(v) = v + 1

        main(_) = IO.println(v + foo(3))
      }
      46))

  (test-case "it does not export local definitions on modules"
    (check-match
      @interp-sexp{
        module M {
          f() = {
            let v = 3
            v
          }
        }

        main(_) = IO.println(M.v)
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier M.v))))

  (test-case "it does not capture id's in lexical scope for modules as exports"
    (check-match
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = 42

          module n { }
        }

        main(_) = IO.println(m.n.f())
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundQualIdentifier m.n.f))))

  (test-case "it does not allow nested modules to escape the local env"
    (check-match
      @interp-sexp{
        module m {
          module m1 {
            g : Int -> Int -> Int
            g(x, y) = {
              y + x
            }
          }
        }

        main(_) = IO.println(m1.g(1, 1))
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (InvalidUniqModulePath m1))))

  (test-case "it can resolve submodule members of modules in the closure"
    (check-equal?
      @interp-lines{
        module M {
          let foo = 42
        }

        module M' {
          let bar = M.foo
        }

        main(_) = {
          IO.println(M'.bar)
        }
      }
      '("42")))

  (test-case "it can resolve types defined on sibling modules"
    (check-equal?
      @interp-lines{
        module Number {
          type t = Int
        }

        module Arith {
          add : Number.t -> Number.t -> Number.t
          add(x, y) = x + y
        }

        main(_) = IO.println(Arith.add(1, 2))
      }
      '("3")))

  (test-case "it can resolve qualified type names with matching local id's"
    (check-equal?
      @interp-lines{
        module Number {
          type t = Int
        }

        module Div {
          type t =
            | Num(Number.t)
            | ByZero

          div(x, 0) = ByZero()
          div(x, y) = Num(x / y)
        }

        main(_) = {
          let Div.Num(answer) = Div.div(100, 10)
          IO.println(answer)
        }
      }
      '("10")))

  (test-case "it does not allow rebinding in the same scope"
    (check-match
      @interp-sexp{
        main(_) = {
          let v = 42
          let v = 43
          IO.println(v)
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (IdAlreadyBound v))))

  (test-case "it allows rebinding of a non-module-bound id to a module"
    (check-equal?
      @interp-lines{
        let m = 42
        module m {
          let x = 43

          f() = 42
        }

        import Core.List
        import Core.Int
        main(_) = IO.println(toString(m.x + m) ++ " worked!")
      }
      '("\"85 worked!\"")))

  (test-case "it does not allow rebinding at the top level"
    (check-match
      @interp-sexp{
        let x = 42
        let x = 43

        main(_) = IO.println(x)
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it does not allow rebinding at the top level of a module"
    (check-match
      @interp-sexp{
        module M {
          let x = 42
          let x = 43
        }

        main(_) = IO.println(M.x)
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound x))))

  (test-case "it allows submodules to define variables with names matching those of a parent module"
    (check-equal?
      @interp-lines{
        let x = 42

        module M {
          let x = 43
        }

        main(_) = IO.println(x)
      }
      '("42")))

  (test-case "it allows reopening of modules"
    (check-equal?
      @interp-lines{
        module Foo {
          f(x) = x
        }

        module Foo {
          g(y) = y
        }

        main(_) = IO.println(Foo.f(1) + Foo.g(2))
      }
      '("3")))

  (test-case "it allows rebinding of an id to a module in a nested scope"
    (check-equal?
      @interp-lines{
        let m = 42
        module Foo {
          module m {
            let m = 43
          }
        }

        main(_) = IO.println(m + Foo.m.m)
      }
      '("85")))

  (test-case "it allows rebinding for values in nested scopes"
    (check-equal?
      @interp-sexp{
        let v = 42

        main(_) = {
          let x = fun(x) = { let v = 43  v }(1)
          IO.println(x)
        }
      }
      43))

  (test-case "it allows rebinding in a nested 'if' scope"
    (check-equal?
      @interp-lines{
        module m {
          let x = False

          f() = {
            if (True) {
                let x = 42
              }
              ()
          }
        }

        main(_) = {
          let %(a, b) = %(m.f(), m.x)
          IO.println(a)
          IO.println(b)
        }
      }
      '("Unit" "False")))

  (test-case "it refers to the correct value after a rebinding in a nested scope"
    (check-equal?
      @interp-sexp{
        let v = 3

        main(_) = {
          let v = fun(x) = { let v = 43  v }(1) + v
          IO.println(v)
        }
      }
      46))

  (test-case "it resolves module-scoped types with matching names"
    (check-equal?
      @interp-sexp{
        module Number {
          type t = Int
        }

        module Div {
          type t =
            | Num(Number.t)
            | ByZero

          div(x, 0) = ByZero()
          div(x, y) = Num(x / y)
        }

        main(_) = {
          let Div.Num(answer) = Div.div(100, 10)
          IO.println(answer)
        }
      }
      10))

  (test-case "it scopes shadowing type identifiers"
    (check-equal?
      @interp-sexp{
        module I {
          type t = Int

          module B {
            type t = Bool

            boolId : t -> t
            boolId(b) = b
          }

          intId : t -> t
          intId(i) = i
        }

        main(_) = IO.println(I.B.boolId(False))
      }
      'False))

  (test-case "it does not allow multiple type declarations with the same id"
    (check-match
      @interp-sexp{
        type Same = Int
        type Same = Bool

        f : Same
        let f = False

        main(_) = IO.println(f)
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (IdAlreadyBound Same))))

  (test-case "it allows type definitions to 'shadow' ones in the module closure"
    (check-equal?
      @interp-lines{
        type Same = Int

        module Inner {
          type Same = Bool
        }

        f : Inner.Same -> Same -> Inner.Same
        f(True, x) = False
        f(_, x) = True

        main(_) = IO.println(f(False, 42))
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

        main(_) = IO.println(m.x)
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier m.x))))

  (test-case "it does not add locals in function bodies to the module export env"
    (check-match
      @interp-sexp{
        module m {
          f : (-> Int)
          f() = {
            let x = 42
            x
          }
        }

        main(_) = IO.println(m.x)
      }
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier m.x))))

  (test-case "it does not allow bindings in a pattern to escape into other clauses"
    (check-match
      @interp-sexp{
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
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not allow bindings to escape from then/else scopes"
    (check-match
      @interp-sexp{
        main(_) = {
          let v = if (True) {
              let x = 42
              x
            }
            0

          IO.println(x)
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not allow bindings to escape the test exp of an if/else"
    (check-match
      @interp-sexp{
        main(_) = {
          let _ = if (if (True) { let x = 42 True } False) {
                x
              }
              x
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier x))))

  (test-case "it does not require type definitions to be in order"
    (check-equal?
      @interp-sexp{
        type foo = bar
        type bar = Int

        x : foo
        let x = 42

        main(_) = IO.println(x)
      }
      42))

  (test-case "it allows circular dependencies between types"
    (check-equal?
      @interp-lines{
        type Expr =
          | ExprNum(Int)
          | ExprStm(Stm)

        type Stm =
          | StmDef(Char[], Expr)

        main(_) = IO.println([ StmDef("x", ExprNum(42)) ])
      }
      '("[StmDef(\"x\", ExprNum(42))]")))

  (test-case "it allows circular dependencies between module-level types"
    (check-equal?
      @interp-lines{
        module Expr {
          type t =
            | ExprNum(Int)
            | ExprStm(Stm.t)
        }

        module Stm {
          type t =
            | StmDef(Char[], Expr.t)
        }

        main(_) = IO.println([ Stm.StmDef("x", Expr.ExprNum(42)) ])
      }
      '("[StmDef(\"x\", ExprNum(42))]")))

  (test-case "it allows use-before-defines in top-level definitions"
    (check-equal?
      @interp-sexp{
        let y = x
        let x = 42

        main(_) = IO.println(y)
      }
      42))

  (test-case "it allows use-before-defines in module-level definitions"
    (check-equal?
      @interp-sexp{
        module M {
          let y = x
          let x = 42
        }

        main(_) = IO.println(M.y)
      }
      42))

  (test-case "it allows use-before-defines that refer to other modules"
    (check-equal?
      @interp-sexp{
        module M {
          let y = N.x
        }

        module N {
          let x = 42
        }

        main(_) = IO.println(M.y)
      }
      42))

  (test-case "it does not allow use-before-defines in local contexts"
    (check-match
      @interp-sexp{
        foo(a) = {
          let x = y
          let y = a

          x + y
        }
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier y))))

  (test-case "it allows mutually recursive functions"
    (check-equal?
      @interp-lines{
        import Core.List

        foo(0) = "zero"
        foo(x) = bar(x)

        bar(0) = foo(0)
        bar(x) = "not zero"

        main(_) = {
          IO.println(foo(0) ++ foo(1))
        }
      }
      '("\"zeronot zero\"")))

  (test-case "it fails on incorrect qualified paths"
    (check-match
      @interp-sexp{
        module M {
          module N {
            let foo = 42
          }
        }

        module M' {
          let bar = N.foo //The correct reference would be M.N.foo
        }

        main(_) = IO.println(M'.bar)
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule AlphaConvert) (InvalidUniqModulePath N))))

  (test-case "it does not extend type name resolution to closures of closed modules"
    (check-match
      @interp-sexp{
        type Str = Char[]

        module M { }

        f : M.Str -> M.Str
        f(s) = s
      }
      `(AtPos (SourcePos ,_ 5 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier Str))))

  (test-case "it does not extend variable name resolution to closures of closed modules"
    (check-match
      @interp-sexp{
        let foo = 42

        module M {
          let bar = foo
        }

        main(_) = IO.println(M.foo + M.bar)
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule AlphaConvert) (UnboundQualIdentifier M.foo))))

  (test-case "it does not drop exports defined before a submodule"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Outer {
            type A = | Foo(primtype(int)) | Bar(primtype(int))

            module Inner { }

            let otherThing = 43
          }

          main(_) = prim(println)(Outer.Foo(Outer.otherThing))
        }
        '("Foo(43)"))))

  (test-case "it can resolve pattern names in the module closure"
    (check-equal?
      @interp-sexp{
        module Root {
          type A = | Foo(Int) | Bar(Int)

          module M {
            f(a) = {
              switch (a) {
                Foo(x) -> x
                _ -> 0
              }
            }
          }
        }

        main(_) = IO.println(Root.M.f(Root.Foo(43)))
      }
      43))

  (test-case "it can resolve constructors in the module closure"
    (check-equal?
      @interp-lines{
        module Root {
          type A = | Foo(Int) | Bar(Int)

          module M {
            f(a) = {
              switch (a) {
                0 -> Foo(42)
                _ -> Bar(43)
              }
            }
          }
        }

        main(_) = IO.println(Root.M.f(1))
      }
      '("Bar(43)")))

  (test-case "it does not re-export pattern names from the module closure"
    (check-match
      @interp-sexp{
        type A = | Foo(Int) | Bar(Int)

        module M { }

        main(_) = {
          let v = switch (Foo(42)) {
            M.Foo(x) -> x
            _ -> 0
          }

          IO.println(v)
        }
      }
			`(AtPos (SourcePos ,_ 7 ,_) (CompilerModule AlphaConvert) (UnboundConstructor M.Foo))))

  (test-case "it does not allow module-exported type bindings to escape"
    (check-match
      @interp-sexp{
        module Geometry {
          type Thing = Int[]
        }

        main(_) = {
          p : Thing
          let p = [1, 2]
          IO.println(p)
        }
      }
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier Thing))))

  (test-case "it imports infix operators"
    (check-equal?
      @interp-lines{
        module Prims {
          infixl (&&)(True, True) = True
          infixl (&&)(_, _) = False
        }

        module Foo {
          import Prims

          main(_) = {
            IO.println(True && False)
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

        main(_) = IO.println(Bar.x)
      }
      '("42")))

  (test-case "it does not allow direct references to module names"
    (check-match
      @interp-sexp{
        type Foo = | Bar(Int)

        module Foo { }

        main(_) = {
          let _ = if (False) Foo(42) Bar(42)
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
        main(_) = {
          IO.println(Foo.bar(42))
        }
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule AlphaConvert) (OverlappingVarImport Foo (bar)))))

  (test-case "it can handle mutually recursive modules"
    (check-match
      @interp-lines{
        module A {
          import B
          f(x) = cond {
            x < 100 -> g(x)
            _       -> 1
          }
        }

        module B {
          import A
          g(x) = cond {
            x < 100 -> x
            _       -> f(x)
          }
        }

        import B
        import A
        main(_) = IO.println(g(101))
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

        import B
        import A
        main(_) = {
          let a = ComplexA(ComplexB(SimpleA(42)))
          IO.println(a)
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
          main(_) = IO.println(A.one + A.two)
        }
      }
    '("3")))

  (test-case "it does not blow away prior exports with a reopening definition of a submodule"
    (check-equal?
      @interp-lines{
        module A {
          f() = Outer.B.g()
        }

        module Outer.B {
          g() = 42
        }

        module Outer {
          module B { }
        }

        module Main {
          main(_) = IO.println(A.f())
        }
      }
      '("42")))

  (test-case "it does not blow away prior exports with a reopening definition"
    (check-equal?
      @interp-lines{
        module A {
          f() = B.g()
        }

        module B {
          g() = 42
        }

        module B { }

        module Main {
          main(_) = IO.println(A.f())
        }
      }
      '("42")))

  (test-case "it does not preserve bindings in the module closure of a prior partial module definition"
    (check-match
      @interp-sexp{
        module Foo {
          let v = 42

          module A {
            f() = v
          }
        }

        module Foo.A {
          import Core

          h() = f() //Ensure we retained the binding for f
          g() = h() + v //v should no longer be in scope
        } //This is a tricky one because the reopening will end up overwriting Foo.A's entry in
          //the global NS env, along with its module closure.  So when we "reopen" (aka convertLoc)
          //the *initial* definition of A on line 926, we've lost the binding for `v` which should
          //actually still be present.  We want to retain this but somehow drop it when we convertLoc
          //on the `Foo.A` reopening on 931.

        module Main {
          main(_) = IO.println(Foo.A.g())
        }
      }
      `(AtPos (SourcePos ,_ 13 ,_) (CompilerModule AlphaConvert) (UnboundUniqIdentifier v))))

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

        module B.Bar {
          let y = 43
        }

        module Main {
          import A.Foo
          import B

          main(_) = {
            let x = A.Foo.x
            let y = Bar.y //importing B should not  bind Bar

            IO.println(x + y)
          }
        }
      }
      `(AtPos (SourcePos ,_ 19 ,_) (CompilerModule AlphaConvert) (UnboundUniqModulePath Bar))))

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
