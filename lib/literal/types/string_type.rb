# frozen_string_literal: true

# @api private
class Literal::Types::StringType < Literal::Types::ConstraintType
	def inspect = "_String(#{@constraint.inspect})"

	def ===(value)
		String === value && super
	end
end
