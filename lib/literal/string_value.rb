# frozen_string_literal: true

class Literal::StringValue < Literal::Value
	def initialize(value)
		unless String === value
			raise Literal::TypeError.expected(value, to_be_a: String)
		end

		@value = value

		freeze
	end

	alias_method :to_s, :value
	alias_method :to_str, :value

	def ==(other)
		case other
		when String
			@value == other
		when Literal::StringValue
			@value == other.value
		else
			false
		end
	end
end
