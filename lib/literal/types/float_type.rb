# frozen_string_literal: true

class Literal::Types::FloatType
	def initialize(range)
		@range = range
	end

	def inspect
		"Float(#{@range})"
	end

	def ===(other)
		other.is_a?(::Float) && @range === other
	end
end
