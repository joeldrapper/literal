# frozen_string_literal: true

# @api private
class Literal::Types::StringType < Literal::Type
	def initialize(constraint)
		@constraint = constraint
	end

	def inspect = "_String(#{@constraint.inspect})"

	def ===(value)
		String === value && @constraint === value
	end
end
