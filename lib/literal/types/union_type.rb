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
end
