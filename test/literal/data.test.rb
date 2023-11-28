# frozen_string_literal: true

class Person < Literal::Data
	attribute :name, String
	attribute :age, Integer
end

class ExtendedPerson < Person
	attribute :settings, Hash, default: {}.freeze
end

test do
	person = Person.new(name: +"John", age: 30)

	expect(person.name) == "John"
	expect(person.age) == 30

	expect(person).to_be :frozen?
	expect(person.name).to_be :frozen?
end

test do
	joe = Person.new(name: "Joe", age: 30)
	john = joe.with(name: "John")

	expect(joe.name) == "Joe"
	expect(john.name) == "John"
	expect(john).to_be :frozen?
end

test "#to_h returns attributes as new hash" do
	person = Person.new(name: "John", age: 30)
	hash = person.to_h
	expect(hash) == { name: "John", age: 30 }
	refute(hash.equal?(person.instance_variable_get(:@attributes)))
	expect(hash).not_to_be :frozen?
	expect(hash[:name]).to_be :frozen?
end

test "#[]" do
	person = Person.new(name: "John", age: 30)
	expect(person[:name]) == "John"
end

test "#[]= with valid type" do
	person = Person.new(name: "John", age: 30)
	person[:name] = "Joe"
	expect(person.name) == "Joe"
end

test "#[]= with invalid type" do
	person = Person.new(name: "John", age: 30)
	expect { person[:name] = 1 }.to_raise Literal::TypeError
end

test "#deconstruct returns attributes as array" do
	person = Person.new(name: "John", age: 30)
	expect(person.deconstruct) == ["John", 30]
end

test "#deconstruct_keys returns attributes as hash" do
	person = Person.new(name: "John", age: 30)
	expect(person.deconstruct_keys(nil)) == { name: "John", age: 30 }
	expect(person.deconstruct_keys([:name])) == { name: "John" }
	expect(person.deconstruct_keys([:age])) == { age: 30 }
	expect(person.deconstruct_keys([:name, :age])) == { name: "John", age: 30 }
end

test "pattern matching" do
	person = ExtendedPerson.new(name: "John", age: 30, settings: { x: 1 })

	person => ExtendedPerson[name: "John", age: 30, settings: { x: 1 }]

	person => ExtendedPerson[String => name, Integer => age, Hash => settings]
	expect(name) == "John"
	expect(age) == 30
	expect(settings) == { x: 1 }

	person => Literal::Structish[name, *rest]
	expect(name) == "John"
	expect(rest) == [30, { x: 1 }]

	person => {name:, age:, **rest}
	expect(name) == "John"
	expect(age) == 30
	expect(rest) == { settings: { x: 1 } }

	expect { person => ExtendedPerson[name: "x", age: 30, settings: { x: 1 }] }.to_raise NoMatchingPatternError
	expect { person => ExtendedPerson[String => name, Symbol => age, Hash => settings] }.to_raise NoMatchingPatternError
end

test "marshalling" do
	object = ExampleData.new(name: "Joel")
	dumped = Marshal.dump(object)
	loaded = Marshal.load(dumped)

	expect(loaded.name) == "Joel"
	expect(loaded).to_be :frozen?
end

test "marshalling with old data" do
	dumped = "\x04\bU:\x10ExampleData[\ai\a{\x06:\tnameI\"\tJoel\x06:\x06ET"
	loaded = Marshal.load(dumped)
end
