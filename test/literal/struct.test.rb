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

test "#== compares attributes" do
	person = PersonStruct.new(name: "John", age: 30)
	other = PersonStruct.new(name: "John", age: 30)
	another = PersonStruct.new(name: "John", age: 40)
	assert(person == other)
	refute(person == another)
end

test "#eql? compares attributes" do
	person = PersonStruct.new(name: "John", age: 30)
	other = PersonStruct.new(name: "John", age: 30)
	another = PersonStruct.new(name: "John", age: 40)
	assert(person.eql?(other))
	refute(person.eql?(another))
end

class StudentStruct < PersonStruct
	def ==(other)
		super && other.is_a?(StudentStruct)
	end
end

test "#eql? works with subclass overrides #==" do
	person = PersonStruct.new(name: "John", age: 30)
	student = StudentStruct.new(name: "John", age: 30)
	refute(student.eql? person)
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
