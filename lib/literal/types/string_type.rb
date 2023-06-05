# frozen_string_literal: true

class Literal::Types::StringType
	include Literal::Type

	def initialize(constraint)
		@constraint = constraint
	end

	def inspect
		"_String(#{@constraint.inspect})"
	end

	def ===(value)
		String === value && @constraint === value.length
	end
end
