namespace Core {
  type Bool = True | False

  //Experimental
  fun (!)(Bool) : Bool
  (!)(False) := True
  (!)(True) := False

  type Char = Byte
  type String = Char[]

  type [T] Option = Some T | None

  << Pure >>
  fun [T] ([T] Option) IsJust() : Bool
  (Some _).IsSome() := { True }
  (_).IsSome() := { False }

  << Pure >>
  fun [T] ([T] Option) IsNone() : Bool
  (opt).IsNone() := { !opt.IsSome() }

  type [T] List =
      Cons T ([T] List)
    | Nil

  fun [A, B] ([A] List) Map(fun (A) : B) : [B] List
  (Nil).Map(_) := Nil
  (Cons x xs).Map(f) := Cons (f(x)) (Map xs f)

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

  << Pure >>
  fun (String) Split(String) : String[]
  ("").Split(sep) := { [] }
  (str).Split(sep) := {

  }

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

  interface Entrypoint {
    fun Main(String[]) : Int
  }
}
