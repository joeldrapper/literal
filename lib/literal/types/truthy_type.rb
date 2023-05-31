# frozen_string_literal: true

class Literal::Types::TruthyType
	include Literal::Type

	def inspect
		"Truthy"
	end

	def ===(value)
		!!value
	end
end
