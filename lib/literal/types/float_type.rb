# frozen_string_literal: true

class Literal::Types::FloatType
	include Literal::Type

	def initialize(range)
		@range = range
	end

	def inspect = "_Float(#{@range})"

	def ===(value)
		Float === value && @range === value
	end
end
