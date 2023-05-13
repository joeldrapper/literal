# frozen_string_literal: true

class Literal::Types::TupleType
	include Literal::Type

	def initialize(*types)
		@types = types
	end

	def inspect
		"Tuple(#{@types.map(&:inspect).join(', ')})"
	end

	def ===(value)
		value.is_a?(::Enumerable) && value.size == @types.size && value.zip(@types).all? { |v, t| t === v }
	end
end
