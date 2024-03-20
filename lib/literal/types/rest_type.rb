# frozen_string_literal: true

# @api private
class Literal::Types::RestType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect = "_Rest(#{@type.inspect})}"

	def ===(value)
		@type === value
	end
end
