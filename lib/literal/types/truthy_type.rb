# frozen_string_literal: true

# @api private
class Literal::Types::TruthyType
	Instance = new.freeze
	include Literal::Type

	def inspect
		"_Truthy"
	end

	def ===(value)
		!!value
	end

	def >=(other)
		return false if other == Literal::Types::FalseyType

		case other
		when false, nil
			false
		else
			true
		end
	end

	freeze
end
