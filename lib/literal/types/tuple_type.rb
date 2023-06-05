# frozen_string_literal: true

class Literal::Types::TupleType
	include Literal::Type

	def initialize(*types)
		@types = types
	end

	def inspect = "_Tuple(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		Enumerable === value && value.size == @types.size && @types.each_with_index.all? { |t, i| t === value[i] }
	end
end
