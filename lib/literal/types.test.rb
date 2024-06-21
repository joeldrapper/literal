# frozen_string_literal: true

include Literal::Types

test "_Any" do
	Fixtures::Objects.each do |object|
		assert AnyType === object
	end

	refute AnyType === nil
end

test "_Array" do
	assert _Array(String) === []
	assert _Array(String) === ["a", "b", "c"]

	refute _Array(String) === ["a", "b", 42]
end

test "_Boolean" do
	assert _Boolean === true
	assert _Boolean === false

	refute _Boolean === nil
end

test "_Callable" do
	assert _Callable === -> {}
	assert _Callable === method(:puts)

	refute _Callable === nil
end

test "_Class" do
	assert _Class(Enumerable) === Array

	refute _Class(Enumerable) === []
	refute _Class(Enumerable) === String
	refute _Class(Enumerable) === Enumerable
end

describe "_Constraint" do
	test "object constraints" do
		age_constraint = _Constraint(Integer, 18..)

		assert age_constraint === 18

		refute age_constraint === 17
		refute age_constraint === 17.5
	end

	test "attribute constraints" do
		age_constraint = _Constraint(Array, size: 2..3)

		assert age_constraint === [1, 2]
		assert age_constraint === [1, 2, 3]

		refute age_constraint === [1]
		refute age_constraint === [1, 2, 3, 4]
		refute age_constraint === Set[1, 2]
	end
end

test "_Descendant" do
	assert _Descendant(Enumerable) === Array
	assert _Descendant(Enumerable) === Set

	refute _Descendant(Enumerable) === []
	refute _Descendant(Enumerable) === String
end

test "_Enumerable" do
	assert _Enumerable(String) === ["a", "b", "c"]
	assert _Enumerable(Integer) === Set[1, 2, 3]

	refute _Enumerable(String) === [1, "a", :symbol]
end

test "_Falsy" do
	falsy_objects = Set[false, nil]
	truthy_objects = Fixtures::Objects - falsy_objects

	falsy_objects.each do |object|
		assert _Falsy === object
	end

	truthy_objects.each do |object|
		refute _Falsy === object
	end
end

test "_Float" do
	assert _Float(18.0..) === 18.0
	assert _Float(18.0..) === 19.5

	refute _Float(18.0..) === 17.99
	refute _Float(18.0..) === 42
	refute _Float(18.0..) === "string"
	refute _Float(18.0..) === nil
end

test "_Frozen" do
	assert _Frozen(Array) === [].freeze
	assert _Frozen(String) === "immutable"

	refute _Frozen(Array) === []
	refute _Frozen(String) === +"mutable"
	refute _Frozen(Array) === nil
end

test "_Hash" do
	assert _Hash(String, Integer) === { "a" => 1, "b" => 2 }
	assert _Hash(Symbol, String) === { foo: "bar", baz: "qux" }

	refute _Hash(String, Integer) === { "a" => "1", "b" => 2 }
	refute _Hash(String, Integer) === { 1 => 2, 3 => 4 }
	refute _Hash(Symbol, String) === { "foo" => "bar", :baz => "qux" }
end

test "_Integer" do
	assert _Integer(18..) === 18
	assert _Integer(18..) === 19

	refute _Integer(18..) === 17
	refute _Integer(18..) === 18.5
	refute _Integer(18..) === "string"
	refute _Integer(18..) === nil
end

test "_Interface" do
	enumerable_interface = _Interface(:each, :map, :select)

	assert enumerable_interface === []
	assert enumerable_interface === Set.new

	refute enumerable_interface === 42
	refute enumerable_interface === "string"
	refute enumerable_interface === nil
end

test "_Intersection" do
	type = _Intersection(
		_Interface(:size),
		_Interface(:each),
	)

	assert type === []
	assert type === Set.new

	refute type === "string"
end

test "_Never" do
	Fixtures::Objects.each do |object|
		refute _Never === object
	end

	refute _Never === nil
end

test "_Void" do
	Fixtures::Objects.each do |object|
		assert _Void === object
	end
end
