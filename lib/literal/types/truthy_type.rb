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
		case other
		when _Truthy
			true
		else
			false
		end
	end

	freeze
end
