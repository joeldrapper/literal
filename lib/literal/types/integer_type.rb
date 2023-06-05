# frozen_string_literal: true

# @api private
class Literal::Types::IntegerType < Literal::Type
	def initialize(range)
		@range = range
	end

	def inspect = "_Integer(#{@range})"

	def ===(value)
		Integer === value && @range === value
	end
end
