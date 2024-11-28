# frozen_string_literal: true

# @api private
class Literal::Types::TruthyTypeClass
	include Literal::Type

	def inspect
		"_Truthy"
	end

	def ===(value)
		!!value
	end

	def >=(other)
		case other
		when Literal::Types::TruthyType, true
			true
		else
			false
		end
	end

	freeze
end

Literal::Types::TruthyType = Literal::Types::TruthyTypeClass.new.freeze
