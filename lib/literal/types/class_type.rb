# frozen_string_literal: true

# @api private
class Literal::Types::ClassType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Class(#{@type.name})"

	def ===(value)
		Class === value && (value == @type || value < @type)
	end
end
