# frozen_string_literal: true

class Literal::Types::UnionType
	include Enumerable

	def initialize(*types)
		raise Literal::ArgumentError.new("_Union type must have at least one type.") if types.size < 1
		@types = types.to_set.freeze
	end

	def inspect = "_Union(#{@types.inspect})"

	def ===(value)
		@types.any? { |type| type === value }
	end

	def each(&)
		@types.each(&)
	end

	def deconstruct
		@types.to_a
	end
end
