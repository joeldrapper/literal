# frozen_string_literal: true

# @api private
class Literal::LeftType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Left(#{@type})"

	def ===(other)
		case other
		when Literal::Left
			@type === other.value
		else
			false
		end
	end

	def new(value)
		case value
		when @type
			Literal::Left.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end
end
