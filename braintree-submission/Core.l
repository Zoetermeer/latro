namespace Core {
  type Bool = True | False
  type Char = Byte
  type String = Char[]

  << Pure >>
  fun (this String) Split(String sep) : String[] {

  }

  type [K, V] Hash = struct {

  }

  fun [K, V] (this [K, V] Hash) Insert(K key, V value) : Unit {

  }

  fun [K, V] (this [K, V] Hash) Update(K key, V value, (fun (V) : V) updateExisting) : Unit {

  }

  interface Entrypoint {
    fun Main(String[]) : Int
  }
}
