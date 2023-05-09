# frozen_string_literal: true

class LeftType
	def initialize(type)
		@type = type
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
			raise Literal::TypeError,
				"Expected `#{value.inspect}` to be `#{@type.inspect}`."
		end
	end
end
