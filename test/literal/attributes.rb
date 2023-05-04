# frozen_string_literal: true

class Person
	extend Literal::Attributes

	attribute :name, _Maybe(String)
end
