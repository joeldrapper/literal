# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType
	def initialize(*object_constraints, **property_constraints)
		@object_constraints = object_constraints
		@property_constraints = property_constraints
	end

	def inspect = "_Constraint(#{inspect_constraints})"

	def ===(value)
		@object_constraints.all? { |t| t === value } &&
			@property_constraints.all? { |a, t| t === value.public_send(a) }
	end

	private

	def inspect_constraints
		[inspect_object_constraints, inspect_property_constraints].compact.join(", ")
	end

	def inspect_object_constraints
		if @object_constraints.length > 0
			@object_constraints.map(&:inspect).join(", ")
		end
	end

	def inspect_property_constraints
		if @property_constraints.length > 0
			@property_constraints.map { |k, t| "#{k}: #{t.inspect}" }.join(", ")
		end
	end
end
