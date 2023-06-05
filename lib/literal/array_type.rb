# frozen_string_literal: true

class Literal::ArrayType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Array(#{@type.inspect})"

	def ===(value)
		case value
		when Literal::Array
			@type == value.type
		else
			false
		end
	end

	def new(value)
		value = value.to_a

		if Literal::_Array(@type) === value
			Literal::Array.new(value, type: @type)
		else
			Literal::TypeError.expected(item, to_be_a: @type)
		end
	end
end
