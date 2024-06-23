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
end
