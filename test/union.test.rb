# frozen_string_literal: true

include Literal::Types

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
