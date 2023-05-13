# frozen_string_literal: true

class Person < Literal::Data
	attribute :name, String
	attribute :age, Integer
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
