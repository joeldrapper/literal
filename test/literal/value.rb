let def type = Literal::Value(Integer)
let def example = type.new(1)

context "with Integer" do
  let def type = Literal::Value(Integer)
  let def example = type.new(1)

  test "invalid type" do
    expect { type.new(1.0) }.to_raise(Literal::TypeError)
  end

  test do
    expect(example.value) == 1
    expect(example.to_i) == 1
  end
end

context "with String" do
  let def type = Literal::Value(String)
  let def example = type.new("foo")

  test do
    expect(example.value) == "foo"
    expect(example.to_s) == "foo"
    expect(example.to_str) == "foo"
  end
end

context "with Symbol" do
  let def type = Literal::Value(Symbol)
  let def example = type.new(:foo)

  test do
    expect(example.value) == :foo
    expect(example.to_sym) == :foo
  end
end

context "with Float" do
  let def type = Literal::Value(Float)
  let def example = type.new(1.0)

  test do
    expect(example.value) == 1.0
    expect(example.to_f) == 1.0
  end
end

context "with Set" do
  let def type = Literal::Value(Set)
  let def example = type.new(Set[1, 2, 3])

  test do
    expect(example.value) == Set[1, 2, 3]
    expect(example.to_set) == Set[1, 2, 3]
  end
end

context "with Array" do
  let def type = Literal::Value(Array)
  let def example = type.new([1, 2, 3])

  test do
    expect(example.value) == [1, 2, 3]
    expect(example.to_a) == [1, 2, 3]
    expect(example.to_ary) == [1, 2, 3]
  end
end

context "with Hash" do
  let def type = Literal::Value(Hash)
  let def example = type.new({ foo: :bar })

  test do
    expect(example.value) == { foo: :bar }
    expect(example.to_h) == { foo: :bar }
  end
end

context "with Proc" do
  let def type = Literal::Value(Proc)
  let def value = -> { :foo }
  let def example = type.new(value)

  test do
    expect(example.value) == value
    expect(example.to_proc) == value
  end
end
