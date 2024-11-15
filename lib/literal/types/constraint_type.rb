# frozen_string_literal: true

# @api private
class Literal::Types::ConstraintType
	include Literal::Type

	def initialize(*object_constraints, **property_constraints)
		@object_constraints = object_constraints
		@property_constraints = property_constraints
	end

	attr_reader :object_constraints
	attr_reader :property_constraints

	def inspect
		"_Constraint(#{inspect_constraints})"
	end

	def ===(value)
		object_constraints = @object_constraints

		i, len = 0, object_constraints.size
		while i < len
			return false unless object_constraints[i] === value
			i += 1
		end

		@property_constraints.each do |a, t|
			return false unless t === value.public_send(a)
		rescue NoMethodError => e
			raise unless e.name == a && e.receiver == value
			return false
		end

		true
	end

	def >=(other)
		case other
		when Literal::Types::ConstraintType
			return false unless [@object_constraints.length, other.object_constraints.length].max.times.all? do |i|
				a, b = @object_constraints[i], other.object_constraints[i]
				Literal.subtype?(b, of: a)
			end

			return false unless @property_constraints.all? do |k, v|
				Literal.subtype?(other.property_constraints[k], of: v)
			end

			true
		else
			false
		end
	end

	def record_literal_type_errors(context)
		@object_constraints.each do |constraint|
			next if constraint === context.actual

			context.add_child(label: inspect, expected: constraint, actual: context.actual)
		end

		@property_constraints.each do |property, constraint|
			next unless context.actual.respond_to?(property)
			actual = context.actual.public_send(property)
			next if constraint === actual

			context.add_child(label: ".#{property}", expected: constraint, actual:)
		end
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

	freeze
end
