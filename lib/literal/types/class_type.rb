# frozen_string_literal: true

class Literal::Types::ClassType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	def inspect = "_Class(#{@type.name})"

	def ===(value)
		Class === value && (value == @type || value < @type)
	end
end
