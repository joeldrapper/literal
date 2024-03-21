# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType
	def initialize(*constraints, **attributes)
		@constraints = constraints
		@attributes = attributes
	end

	def inspect = "_Constraint(#{@constraints.inspect}, #{@attributes.inspect})"

	def ===(value)
		@constraints.all? { |c| c === value } && @attributes.all? do |method, type|
			type === value.public_send(method)
		end
	end
end
