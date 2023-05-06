# frozen_string_literal: true

let def type = Literal::Value(Integer)
let def example = type.new(1)

context "with Integer" do
	let def value = 1
	let def type = Literal::Value(Integer)
	let def example = type.new(value)

	test "invalid type" do
		expect { type.new(1.0) }.to_raise(Literal::TypeError)
	end

	test do
		expect(example.value) == value
		expect(example.to_i) == value
	end
end

context "with String" do
	let def value = "foo"
	let def type = Literal::Value(String)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_s) == value
		expect(example.to_str) == value
	end
end

context "with Symbol" do
	let def value = :foo
	let def type = Literal::Value(Symbol)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_sym) == value
	end
end

context "with Float" do
	let def value = 1.0
	let def type = Literal::Value(Float)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_f) == value
	end
end

context "with Set" do
	let def value = Set[1, 2, 3]
	let def type = Literal::Value(Set)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_set) == value
	end
end

context "with Array" do
	let def value = [1, 2, 3]
	let def type = Literal::Value(Array)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_a) == value
		expect(example.to_ary) == value
	end
end

context "with Hash" do
	let def value = { foo: :bar }
	let def type = Literal::Value(Hash)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_h) == value
	end
end

context "with Proc" do
	let def value = -> { :foo }
	let def type = Literal::Value(Proc)
	let def example = type.new(value)

	test do
		expect(example.value) == value
		expect(example.to_proc) == value
	end
end
