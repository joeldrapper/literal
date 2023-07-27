# frozen_string_literal: true

class Literal::IntegerValue < Literal::Value
	def initialize(value)
		unless Integer === value
			raise Literal::TypeError.expected(value, to_be_a: Integer)
		end

		@value = value

		freeze
	end

	alias_method :to_i, :value

	def ==(other)
		case other
		when Integer
			@value == other
		when Literal::IntegerValue
			@value == other.value
		else
			false
		end
	end
end
