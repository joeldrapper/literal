# frozen_string_literal: true

# @api private
class Literal::Types::CallableType
	include Literal::Type

	def inspect
		"_Callable"
	end

	def ===(value)
		value.respond_to?(:call)
	end

	def >=(other)
		(self == other) || (Proc == other) || (Method == other) || case other
		when Literal::Types::IntersectionType
			other.types.any? { |type| self >= type }
		when Literal::Types::ConstraintType
			other.object_constraints.any? { |type| self >= type }
		when Literal::Types::InterfaceType
			other.methods.include?(:call)
		else
			false
		end
	end

	Instance = new.freeze

	freeze
end
