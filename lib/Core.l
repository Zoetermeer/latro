@(+)(a, b) = prim(intAdd)(a, b)
@(-)(a, b) = prim(intSub)(a, b)
@(*)(a, b) = prim(intMul)(a, b)
@(/)(a, b) = prim(intDiv)(a, b)

precedence + 6
precedence - 6
precedence * 5
precedence / 5

mod(n, d) = prim(intMod)(n, d)

not(True) = False
not(_)    = True

@(< )(a, b)   = prim(intLt)(a, b)
@(<=)(a, b)  = prim(intLeq)(a, b)
@(> )(a, b)   = prim(intGt)(a, b)
@(>=)(a, b)  = prim(intGeq)(a, b)
@(==)(a, b)  = prim(intEq)(a, b)
@(!=)(a, b)  = not(a == b)

precedence < 9
precedence > 9
precedence <= 9
precedence >= 9
precedence == 10
precedence != 10

@(||)(True, _) = True
@(||)(_, True) = True
@(||)(_, _)    = False

@(&&)(True, True) = True
@(&&)(_, _)       = False

precedence || 11
precedence && 11

@(|>)(x, f) = f(x)
precedence |> 12

type Maybe{a} =
  | Just(a)
  | Nothing

type Result{e, t} =
  | Ok(t)
  | Error(e)

module Core {
  id(v) = v

  module List {
    length{a} : a[] -> Int
    length([])    = 0
    length(x::xs) = 1 + length(xs)


    @(++)([], bs)    = bs
    @(++)(as, [])    = as
    @(++)(a::as, bs) = a :: (as ++ bs)


    head{a} : a[] -> Maybe{a}
    head([]) = Nothing()
    head(x::_) = Just(x)


    tail{a} : a[] -> Maybe{a[]}
    tail([]) = Nothing()
    tail(_::xs) = Just(xs)


    atIndex{a} : a[] -> Int -> Maybe{a}
    atIndex([], _)    = Nothing()
    atIndex(x::_, 0)  = Just(x)
    atIndex(_::xs, n) = atIndex(xs, n - 1)


    map{a, b} : (a -> b) -> a[] -> b[]
    map(_, []) = []
    map(f, x::xs) = f(x) :: map(f, xs)


    each{a} : (a -> Unit) -> a[] -> Unit
    each(_, []) = ()
    each(f, x::xs) {
      f(x)
      each(f, xs)
    }


    foldl{a, b} : (a -> b -> b) -> b -> a[] -> b
    foldl(f, b, []) = b
    foldl(f, b, x::xs) = foldl(f, f(x, b), xs)


    foldr{a, b} : (a -> b -> b) -> b -> a[] -> b
    foldr(f, b, x::xs) = f(x, foldr(f, b, xs))
    foldr(f, b, [])    = b


    select{a} : (a -> Bool) -> a -> %(a[], a[]) -> %(a[], a[])
    select(p, x, %(ts, fs)) =
      cond {
        case p(x) -> %(x :: ts, fs)
        case _    -> %(ts, x :: fs)
      }


    partition{a} : (a -> Bool) -> a[] -> %(a[], a[])
    partition(p, xs) {
      def selector = fun(x, pr) = select(p, x, pr)
      foldr(selector, %([], []), xs)
    }
  }
}

module Tuple {
  fst{a, b} : %(a, b) -> a
  fst(%(a, _)) = a

  snd{a, b} : %(a, b) -> b
  snd(%(_, b)) = b
}

module IO {
  println(v) = prim(println)(v)
}

type String = Char[]

module String {
  splitAt : String -> Int -> %(String, String)
  splitAt(s, 0)      = %("", s)
  splitAt("", _)     = %("", "")
  splitAt(c::cs, 1)  = %([c], cs)
  splitAt(c::cs, n) {
    def %(a, b) = splitAt(cs, n - 1)
    %(c :: a, b)
  }
}
