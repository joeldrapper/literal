# frozen_string_literal: true

# @api private
class Literal::Types::InterfaceType
	# TODO: We can generate this and make it much more extensive.
	METHOD_TYPE_MAPPINGS = {
		:call => Set[Proc, Method],
		:to_proc => Set[Proc, Method, Symbol],
		:to_s => Set[String],
	}.freeze

	include Literal::Type

	def initialize(*methods)
		raise Literal::ArgumentError.new("_Interface type must have at least one method.") if methods.size < 1
		@methods = methods
		freeze
	end

	attr_reader :methods

	def inspect
		"_Interface(#{@methods.map(&:inspect).join(', ')})"
	end

	def ===(value)
		@methods.all? { |m| value.respond_to?(m) }
	end

	def >=(other)
		case other
		when Literal::Types::InterfaceType
			@methods.all? { |m| other.methods.include?(m) }
		when Module
			@methods.map { |m| METHOD_TYPE_MAPPINGS[m] }.all? { |types| types&.include?(other) }
		when Literal::Types::IntersectionType
			other.types.any? { |type| Literal.subtype?(type, of: self) }
		when Literal::Types::ConstraintType
			other.object_constraints.any? { |type| Literal.subtype?(type, of: self) }
		else
			false
		end
	end

	freeze
end
