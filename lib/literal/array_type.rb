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
		Literal::Array.new(value, type: @type)
	end
end
