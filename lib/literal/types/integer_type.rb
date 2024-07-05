# frozen_string_literal: true

# @api private
class Literal::Types::IntegerType < Literal::Types::ConstraintType
	def inspect = "_Integer(#{inspect_constraints})"

	def ===(value)
		Integer === value && super
	end
end
