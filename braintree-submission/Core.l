namespace Core {
  type Bool = True | False
  type Char = Byte
  type String = Char[]

  type [T] Option = Some T | None

  << Pure >>
  fun (String) Split(String) : String[]
  ("") Split(sep) := { [] }
  (this) Split(sep) := {

  }

  type [K, V] Hash = struct {

  }

  fun [K, V] ([K, V] Hash) Find(K) : [V] Option
  (this) Find(key) := {
    None
  }

  fun [K, V] (this [K, V] Hash) Insert(K key, V value) : Unit {

  }

  fun [K, V] ([K, V] Hash) Update(K, V, (fun (V) : V)) : Unit
  fun (this) Update(key, value, updateExisting) {
  /*fun [K, V] (this [K, V] Hash) Update(K key, V value, (fun (V) : V) updateExisting) : Unit {*/

  }

  interface Entrypoint {
    fun Main(String[]) : Int
  }
}
