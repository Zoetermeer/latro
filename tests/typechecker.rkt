#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "it rejects incorrect annotations on locals"
    (check-match
      @interp-sexp{
        main(_) {
          x : Int
          def x = "hello"
          IO.println(x)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it typechecks tuples"
    (check-equal?
      @interp-lines{
        main(_) {
          x : %(Int, Bool)
          def x = %(1, False)
          IO.println(x)
        }
      }
      '("%(1, False)")))

  (test-case "it rejects incorrect tuple annotations"
    (check-match
      @interp-sexp{
        main(_) {
          x : %(Int, Bool)
          def x = %(1, 2)
          IO.println(x)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Bool) (Got Int)))))

  (test-case "it typechecks tuples of tuples"
    (check-equal?
      @interp-lines{
        main(_) {
          x : %(%(Int, Bool), %(String, Char))
          def x = %(%(1, False), %("hello", 'c'))
          IO.println(x)
        }
      }
      '("%(%(1, False), %(\"hello\", 'c'))")))

  (test-case "it fails to typecheck using non-numerics in arithmetic"
    (check-match
      @interp-sexp{main(_) = IO.println(1 + True)}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck using non-numerics on the LHS of arithmetic exps"
    (check-match
      @interp-sexp{main(_) = IO.println(False + 42)}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck if no numerics are given in arithmetic"
    (check-match
      @interp-sexp{main(_) = IO.println(False + True)}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it typechecks list expressions"
    (check-equal?
      @interp-lines{
        main(_) {
          xs : Bool[]
          def xs = [False, True]
          IO.println(xs)
        }
      }
      '("[False, True]")))

  (test-case "it makes empty-list expressions polymorphic"
    (check-match
      @interp-lines{
        main(_) {
          xs{a} : a[]
          def xs = []
          IO.println(xs)
        }
      }
      '("[]")))

  (test-case "it fails non-uniformly-typed list expressions"
    (check-match
      @interp-sexp{main(_) = IO.println([1, False])}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails ill-typed conses"
    (check-match
      @interp-sexp{main(_) = IO.println(1::[False, True])}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Bool) (Got Int)))))

  (test-case "it fails if the right-hand side of a cons is not a list"
    (check-match
      @interp-sexp{main(_) = IO.println(1::2)}
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App List (Int))) (Got Int)))))

  (test-case "it fails to typecheck if an if-else test is not a boolean"
    (check-match
      @interp-sexp{
        main(_) {
          if (0) { IO.println("zero") }
          else   { IO.println("not zero?") }
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it fails to typecheck if an if-else's branch types do not unify"
    (check-match
      @interp-sexp{
        main(_) {
          def x = if (True) { 42 } else { "hello" }
          IO.println(x)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it searches the module closure for type names"
    (check-equal?
      @interp-lines{
        module Root {
          type Foo = Int

          module Leaf {
            add : Foo -> Int -> Int
            add(x, y) = x + y
          }
        }

        main(_) = IO.println(Root.Leaf.add(1, 2))
      }
      '("3")))

  (test-case "it checks module-exported struct field initializers/getters"
    (check-match
      @interp-lines{
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

        main(_) {
          def l = Geometry.Line %{
            A = Geometry.Point %{ X = 0; Y = 0; };
            B = Geometry.Point %{ X = 3; Y = 4; };
          }

          def x = Geometry.Y(Geometry.B(l))
          IO.println(x)
        }
      }
      '("4")))

  (test-case "it rejects invalid arguments to struct field initializers"
    (check-match
      @interp-sexp{
        type S = struct {
          Int X;
          Int Y;
        }

        main(_) {
          def s = S %{ X = 42; Y = False; }
          def x = s.Y + 2
          IO.println(x)
        }
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it rejects invalid arguments to nested struct field initializers"
    (check-match
      @interp-sexp{
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

        main(_) {
          def l = Geometry.Line %{
            A = Geometry.Point %{ X = 0; Y = False; };
            B = Geometry.Point %{ X = 3; Y = 4; };
          }

          IO.println(l.A.Y + 1)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks expressions with module-binding components"
    (check-match
      @interp-sexp{
        module M {
          def v = False
        }

        main(_) = IO.println(1 + M.v)
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks string patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def x = switch ("hello") {
            "foo" -> "bar"
            42 -> "world"
            _ -> "no match"
          }

          ()
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App List (Char))) (Got Int)))))

  (test-case "it checks tuple patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def %("hello", y) = %(1, False)
          IO.println(y)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App List (Char))) (Got Int)))))

  (test-case "it rejects tuple patterns with non-tuple right-hand exps"
    (check-match
      @interp-sexp{
        main(_) {
          def %(a, b) = 42
          IO.println(a)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App Tuple (,_ ,_))) (Got Int)))))

  (test-case "rejects ill-typed inner tuple patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def %(%(x, 4), z) = %(%(1, True), %(3, 4))
          IO.println(z)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "rejects ill-typed tuple sub-patterns in list patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def [%(1, x), %(2, 3)] = [%(1, False), %(2, True)]
          IO.println(%(x, 1))
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it rejects ill-typed nested list patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def [[1, 2], [3, 4, 5], x] = [[False]]
          x
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it unifies concrete types with the empty list"
    (check-match
      @interp-sexp{
        main(_) {
          def xs = 42 :: []
          def xs' = 43 :: xs
          def xs'' = True :: xs'
          IO.println(xs'')
        }
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it rejects ill-typed cons patterns"
    (check-match
      @interp-sexp{
        main(_) {
          def x::[1] = [False, True]
          IO.println(x)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it unifies concrete types with empty lists in tuples"
    (check-match
      @interp-sexp{
        main(_) {
          def %(is, bs) = %(42 :: [], False :: [])
          IO.println(True :: is)
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks list patterns with concrete types against the empty list"
    (check-match
      @interp-sexp{
        main(_) {
          def %([1, 2, 3, x], y) = %([], False)
          IO.println(x :: "hello")
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule Typecheck) (CantUnify (Expected Char) (Got Int)))))

  (test-case "it checks list patterns against applications returning empty lists"
    (check-equal?
      @interp-lines{
        mt() = []

        main(_) {
          def xs = mt()
          IO.println(1 :: xs)
        }
      }
      '("[1]")))

  (test-case "it fails if the right-hand side of a list-pat binding is ill-typed"
    (check-match
      @interp-sexp{
        main(_) {
          def [x, y] = [1, "hello"]
          IO.println(y)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it infers function types"
    (check-match
      @interp-sexp{
        f() = 42

        main(_) {
          IO.println(f() :: [False])
        }
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule Typecheck) (CantUnify (Expected Bool) (Got Int)))))

  (test-case "it infers the identity function"
    (check-equal?
      @interp-lines{
        id(x) = x

        main(_) {
          IO.println(%(id(1), id(False), id("hello")))
        }
      }
      '("%(1, False, \"hello\")")))

  (test-case "it infers types for expressions with polymorphic applications"
    (check-equal?
      @interp-lines{
        id(x) = x

        main(_) = IO.println(id(42) + id(43))
      }
      '("85")))

  (test-case "it infers type relationships when generalizing"
    (check-match
      @interp-sexp{
        randomzap(x) {
          fun(y) = if (False) { y } else { x }
        }

        main(_) {
          def str = randomzap(3)("hello")
          IO.println(str)
        }
      }
      `(AtPos (SourcePos ,_ 6 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it infers nested function types"
    (check-equal?
      @interp-lines{
        randomzap(x) {
          fun(y) = if (False) { y } else { x }
        }

        main(_) {
          IO.println(%(randomzap(42)(43), randomzap(False)(True)))
        }
      }
      '("%(42, False)")))

  (test-case "it fails to unify if we apply the nested function with a different type"
    (check-match
      @interp-sexp{
        randomzap(x) {
          fun(y) {
            if (False) { y } else { x }
          }
        }

        main(_) {
          IO.println(randomzap(42)(False))
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it infers list types in implicitly polymorphic functions"
    (check-match
      @interp-sexp{
        toList(x) { x::[] }
        main(_) {
          IO.println(False :: toList(42))
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it can infer empty list element types based on other occurrences"
    (check-match
      @interp-sexp{
        make(makeTwo, x) {
          if (makeTwo) {
            [x, x]
          } else {
            []
          }
        }

        main(_) {
          IO.println(False :: make(False, 1))
        }
      }
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  ; This is a bigger issue than it first appears.
  ; We should decide whether we need a monomorphism restriction,
  ; as in Haskell, Ocaml, F#.
  #;(test-case "it preserves polymorphism for the empty list for function results"
    (check-match
      @typecheck{
        def toList = fun(x) { [] }
        toList(42)
      }
      `(Poly (,t) (App List ((Var ,t))))))

  (test-case "it checks recursive functions with conditions"
    (check-match
      @interp-sexp{
        f(x, runForever) {
          if (runForever) {
            f(x, runForever)
          } else {
            x
          }
        }

        main(_) = IO.println(f("hello world", False) + 1)
      }
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

  (test-case "it fails if switch clauses don't unify with the test expression"
    (check-match
      @interp-sexp{
        main(_) {
          def v = switch (42) {
            0 -> "hello"
            False -> "world"
          }

          IO.println(v)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks switches in function bodies"
    (check-match
      @interp-sexp{
        len(ls) {
          switch (ls) {
            [] -> 0
            xs -> xs
          }
        }

        main(_) = IO.println(len([1]))
      }
      `(AtPos (SourcePos ,_ 2 ,_) (CompilerModule Typecheck) (CantUnify (Expected (App List (,_))) (Got Int)))))

  (test-case "it allows polymorphic behavior of functions with switches at different callsites"
    (check-equal?
      @interp-lines{
        unwrap{a} : a -> a
        unwrap(x) {
          switch (x) {
            y -> y
          }
        }

        main(_) {
          IO.println(%(unwrap("hello"), unwrap(42)))
        }
      }
      '("%(\"hello\", 42)")))

  (test-case "it checks annotations on variable bindings involving custom type aliases"
    (check-match
      @interp-sexp{
        type Str = Char[]

        main(_) {
          s : Str
          def s = 'c'

          IO.println(s)
        }
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule Typecheck) (CantUnify (Expected (App List (Char))) (Got Char)))))

  (test-case "it fails if annotations don't match inferred types (monomorphic)"
    (check-match
      @interp-sexp{
        add : Int -> Int -> Int
        add(x, y) = False

        main(_) = ()
      }
      `(AtPos (SourcePos ,_ 1 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it checks annotated functions with recursive application"
    (check-match
      @interp-sexp{
        len{a} : a[] -> Int
        len([]) = 0
        len(x::xs) = 1 + len(3)

        main(_) = IO.println(len([1, 2]))
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule Typecheck) (CantUnify (Expected (App List ((Meta ,_)))) (Got Int)))))

  (test-case "it fails in ill-typed application of annotated functions"
    (check-match
      @interp-sexp{
        len{a} : a[] -> Int
        len([]) = 0
        len(x::xs) { 1 + len(xs) }

        main(_) = IO.println(len(3))
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App List (,t))) (Got Int)))))

  (test-case "it unifies different type params if an application matches their types"
    (check-match
      @interp-sexp{
        f(x, y) { if (True) { x } else { y } }
        main(_) {
          IO.println(f(1, 'c'))
        }
      }
      `(AtPos (SourcePos ,_ 3 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Char)))))

  (test-case "it unifies different explicit type params if an application matches their types"
    (check-match
      @interp-sexp{
        f{a, a} : a -> a -> a
        f(x, y) { if (True) { x } else { y } }
        main(_) {
          IO.println(f(1, 'c'))
        }
      }
      `(AtPos (SourcePos ,_ 4 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Char)))))

  (test-case "it checks ADT constructors"
    (check-match
      @interp-lines{
        type String = Char[]
        type Foo =
          | A(Int)
          | B(String)

        main(_) = IO.println(A(42))
      }
      '("A(42)")))

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
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected (App List (Char))) (Got Bool)))))

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
         (CompilerModule Typecheck)
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
      `(AtPos (SourcePos ,_ 8 ,_) (CompilerModule Typecheck) (UnboundUniqIdentifier (Id MakeOpt ,_)))))

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
      `(AtPos (SourcePos ,_ 11 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

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
      `(AtPos (SourcePos ,_ 10 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

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
      `(AtPos (SourcePos ,_ 9 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

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

  (test-case "it rejects ill-typed applications involving recursive polymorphic types"
    (check-match
      @interp-sexp{
        type BTree{a} =
          | Node(a, BTree{a}, BTree{a})
          | Leaf(a)

        comp(x) = switch(x) {
          0 -> Leaf(0)
          d -> Node(d, comp(d - 1), comp(False))
        }

        main(_) {
          IO.println(comp(1))
        }
      }
      `(AtPos (SourcePos ,_ 7 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it refines annotated functions involving recursive polymorphic types"
    (check-match
      @interp-sexp{
        type BTree{a} =
          | Node(a, BTree{a}, BTree{a})
          | Leaf(a)

        intVal : BTree{Int} -> Int
        intVal(Leaf(v)) = v
        intVal(Node(v, left, right)) = v + intVal(left) + intVal(right)

        addIntData : BTree{Int} -> BTree{Int} -> Int
        addIntData(a, b) = intVal(a) + intVal(b)

        main(_) {
          IO.println(addIntData(Leaf("hello"), Leaf("world")))
        }
      }
      `(AtPos (SourcePos ,_ 13 ,_) (CompilerModule Typecheck) (CantUnify (Expected Int) (Got (App List (Char)))))))

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
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))

  (test-case "it narrows types correctly with annotations"
    (check-match
      @interp-sexp{
        foo : Int -> Int
        foo(a) = a

        main(_) {
          foo(True)
        }
      }
      `(AtPos ,_ (CompilerModule Typecheck) (CantUnify (Expected Int) (Got Bool)))))
)
