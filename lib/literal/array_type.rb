# frozen_string_literal: true

class Literal::ArrayType
	def initialize(type)
		@type = type
	end

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

		value.each do |item|
			unless @type === item
				Literal::TypeError.expected(item, to_be_a: @type)
			end
		end

		Literal::Array.new(value, type: @type)
	end
end
