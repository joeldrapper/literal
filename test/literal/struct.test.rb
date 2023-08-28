# frozen_string_literal: true

class PersonStruct < Literal::Struct
	attribute :name, String
	attribute :age, Integer
	attribute :settings, Hash, default: {}.freeze
end

test do
	original = ExampleStruct.new(name: "example")
	packed = Marshal.dump(original)
	unpacked = Marshal.load(packed)

	expect(unpacked) == original
end

test "#to_h returns attributes as new hash" do
	person = PersonStruct.new(name: "John", age: 30)
	hash = person.to_h
	expect(hash) == { name: "John", age: 30, settings: {} }
	refute(hash.equal?(person.instance_variable_get(:@attributes)))
	expect(hash).not_to_be :frozen?
end

test "does not freeze attribute values" do
	person = PersonStruct.new(name: "John", age: 30, settings: { x: 1 })
	expect(person.settings).not_to_be :frozen?
end

test "#deconstruct returns attributes as array" do
	person = PersonStruct.new(name: "John", age: 30)
	expect(person.deconstruct) == ["John", 30, {}]
end

test "#deconstruct_keys returns attributes as hash" do
	person = PersonStruct.new(name: "John", age: 30, settings: { x: 1 })
	expect(person.deconstruct_keys(nil)) == { name: "John", age: 30, settings: { x: 1 } }
	expect(person.deconstruct_keys([:name])) == { name: "John" }
	expect(person.deconstruct_keys([:age])) == { age: 30 }
	expect(person.deconstruct_keys([:age, :name])) == { name: "John", age: 30 }
end

test "pattern matching" do
	person = PersonStruct.new(name: "John", age: 30, settings: { x: 1 })

	person => PersonStruct[name: "John", age: 30, settings: { x: 1 }]

	person => PersonStruct[String => name, Integer => age, Hash => settings]
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

	expect { person => PersonStruct[name: "x", age: 30, settings: { x: 1 }] }.to_raise NoMatchingPatternError
	expect { person => PersonStruct[String => name, Symbol => age, Hash => settings] }.to_raise NoMatchingPatternError
end
