# frozen_string_literal: true

class Person
	extend Literal::Properties

	prop :name, String, :positional, reader: :public
	prop :age, Integer, reader: :public
end

class Random
	extend Literal::Properties
	prop :begin, Integer, :positional, reader: :public
end

class WithDefaultBlock
	extend Literal::Properties
	prop :block, Proc, :&, reader: :public, default: -> { proc { "Hello" } }
end

class WithNilableType
	extend Literal::Properties
	prop :name, Literal::Types::NilableType.new(String), :positional
end

test do
	person = Person.new("John", age: 30)

	expect(person.name) == "John"
	expect(person.age) == 30
end

test "initializer type check" do
	expect { Person.new(1, age: "Joel") }.to_raise(Literal::TypeError)
end

test "initializer keyword check" do
	random = Random.new(1)

	expect(random.begin) == 1
end

test "default block" do
	object = WithDefaultBlock.new
	expect(object.block.call) == "Hello"

	object = WithDefaultBlock.new { "World" }
	expect(object.block.call) == "World"
end

test "properties are enumerable" do
	props = Person.literal_properties
	expect(props.size) == 2
	expect(props.map(&:name)) == ["name", "age"]
end

test "introspection" do
	prop1, prop2 = *Person.literal_properties

	expect(prop1.name) == "name"
	expect(prop1.type) == String
	assert(prop1.positional?) { "Expected name to be kind :positional" }
	refute(prop1.keyword?) { "Expected name to not be kind :keyword" }
	refute(prop1.block?) { "Expected name to not be kind :&" }
	refute(prop1.splat?) { "Expected name to not be bind :*" }
	refute(prop1.double_splat?) { "Expected name to not be kind :**" }
	assert(prop1.required?) { "Expected name to be required" }
	refute(prop1.optional?) { "Expected name to not be optional" }

	expect(prop2.name) == "age"
	expect(prop2.type) == Integer
	assert(prop2.keyword?) { "Expected age to be kind :keyword" }
	assert(prop2.required?) { "Expected age to be required" }

	props = WithDefaultBlock.literal_properties
	prop_block = props.first
	assert(prop_block.block?) { "Expected block to be kind :&" }
	assert(prop_block.optional?) { "Expected block to be optional" }

	props = WithNilableType.literal_properties
	prop_name = props.first
	assert(prop_name.optional?) { "Expected name to be optional" }
end

test "after initialize callback" do
	callback_called = false

	example = Class.new do
		extend Literal::Properties

		prop :name, String

		define_method :after_initialize do
			callback_called = true
		end
	end

	example.new(name: "John")

	assert callback_called
end

class Friend < Person
	prop :age, Float, reader: :public
end

test "inheritance" do
	friend = Friend.new("John", age: 30.5)

	expect(friend.name) == "John"
	expect(friend.age) > 30
end
