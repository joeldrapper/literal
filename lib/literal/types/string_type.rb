# frozen_string_literal: true

class Literal::Types::StringType
	def initialize(range)
		@range = range
	end

	def inspect
		"_String(#{@range.inspect})"
	end

	def ===(value)
		value.is_a?(String) && @range === value.length
	end
end
