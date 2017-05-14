infixl (+)(a, b) = prim(intAdd)(a, b)
infixl (-)(a, b) = prim(intSub)(a, b)
infixl (*)(a, b) = prim(intMul)(a, b)
infixl (/)(a, b) = prim(intDiv)(a, b)

precedence + 6
precedence - 6
precedence * 5
precedence / 5

mod(n, d) = prim(intMod)(n, d)

pow : Int -> Int -> Int
pow(n, 0) = 1
pow(n, p) = n * pow(n, p - 1)

not(True) = False
not(_)    = True

infixl (< )(a, b)   = prim(intLt)(a, b)
infixl (<=)(a, b)  = prim(intLeq)(a, b)
infixl (> )(a, b)   = prim(intGt)(a, b)
infixl (>=)(a, b)  = prim(intGeq)(a, b)
infixl (==)(a, b)  = prim(intEq)(a, b)
infixl (!=)(a, b)  = not(a == b)

precedence < 9
precedence > 9
precedence <= 9
precedence >= 9
precedence == 10
precedence != 10

infixl (||)(True, _) = True
infixl (||)(_, True) = True
infixl (||)(_, _)    = False

infixl (&&)(True, True) = True
infixl (&&)(_, _)       = False

precedence || 11
precedence && 11

infixl (|>)(x, f) = f(x)
precedence |> 12

type Result<e, t> =
  | Ok(t)
  | Error(e)

type String = Char[]

module Core {
  id<a> : a -> a
  id(v) = v


  charEqual : Char -> Char -> Bool
  charEqual(c1, c2) = prim(charEq)(c1, c2)


  module Maybe {
    type <a>
      | Just(a)
      | Nothing


    isJust<a> : Maybe<a> -> Bool
    isJust(Just(_)) = True
    isJust(_) = False
  }


  module List {
    import Core

    length<a> : a[] -> Int
    length([])    = 0
    length(x@xs) = 1 + length(xs)


    concat<a> : a[][] -> a[]
    concat([]) = []
    concat((x @ xs) @ xss) = x @ concat(xs @ xss)
    concat(_ @ xss) = concat(xss)


    append<a> : a[] -> a[] -> a[]
    append(as, bs) = concat([as, bs])


    infixl (++)([], bs)    = bs
    infixl (++)(as, [])    = as
    infixl (++)(a@as, bs) = a @ (as ++ bs)


    head<a> : a[] -> Core::Maybe<a>
    head([]) = Core::Maybe::Nothing()
    head(x@_) = Core::Maybe::Just(x)


    tail<a> : a[] -> Core::Maybe<a[]>
    tail([]) = Core::Maybe::Nothing()
    tail(_@xs) = Core::Maybe::Just(xs)


    atIndex<a> : a[] -> Int -> Core::Maybe<a>
    atIndex([], _)    = Core::Maybe::Nothing()
    atIndex(x@_, 0)  = Core::Maybe::Just(x)
    atIndex(_@xs, n) = atIndex(xs, n - 1)


    map<a, b> : (a -> b) -> a[] -> b[]
    map(_, []) = []
    map(f, x@xs) = f(x) @ map(f, xs)


    each<a> : (a -> Unit) -> a[] -> Unit
    each(_, []) = ()
    each(f, x@xs) = {
      f(x)
      each(f, xs)
    }


    foldl<a, b> : (a -> b -> b) -> b -> a[] -> b
    foldl(f, b, []) = b
    foldl(f, b, x@xs) = foldl(f, f(x, b), xs)


    foldr<a, b> : (a -> b -> b) -> b -> a[] -> b
    foldr(f, b, x@xs) = f(x, foldr(f, b, xs))
    foldr(f, b, [])    = b


    select<a> : (a -> Bool) -> a -> %(a[], a[]) -> %(a[], a[])
    select(p, x, %(ts, fs)) =
      cond {
        p(x) -> %(x @ ts, fs)
        _    -> %(ts, x @ fs)
      }


    partition<a> : (a -> Bool) -> a[] -> %(a[], a[])
    partition(p, xs) = {
      let selector = fun(x, pr) = select(p, x, pr)
      foldr(selector, %([], []), xs)
    }


    reverse<a> : a[] -> a[]
    reverse([]) = []
    reverse(x @ xs) = reverse(xs) ++ [x]


    take<a> : a[] -> Int -> a[]
    take(x @ xs, n) = cond {
      n == 0 -> []
      _      -> x @ take(xs, n - 1)
    }
  }

  module Character {
    toInt : Char -> Int
    toInt(c) = prim(charToInt)(c)


    unsafeRead : Char -> Int
    unsafeRead(c) = toInt(c) - 48
  }

  module Integer {
    import Core::List

    digits : Int -> Int[]
    digits(0) = [0]
    digits(n) = {
      let m = mod(n, 10)
      let n' = n / 10
      if (n' == 0) [m] digits(n') ++ [m]
    }

    read/priv : String -> Int -> Int
    read/priv("", _) = 0
    read/priv(c @ cs, p) = Core::Character::unsafeRead(c) * pow(10, p) + read/priv(cs, p + 1)


    unsafeRead : String -> Int
    unsafeRead("") = 0
    unsafeRead(str) = read/priv(Core::List::reverse(str), 0)


    toString : Int -> String
    toString(0) = "0"
    toString(n) = {
      cond {
        n < 0 -> "-" ++ toString(n - n * 2)
        _     -> {
          let r = mod(n, 10)
          let c = switch (r) {
            0 -> '0'
            1 -> '1'
            2 -> '2'
            3 -> '3'
            4 -> '4'
            5 -> '5'
            6 -> '6'
            7 -> '7'
            8 -> '8'
            9 -> '9'
          }
          let n' = n / 10
          cond {
            n' == 0 -> [c]
            _       -> toString(n') ++ [c]
          }
        }
      }
    }
  }

  module String {
    import Core::List

    isEmpty : String -> Bool
    isEmpty("") = True
    isEmpty(_) = False


    areEqual : String -> String -> Bool
    areEqual([], []) = True
    areEqual(a @ as, b @ bs) = cond {
      charEqual(a, b) -> areEqual(as, bs)
      _                    -> False
    }

    areEqual(_, _) = False


    splitAt : String -> Int -> %(String, String)
    splitAt(s, 0)      = %("", s)
    splitAt("", _)     = %("", "")
    splitAt(c @ cs, 1)  = %([c], cs)
    splitAt(c @ cs, n) = {
      let %(a, b) = splitAt(cs, n - 1)
      %(c @ a, b)
    }


    split/priv : String -> Char -> String -> String[] -> String[]
    split/priv([], _, curWord, words) = Core::List::reverse(curWord) @ words

    split/priv(c @ cs, matchChar, curWord, words) = {
      if (charEqual(c,matchChar)) {
        let words' = if (isEmpty(curWord)) words Core::List::reverse(curWord) @ words
        split/priv(cs, matchChar, "", words')
      } {
        split/priv(cs, matchChar, c @ curWord, words)
      }
    }

    split : String -> Char -> String[]
    split(str, matchChar) = {
      Core::List::reverse(split/priv(str, matchChar, "", []))
    }


    join : String[] -> String -> String
    join([], _) = ""
    join(s @ ss, spacer) = s ++ spacer ++ join(ss, spacer)


    words : String -> String[]
    words(str) = split(str, ' ')
  }
}

module Tuple {
  fst<a, b> : %(a, b) -> a
  fst(%(a, _)) = a

  snd<a, b> : %(a, b) -> b
  snd(%(_, b)) = b
}

module IO {
  println(v) = prim(println)(v)
  readln() = prim(readln)()
}
