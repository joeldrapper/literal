# frozen_string_literal: true

# @api private
class Literal::Types::FalsyTypeClass
	include Literal::Type

	def initialize
		freeze
	end

	def inspect
		"_Falsy"
	end

	def ===(value)
		!value
	end

	def >=(other)
		case other
		when Literal::Types::FalsyTypeClass, nil, false
			true
		else
			false
		end
	end

	freeze
end

Literal::Types::FalsyType = Literal::Types::FalsyTypeClass.new.freeze
