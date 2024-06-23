# frozen_string_literal: true

class Person < Literal::Data
	prop :name, String
end

test do
	person = Person.new(name: +"John")
	expect(person.name) == "John"

	expect(person).to_be(:frozen?)
	expect(person.name).to_be(:frozen?)
end
