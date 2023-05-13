# frozen_string_literal: true

class Literal::Types::NotType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	def inspect
		"_Not(#{@type.inspect})"
	end

	def ===(value)
		!(@type === value)
	end
end
