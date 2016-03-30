prims := import Primitives

IO := module {
  interface InputPort { ... }

  interface OutputPort { ...  }

  fun [InputPort P] ReadLine(P port) : String {
    prims.ReadLine(port)
  }
}
