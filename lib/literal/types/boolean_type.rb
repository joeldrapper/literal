# frozen_string_literal: true

# @api private
class Literal::Types::BooleanType
	include Literal::Type

	Instance = new

	def inspect = "_Boolean"

	def ===(value)
		true == value || false == value
	end

	def <=>(other)
		case other
		when true, false
			1
		when Literal::Types::BooleanType
			0
		else
			-1
		end
	end

	freeze
end
