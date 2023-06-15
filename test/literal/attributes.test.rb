# frozen_string_literal: true

class Person
	extend Literal::Attributes

	attribute :name, String, reader: :public, writer: :public
	attribute :age, Integer, reader: :public, writer: :public, default: 30
	attribute :class, String, writer: :public
end

joel = Person.new(name: "Joel", class: "A")
binding.irb
