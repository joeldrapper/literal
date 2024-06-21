# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType
	def initialize(*object_constraints, **attribute_constraints)
		@object_constraints = object_constraints
		@attribute_constraints = attribute_constraints
	end

	def inspect = "_Constraint(#{@object_constraints.inspect}, #{@attribute_constraints.inspect})"

	def ===(value)
		@object_constraints.all? { |t| t === value } &&
			@attribute_constraints.all? { |a, t| t === value.public_send(a) }
	end
end
