Prims := module {
  type Bool = | True | False

  type Char = Byte
  type String = Char[]

  interface [A] Eq {
    fun (==)(A, A) : Bool
    fun (!=)(A, A) : Bool
  }

  interface [A] Ord {
    fun (<)(A, A) : Bool
    fun (>)(A, A) : Bool
    fun (<=)(A, A) : Bool
    fun (>=)(A, A) : Bool
  }

  interface [A] Show {
    fun (A) Show() : String
  }


  << Pure >>
  fun (String) Split(String) : String[]
  ("").Split(sep) := { [] }
  (str).Split(sep) := {

  }


  type [T] Option = Some T | None

  imp [Show T] ([T Option] Show) {
    (Some t).Show() := { "Some #{t.Show()}" }
    (None).Show() := "None"
  }

  imp [Eq T] ([T Option] Eq) {
    (==)(Some a, Some b) := a == b
    (==)(None, None) := True
    (==)(_, _) := False

    (!=)(a, b) := !(a == b)
  }

  << Pure >>
  fun [T] ([T] Option) IsJust() : Bool
  (Some _).IsSome() := { True }
  (_).IsSome() := { False }

  << Pure >>
  fun [T] ([T] Option) IsNone() : Bool
  (opt).IsNone() := { !opt.IsSome() }

  type [T] List =
    | Cons T ([T] List)
    | Nil

  fun [A, B] ([A] List) Map(fun (A) : B) : [B] List
  (Nil).Map(_) := Nil
  (Cons x xs).Map(f) := Cons (f(x)) (Map xs f)
}

`Prims Tests` := test module {
  `Option Tests` := test module {
    `IsSome/None` := test module {
      `it returns true for Somes`() := {
        Check((Some 42).IsSome() == True);
      }

      `it returns false for Nones`() := {
        Check((None).IsSome() == False);
      }
    }
  }
}

Hash := module {
  /*

    Functions with patterns are desugared using the following rule:

    (<instance-pat1>).Id(<arg-pat1> ...) := body1
    (<instance-pat2>).Id(<arg-pat2> ...) := body2

    -->

    Id(instance, arg1, ...) := {
      match (instance, arg1, ...) with
        | (<instance-pat1>, <arg-pat1>, ...) -> body1
        | (<instance-pat2>, <arg-pat2>, ...) -> body2
    }

  */

  type [K, V] Hash = struct {

  }

  fun [K, V] ([K, V] Hash) Find(K) : [V] Option
  (hash) Find(key) := {
    None
  }


  fun [K, V] ([K, V] Hash) Insert(K, V) : Unit
  (hash).Insert(key, value) := {

  }


  fun [K, V] ([K, V] Hash) Update(K, V, (fun (V) : V)) : Unit
  fun (this) Update(key, value, updateExisting) {

  }
}

Executables := module {
  interface Entrypoint {
    fun Main(String[]) : Int
  }
}

Core := module {
  provide Prims;
  provide Hash;
  provide Executables;
}
