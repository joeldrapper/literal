# frozen_string_literal: true

class Literal::LeftType
	include Literal::Generic

	def initialize(type)
		@type = type
	end

	def inspect
		"Literal::Left(#{@type})"
	end

	def ===(left)
		case left
		when Literal::Left
			@type === left.value
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
