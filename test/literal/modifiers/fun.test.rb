# frozen_string_literal: true

module Example
	extend Literal::Modifiers::Fun
	extend self

	fun :add, [Integer, Integer] => Integer do |a, b|
		a + b
	end

	fun :subtract, [Integer, { from: Integer }] => Integer do |n, from:|
		from - n
	end

	fun :invalid_return, [] => Integer do
		"hello"
	end

	fun :block_required, [:&] => Integer do
		1
	end
end

test "positional arguments" do
	expect(
		Example.add(1, 2)
	) == 3
end

test "keyword arguments" do
	expect(
		Example.subtract(1, from: 3)
	) == 2
end

test "invalid return type" do
	expect {
		Example.invalid_return
	}.to_raise(Literal::TypeError)
end

test "wrong number of arguments" do
	expect {
		Example.add(1, 2, 3)
	}.to_raise(ArgumentError)
end

test "wrong positional arguments" do
	expect {
		Example.add("hello", "world")
	}.to_raise(Literal::TypeError)
end

test "wrong keyword arguments" do
	expect {
		Example.subtract(1, from: "hello")
	}.to_raise(Literal::TypeError)
end

test "block required and not given" do
	expect {
		Example.block_required
	}.to_raise(ArgumentError)
end

test "block given and not required" do
	expect {
		Example.add(1, 2) {}
	}.to_raise(ArgumentError)
end
