# frozen_string_literal: true

# @api private
class Literal::SomeType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Some(#{@type.inspect})"

	def ===(other)
		case other
		when Literal::Some
			@type === other.value
		else
			false
		end
	end

	def new(value)
		case value
		when @type
			Literal::Some.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end
end
