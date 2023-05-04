include Literal::Types

test "Any" do
  assert _Any === 0
  assert _Any === "a"
  assert _Any === :a
  assert _Any === []
  assert _Any === {}
  assert _Any === Object.new
  assert _Any === Class.new

  refute _Any === nil
end

test "Array" do
  assert _Array(String) === ["a", "b", "c"]

  refute _Array(String) === ["a", "b", 1]
  refute _Array(String) === Set.new(["a", "b", "c"])
end

test "Boolean" do
  assert _Boolean === true
  assert _Boolean === false

  refute _Boolean === nil
  refute _Boolean === 0
  refute _Boolean === "true"
  refute _Boolean === "false"
  refute _Boolean === [true]
  refute _Boolean === [false]
  refute _Boolean === TrueClass
  refute _Boolean === FalseClass
end

test "Class" do
  assert _Class(StandardError) === StandardError
  assert _Class(StandardError) === RuntimeError

  refute _Class(StandardError) === Exception
  refute _Class(StandardError) === Object
  refute _Class(StandardError) === Class
end

test "Enumerable" do
  assert _Enumerable(String) === ["a", "b", "c"]
  assert _Enumerable(String) === Set.new(["a", "b", "c"])

  refute _Enumerable(String) === ["a", "b", 1]
  refute _Enumerable(String) === Set.new(["a", "b", 1])
end

test "Float" do
  assert _Float(0..1) === 0.0
  assert _Float(0..1) === 0.5
  assert _Float(0..1) === 1.0

  refute _Float(0..1) === -1.0
  refute _Float(0..1) === 1.1
end

test "Hash" do
  assert _Hash(String, Integer) === {"a" => 1, "b" => 2, "c" => 3}

  refute _Hash(String, Integer) === {"a" => 1, "b" => 2, 3 => "c"}
end

test "Integer" do
  assert _Integer(1..2) === 1
  assert _Integer(1..2) === 2

  refute _Integer(1..2) === 0
  refute _Integer(1..2) === 3
  refute _Integer(1..2) === 1.0
end

test "Interface" do
  assert _Interface(:to_a) === { a: 1 }

  refute _Interface(:to_a) === ""
end

test "Set" do
  assert _Set(String) === Set.new(["a", "b", "c"])

  refute _Set(String) === Set.new(["a", "b", 1])
  refute _Set(String) === ["a", "b", "c"]
end

test "Tuple" do
  assert _Tuple(String, Integer) === ["a", 1]

  refute _Tuple(String, Integer) === ["a", "b"]
  refute _Tuple(String, Integer) === ["a", 1, "b"]
end

test "Union" do
  assert _Union(String, Integer) === "a"
  assert _Union(String, Integer) === 1

  refute _Union(String, Integer) === :a
  refute _Union(String, Integer) === 1.0
end
