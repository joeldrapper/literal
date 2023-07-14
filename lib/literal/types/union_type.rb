# frozen_string_literal: true

# @api private
class Literal::Types::UnionType < Literal::Type
	include Enumerable

	def initialize(*types)
		@types = types
	end

	def inspect = "_Union(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		@types.any? { |type| type === value }
	end

	def each(&)
		@types.each(&)
	end

	def [](key)
		index.fetch(key)
	end

	def index
		@index ||= @types.index_by(&:itself)
	end

	def variant(value = Literal::Null)
		if Literal::Null == value
			Literal::Variant.new(yield, *@types)
		else
			Literal::Variant.new(value, *@types)
		end
	end

	def deconstruct
		@types
	end

	def deconstruct_keys(_)
		{ types: @types }
	end
end
