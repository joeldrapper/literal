# frozen_string_literal: true

# @api private
class Literal::Types::FrozenType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	attr_reader :type

	def inspect
		"_Frozen(#{@type.inspect})"
	end

	def ===(value)
		value.frozen? && @type === value
	end

	def >=(other)
		case other
		when Literal::Types::FrozenType
			@type >= other.type
		when Literal::Types::ConstraintType
			(
				Literal.subtype?(other.property_constraints[:frozen?], of: true)
			) && (
				other.object_constraints.any? { |t| Literal.subtype?(t, of: @type) }
			)
		else
			false
		end
	end
end
