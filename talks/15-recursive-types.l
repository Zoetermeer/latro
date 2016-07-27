type BinaryTree{a} =
  | Node(a, BinaryTree{a}, BinaryTree{a})
  | Leaf(a)

size{a} : BinaryTree{a} -> Int
size(Leaf(_)) = 1
size(Node(_, left, right)) =
  1 + size(left) + size(right)

type Depth = Int

complete : Depth -> BinaryTree{Int}
complete(0) = Leaf(0)
complete(depth) = Node(depth, complete(depth - 1), complete(depth - 1))

main(_) {
  def complete1 = complete(1)
  def complete2 = complete(2)
  IO.println(complete1)
  IO.println(complete2)
  IO.println(size(complete1))
  IO.println(size(complete2))
}
