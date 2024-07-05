# frozen_string_literal: true

# @api private
class Literal::Types::StringType < Literal::Types::ConstraintType
	def inspect = "_String(#{inspect_constraints})"

	def ===(value)
		String === value && super
	end
end
