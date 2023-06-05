# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType < Literal::Type
	def initialize(attribute, constraint = Literal::Types::TruthyType)
		@attribute = attribute
		@constraint = constraint
	end

	def inspect = "_Constraint(#{@attribute.inspect}, #{@constraint.inspect})"

	def ===(value)
		@constraint === value.public_send(@attribute)
	end
end
