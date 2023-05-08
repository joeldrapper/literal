# frozen_string_literal: true

class Literal::Types::FrozenType
	def initialize(type)
		@type = type
	end

	def inspect
		"Frozen(#{@type.inspect})"
	end

	def ===(value)
		value.frozen? && @type === value
	end
end
