# frozen_string_literal: true

# @api private
class Literal::Types::NotType
	def initialize(type)
		@type = type
	end

	def inspect = "_Not(#{@type.inspect})"

	def ===(value)
		!(@type === value)
	end
end
