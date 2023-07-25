# frozen_string_literal: true

class Literal::SuccessType < Literal::Generic
	def initialize(type)
		@type = type
	end

	def inspect = "Literal::Success(#{@type.inspect})"

	def ===(value)
		Literal::Success === value && @type === value.value
	end

	def new(value)
		if @type === value
			Literal::Success.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end
end
