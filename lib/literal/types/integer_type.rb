# frozen_string_literal: true

class Literal::Types::IntegerType
	include Literal::Type

	def initialize(range)
		@range = range
	end

	def inspect
		"Integer(#{@range})"
	end

	def ===(other)
		other.is_a?(::Integer) && @range === other
	end
end
