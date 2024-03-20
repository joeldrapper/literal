# frozen_string_literal: true

class Literal::Types::OptionalType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Optional(#{@type.inspect})"

	def ===(value)
		@type === value
	end
end
