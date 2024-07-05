# frozen_string_literal: true

# @api private
class Literal::Types::FloatType < Literal::Types::ConstraintType
	def inspect = "_Float(#{inspect_constraints})"

	def ===(value)
		Float === value && super
	end
end
