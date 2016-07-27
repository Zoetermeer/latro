module Person {
  type Person = struct {
    String Name;
    Int Age;
  }
}

main(_) {
  import Person

  def p = Person %{ Name = "james"; Age = 22; }
  IO.println(p.Name)
  IO.println(Age(p))
}
