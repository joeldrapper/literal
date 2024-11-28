# frozen_string_literal: true

# @api private
class Literal::Types::NotType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	attr_reader :type

	def inspect
		"_Not(#{@type.inspect})"
	end

	def ===(value)
		!(@type === value)
	end

	def >=(other)
		case other
		when Literal::Types::NotType
			Literal.subtype?(other.type, of: @type)
		when Literal::Types::ConstraintType
			other.object_constraints.any? { |constraint| Literal.subtype?(constraint, of: self) }
		when Literal::Types::IntersectionType
			other.types.any? { |type| Literal.subtype?(type, of: self) }
		else
			false
		end
	end

	freeze
end
