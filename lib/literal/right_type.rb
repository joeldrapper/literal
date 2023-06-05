# frozen_string_literal: true

# @api private
class Literal::RightType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Right(#{@type})"

	def ===(other)
		case other
		when Literal::Right
			@type === other.value
		else
			false
		end
	end

	def new(value)
		case value
		when @type
			Literal::Right.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end
end
