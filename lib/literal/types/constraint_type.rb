# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType
	def initialize(*object_constraints, **property_constraints)
		@object_constraints = object_constraints
		@property_constraints = property_constraints
	end

	def inspect = "_Constraint(#{@object_constraints.inspect}, #{@property_constraints.inspect})"

	def ===(value)
		@object_constraints.all? { |t| t === value } &&
			@property_constraints.all? { |a, t| t === value.public_send(a) }
	end
end
