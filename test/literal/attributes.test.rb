# frozen_string_literal: true

class Person
	extend Literal::Attributes

	attribute :name, String, reader: :public, writer: :public
	attribute :age, Integer, reader: :public, writer: :public, default: 30
end

joel = Person.new(name: "Joel")
binding.irb
