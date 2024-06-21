# frozen_string_literal: true

# @api private
class Literal::Types::TupleType
	def initialize(*types)
		raise Literal::ArgumentError.new("_Tuple type must have at least one type.") if types.size < 1

		@types = types
	end

	def inspect = "_Tuple(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		Array === value && value.size == @types.size && @types.each_with_index.all? { |t, i| t === value[i] }
	end
end
