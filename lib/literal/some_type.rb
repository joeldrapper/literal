# frozen_string_literal: true

class Literal::SomeType
	def initialize(type)
		@type = type
	end

	def inspect
		"Some(#{@type.inspect})"
	end

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
