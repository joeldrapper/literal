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
