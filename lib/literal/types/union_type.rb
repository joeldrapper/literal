# frozen_string_literal: true

class Literal::Types::UnionType
	include Enumerable

	def initialize(*types)
		raise Literal::ArgumentError.new("_Union type must have at least one type.") if types.size < 1

		@types = Set[]
		load_types(types)
		@types.freeze
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

	def [](key)
		if @types.include?(key)
			key
		else
			raise ArgumentError.new("#{key} not in #{inspect}")
		end
	end

	protected

	attr_reader :types

	private

	def load_types(types)
		types.each do |type|
			(Literal::Types::UnionType === type) ? load_types(type.types) : @types << type
		end
	end
end
