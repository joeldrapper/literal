# frozen_string_literal: true

# @api private
class Literal::MaybeType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Maybe(#{@type.inspect})"

	def new(value)
		case value
		when nil
			Literal::Nothing
		when @type
			Literal::Some.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end

	def ===(value)
		case value
		when Literal::Nothing
			true
		when Literal::Some
			@type === value.value
		else
			false
		end
	end
end
