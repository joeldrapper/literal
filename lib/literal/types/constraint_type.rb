# frozen_string_literal: true

class Literal::Types::ConstraintType
	include Literal::Type

	def initialize(attribute, constraint = Literal::Types::TruthyType.new)
		@attribute = attribute
		@constraint = constraint
	end

	def inspect
		"Constraint(#{@attribute.inspect}, #{@constraint.inspect})"
	end

	def ===(value)
		@constraint === value.public_send(@attribute)
	end
end
