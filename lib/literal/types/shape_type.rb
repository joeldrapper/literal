# frozen_string_literal: true

# @api private
class Literal::Types::ShapeType < Literal::Type
	def initialize(**shape)
		@shape = shape
	end

	def inspect
		"_Shape(#{@shape.inspect})"
	end

	def ===(other)
		Hash === other && (@shape.size == other.size) && @shape.all? { |k, t| t === other[k] }
	end
end
