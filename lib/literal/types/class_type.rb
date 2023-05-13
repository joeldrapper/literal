# frozen_string_literal: true

class Literal::Types::ClassType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	def inspect
		"Class(#{@type.name})"
	end

	def ===(value)
		value.is_a?(::Class) && (value == @type || value < @type)
	end
end
