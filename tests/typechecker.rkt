#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it typechecks tuples"
    (check-equal?
      @typecheck{%(1, False)}
      '(App Tuple (Int Bool))))

  (test-case "it typechecks tuples of tuples"
    (check-equal?
      @typecheck{%(42, %("hello", True))}
      '(App Tuple (Int (App Tuple ((App List (Char)) Bool))))))

  (test-case "it typechecks arithmetic expressions"
    (check-equal? @typecheck{1 + 1} 'Int)
    (check-equal? @typecheck{1 - 1} 'Int)
    (check-equal? @typecheck{42 + 3 * 1 / 33} 'Int))

  (test-case "it fails to typecheck using non-numerics in arithmetic"
    (check-match
      @typecheck{1 + True}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck using non-numerics on the LHS of arithmetic exps"
    (check-match
      @typecheck{False + 42}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck if no numerics are given in arithmetic"
    (check-match
      @typecheck{False + True}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it typechecks list expressions"
    (check-equal?
      @typecheck{[1, 2, 3]}
      '(App List (Int))))

  (test-case "it makes empty-list expressions polymorphic"
    (check-match
      @typecheck{[]}
      `(Poly (,t) (App List ((Var ,t))))))

  (test-case "it fails non-uniformly-typed list expressions"
    (check-match
      @typecheck{[1, False]}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks cons expressions"
    (check-equal?
      @typecheck{1::[2, 3]}
      '(App List (Int))))

  (test-case "it fails ill-typed conses"
    (check-equal?
      @typecheck{1::[False, True]}
      '(CantUnify (Expected Bool) (Got Int))))

  (test-case "it fails if the right-hand side of a cons is not a list"
    (check-equal?
      @typecheck{1::2}
      '(CantUnify (Expected (App List (Int))) (Got Int))))

  (test-case "it checks if-else expressions"
    (check-equal?
      @typecheck{if (True) { 42 } else { 43 }}
      'Int))

  (test-case "it fails to typecheck if an if-else test is not a boolean"
    (check-match
      @typecheck{if (0) { 42 } else { 43 }}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck if an if-else's branch types do not unify"
    (check-match
      @typecheck{if (True) { 42 } else { "hello" }}
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it checks module-value accesses"
    (check-equal?
      @typecheck{
        module M {
          def v = 42
        }

        M.v
      }
      'Int))

  (test-case "it searches the module closure for type names"
    (check-equal?
      @typecheck{
        module Root {
          type Foo = Int

          module Leaf {
            add => fun(Foo, Int) : Int
            fun add(x, y) = x + y
          }
        }
        Root.Leaf.add(1, 2)
      }
      'Int))

  (test-case "it can resolve submodule members of modules in the closure"
    (check-equal?
      @typecheck{
        module M {
          def foo = 42
        }

        module M' {
          def bar = M.foo
        }

        M'.bar
      }
      'Int))

  (test-case "it can resolve types defined on sibling modules"
    (check-equal?
      @typecheck{
        module Number {
          type t = Int
        }

        module Arith {
          add => fun(Number.t, Number.t) : Number.t
          fun add(x, y) = x + y
        }

        Arith.add(1, 2)
      }
      'Int))

  (test-case "it can resolve qualified type names with matching local id's"
    (check-equal?
      @typecheck{
        module Number {
          type t = Int
        }

        module Div {
          type t =
            | Num(Number.t)
            | ByZero

          fun div(x, 0) = ByZero()
          fun div(x, y) = Num(x / y)
        }

        def Div.Num(answer) = Div.div(100, 10)
        answer
      }
      'Int))

  (test-case "it checks module-exported struct field initializers/getters"
    (check-equal?
      @typecheck{
        module Geometry {
          type Point = struct {
            Int X;
            Int Y;
          }

          type Line = struct {
            Point A;
            Point B;
          }
        }

        def l = Geometry.Line %{
          A = Geometry.Point %{ X = 0; Y = 0; };
          B = Geometry.Point %{ X = 3; Y = 4; };
        }

        Geometry.Y(Geometry.B(l))
      }
      'Int))

  (test-case "it checks expressions with module-binding components"
    (check-equal?
      @typecheck{
        module M {
          def v = 42
        }

        1 + M.v
      }
      'Int))

  (test-case "it infers qualified-reference function application"
    (check-equal?
      @typecheck{
        module M {
          def f = fun(x) { x }
        }

        M.f("hello world")
      }
      '(App List (Char))))

  (test-case "it checks string patterns"
    (check-equal?
      @typecheck{
        switch ("hello") {
          "foo" -> "bar"
          "hello" -> "world"
          _ -> "no match"
        }
      }
      '(App List (Char))))

  (test-case "it checks tuple patterns"
    (check-equal?
      @typecheck{
        def %(x, y) = %(1, False)
        y
      }
      'Bool))

  (test-case "it reports an error for tuple patterns with non-tuple right-hand exps"
    (check-match
      @typecheck{
        def %(a, b) = 42
        a
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App Tuple (,_ ,_))) (Got Int)))))

  (test-case "it checks compound tuple patterns"
    (check-equal?
      @typecheck{
        def %(%(x, y), z) = %(%(1, True), %(3, 4))
        z
      }
      '(App Tuple (Int Int))))

  (test-case "it reports an error if inner tuple patterns are ill-typed"
    (check-match
      @typecheck{
        def %(%(a, b), %(c, d)) = %(%(1, 2), 3)
        b
      }
      `(AtPos
         ,_
         (CompilerModule Types)
         (CantUnify
           (Expected
             (App Tuple (,t1 ,t2)))
           (Got Int)))))

  (test-case "it checks simple list patterns"
    (check-equal?
      @typecheck{
        def [x] = [42]
        x
      }
      'Int))

  (test-case "it checks tuple sub-patterns in list patterns"
    (check-equal?
      @typecheck{
        def [%(1, x), %(2, y)] = [%(1, False), %(2, True)]
        %(x, y)
      }
      '(App Tuple (Bool Bool))))

  (test-case "it checks nested list patterns"
    (check-equal?
      @typecheck{
        def [[1, 2], [3, 4, 5], x] = [[1, 2], [3, 4, 5], [7]]
        x
      }
      '(App List (Int))))

  (test-case "it unifies concrete types with the empty list"
    (check-equal?
      @typecheck{
        42 :: []
      }
      '(App List (Int))))

  (test-case "it checks cons patterns"
    (check-equal?
      @typecheck{
        def x::[] = [1]
        x
      }
      'Int))

  (test-case "it unifies concrete types with empty lists in tuples"
    (check-equal?
      @typecheck{
        %(42 :: [], False :: [])
      }
      '(App Tuple ((App List (Int)) (App List (Bool))))))

  (test-case "it checks list patterns with concrete types against the empty list"
    (check-equal?
      @typecheck{
        def %([1, 2, 3], x) = %([], False)
        x
      }
      'Bool))

  (test-case "it checks list patterns against the empty list"
    (check-match
      @typecheck{
        def [x] = []
        x
      }
      `(Meta ,_)))

  (test-case "it checks list patterns against applications returning empty lists"
    (check-match
      @typecheck{
        def mt = fun() { [] }
        def [x] = mt()

        x
      }
      `(Meta ,_)))

  (test-case "it returns an error for ill-typed list patterns"
    (check-match
      @typecheck{
        def [True, 1, x] = [1, 2, 3]
        x
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Bool) (Got Int)))))

  (test-case "it fails regardless of subexpression order in list pats"
    (check-match
      @typecheck{
        def [x, 1] = [True, False]
        x
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails if the right-hand side of a list-pat binding is ill-typed"
    (check-match
      @typecheck{
        def [x, y] = [1, "hello"]
        y
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it infers function types"
    (check-equal?
      @typecheck{
        def f = fun() { 42 }
        f()
      }
      'Int))

  (test-case "it infers the identity function"
    (check-equal?
      @typecheck{
        def id = fun(x) { x }
        id(False)
      }
      'Bool))

  (test-case "it allows polymorphic behavior for different callsites"
    (check-equal?
      @typecheck{
        def id = fun(x) { x }
        %(id(42), id(False), id("hello"))
      }
      '(App Tuple (Int Bool (App List (Char))))))

  (test-case "it infers types for expressions with polymorphic applications"
    (check-equal?
      @typecheck{
        def id = fun(x) { x }

        id(42) + id(43)
      }
      'Int))

  (test-case "it infers type relationships when generalizing"
    (check-match
      @typecheck{
        def randomzap = fun(x) {
          def f = fun(y) {
            if (False) { y } else { x }
          }

          f
        }

        randomzap
      }
      `(Poly (,t) (App Arrow ((Var ,t) (App Arrow ((Var ,t) (Var ,t))))))))

  (test-case "it infers nested function types"
    (check-equal?
      @typecheck{
        def randomzap = fun(x) {
          def f = fun(y) {
            if (False) { y } else { x }
          }
          f
        }
        %(randomzap(42)(43), randomzap(False)(True))
      }
      '(App Tuple (Int Bool))))

  (test-case "it fails to unify if we apply the nested function with a different type"
    (check-match
      @typecheck{
        def randomzap = fun(x) {
          def f = fun(y) {
            if (False) { y } else { x }
          }
          f
        }

        randomzap(42)(False)
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it infers list types in implicitly polymorphic functions"
    (check-equal?
      @typecheck{
        def toList = fun(x) { x::[] }
        toList(42)
      }
      '(App List (Int))))

  (test-case "it can infer empty list element types based on other occurrences"
    (check-equal?
      @typecheck{
        def make = fun(makeTwo, x) {
          if (makeTwo) {
            [x, x]
          } else {
            []
          }
        }

        make(False, 1)
      }
      '(App List (Int))))

  (test-case "it preserves polymorphism for the empty list for function results"
    (check-match
      @typecheck{
        def toList = fun(x) { [] }
        toList(42)
      }
      `(Poly (,t) (App List ((Var ,t))))))

  (test-case "it makes the empty list polymorphic in tuple expressions"
    (check-equal?
      @typecheck{
        def toList = fun(x) { x::[] }
        %(toList(42), toList("foo"))
      }
      '(App Tuple ((App List (Int)) (App List ((App List (Char))))))))

  (test-case "it checks recursive functions"
    (check-equal?
      @typecheck{
        fun inf(x) { 1 + inf(x) }
        inf(3)
      }
      'Int))

  (test-case "it checks recursive functions with conditions"
    (check-equal?
      @typecheck{
        fun f(x, runForever) {
          if (runForever) {
            f(x, runForever)
          } else {
            x
          }
        }

        f(3, False)
      }
      'Int))

  (test-case "it checks switch expressions"
    (check-equal?
      @typecheck{
        fun len(xs) {
          switch (xs) {
            [] -> 0
            a::as -> 1 + len(as)
          }
        }

        len([42])
      }
      'Int))

  (test-case "it fails if switch clauses return different types"
    (check-match
      @typecheck{
        switch (42) {
          0 -> "hello"
          2 -> 43
          _ -> 44
        }
      }
      `(AtPos
         ,_
         (CompilerModule Types)
         (CantUnify (Expected (App List (Char))) (Got Int)))))

  (test-case "it fails if switch clauses don't unify with the test expression"
    (check-match
      @typecheck{
        switch (42) {
          0 -> "hello"
          False -> "world"
        }
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it allows id shadowing in switch pattern bindings"
    (check-equal?
      @typecheck{
        def x = [1, 2]
        switch (x) {
          x::xs -> x
        }
      }
      'Int))

  (test-case "it binds identifiers introduced in cons patterns in switches"
    (check-equal?
      @typecheck{
        switch ([2]) {
          [] -> [1]
          x::xs -> xs
        }
      }
      '(App List (Int))))

  (test-case "it binds identifiers introduced in nested cons patterns (in tuple pats)"
    (check-equal?
      @typecheck{
        switch (%([1], 42)) {
          %([], _) -> []
          %(x::xs, _) -> xs
        }
      }
      '(App List (Int))))

  (test-case "it checks switches in function bodies"
    (check-equal?
      @typecheck{
        fun len(ls) {
          switch (ls) {
            [] -> 0
            x::xs -> 1 + len(xs)
          }
        }

        len([1])
      }
      'Int))

  (test-case "it allows polymorphic behavior of functions with switches at different callsites"
    (check-equal?
      @typecheck{
        def unwrap = fun(x) {
          switch (x) {
            y -> y
          }
        }

        %(unwrap("hello"), unwrap(42))
      }
      '(App Tuple ((App List (Char)) Int))))

  (test-case "it checks switch expressions with mixed block-style and short-form bodies"
    (check-equal?
      @typecheck{
        switch ([1, 2, 3]) {
          [x, y] -> {
            def z = x + y
            z + 1
          }
          _ -> 3
        }
      }
      'Int))

  (test-case "it checks non-polymorphic annotated function definitions"
    (check-equal?
      @typecheck{
        weird => fun(Int, Int) : Int
        fun weird(0, 0) = 100
        fun weird(x, y) { x + y }

        weird(1, 2)
      }
      'Int))

  (test-case "it checks annotations on variable bindings"
    (check-equal?
      @typecheck{
        v => Int
        def v = 42

        v
      }
      'Int))

  (test-case "it checks annotations on variable bindings involving custom type aliases"
    (check-equal?
      @typecheck{
        type String = Char[]
        s => String
        def s = "hello world"

        s
      }
      '(App List (Char))))

  (test-case "it checks annotations on variable bindings in functions"
    (check-equal?
      @typecheck{
        fun f() {
          x => Int
          def x = 1
          x + 2
        }

        f()
      }
      'Int))

  (test-case "it fails if annotations don't match inferred types (monomorphic)"
    (check-match
      @typecheck{
        add => fun(Int, Int) : Int
        fun add(x, y) = False
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks annotated function definitions"
    (check-equal?
      @typecheck{
        f{a} => fun(a) : a
        fun f(x) = x

        f(42)
      }
      'Int))

  (test-case "it checks annotated functions with recursive application"
    (check-equal?
      @typecheck{
        len{a} => fun(a[]) : Int
        fun len([]) = 0
        fun len(x::xs) { 1 + len(xs) }

        len([1, 2])
      }
      'Int))

  (test-case "it fails in ill-typed application of annotated functions"
    (check-match
      @typecheck{
        len{a} => fun(a[]) : Int
        fun len([]) = 0
        fun len(x::xs) { 1 + len(xs) }

        len(3)
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App List (,t))) (Got Int)))))

  (test-case "it fails if return values are of different type params"
    (check-match
      @typecheck{
        def f = fun(x, y) { if (True) { x } else { y } }
        f(1, False)
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it unifies different type params if an application matches their types"
    (check-equal?
      @typecheck{
        def f = fun(x, y) { if (True) { x } else { y } }
        f(1, 3)
      }
      'Int))

  (test-case "it checks ADT constructors"
    (check-match
      @typecheck{
        type String = Char[]
        type Foo =
          | A(Int)
          | B(String)

        A(42)
      }
      `(App
         (Unique
           (Id Foo ,_)
           (TyFun
             ()
             (App
               (Adt ((Id A ,_) (Id B ,_)))
               ((App Tuple (Int))
                (App Tuple ((App (TyFun () (App List (Char))) ())))))))
         ())))

  (test-case "it fails on ill-typed ADT constructor applications"
    (check-match
      @interp-sexp{
        type String = Char[]
        type Rope =
          | Leaf(String)

        main(_) {
          IO.println(Leaf(False))
        }
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected (App List (Char))) (Got Bool)))))

  (test-case "it checks recursive ADT's"
    (check-equal?
      @interp-lines{
        type String = Char[]
        type Foo =
          | A(Int, String)
          | B(Bool, Foo)

        add1ToInnerA(B(_, A(x, _))) = x + 1

        main(_) {
          def b = B(False, A(42, "hello"))
          IO.println(add1ToInnerA(b))
        }
      }
      '("43")))

  (test-case "it checks annotated functions involving ADT types"
    (check-equal?
      @interp-lines{
        type A = | Foo(Int) | Bar(Int, Bool)

        f : A -> A
        f(v) = v

        main(_) {
          IO.println(f(Bar(1, False)))
        }
      }
      '("Bar(1, False)")))

  (test-case "it checks parameterized ADT types"
    (check-match
      @interp-lines{
        type Option{a} =
          | Some(a)
          | None

        main(_) {
          def Some(x) = Some(())
          x
        }
      }
      '()))

  (test-case "it checks parameterized ADT types with multiple parameters"
    (check-equal?
      @interp-lines{
        type Either{l, r} =
          | Left(l)
          | Right(r)

        main(_) {
          IO.println(%(Right("hello"), Left(42), Right(True)))
        }
      }
      '("%(Right(\"hello\"), Left(42), Right(True))")))

  (test-case "it checks parameterized ADT type constructors with no arguments"
    (check-equal?
      @interp-lines{
        type Option{a} =
          | Some(a)
          | None

        main(_) {
          IO.println(None())
        }
      }
      '("None()")))

  (test-case "it does not unify two distinct types with the same structure"
    (check-match
      @interp-sexp{
        type A{a} =
          | A(a, a)

        type B{a} =
          | B(a, a)

        main(_) {
          IO.println([A(1, 1), B(1, 1)])
        }
      }
      `(AtPos
         (SourcePos ,_ 8 ,_)
         (CompilerModule Types)
         (CantUnify
           (Expected
             (App
               (Unique
                (Id A ,_)
                ,_)
               (Int)))
           (Got
             (App
               (Unique
                 (Id B ,_)
                 ,_)
               (Int)))))))

  (test-case "it checks monomorphic ADT patterns"
    (check-equal?
      @interp-lines{
        type String = Char[]
        type Val =
          | B(Bool)
          | I(Int)
          | S(String)

        main(_) {
          def v = switch (B(True)) {
              I(x) -> x
              B(_) -> 1
              _ -> 0
            }

          IO.println(v + 1)
        }
      }
      '("2")))

  (test-case "it checks ADT patterns"
    (check-equal?
      @interp-lines{
        type Option{a} =
          | Some(a)
          | None

        main(_) {
          def Some(v) = Some(42)
          IO.println(v + 1)
        }
      }
      '("43")))

  (test-case "it does not allow arbitrary functions in ADT patterns"
    (check-match
      @interp-sexp{
        type Option{a} =
          | Some(a)
          | None

        MakeOpt() = Some(False)

        main(_) {
          def MakeOpt(v) = Some(42)
          IO.println(v)
        }
      }
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule Types) (UnboundUniqIdentifier (Id MakeOpt ,_)))))

  (test-case "it does not allow pattern bindings to escape modules"
    (check-match
      @interp-sexp{
        module Opt {
          type t{a} = | Some(a) | None

          GetOne() = Some(42)
        }

        main(_) {
          def x = switch (Opt.GetOne()) {
              Some(43) -> False
              _ -> True
            }

          IO.println(x)
        }
      }
      `(AtPos ,_ (CompilerModule AlphaConvert) (UnboundRawIdentifier Some))))

  (test-case "it checks qualified ADT patterns"
    (check-equal?
      @interp-lines{
        module Opt {
          type t{a} = | Some(a) | None

          GetOne() = Some(42)
        }

        main(_) {
          def Opt.Some(x1) = Opt.GetOne()
          def x2 = switch (Opt.GetOne()) {
              Opt.Some(x) -> x
              _           -> 0
            }

          IO.println(x1 + x2)
        }
      }
      '("84")))

  (test-case "it checks annotated functions on polymorphic ADT's"
    (check-match
      @interp-sexp{
        type Opt{a} =
          | Some(a)
          | None

        unsafeUnwrap{t} : Opt{t} -> t
        unsafeUnwrap(Some(x)) = x

        main(_) {
          def s = unsafeUnwrap(Some("hello"))
          def i = unsafeUnwrap(Some(42))
          IO.println(s + i)
        }
      }
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it checks implicitly typed functions on polymorphic ADT's"
    (check-match
      @interp-sexp{
        type Opt{a} =
          | Some(a)
          | None

        unsafeUnwrap(Some(x)) = x

        main(_) {
          def s = unsafeUnwrap(Some("hello"))
          def i = unsafeUnwrap(Some(42))
          IO.println(s + i)
        }
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it checks annotated functions refining the type parameter on polymorphic ADT's"
    (check-match
      @interp-sexp{
        type Opt{a} =
          | Some(a)
          | None

        unsafeUnwrap : Opt{Int} -> Int
        unsafeUnwrap(Some(x)) = x

        main(_) {
          def s = unsafeUnwrap(Some("hello"))
          IO.println(s)
        }
      }
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule Types) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it infers function types on ADT values"
    (check-equal?
      @interp-lines{
        type Opt{a} = | Some(a) | None

        not(True) = False
        not(_) = True

        isSome(o) {
          switch (o) {
            Some(_) -> True
            _ -> False
          }
        }

        isNone(o) {
          not(isSome(o))
        }

        main(_) {
          IO.println(%(isSome(None()), isSome(Some("hello"))))
        }
      }
      '("%(False, True)")))

  (test-case "it checks applications involving parameterized recursive types"
    (check-equal?
      @interp-lines{
        type BTree{a} =
          | Node(a, BTree{a}, BTree{a})
          | Leaf(a)

        sizeImp(tree) {
          switch (tree) {
            Leaf(_) -> 1
            Node(_, left, right) ->
              1 + sizeImp(left) + sizeImp(right)
          }
        }

        sizeExp{a} : BTree{a} -> Int
        sizeExp(Leaf(_)) = 1
        sizeExp(Node(_, left, right)) {
          1 + sizeImp(left) + sizeImp(right)
        }

        main(_) = IO.println(sizeExp(Leaf(0)))
      }
      '("1")))

  (test-case "it unifies functions constructing recursive polymorphic types"
    (check-equal?
      @interp-lines{
        type BTree{a} =
          | Node(a, BTree{a}, BTree{a})
          | Leaf(a)

        comp(x) = switch(x) {
          0 -> Leaf(0)
          d -> Node(d, comp(d - 1), comp(d - 1))
        }

        main(_) {
          IO.println(comp(1))
        }
      }
      '("Node(1, Leaf(0), Leaf(0))")))

  (test-case "it checks cond expressions"
    (check-equal?
      @interp-lines{
        main(_) =
          IO.println(
            cond {
              False -> "hello"
              _ -> "world"
            }
          )
      }
      '("\"world\"")))

  (test-case "checks a module with common list operations"
    (check-equal?
      @interp-lines{
        module IntList {
          type t = Int[]
          type BoolList = Bool[]

          Concat : t -> t -> t
          Concat(xs, []) { xs }
          Concat([], ys) { ys }
          Concat(x::xs, ys) {
            x :: Concat(xs, ys)
          }

          Map : (Int -> Bool) -> t -> BoolList
          Map(f, []) { [] }
          Map(f, x::xs) {
            f(x) :: Map(f, xs)
          }
        }

        main(_) {
          IO.println(IntList.Concat([], []))
          IO.println(IntList.Concat([1, 2], []))
          IO.println(IntList.Concat([1, 2], [3, 4, 5]))
        }
      }
      '("[]"
        "[1, 2]"
        "[1, 2, 3, 4, 5]")))

  (test-case "it checks functions with argument types accepting multiple type params"
    (check-equal?
      @interp-lines{
        type t{k, v} = %(k, v)[]

        insert{k, v} : t{k, v} -> k -> v -> t{k, v}
        insert(map, key, val) { %(key, val) :: map }

        find{v} : t{Int, v} -> Int -> Maybe{v}
        find([], _) = Nothing()
        find(%(k, v) :: kvs, findKey) =
          cond {
            k == findKey -> Just(v)
            _            -> find(kvs, findKey)
          }

        main(_) {
          def m = [%(1, "hello")]
          IO.println(find(m, 3))
          IO.println(find(m, 1))
        }
      }
      '("Nothing()" "Just(\"hello\")")))

  (test-case "it checks implicit functions with argument types accepting multiple type params"
    (check-equal?
      @interp-lines{
        type t{k, v} = %(k, v)[]

        insert(map, key, val) { %(key, val) :: map }

        find([], _) = Nothing()
        find(%(k, v) :: kvs, findKey) =
          cond {
            k == findKey -> Just(v)
            _            -> find(kvs, findKey)
          }

        main(_) {
          def m = [%(1, "hello")]
          IO.println(find(m, 3))
          IO.println(find(m, 1))
        }
      }
      '("Nothing()" "Just(\"hello\")")))

  (test-case "it checks infix application of binary functions"
    (check-equal?
      @interp-lines{
        @"@"(!!)(a, b) = a + b

        main(_) {
          IO.println(1 !! 3 + 4)
        }
      }
      '("8")))

  (test-case "it rejects invalid arguments to infix operators"
    (check-match
      @interp-sexp{
        @"@"(!!)(a, b) = a + b

        main(_) {
          IO.println(1 !! True)
        }
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it narrows types correctly with annotations"
    (check-match
      @interp-sexp{
        foo : Int -> Int
        foo(a) = a

        main(_) {
          foo(True)
        }
      }
      `(AtPos ,_ (CompilerModule Types) (CantUnify (Expected Int) (Got Bool)))))
)
