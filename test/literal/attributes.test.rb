# frozen_string_literal: true

class Person
	extend Literal::Attributes

	attribute :name, String, reader: :public, writer: :public
	attribute :age, Integer, reader: :public, writer: :public
end

joel = Person.new(name: "Joel", age: 30)
binding.irb
