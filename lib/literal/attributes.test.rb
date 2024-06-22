# frozen_string_literal: true

class Person
	extend Literal::Attributes

	attribute :name, String, :positional, reader: :public
	attribute :age, Integer, reader: :public
end

test do
	person = Person.new("John", age: 30)

	expect(person.name) == "John"
	expect(person.age) == 30
end
