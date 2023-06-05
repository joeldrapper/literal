# frozen_string_literal: true

# @api private
class Literal::Types::FloatType < Literal::Type
	def initialize(range)
		@range = range
	end

	def inspect = "_Float(#{@range})"

	def ===(value)
		Float === value && @range === value
	end
end
