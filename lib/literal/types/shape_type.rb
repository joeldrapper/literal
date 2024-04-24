# frozen_string_literal: true

# @api private
class Literal::Types::ShapeType
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

	def ==(other)
		self.class == other.class && @constraints == other.constraints && @shape == other.shape
	end
	alias_method :eql?, :==

	protected

	attr_reader :constraints, :shape
end
