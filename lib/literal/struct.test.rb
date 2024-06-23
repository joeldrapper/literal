# frozen_string_literal: true

class Person < Literal::Struct
	prop :name, String
end

test do
	person = Person.new(name: "Joel")
	expect(person.name) == "Joel"
end

test do
	person = Person.new(name: "Joel")
	person.name = "Jill"
	expect(person.name) == "Jill"
end

test do
	person = Person.new(name: "Joel")
	expect(person.to_h) == { name: "Joel" }
end

test do
	a = Person.new(name: "Joel")
	b = Person.new(name: "Joel")

	expect(a) == b
end

test do
	a = Person.new(name: "Joel")
	b = Person.new(name: "Jill")

	expect(a) != b
end

# Marshal doesn't work with anonymous classes
class ::RootStruct < Literal::Struct
	prop :name, String
end

test "marshalling" do
	a = RootStruct.new(name: "Joel")
	b = Marshal.load(Marshal.dump(a))

	expect(b) == a
end

test "marshalling a frozen struct" do
	a = RootStruct.new(name: "Joel")
	a.freeze

	b = Marshal.load(Marshal.dump(a))

	expect(b) == a
	expect(b).to_be(:frozen?)
end

test "as_pack/from_pack" do
	a = RootStruct.new(name: "Joel")
	a.freeze

	b = RootStruct.from_pack(a.as_pack)

	expect(b) == a
	expect(b).to_be(:frozen?)
end
