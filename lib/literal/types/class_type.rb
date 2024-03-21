# frozen_string_literal: true

# @api private
class Literal::Types::ClassType
	def initialize(type)
		@type = type
	end

	def inspect = "_Class(#{@type.name})"

	def ===(value)
		Class === value && (value == @type || value < @type)
	end
end
