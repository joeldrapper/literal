# frozen_string_literal: true

# @api private
class Literal::Types::BooleanType
	include Literal::Type

	Instance = new

	def inspect = "_Boolean"

	def ===(value)
		true == value || false == value
	end

	def >=(other)
		case other
		when true, false, Literal::Types::BooleanType
			true
		else
			false
		end
	end

	freeze
end
