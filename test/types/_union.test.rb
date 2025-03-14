# frozen_string_literal: true

include Literal::Types

def expect_type_error(expected:, actual:, message:)
	error = assert_raises(Literal::TypeError) do
		Literal.check(expected:, actual:)
	end

	assert_equal error.message, message
end

test "#enumerability" do
	union = _Union(:a, :b, :c, 1, 2, 3, String, Integer)

	assert_equal union.to_a, [:a, :b, :c, 1, 2, 3, String, Integer]
end

test "#deconstruct" do
	union = _Union(:a, :b, :c, 1, 2, 3, String, Integer)

	assert_equal union.deconstruct, [:a, :b, :c, 1, 2, 3, String, Integer]
end

test "#[]" do
	union = _Union(:a, :b, :c, 1, 2, 3, String, Integer)

	assert_equal union[:a], :a
	assert_equal union[:b], :b
	assert_equal union[:c], :c
	assert_equal union[1], 1
	assert_equal union[2], 2
	assert_equal union[3], 3
	assert_equal union[String], String
	assert_equal union[Integer], Integer

	assert_equal union[:d], nil
end

test "#fetch" do
	union = _Union(:a, :b, :c, 1, 2, 3, String, Integer)

	assert_equal union.fetch(:a), :a
	assert_equal union.fetch(:b), :b
	assert_equal union.fetch(:c), :c
	assert_equal union.fetch(1), 1
	assert_equal union.fetch(2), 2
	assert_equal union.fetch(3), 3
	assert_equal union.fetch(String), String
	assert_equal union.fetch(Integer), Integer

	assert_raises(KeyError) { union.fetch(:d) }
end

test ">=" do
	assert _Union(:a, :b, :c) >= _Union(:a, :b, :c)
	assert _Union(:a, :b, :c) >= _Union(:a, :b)
	refute _Union(:a, :b, :c) >= _Union(:a, :b, :c, :d)

	assert _Union(:a, :b, :c) >= :a

	assert _Union(Integer, String) >= 1
	assert _Union(Integer, String) >= "1"
	assert _Union(Array, Hash) >= {}
	assert _Union(Array, Hash) >= []
end

test "_Union with primitives" do
	position = _Union(:top, :right, :bottom, :left, Integer)

	assert position === :top
	assert position === :right
	assert position === :bottom
	assert position === :left
	assert position === 42

	refute position === :center
	refute position === "top"
end

test "other unions are flattened" do
	type = _Union(
		_Union(String, Integer),
		_Union(Symbol, Float),
	)

	assert_equal type.inspect, "_Union([String, Integer, Symbol, Float])"
end

test "_Union matching" do
	type = _Union(String, Integer)

	assert type === "string"
	assert type === 42

	refute type === :symbol
	refute type === []
	refute type === nil

	assert _Union(String, Integer) >= _Union(String, Integer)
	refute _Union(String, Integer) >= _Union(String, Float)
	assert _Union(String, Integer) >= String
	refute _Union(String, Integer) >= Numeric
	assert _Union(String, Numeric) >= Float

	expect_type_error(expected: type, actual: :symbol, message: <<~ERROR)
		Type mismatch

		  Expected: _Union([String, Integer])
		  Actual (Symbol): :symbol
	ERROR

	expect_type_error(expected: _Union(_Array(String), _Array(Integer)), actual: [nil], message: <<~ERROR)
		Type mismatch

		    _Array(String)
		      [0]
		        Expected: String
		        Actual (NilClass): nil
		    _Array(Integer)
		      [0]
		        Expected: Integer
		        Actual (NilClass): nil
	ERROR
end
