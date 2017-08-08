#lang at-exp racket

(module+ test
  (require "common.rkt"
           rackunit)

  (test-case "does not unify type parameters with concretely-typed values"
    (parameterize ([use-core? #f])
      (check-match
        @interp-sexp{
          module Main {
            type Int = primtype(int)
            type Char = primtype(char)

            foo<t> : Int -> t
            foo(42) = 'c'

            main(_) = prim(println)(foo(42))
          }
        }
        `(AtPos
           (SourcePos ,_ 5 ,_)
           (CompilerModule Typecheck)
           (CantUnify
             (Expected (Rigid ,_))
             (Got Char))))))

  (test-case "it unifies user-specified concrete types with inferred type variables"
    (parameterize ([use-core? #f])
      (check-equal?
        @interp-lines{
          module Main {    
            type Unit = primtype(unit)

            each<a> : (a -> Unit) -> a[] -> Unit
            each(_, [])   = ()
            each(f, x @"@" xs) = {
              f(x)
              each(f, xs)
            }
            
            main(_) = {
              each(fun(x) = prim(println)(x), [1, 2, 3]) 
            }
          }
        }
      '("1" "2" "3"))))

  (test-case "it allows named type declarations inside type modules"
		(parameterize ([use-core? #f])
			(check-match
				@interp-lines{
					module Root.Lst {
						type Int = primtype(int)
						import Root

						type<a> | Cons(a, Lst<a>)
										| Nil

						tail<b> : Lst<b> -> Lst<b>
						tail(Nil) = Nil()
						tail(Cons(_, tl)) = tl

						type IntList = Lst<Int>
					}

					module Main {
						import Root.Lst

						main(_) = {
							ints : IntList
							let ints = Cons(42, Cons(43, Nil()))
							prim(println)(tail(ints))
						}
					}
				}
				'("Cons(43, Nil)"))))

  (test-case "it allows mutually recursive refs between adt's and aliases"
		(parameterize ([use-core? #f])
			(check-equal?
				@interp-lines{
					module Main {
						type Int = primtype(int)

						type Lst<b> = t<b>

						type t <a> =
							| Cons(a, Lst<a>)
							| Nil

						type IntList = Lst<Int>

						tail<c> : Lst<c> -> Lst<c>
						tail(Nil) = Nil()
						tail(Cons(_, tl)) = tl

						main(_) = {
							ints : IntList
							let ints = Cons(42, Cons(43, Nil()))
							prim(println)(tail(ints))
						}
					}
				}
				'("Cons(43, Nil)"))))
)
