# frozen_string_literal: true

class Literal::MaybeType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect
		"Maybe(#{@type.inspect})"
	end

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

	def ===(maybe)
		case maybe
		when Literal::Nothing
			true
		when Literal::Some
			@type === maybe.value
		else
			false
		end
	end
end
