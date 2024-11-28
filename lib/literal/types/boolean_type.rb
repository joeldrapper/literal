# frozen_string_literal: true

# @api private
class Literal::Types::BooleanTypeClass
	include Literal::Type

	def inspect
		"_Boolean"
	end

	def ===(value)
		true == value || false == value
	end

	def >=(other)
		case other
		when true, false, Literal::Types::BooleanTypeClass
			true
		else
			false
		end
	end

	freeze
end

Literal::Types::BooleanType = Literal::Types::BooleanTypeClass.new.freeze
