# frozen_string_literal: true

class Literal::Types::NotType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Not(#{@type.inspect})"

	def ===(value)
		!(@type === value)
	end
end
