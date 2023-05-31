# frozen_string_literal: true

class Literal::Types::FalsyType
	include Literal::Type

	def inspect
		"Falsy"
	end

	def ===(value)
		!value
	end
end
