# frozen_string_literal: true

# @api private
class Literal::Types::MapType < Literal::Type
	def initialize(**shape)
		@shape = shape
	end

	def inspect
		"_Map(#{@shape.inspect})"
	end

	def ===(other)
		Enumerable === other && @shape.all? { |k, t| t === other[k] }
	end
end
