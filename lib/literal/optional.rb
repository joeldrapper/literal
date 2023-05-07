# frozen_string_literal: true

class Literal::Optional
	def initialize(type)
		@type = type
	end

	def inspect
		"Optional(#{@type.inspect})"
	end

	def ===(optional)
		case optional
		when Literal::None
			true
		when Literal::Some
			@type === optional.value
		else
			false
		end
	end
end
