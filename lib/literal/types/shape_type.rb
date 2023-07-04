# frozen_string_literal: true

# @api private
class Literal::Types::ShapeType < Literal::Type
	def initialize(*constraints, **shape)
		@constraints = constraints
		@shape = shape
	end

	def inspect
		"_Shape(#{@shape.inspect})"
	end

	def ===(other)
		@constraints.all? { |c| c === other } && @shape.all? { |k, t| t === other[k] } && other.keys.all? { |k| @shape.key?(k) }
	end
end
